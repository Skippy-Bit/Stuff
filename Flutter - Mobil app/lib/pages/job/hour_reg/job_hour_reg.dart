import 'package:e7mr/e7mr_theme.dart';
import 'package:e7mr/state/actions/log.actions.dart';
import 'package:e7mr/state/actions/log_commands/job_hour.dart';
import 'package:e7mr/state/middleware/generated/job_journal_line/db_job_journal_line.dart';
import 'package:e7mr/state/middleware/generated/job_ledger_entry/db_job_ledger_entry.dart';
import 'package:e7mr/state/middleware/generated/log/db_log.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/generated/job_state.dart';
import 'package:e7mr/state/models/generated/job_task_state.dart';
import 'package:e7mr/state/models/generated/log_state.dart';
import 'package:e7mr/state/models/generated/work_type_state.dart';
import 'package:e7mr/state/selectors/auth_selectors.dart';
import 'package:e7mr/state/selectors/generated/state_status_selectors.dart';
import 'package:e7mr/state/selectors/setup_selectors.dart';
import 'package:e7mr/state/selectors/work_type_selectors.dart';
import 'package:e7mr/utils/db.util.dart';
import 'package:e7mr/widgets/ensure_visibility_when_focused.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';
import 'package:redux/redux.dart';
import 'package:sqflite/sqflite.dart';

typedef void RegisterJobHourCallback({bool exit});

class JobHourRegPage extends StatefulWidget {
  final JobState job;
  final JobTaskState jobTask;
  final String title;

  JobHourRegPage({
    Key key,
    @required this.job,
    @required this.jobTask,
    this.title,
  }) : super(key: key);

  @override
  _JobHourRegPageState createState() => _JobHourRegPageState();
}

class _JobHourRegPageState extends State<JobHourRegPage> {
  final controller = TextEditingController();
  final jobDetails = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final dateNode = FocusNode();
  final timeNode = FocusNode();
  final qtyNode = FocusNode();
  final descriptionNode = FocusNode();
  final hourFormKey = GlobalKey<FormState>();
  final _hourScaffoldKey = GlobalKey<ScaffoldState>();
  bool ignoring = false;
  num hours = 0;
  DateTime _selectedDate;
  TimeOfDay time;
  WorkTypeState _selectedWorkType;
  String errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _dateController.text = DateFormat.yMd().format(_selectedDate);
    _timeController.text = DateFormat.Hm().format(_selectedDate);
  }

  Future<void> _regUsage(Store<AppState> store, {bool exit = false}) async {
    if (hourFormKey.currentState.validate()) {
      hourFormKey.currentState.save();
      String description = jobDetails.text;
      if (hours != null && hours != 0 && _selectedDate != null) {
        setState(() {
          ignoring = true;
        });

        String validationError = await _validate(store);
        if (validationError != null) {
          setState(() {
            ignoring = false;
            errorMessage = validationError;
          });
          return;
        }

        postLogPayload(
          store,
          JobHour(
            widget.job.no,
            widget.jobTask.jobTaskNo,
            hours,
            _selectedWorkType.code,
            _selectedWorkType.unitOfMeasureCode,
            _selectedDate,
            description,
          ),
        );
        setState(() {
          if (exit) {
            Navigator.of(context).pop();
          } else {
            _selectedDate = DateTime.now();
            _dateController.text = DateFormat.yMd().format(_selectedDate);
            _timeController.text = DateFormat.Hm().format(_selectedDate);
            controller.text = '';
            jobDetails.text = '';
            hours = 0.0;
            time = null;
            errorMessage = null;
          }
          ignoring = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
            key: _hourScaffoldKey,
            appBar: AppBar(
              title: Text('Timeføring'),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: _mainViewChildren().toList(),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              elevation: 8.0,
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                child: StoreConnector<AppState, RegisterJobHourCallback>(
                  converter: (store) => ({exit}) => _regUsage(
                        store,
                        exit: exit,
                      ),
                  ignoreChange: (state) => isLoadingStateStatusSelector(state),
                  builder: (context, registerHour) => Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton.icon(
                            icon: Icon(Icons.check),
                            label: Text('Legg til & ny'),
                            onPressed: ignoring
                                ? null
                                : () => registerHour(exit: false),
                          ),
                          RaisedButton.icon(
                            icon: Icon(Icons.exit_to_app),
                            label: Text('Legg til & tilbake'),
                            onPressed: ignoring
                                ? null
                                : () => registerHour(exit: true),
                          ),
                        ],
                      ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Iterable<Widget> _mainViewChildren() sync* {
    if (errorMessage != null && errorMessage.isNotEmpty) {
      yield Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Text(
          errorMessage,
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    yield Form(
      key: hourFormKey,
      child: Column(
        children: <Widget>[
          _buildDatePicker(),
          // _buildTimePicker(),
          Divider(),
          _buildQtyField(),
          _buildQuickSelectQty(),
          Divider(),
          _buildWorkTypeSelect(),
          Divider(),
          _buildDescriptionField(),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return Padding(
      padding: EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
        bottom: 4.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: EnsureVisibleWhenFocused(
              focusNode: dateNode,
              child: TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  prefixText: 'Dato:',
                  hintText: 'dd/mm/yyyy',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: E7MRTheme.secondary),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                  ),
                ),
                textAlign: TextAlign.end,
                controller: _dateController,
                keyboardType: TextInputType.datetime,
                inputFormatters: [LengthLimitingTextInputFormatter(8)],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.date_range),
            tooltip: 'Velg dato',
            onPressed: (() {
              _chooseDate(context, _dateController.text);
            }),
          )
        ],
      ),
    );
  }

  Widget _buildTimePicker() {
    return Padding(
      padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 4.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: EnsureVisibleWhenFocused(
              focusNode: timeNode,
              child: TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  prefixText: 'Tidspunkt:',
                  hintText: 'hh:mm',
                  hasFloatingPlaceholder: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: E7MRTheme.secondary),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                  ),
                ),
                textAlign: TextAlign.end,
                controller: _timeController,
                keyboardType: TextInputType.datetime,
                inputFormatters: [LengthLimitingTextInputFormatter(8)],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.date_range),
            tooltip: 'Velg dato',
            onPressed: (() {
              _chooseTime(context, _timeController.text);
            }),
          )
        ],
      ),
    );
  }

  Widget _buildQtyField() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 16.0,
      ),
      child: EnsureVisibleWhenFocused(
        focusNode: qtyNode,
        child: TextFormField(
          controller: controller,
          autocorrect: false,
          textAlign: TextAlign.right,
          autovalidate: true,
          decoration: InputDecoration(
            prefixText: 'Antall:',
            suffixText: ReCase(
                    _selectedWorkType?.unitOfMeasureCode?.toLowerCase() ?? '')
                .titleCase,
            // suffixStyle: TextStyle(),
            hintText: '0,0',
            border: OutlineInputBorder(
              borderSide: BorderSide(color: E7MRTheme.secondary),
              borderRadius: BorderRadius.all(
                Radius.circular(4.0),
              ),
            ),
          ),
          keyboardType: TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
          validator: (value) {
            final match =
                RegExp(r'^-{0,1}[0-9]*[\.\,]{0,1}[0-9]*$').firstMatch(value);
            if (match == null) {
              return 'Ugyldig format';
            }
          },
          onSaved: (value) {
            setState(() {
              hours = num.tryParse(value) ?? 0;
            });
          },
        ),
      ),
    );
  }

  Widget _buildQuickSelectQty() {
    return StoreBuilder<AppState>(
      builder: (context, store) {
        final shortcutPadding = EdgeInsets.symmetric(vertical: 4);
        final crossAxisCount = 4;

        final shortcuts = hourQuantityShortcutsSelector(store.state)
            .map(
              (shortcut) => Padding(
                    padding: shortcutPadding,
                    child: MaterialButton(
                      color: E7MRTheme.primary.shade800,
                      child: Text(
                        shortcut.toString(),
                        style: TextStyle(
                          color: E7MRTheme.secondary.shade900,
                        ),
                      ),
                      elevation: 0.7,
                      onPressed: () {
                        setState(
                          () {
                            hours = shortcut;
                            controller.text = hours.toStringAsFixed(1);
                          },
                        );
                      },
                    ),
                  ),
            )
            .toList();

        // Increment & decrement
        // Make sure increment and decrement end up on the same row.
        if (shortcuts.length % crossAxisCount == crossAxisCount - 1) {
          shortcuts.add(Padding(padding: shortcutPadding));
        }
        shortcuts.addAll([
          Padding(
            padding: shortcutPadding,
            child: MaterialButton(
              color: E7MRTheme.primary.shade500,
              child: Text(
                "+",
                style: TextStyle(
                  color: E7MRTheme.secondary.shade900,
                ),
              ),
              elevation: 0.7,
              onPressed: () {
                hourFormKey.currentState.save();
                setState(() {
                  hours = hours + hourQuantityIncrementSelector(store.state);
                  controller.text = hours.toStringAsFixed(1);
                });
              },
            ),
          ),
          Padding(
            padding: shortcutPadding,
            child: MaterialButton(
              color: E7MRTheme.primary.shade500,
              child: Text(
                "-",
                style: TextStyle(
                  color: E7MRTheme.secondary.shade900,
                ),
              ),
              elevation: 0.7,
              onPressed: () {
                hourFormKey.currentState.save();
                setState(() {
                  hours = hours - hourQuantityDecrementSelector(store.state);
                  controller.text = hours.toStringAsFixed(1);
                });
              },
            ),
          ),
        ]);

        return GridView.count(
          crossAxisSpacing: 16.0,
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),
          shrinkWrap: true,
          childAspectRatio: 1.8,
          crossAxisCount: crossAxisCount,
          children: shortcuts,
        );
      },
    );
  }

  Widget _buildWorkTypeSelect() {
    return StoreConnector<AppState, Iterable<WorkTypeState>>(
      converter: (store) => workTypesSelector(store.state),
      ignoreChange: (state) => isLoadingStateStatusSelector(state),
      builder: (context, workTypes) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: E7MRTheme.secondary,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isDense: true,
                      isExpanded: true,
                      items: workTypes.map((workType) {
                        return DropdownMenuItem(
                          value: workType,
                          child: Center(
                              child: Text(
                            workType.code + ' - ' + workType.description,
                          )),
                        );
                      }).toList(),
                      hint: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                            _selectedWorkType?.description ?? 'Velg en type'),
                      ),
                      onChanged: (workType) {
                        setState(() {
                          _selectedWorkType = workType;
                        });
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildDescriptionField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 4.0,
      ),
      child: EnsureVisibleWhenFocused(
        focusNode: descriptionNode,
        child: TextFormField(
          controller: jobDetails,
          maxLines: 3,
          maxLength: 250,
          autocorrect: false,
          textAlign: TextAlign.left,
          autovalidate: true,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
              labelText: 'Beskrivelse',
              // alignLableWithHint: true,  //added in future release
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: E7MRTheme.secondary),
                  borderRadius: BorderRadius.all(Radius.circular(4.0)))),
        ),
      ),
    );
  }

  Future _chooseDate(BuildContext context, String initialDateString) async {
    final store = StoreProvider.of<AppState>(context);

    final newDate = await showDatePicker(
      context: context,
      initialDate: _getInitialDate(initialDateString),
      firstDate: _getFirstDate(store?.state),
      lastDate: _getLastDate(store?.state),
    );

    if (newDate == null) return;

    setState(() {
      _updateDate(newDate);
    });
  }

  DateTime _getInitialDate(String initialDateString) {
    final now = DateTime.now();
    final initialDate = _convertStringToDate(initialDateString) ?? now;
    if (initialDate.year >= 2000 && initialDate.isBefore(now)) {
      return initialDate;
    }
    return now;
  }

  DateTime _convertStringToDate(String input) {
    try {
      return DateFormat.yMd().parseStrict(input);
    } catch (e) {
      return null;
    }
  }

  DateTime _getFirstDate(AppState state) {
    if (state != null) {
      final backward = hourDateOffsetBackwardSelector(state);
      if (backward != null && backward >= 0) {
        final now = DateTime.now();
        return DateTime(now.year, now.month, now.day - backward);
      }
    }
    return null;
  }

  DateTime _getLastDate(AppState state) {
    if (state != null) {
      final forward = hourDateOffsetForwardSelector(state);
      if (forward != null && forward >= 0) {
        return DateTime.now().add(Duration(days: forward));
      }
    }
    return null;
  }

  void _updateDate(DateTime newDate) {
    _selectedDate = DateTime(
      newDate.year ?? DateTime.now().year,
      newDate.month ?? DateTime.now().month,
      newDate.day ?? DateTime.now().day,
      _selectedDate.hour ?? DateTime.now().hour,
      _selectedDate.minute ?? DateTime.now().minute,
      _selectedDate.second ?? DateTime.now().second,
    );
    _dateController.text = DateFormat.yMd().format(_selectedDate);
  }

  Future _chooseTime(BuildContext context, String initialTimeString) async {
    var now = DateTime.now();
    var initialTime = _convertStringToTime(initialTimeString) ?? now;
    initialTime = (initialTime.year >= 2000 && initialTime.isBefore(now)
        ? initialTime
        : now);

    var result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (result == null) return;

    setState(() {
      time = result;
      _selectedDate = DateTime(
        _selectedDate.year ?? DateTime.now().year,
        _selectedDate.month ?? DateTime.now().month,
        _selectedDate.day ?? DateTime.now().day,
        result.hour ?? DateTime.now().hour,
        result.minute ?? DateTime.now().minute,
        _selectedDate.second ?? DateTime.now().second,
      );
      _timeController.text = DateFormat.Hm().format(_selectedDate);
    });
  }

  DateTime _convertStringToTime(String input) {
    try {
      var d = DateFormat.Hms().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  Future<String> _validate(Store<AppState> store) async {
    String result;

    result = _validateDescriptionRequired(store);
    if (result != null) {
      return result;
    }

    result = await _validateMaxHoursPerDay(store);
    if (result != null) {
      return result;
    }

    return null;
  }

  String _validateDescriptionRequired(Store<AppState> store) {
    if (hourDescriptionRequiredSelector(store.state)) {
      final description = jobDetails.text;
      if (description == null || description.isEmpty) {
        return 'Beskrivelse må fylles ut.';
      }
    }

    return null;
  }

  Future<String> _validateMaxHoursPerDay(Store<AppState> store) async {
    Database db = await DbUtil.db;
    String username = userSelector(store.state).username;

    final workTypeCodes = maxHoursPerDayWorkTypesSelector(store.state);
    if (!workTypeCodes.contains(_selectedWorkType.code)) {
      return null;
    }

    num maxHoursPerDay = maxHoursPerDaySelector(store.state);
    if (maxHoursPerDay <= 0) {
      return null;
    }

    num hourSum = hours;
    final maxHourErrorMessage = () {
      var message =
          'Du kan ikke registrere mer enn $maxHoursPerDay timer per dag.';
      if ((hourSum - hours) < maxHoursPerDay) {
        message +=
            ' Du kan maks registere ${maxHoursPerDay - (hourSum - hours)} timer til på denne datoen.';
      }
      return message;
    };

    final postingDateTimeFilter =
        _selectedDate.year.toString().padLeft(4, '0') +
            _selectedDate.month.toString().padLeft(2, '0') +
            _selectedDate.day.toString().padLeft(2, '0') +
            '%';

    // Job Journal Lines
    var query =
        'SELECT SUM(Quantity) as sum_of_qty FROM ${DBJobJournalLine.TABLE_NAME} WHERE User = ? AND Posting_Date_Time LIKE ? AND Work_Type_Code IN (${workTypeCodes.map((_) => '?').join(', ')})';
    var whereArgs = [username, postingDateTimeFilter];
    whereArgs.addAll(workTypeCodes);
    try {
      final rows = await db?.rawQuery(query, whereArgs);
      if (rows != null) {
        hourSum =
            rows.fold(hourSum, (currSum, row) => currSum + row['sum_of_qty']);
      }
    } catch (e) {}

    if (hourSum > maxHoursPerDay) {
      return maxHourErrorMessage();
    }

    // Job Ledger Entries
    query =
        'SELECT SUM(Quantity) as sum_of_qty FROM ${DBJobLedgerEntry.TABLE_NAME} WHERE User = ? AND Posting_Date_Time LIKE ? AND Work_Type_Code IN (${workTypeCodes.map((_) => '?').join(', ')})';
    try {
      final rows = await db?.rawQuery(query, whereArgs);
      if (rows != null) {
        hourSum =
            rows.fold(hourSum, (currSum, row) => currSum + row['sum_of_qty']);
      }
    } catch (e) {}

    if (hourSum > maxHoursPerDay) {
      return maxHourErrorMessage();
    }

    // Job Hours
    query = 'SELECT * FROM ${DBLog.TABLE_NAME} WHERE User = ? AND Command = ?';
    whereArgs = [username, JobHour.COMMAND];
    try {
      final rows = await db?.rawQuery(query, whereArgs);
      if (rows != null) {
        final jobHours = rows.map((row) =>
            JobHour.decodeFromLogState(LogState.decodeDB(Map.of(row))));
        hourSum = jobHours.fold(hourSum, (currSum, jobHour) {
          final a = jobHour.postingDateTime;
          final b = _selectedDate;
          if (workTypeCodes.contains(jobHour.workTypeCode.trim()) &&
              a.year == b.year &&
              a.month == b.month &&
              a.day == b.day) {
            currSum += jobHour.quantity;
          }
          return currSum;
        });
      }
    } catch (e) {}

    if (hourSum > maxHoursPerDay) {
      return maxHourErrorMessage();
    }

    return null;
  }
}
