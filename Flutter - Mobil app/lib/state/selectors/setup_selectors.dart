import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/generated/setup_state.dart';

SetupState setupSelector(AppState state) {
  final setups = state?.setups;
  if (setups != null && setups.isNotEmpty) {
    return setups.first;
  }
  return null;
}

num maxHoursPerDaySelector(AppState state) =>
    setupSelector(state)?.maxHoursPerDay ?? 0;

Iterable<String> maxHoursPerDayWorkTypesSelector(AppState state) =>
    setupSelector(state)?.maxHoursPerDayWorkTypes?.split(';') ??
    Iterable.empty();

bool hourDescriptionRequiredSelector(AppState state) =>
    setupSelector(state)?.hourDescriptionRequired ?? false;

int hourDateOffsetBackwardSelector(AppState state) =>
    setupSelector(state)?.hourDateOffsetBackward;

int hourDateOffsetForwardSelector(AppState state) =>
    setupSelector(state)?.hourDateOffsetForward;

num hourQuantityIncrementSelector(AppState state) =>
    setupSelector(state)?.hourQuantityIncrement ?? 0.5;

num hourQuantityDecrementSelector(AppState state) =>
    setupSelector(state)?.hourQuantityDecrement ?? 0.5;

Iterable<num> hourQuantityShortcutsSelector(AppState state) =>
    setupSelector(state)
        ?.hourQuantityShortcuts
        ?.split(';')
        ?.map((shortcut) => num.tryParse(shortcut))
        ?.where((shortcut) => shortcut != null) ??
    Iterable.empty();
