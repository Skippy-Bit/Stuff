import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/models/generated/location_state.dart';

Iterable<LocationState> locationsSelector(AppState state) => state.locations;

LocationState locationSelector(AppState state, String locationCode) {
  locationCode = locationCode.toUpperCase();
  return locationsSelector(state).firstWhere(
      (location) => location.code.toUpperCase() == locationCode,
      orElse: () => null);
}
