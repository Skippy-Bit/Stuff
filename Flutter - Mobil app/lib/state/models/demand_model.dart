import 'package:e7mr/pages/job/usage/job_add_usage.dart';
import 'package:e7mr/state/models/generated/field_data.dart';
import 'package:e7mr/state/models/generated/job_planning_line_state.dart';
import 'package:e7mr/utils/constants.dart';
import 'package:e7mr/widgets/demand_list_tile..dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

class DemandModel {
  final String jobNo;
  final String jobTaskNo;
  final String no;
  final String description;
  final num quantity;
  final String unitOfMeasureCode;
  final String extendedDescription;
  final int typeAsInt;
  final List<FieldData> detailFields;

  DemandModel({
    @required this.jobNo,
    @required this.jobTaskNo,
    this.no,
    this.description,
    @required this.quantity,
    @required this.unitOfMeasureCode,
    this.extendedDescription,
    @required this.typeAsInt,
    this.detailFields,
  });

  factory DemandModel.fromJobPlanningLine(JobPlanningLineState line) =>
      DemandModel(
        jobNo: line.jobNo,
        jobTaskNo: line.jobTaskNo,
        no: line.no,
        quantity: line.quantity,
        typeAsInt: line.type,
        unitOfMeasureCode: line.unitOfMeasureCode,
        description: line.description,
        extendedDescription: line.description2,
        detailFields: line.detailFields,
      );

  Widget buildDemandListTile({
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
              icon: Icon(Icons.assignment),
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => JobAddUsagePage(
                          title: 'Forbruk $description',
                          jobNo: jobNo,
                          jobTaskNo: jobTaskNo,
                          itemNo: no,
                          itemDescription: description,
                          itemUoM: unitOfMeasureCode,
                          lockItem: true,
                          maxQuantity: quantity,
                          returnMode: false,
                        ),
                  ),
                );
              },
            ),
      ));
    }

    Widget widget = DemandListTile(DemandListTileModel(
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
                    'Forbruk',
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
