import 'package:e7mr/state/middleware/generated/middleware.dart';
import 'package:e7mr/state/middleware/middleware_context.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:e7mr/state/models/generated/app_state.dart';
import 'package:e7mr/state/middleware/auth_epics/auth.epic.dart';
import 'package:e7mr/state/middleware/thunk/thunk.middleware.dart';
import 'package:e7mr/state/middleware/generated/initial_load.middleware.dart';

List<Middleware<AppState>> createStoreMiddleware(MiddlewareContext context) {
  // TODO: Create createNavigatorMiddleware(context.navigatorKey) to navigate upon NavigateActions (instead of AuthMiddleware having to handle navigation).

  // TODO: Refactor AuthEpic into createAuthMiddleware(context.navigatorKey);
  final epics = List<Epic<AppState>>();
  epics.add(new AuthEpic(context.navigatorKey));
  final epicMiddleware = new EpicMiddleware(combineEpics<AppState>(epics));

  final middleware = <Middleware<AppState>>[
    createThunkMiddleware(context),
    initialLoadMiddleware,
    epicMiddleware,
  ];
  middleware.addAll(createGeneratedStoreMiddleware(context));
  return middleware;
}
