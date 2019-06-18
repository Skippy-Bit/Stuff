import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/generated/work_type_state.dart';

Iterable<WorkTypeState> workTypesSelector(AppState state) => state.workTypes;
WorkTypeState workTypeSelector(AppState state, String workTypeCode) {
  if (workTypeCode == null || workTypeCode == '') {
    return null;
  }
  workTypeCode = workTypeCode.toUpperCase();
  return workTypesSelector(state).firstWhere(
      (workType) => workType.code.toUpperCase() == workTypeCode,
      orElse: () => null);
}
