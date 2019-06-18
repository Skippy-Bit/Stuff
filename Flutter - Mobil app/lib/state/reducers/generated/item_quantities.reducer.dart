import 'package:e7mr/state/actions/generated.actions.dart';
import 'package:e7mr/state/models/generated/item_quantity_state.dart';
import 'package:redux/redux.dart';

final itemQuantitiesReducer = combineReducers<Iterable<ItemQuantityState>>([
  TypedReducer<Iterable<ItemQuantityState>, LoadItemQuantitiesSuccessAction>(_loadItemQuantitiesSuccessAction),
]);

Iterable<ItemQuantityState> _loadItemQuantitiesSuccessAction(
  Iterable<ItemQuantityState> state,
  LoadItemQuantitiesSuccessAction action,
) {
  return state;
}