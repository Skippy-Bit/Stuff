import 'package:e7mr/state/actions/item.actions.dart';
import 'package:e7mr/state/models/item_state.dart';
import 'package:redux/redux.dart';

final itemsReducer = combineReducers<Iterable<ItemState>>([
  TypedReducer<Iterable<ItemState>, LoadItemsSuccessAction>(
      _loadItemsSuccessAction),
]);

Iterable<ItemState> _loadItemsSuccessAction(
  Iterable<ItemState> state,
  LoadItemsSuccessAction action,
) {
  if (action.items != null) {
    state = action.items;
  }
  return state;
}
