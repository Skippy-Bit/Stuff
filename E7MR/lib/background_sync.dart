// import 'package:background_fetch/background_fetch.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:connectivity/connectivity.dart';
// import 'package:e7mr/utils/db.util.dart';
// import 'package:e7mr/state/models/user.dart';
// import 'package:e7mr/utils/constants.dart';
// import 'package:e7mr/utils/query_args.dart';
// import 'package:e7mr/state/middleware/auth_epics/auth.epic.dart';
// import 'package:e7mr/state/middleware/generated/log/db_log.dart';
// import 'package:e7mr/state/middleware/generated/log/post_log.dart';
// import 'package:e7mr/state/models/generated/log_state.dart';

// // THIS IS FOR ANDROID ONLY!
// // iOS doesn't allow for background processing.

// Future<void> backgroundFetchHeadlessTask() async {
//   final db = await DbUtil.db;
//   if (db != null) {
//     final offline =
//         (await Connectivity().checkConnectivity()) == ConnectivityResult.none;

//     if (!offline) {
//       final loginResult = await AuthEpic.checkStoredCredentials();
//       if (loginResult.success) {
//         final user = loginResult.user;
//         await Future.wait([
//           syncLogs(db, user),
//         ]);
//       }
//     }
//   }

//   BackgroundFetch.finish();
// }

// const _LOG_TABLE_NAME = 'Log';

// Future<void> syncLogs(Database db, User user) async {
//   Future.wait([postLogs(db, user)]);
// }

// Future<void> postLogs(Database db, User user) async {
//   final toPost = await DBLog.query(db, user.username,
//       internalState: INTERNAL_STATE_POST);

//   final success = List<LogState>();
//   final failed = List<LogState>();

//   await PostLog.postLogs(
//     toPost,
//     user.credentials,
//     success,
//     failed,
//   );

//   // Save the posted records to the database
//   try {
//     await db.transaction((txn) async {
//       final batch = txn.batch();

//       // Delete->Insert only the fetched records
//       for (var model in success) {
//         model = model.copyWith(internalState: INTERNAL_STATE_NONE);
//         final values = model.encodeDB(user.username);
//         final q = QueryArgs.fromLog(user.username, model);
//         if (q.isCorrect) {
//           batch.update(
//             _LOG_TABLE_NAME,
//             values,
//             where: q.query,
//             whereArgs: q.args,
//           );
//         }
//       }

//       batch.commit();
//     });
//   } catch (e) {
//     print('An unexpected error occurred in the database: $e');
//     return;
//   }
// }
