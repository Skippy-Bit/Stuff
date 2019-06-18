import 'package:e7mr/pages/job/usage/job_add_usage.dart';
import 'package:e7mr/state/actions/log_commands/job_hour.dart';
import 'package:e7mr/state/actions/log_commands/job_item_usage.dart';
import 'package:e7mr/state/models/generated/field_data.dart';
import 'package:e7mr/state/models/generated/job_journal_line_state.dart';
import 'package:e7mr/state/models/generated/job_ledger_entry_state.dart';
import 'package:e7mr/utils/constants.dart';
import 'package:e7mr/widgets/usage_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

class UsageModel {
  final List<UsageItemModel> items;

  UsageModel({
    @required this.items,
  });
}

class UsageItemModel {
  final String jobNo;
  final String jobTaskNo;
  final String no;
  final String description;
  final num quantity;
  final String unitOfMeasureCode;
  final String extendedDescription;
  final DateTime postingDateTime;
  final String workTypeCode;
  final String userID;
  final String userName;
  final int typeAsInt;
  final List<FieldData> detailFields;

  UsageItemModel({
    @required this.jobNo,
    @required this.jobTaskNo,
    this.no,
    this.description,
    @required this.quantity,
    @required this.unitOfMeasureCode,
    this.extendedDescription,
    this.workTypeCode,
    this.userID,
    this.userName,
    @required this.postingDateTime,
    @required this.typeAsInt,
    this.detailFields,
  }) : assert(postingDateTime != null);

  factory UsageItemModel.fromJobJournalLine(JobJournalLineState line) =>
      UsageItemModel(
        jobNo: line.jobNo,
        jobTaskNo: line.jobTaskNo,
        no: line.no,
        postingDateTime: line.postingDateTime,
        quantity: line.quantity,
        typeAsInt: line.typeAsInt,
        unitOfMeasureCode: line.unitOfMeasureCode,
        workTypeCode: line.workTypeCode,
        userID: line.userID,
        userName: line.userName,
        description: line.description,
        extendedDescription: line.extendedDescription,
        detailFields: line.detailFields,
      );
  factory UsageItemModel.fromJobLedgerEntry(JobLedgerEntryState entry) =>
      UsageItemModel(
        jobNo: entry.jobNo,
        jobTaskNo: entry.jobTaskNo,
        no: entry.no,
        postingDateTime: entry.postingDateTime,
        quantity: entry.quantity,
        typeAsInt: entry.typeAsInt,
        workTypeCode: entry.workTypeCode,
        unitOfMeasureCode: entry.unitOfMeasureCode,
        userID: entry.userID,
        userName: entry.userID,
        description: entry.description,
        detailFields: entry.detailFields,
      );

  factory UsageItemModel.fromJobHour(JobHour hour) => UsageItemModel(
        jobNo: hour.jobNo,
        jobTaskNo: hour.jobTaskNo,
        postingDateTime: hour.postingDateTime,
        quantity: hour.quantity,
        typeAsInt: JOB_JOURNAL_LINE_TYPE_RESOURCE,
        workTypeCode: hour.workTypeCode,
        unitOfMeasureCode: hour.unitOfMeasureCode,
        description: hour.description,
        detailFields: hour.fields,
      );

  factory UsageItemModel.fromJobItemUsage(JobItemUsage usage) => UsageItemModel(
        jobNo: usage.jobNo,
        jobTaskNo: usage.jobTaskNo,
        postingDateTime: usage.postingDateTime,
        no: usage.itemNo,
        quantity: usage.quantity,
        typeAsInt: JOB_JOURNAL_LINE_TYPE_ITEM,
        unitOfMeasureCode: usage.unitOfMeasureCode,
        description: usage.description,
        detailFields: usage.fields,
      );

  Widget buildUsageListTile({
    bool showJob = true,
    bool showTask = true,
  }) {
    final t = (showJob ? jobNo : '') +
        (showJob && showTask ? ' - ' : '') +
        (showTask ? jobTaskNo : '');

    final actions = List<Widget>();
    if (typeAsInt == JOB_JOURNAL_LINE_TYPE_ITEM) {
      actions.add(Builder(
        builder: (context) => IconButton(
              icon: Icon(Icons.assignment_return),
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => JobAddUsagePage(
                          title: 'Returner $description',
                          jobNo: jobNo,
                          jobTaskNo: jobTaskNo,
                          itemNo: no,
                          itemDescription: description,
                          itemUoM: unitOfMeasureCode,
                          lockItem: true,
                          maxQuantity: 0,
                          returnMode: true,
                        ),
                  ),
                );
              },
            ),
      ));
    }

    Widget widget = UsageListTile(UsageListTileModel(
      title: t,
      subtitle: (no != null ? no + ' - ' : '') + (description ?? ''),
      description: extendedDescription,
      trailingTitle: 'Forbruk:',
      trailingValue: '$quantity $unitOfMeasureCode',
      detailFields: detailFields,
      actions: actions,
    ));

    if (typeAsInt == JOB_JOURNAL_LINE_TYPE_ITEM) {
      widget = Dismissible(
        key: ObjectKey(this),
        child: widget,
        direction: DismissDirection.endToStart,
        background: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    'Returner',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(
                  Icons.assignment_return,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          color: Colors.red,
        ),
        // TODO: Venter på at https://github.com/flutter/flutter/pull/26901 skal bli released.
      );
    }
    return widget;
  }
}
