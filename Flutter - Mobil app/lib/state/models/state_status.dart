import 'package:e7mr/state/actions/base.actions.dart';

class StateStatus {
  StateStatus._internal({
    this.isLoading = false,
    this.isEmpty = true,
    this.error,
    DateTime lastUpdated,
    this.queryDistinct,
    this.queryWhere,
    this.queryWhereArgs,
    this.queryGroupBy,
    this.queryHaving,
    this.queryOrderBy,
    this.queryLimit,
    this.queryOffset,
    this.progressCurrent = 0,
    this.progressTotal = 0,
    this.progressMessage,
  }) : lastUpdated = lastUpdated ?? DateTime.fromMicrosecondsSinceEpoch(0);

  factory StateStatus.empty({
    DateTime lastUpdated,
    bool queryDistinct,
    String queryWhere,
    List queryWhereArgs,
    String queryGroupBy,
    String queryHaving,
    String queryOrderBy,
    int queryLimit,
    int queryOffset,
  }) =>
      StateStatus._internal(
        lastUpdated: lastUpdated,
        queryDistinct: queryDistinct,
        queryWhere: queryWhere,
        queryWhereArgs: queryWhereArgs,
        queryGroupBy: queryGroupBy,
        queryHaving: queryHaving,
        queryOrderBy: queryOrderBy,
        queryLimit: queryLimit,
        queryOffset: queryOffset,
      );

  factory StateStatus.loading({
    DateTime lastUpdated,
    bool queryDistinct,
    String queryWhere,
    List queryWhereArgs,
    String queryGroupBy,
    String queryHaving,
    String queryOrderBy,
    int queryLimit,
    int queryOffset,
    int progressCurrent,
    int progressTotal,
    String progressMessage,
  }) =>
      StateStatus._internal(
        isLoading: true,
        lastUpdated: lastUpdated,
        queryDistinct: queryDistinct,
        queryWhere: queryWhere,
        queryWhereArgs: queryWhereArgs,
        queryGroupBy: queryGroupBy,
        queryHaving: queryHaving,
        queryOrderBy: queryOrderBy,
        queryLimit: queryLimit,
        queryOffset: queryOffset,
        progressCurrent: progressCurrent,
        progressTotal: progressTotal,
        progressMessage: progressMessage,
      );

  factory StateStatus.loaded({
    DateTime lastUpdated,
    bool queryDistinct,
    String queryWhere,
    List queryWhereArgs,
    String queryGroupBy,
    String queryHaving,
    String queryOrderBy,
    int queryLimit,
    int queryOffset,
  }) =>
      StateStatus._internal(
        isEmpty: false,
        lastUpdated: lastUpdated,
        queryDistinct: queryDistinct,
        queryWhere: queryWhere,
        queryWhereArgs: queryWhereArgs,
        queryGroupBy: queryGroupBy,
        queryHaving: queryHaving,
        queryOrderBy: queryOrderBy,
        queryLimit: queryLimit,
        queryOffset: queryOffset,
      );

  factory StateStatus.err(
    ActionError e, {
    DateTime lastUpdated,
    bool queryDistinct,
    String queryWhere,
    List queryWhereArgs,
    String queryGroupBy,
    String queryHaving,
    String queryOrderBy,
    int queryLimit,
    int queryOffset,
  }) =>
      StateStatus._internal(
        error: e,
        lastUpdated: lastUpdated,
        queryDistinct: queryDistinct,
        queryWhere: queryWhere,
        queryWhereArgs: queryWhereArgs,
        queryGroupBy: queryGroupBy,
        queryHaving: queryHaving,
        queryOrderBy: queryOrderBy,
        queryLimit: queryLimit,
        queryOffset: queryOffset,
      );

  final bool isLoading;
  final bool isEmpty;
  final ActionError error;
  final DateTime lastUpdated;

  final bool queryDistinct;
  final String queryWhere;
  final List queryWhereArgs;
  final String queryGroupBy;
  final String queryHaving;
  final String queryOrderBy;
  final int queryLimit;
  final int queryOffset;

  final int progressCurrent;
  final int progressTotal;
  final String progressMessage;
  bool get inProgress =>
      (progressCurrent != progressTotal) ||
      (progressMessage != null && progressMessage.isNotEmpty);
}
