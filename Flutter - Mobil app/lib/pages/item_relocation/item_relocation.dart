import 'package:e7mr/search_delegates/item.search_delegate.dart';
import 'package:e7mr/state/actions/log.actions.dart';
import 'package:e7mr/state/actions/log_commands/relocate_item.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/generated/location_state.dart';
import 'package:e7mr/state/models/item_state.dart';
import 'package:e7mr/state/selectors/auth_selectors.dart';
import 'package:e7mr/state/selectors/generated/state_status_selectors.dart';
import 'package:e7mr/state/selectors/location_selectors.dart';
import 'package:e7mr/widgets/ensure_visibility_when_focused.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

typedef ItemState GetItemCallback(String itemNo);

class ItemRelocationPage extends StatefulWidget {
  _ItemRelocationPageState createState() => _ItemRelocationPageState();
}

class _ItemRelocationPageState extends State<ItemRelocationPage> {
  final _reLocFormKey = GlobalKey<FormState>();
  final _itemNo = TextEditingController();
  final itemNode = FocusNode();
  final qtyNode = FocusNode();
  num _qty;
  String _qtySuffix;
  ItemState item;
  LocationState _toLocation;
  LocationState _fromLocation;

  @override
  void initState() {
    super.initState();
    _qty = 0;
    _qtySuffix = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Container(
              child: SingleChildScrollView(
                child: Form(
                  key: _reLocFormKey,
                  child: Column(
                    children: <Widget>[
                      itemSearch(),
                      toLocationDropdown(),
                      // locationQty(_toLocation),
                      fromLocationDropdown(),
                      // locationQty(_fromLocation),
                      qtyField(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: bottomButton(),
            ),
          ),
        ],
      ),
    );
  }

  Widget itemSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: EnsureVisibleWhenFocused(
        focusNode: itemNode,
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: _itemNo,
                autocorrect: false,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  labelText: 'Varenummer',
                  border: OutlineInputBorder(),
                  // prefixText: item?.description,
                ),
              ),
            ),
            StoreConnector<AppState, String>(
              converter: (store) => userSelector(store.state)?.username,
              ignoreChange: (state) => isLoadingStateStatusSelector(state),
              builder: (context, username) => IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      item = await showSearch(
                        context: context,
                        delegate: ItemSearch(username: username),
                        query: _itemNo.text,
                      );
                      if (item != null) {
                        setState(() {
                          _itemNo.text = item.no;
                          _qtySuffix = item.uom;
                        });
                      }
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget locationQty(LocationState loc) {
  //   if (loc != null && _itemNo.text != null && _itemNo.text != '') {
  //     return StoreConnector<AppState, ItemQuantityState>(
  //         converter: (store) => itemQuantityByLocationSelector(
  //             store.state, _itemNo.text, loc.code),
  //         builder: (context, itemQty) =>
  //             itemQty != null ? Text('Beholdning: $itemQty') : Text(''));
  //   } else {
  //     return Text('');
  //   }
  // }

  Widget qtyField() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 16.0,
      ),
      child: EnsureVisibleWhenFocused(
        focusNode: qtyNode,
        child: TextFormField(
          autocorrect: false,
          textAlign: TextAlign.right,
          autovalidate: true,
          decoration: InputDecoration(
            labelText: 'Antall:',
            suffixText: _qtySuffix,
            hintText: '0,0',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.numberWithOptions(
            decimal: true,
            signed: false,
          ),
          validator: (value) {
            final match = RegExp(r'[0-9]*[\.\,]{0,1}[0-9]*$').firstMatch(value);
            if (match == null) {
              return 'Ugyldig format';
            }
          },
          onSaved: (value) {
            setState(() {
              _qty = num.parse(value) ?? 0;
            });
          },
        ),
      ),
    );
  }

  Widget toLocationDropdown() {
    return Padding(
      padding: const EdgeInsets.only(
          top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Til lokasjon',
          border: OutlineInputBorder(),
        ),
        isEmpty: _toLocation == null,
        child: DropdownButtonHideUnderline(
          child: StoreConnector<AppState, Iterable<LocationState>>(
            converter: (store) => locationsSelector(store.state),
            ignoreChange: (state) => isLoadingStateStatusSelector(state),
            builder: (context, toLocations) => DropdownButton<String>(
                  value: _toLocation?.code,
                  isDense: true,
                  onChanged: (String newLocationCode) {
                    setState(() {
                      _toLocation = toLocations.firstWhere(
                          (location) => location.code == newLocationCode);
                    });
                  },
                  items: toLocations?.map((location) {
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

  Widget fromLocationDropdown() {
    return Padding(
      padding: const EdgeInsets.only(
          top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Fra lokasjon',
          border: OutlineInputBorder(),
        ),
        isEmpty: _fromLocation == null,
        child: DropdownButtonHideUnderline(
          child: StoreConnector<AppState, Iterable<LocationState>>(
            converter: (store) => locationsSelector(store.state),
            ignoreChange: (state) => isLoadingStateStatusSelector(state),
            builder: (context, fromLocations) => DropdownButton<String>(
                  value: _fromLocation?.code,
                  isDense: true,
                  onChanged: (String newLocationCode) {
                    setState(() {
                      _fromLocation = fromLocations.firstWhere(
                          (location) => location.code == newLocationCode);
                    });
                  },
                  items: fromLocations?.map((location) {
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

  Widget bottomButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ButtonTheme(
          minWidth: 200.0,
          buttonColor: Colors.grey[300],
          child: StoreBuilder<AppState>(
            rebuildOnChange: false,
            builder: (context, store) => RaisedButton.icon(
                  icon: Icon(Icons.send),
                  label: Text('Flytt vare'),
                  onPressed: () {
                    if (_reLocFormKey.currentState.validate()) {
                      _reLocFormKey.currentState.save();
                      postLogPayload(
                        store,
                        RelocateItem(
                          _itemNo.text,
                          _fromLocation.code,
                          _toLocation.code,
                          _qty,
                        ),
                      );
                    }
                  },
                ),
          ),
        ),
      ),
    );
  }
}
