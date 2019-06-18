import 'package:e7mr/state/middleware/middleware_context.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:redux/redux.dart';

createThunkMiddleware<State>(MiddlewareContext context) =>
    (Store<AppState> store, dynamic action, NextDispatcher next) {
      if (action is ThunkAction<AppState>) {
        action(store, context);
      } else {
        next(action);
      }
    };

/// A function that can be dispatched as an action to a Redux [Store] and
/// intercepted by the the [thunkMiddleware]. It can be used to delay the
/// dispatch of an action, or to dispatch only if a certain condition is met.
///
/// The ThunkFunction receives a [Store], which it can use to get the latest
/// state if need be, or dispatch actions at the appropriate time.
typedef void ThunkAction<State>(Store<State> store, MiddlewareContext context);
