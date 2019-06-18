import 'dart:async';
import 'dart:math';

import 'package:e7mr/search_delegates/item.search_delegate.dart';
import 'package:e7mr/state/actions/log.actions.dart';
import 'package:e7mr/state/actions/log_commands/job_item_usage.dart';
import 'package:e7mr/state/middleware/generated/job_journal_line/db_job_journal_line.dart';
import 'package:e7mr/state/middleware/generated/job_ledger_entry/db_job_ledger_entry.dart';
import 'package:e7mr/state/middleware/generated/log/db_log.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/generated/location_state.dart';
import 'package:e7mr/state/models/generated/log_state.dart';
import 'package:e7mr/state/models/item_state.dart';
import 'package:e7mr/state/selectors/auth_selectors.dart';
import 'package:e7mr/state/selectors/generated/state_status_selectors.dart';
import 'package:e7mr/state/selectors/location_selectors.dart';
import 'package:e7mr/utils/constants.dart';
import 'package:e7mr/utils/db.util.dart';
import 'package:e7mr/widgets/ensure_visibility_when_focused.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

typedef void RegisterItemUsageCallback({bool exit});
typedef ItemState GetItemCallback(String itemNo);

class JobAddUsagePage extends StatefulWidget {
  JobAddUsagePage({
    Key key,
    this.title,
    @required this.jobNo,
    @required this.jobTaskNo,
    this.itemNo,
    this.itemDescription,
    this.itemUoM,
    this.locationCode,
    this.lockItem,
    this.lockLocation,
    this.maxQuantity,
    this.minQuantity,
    this.returnMode,
  }) : super(key: key);

  final String title;
  final String jobNo;
  final String jobTaskNo;

  final String itemNo;
  final String itemDescription;
  final String itemUoM;
  final String locationCode;

  final bool lockItem;
  final bool lockLocation;
  final num maxQuantity;
  final num minQuantity;
  final bool returnMode;

  @override
  _JobAddUsagePageState createState() => _JobAddUsagePageState();
}

class _JobAddUsagePageState extends State<JobAddUsagePage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _itemNoController = TextEditingController();
  final _qtyController = TextEditingController();

  final _itemNoFocusNode = FocusNode();

  String _itemUoM;
  String _itemDescription;
  String _locationCode;
  num _quantity = 0;

  bool _ignoring = false;

  @override
  void initState() {
    super.initState();
    _itemNoController.text = widget.itemNo ?? '';
    _itemDescription = widget.itemDescription ?? '';
    _itemUoM = widget.itemUoM ?? '';
    _locationCode = widget.locationCode ?? '';
  }

  void _regUsage(BuildContext context, {bool exit = false}) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (_quantity != null &&
          _quantity != 0 &&
          _itemNoController.text.isNotEmpty) {
        setState(() {
          _ignoring = true;
        });
        print('ignoring:' + _ignoring.toString());

        final store = StoreProvider.of<AppState>(context);
        postLogPayload(
          store,
          JobItemUsage(
            widget.jobNo,
            widget.jobTaskNo,
            _itemNoController.text,
            _quantity,
            _itemUoM,
            _itemDescription,
            this.widget.returnMode == true ? null : _locationCode,
            DateTime.now(),
          ),
        );
        setState(() {
          if (exit) {
            Navigator.of(context).pop();
          } else {
            _ignoring = false;
            _qtyController.text = '';
            _quantity = 0;
            _locationCode = null;
            _itemNoController.text = '';
            _itemDescription = '';
            _itemUoM = '';
          }
        });
        print('ignoring:' + _ignoring.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formChildren = <Widget>[
      Padding(
        padding: const EdgeInsets.only(
            top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: EnsureVisibleWhenFocused(
                focusNode: _itemNoFocusNode,
                child: TextFormField(
                  controller: _itemNoController,
                  autocorrect: false,
                  enabled: this.widget.lockItem != true,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                      labelText: 'Varenummer',
                      border: OutlineInputBorder(),
                      prefixText: _itemDescription ?? ''),
                ),
              ),
            ),
            StoreConnector<AppState, String>(
              converter: (store) => userSelector(store.state)?.username,
              ignoreChange: (state) => isLoadingStateStatusSelector(state),
              builder: (context, username) => IconButton(
                    icon: Icon(Icons.search),
                    onPressed: this.widget.lockItem == true
                        ? null
                        : () async {
                            final item = await showSearch(
                              context: context,
                              delegate: ItemSearch(username: username),
                              query: _itemNoController.text,
                            );
                            if (item != null) {
                              setState(() {
                                _itemNoController.text = item.no;
                                _itemDescription = item.description;
                                _itemUoM = item.uom;
                              });
                            }
                          },
                  ),
            ),
          ],
        ),
      ),
      _quantityField(),
    ];
    if (this.widget.returnMode != true) {
      formChildren.add(_locationDropdown());
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(this.widget.title ??
              (this.widget.returnMode == true
                  ? 'Returner vare'
                  : 'Legg til Forbruk')),
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: formChildren,
              ),
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomAppBar(),
      ),
    );
  }

  BottomAppBar _buildBottomAppBar() {
    return BottomAppBar(
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: widget.returnMode == true
              ? <Widget>[
                  RaisedButton.icon(
                    icon: Icon(Icons.check),
                    label: Text('Returner'),
                    onPressed:
                        _ignoring ? null : () => _regUsage(context, exit: true),
                  ),
                ]
              : <Widget>[
                  RaisedButton.icon(
                    icon: Icon(Icons.check),
                    label: Text('Legg til & ny'),
                    onPressed: _ignoring ? null : () => _regUsage(context),
                  ),
                  RaisedButton.icon(
                    icon: Icon(Icons.exit_to_app),
                    label: Text('Legg til & tilbake'),
                    onPressed:
                        _ignoring ? null : () => _regUsage(context, exit: true),
                  ),
                ],
        ),
      ),
    );
  }

  Padding _locationDropdown() {
    return Padding(
      padding: const EdgeInsets.only(
          top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Lokasjon',
          border: OutlineInputBorder(),
        ),
        isEmpty: _locationCode == null,
        child: DropdownButtonHideUnderline(
          child: StoreConnector<AppState, Iterable<LocationState>>(
            converter: (store) => locationsSelector(store.state),
            ignoreChange: (state) => isLoadingStateStatusSelector(state),
            builder: (context, locations) => DropdownButton<String>(
                  value:
                      locations?.any((loc) => loc.code == _locationCode) == true
                          ? _locationCode
                          : null,
                  isDense: true,
                  onChanged: this.widget.lockLocation == true
                      ? null
                      : (String newLocationCode) {
                          setState(() {
                            _locationCode = newLocationCode;
                          });
                        },
                  items: locations?.map((location) {
                        return DropdownMenuItem<String>(
                          value: location.code,
                          child: Text(location.code + ' - ' + location.name),
                        );
                      })?.toList() ??
                      List(),
                ),
          ),
        ),
      ),
    );
  }

  Padding _quantityField() {
    return Padding(
      padding: const EdgeInsets.only(
          top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
      child: StoreBuilder<AppState>(
        rebuildOnChange: false,
        builder: (context, store) => FutureBuilder<_MinMaxQuantity>(
              initialData: this.widget.returnMode == true
                  ? _MinMaxQuantity(min: 0, max: 0)
                  : null,
              future: this.widget.returnMode == true
                  ? _calculateReturnModeMinMaxQuantity(store)
                  : null,
              builder: (context, snapshot) {
                final minQuantity = this.widget.returnMode == true
                    ? -snapshot.data.max
                    : this.widget.minQuantity;
                final maxQuantity = this.widget.returnMode == true
                    ? -snapshot.data.min
                    : this.widget.maxQuantity;

                final currQty = num.tryParse(_qtyController.text) ?? 0;

                final counterText = this.widget.returnMode == true
                    ? '$currQty/$maxQuantity'
                    : null;

                return TextFormField(
                  controller: _qtyController,
                  autocorrect: false,
                  textAlign: TextAlign.right,
                  autovalidate: true,
                  decoration: InputDecoration(
                    labelText: 'Antall',
                    border: OutlineInputBorder(),
                    counterText: counterText,
                  ),
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  validator: (value) {
                    final match = RegExp(r'^(?:-){0,1}[0-9]*[\.\,]{0,1}[0-9]*$')
                        .firstMatch(value);
                    if (match == null) {
                      return 'Ugyldig format';
                    }

                    final numValue = num.tryParse(value) ?? 0;

                    if (minQuantity != null) {
                      if (numValue <= minQuantity) {
                        return 'Antall må være større enn ' +
                            minQuantity.toString();
                      }
                    }
                    if (maxQuantity != null) {
                      if (numValue > maxQuantity) {
                        return 'Maks tillatte antall er ' +
                            maxQuantity.toString();
                      }
                    }
                  },
                  onSaved: (value) {
                    setState(() {
                      _quantity = num.parse(value) ?? 0;
                      if (this.widget.returnMode == true) {
                        _quantity = -_quantity;
                      }
                    });
                  },
                );
              },
            ),
      ),
    );
  }

  Future<_MinMaxQuantity> _calculateReturnModeMinMaxQuantity(
      Store<AppState> store) async {
    final db = await DbUtil.db;
    final username = userSelector(store.state).username;

    num qtySum = 0;

    // Job Journal Line
    var query =
        'SELECT SUM(Quantity) as sum_of_qty FROM ${DBJobJournalLine.TABLE_NAME} WHERE User = ? AND Job_No = ? AND Job_Task_No = ? AND TypeAsInt = ? AND No = ?';
    var whereArgs = [
      username,
      this.widget.jobNo,
      this.widget.jobTaskNo,
      JOB_JOURNAL_LINE_TYPE_ITEM,
      this.widget.itemNo,
    ];
    try {
      final rows = await db?.rawQuery(query, whereArgs);
      if (rows != null) {
        qtySum =
            rows.fold(qtySum, (currSum, row) => currSum + row['sum_of_qty']);
      }
    } catch (e) {}

    // Job Ledger Entry
    query =
        'SELECT SUM(Quantity) as sum_of_qty FROM ${DBJobLedgerEntry.TABLE_NAME} WHERE User = ? AND Job_No = ? AND Job_Task_No = ? AND TypeAsInt = ? AND No = ?';
    try {
      final rows = await db?.rawQuery(query, whereArgs);
      if (rows != null) {
        qtySum =
            rows.fold(qtySum, (currSum, row) => currSum + row['sum_of_qty']);
      }
    } catch (e) {}

    // Item Usage
    query =
        'SELECT * FROM ${DBLog.TABLE_NAME} WHERE User = ? AND Command = ? AND Hash = ?';
    whereArgs = [
      username,
      JobItemUsage.COMMAND,
      JobItemUsage.buildSqlLikeHash(
        jobNo: this.widget.jobNo,
        jobTaskNo: this.widget.jobTaskNo,
        itemNo: this.widget.itemNo,
      ),
    ];
    try {
      final rows = await db?.rawQuery(query, whereArgs);
      if (rows != null) {
        final itemUsages = rows.map((row) =>
            JobItemUsage.decodeFromLogState(LogState.decodeDB(Map.of(row))));
        qtySum = itemUsages.fold(
            qtySum, (currSum, itemUsage) => currSum + itemUsage.quantity);
      }
    } catch (e) {}

    return _MinMaxQuantity(
      min: min(-qtySum, 0),
      max: 0,
    );
  }
}

class _MinMaxQuantity {
  _MinMaxQuantity({this.min, this.max});

  final num min;
  final num max;
}
