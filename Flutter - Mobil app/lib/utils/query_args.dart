import 'package:e7mr/state/models/item_state.dart';
import 'package:e7mr/state/models/generated/item_quantity_state.dart';
import 'package:e7mr/state/models/generated/job_journal_line_state.dart';
import 'package:e7mr/state/models/generated/job_ledger_entry_state.dart';
import 'package:e7mr/state/models/generated/job_planning_line_state.dart';
import 'package:e7mr/state/models/generated/job_task_state.dart';
import 'package:e7mr/state/models/generated/job_state.dart';
import 'package:e7mr/state/models/generated/location_state.dart';
import 'package:e7mr/state/models/generated/log_state.dart';
import 'package:e7mr/state/models/generated/rejected_hour_state.dart';
import 'package:e7mr/state/models/generated/setup_state.dart';
import 'package:e7mr/state/models/generated/user_location_state.dart';
import 'package:e7mr/state/models/generated/user_setup_state.dart';
import 'package:e7mr/state/models/generated/work_type_state.dart';

class QueryArgs {
  final String query;
  final List<dynamic> args;
  final bool isCorrect;

  QueryArgs._internal(this.query, this.args, this.isCorrect);
  factory QueryArgs.fromItemQuantity(String username, ItemQuantityState model) {
    if (username != null && model != null) {
    if (model.rowID != null) {
        return QueryArgs._internal(
          'User = ? AND ROWID = ?',
          <dynamic>[username, model.rowID],
          true,
        );
      } else if (model.no != null) {
        return QueryArgs._internal(
          'User = ? AND No = ?',
          <dynamic>[username, model.no],
          true,
        );
      }
    }
    return QueryArgs._internal(null, null, false);
  }
  factory QueryArgs.fromJobJournalLine(String username, JobJournalLineState model) {
    if (username != null && model != null) {
      if (model.uuid != null && model.uuid != '') {
        return QueryArgs._internal(
          'User = ? AND UUID = ?',
          <dynamic>[username, model.uuid],
          true,
        );
      } else if (model.rowID != null) {
        return QueryArgs._internal(
          'User = ? AND ROWID = ?',
          <dynamic>[username, model.rowID],
          true,
        );
      } else if (model.journalTemplateName != null && model.journalBatchName != null && model.lineNo != null) {
        return QueryArgs._internal(
          'User = ? AND Journal_Template_Name = ? AND Journal_Batch_Name = ? AND Line_No = ?',
          <dynamic>[username, model.journalTemplateName, model.journalBatchName, model.lineNo],
          true,
        );
      }
    }
    return QueryArgs._internal(null, null, false);
  }
  factory QueryArgs.fromJobLedgerEntry(String username, JobLedgerEntryState model) {
    if (username != null && model != null) {
    if (model.rowID != null) {
        return QueryArgs._internal(
          'User = ? AND ROWID = ?',
          <dynamic>[username, model.rowID],
          true,
        );
      } else if (model.entryNo != null) {
        return QueryArgs._internal(
          'User = ? AND Entry_No = ?',
          <dynamic>[username, model.entryNo],
          true,
        );
      }
    }
    return QueryArgs._internal(null, null, false);
  }
  factory QueryArgs.fromJobPlanningLine(String username, JobPlanningLineState model) {
    if (username != null && model != null) {
    if (model.rowID != null) {
        return QueryArgs._internal(
          'User = ? AND ROWID = ?',
          <dynamic>[username, model.rowID],
          true,
        );
      } else if (model.jobNo != null && model.jobTaskNo != null && model.lineNo != null) {
        return QueryArgs._internal(
          'User = ? AND Job_No = ? AND Job_Task_No = ? AND Line_No = ?',
          <dynamic>[username, model.jobNo, model.jobTaskNo, model.lineNo],
          true,
        );
      }
    }
    return QueryArgs._internal(null, null, false);
  }
  factory QueryArgs.fromJobTask(String username, JobTaskState model) {
    if (username != null && model != null) {
    if (model.rowID != null) {
        return QueryArgs._internal(
          'User = ? AND ROWID = ?',
          <dynamic>[username, model.rowID],
          true,
        );
      } else if (model.jobNo != null && model.jobTaskNo != null) {
        return QueryArgs._internal(
          'User = ? AND Job_No = ? AND Job_Task_No = ?',
          <dynamic>[username, model.jobNo, model.jobTaskNo],
          true,
        );
      }
    }
    return QueryArgs._internal(null, null, false);
  }
  factory QueryArgs.fromJob(String username, JobState model) {
    if (username != null && model != null) {
    if (model.rowID != null) {
        return QueryArgs._internal(
          'User = ? AND ROWID = ?',
          <dynamic>[username, model.rowID],
          true,
        );
      } else if (model.no != null) {
        return QueryArgs._internal(
          'User = ? AND No = ?',
          <dynamic>[username, model.no],
          true,
        );
      }
    }
    return QueryArgs._internal(null, null, false);
  }
  factory QueryArgs.fromLocation(String username, LocationState model) {
    if (username != null && model != null) {
    if (model.rowID != null) {
        return QueryArgs._internal(
          'User = ? AND ROWID = ?',
          <dynamic>[username, model.rowID],
          true,
        );
      } else if (model.code != null) {
        return QueryArgs._internal(
          'User = ? AND Code = ?',
          <dynamic>[username, model.code],
          true,
        );
      }
    }
    return QueryArgs._internal(null, null, false);
  }
  factory QueryArgs.fromLog(String username, LogState model) {
    if (username != null && model != null) {
      if (model.uuid != null && model.uuid != '') {
        return QueryArgs._internal(
          'User = ? AND UUID = ?',
          <dynamic>[username, model.uuid],
          true,
        );
      } else if (model.rowID != null) {
        return QueryArgs._internal(
          'User = ? AND ROWID = ?',
          <dynamic>[username, model.rowID],
          true,
        );
      } else if (model.entryNo != null) {
        return QueryArgs._internal(
          'User = ? AND Entry_No = ?',
          <dynamic>[username, model.entryNo],
          true,
        );
      }
    }
    return QueryArgs._internal(null, null, false);
  }
  factory QueryArgs.fromRejectedHour(String username, RejectedHourState model) {
    if (username != null && model != null) {
    if (model.rowID != null) {
        return QueryArgs._internal(
          'User = ? AND ROWID = ?',
          <dynamic>[username, model.rowID],
          true,
        );
      } else if (model.entryNo != null) {
        return QueryArgs._internal(
          'User = ? AND Entry_No = ?',
          <dynamic>[username, model.entryNo],
          true,
        );
      }
    }
    return QueryArgs._internal(null, null, false);
  }
  factory QueryArgs.fromSetup(String username, SetupState model) {
    if (username != null && model != null) {
    if (model.rowID != null) {
        return QueryArgs._internal(
          'User = ? AND ROWID = ?',
          <dynamic>[username, model.rowID],
          true,
        );
      } else if (model.primaryKey != null) {
        return QueryArgs._internal(
          'User = ? AND Primary_Key = ?',
          <dynamic>[username, model.primaryKey],
          true,
        );
      }
    }
    return QueryArgs._internal(null, null, false);
  }
  factory QueryArgs.fromUserLocation(String username, UserLocationState model) {
    if (username != null && model != null) {
    if (model.rowID != null) {
        return QueryArgs._internal(
          'User = ? AND ROWID = ?',
          <dynamic>[username, model.rowID],
          true,
        );
      } else if (model.userID != null && model.locationCode != null) {
        return QueryArgs._internal(
          'User = ? AND User_ID = ? AND Location_Code = ?',
          <dynamic>[username, model.userID, model.locationCode],
          true,
        );
      }
    }
    return QueryArgs._internal(null, null, false);
  }
  factory QueryArgs.fromUserSetup(String username, UserSetupState model) {
    if (username != null && model != null) {
    if (model.rowID != null) {
        return QueryArgs._internal(
          'User = ? AND ROWID = ?',
          <dynamic>[username, model.rowID],
          true,
        );
      } else if (model.userID != null) {
        return QueryArgs._internal(
          'User = ? AND User_ID = ?',
          <dynamic>[username, model.userID],
          true,
        );
      }
    }
    return QueryArgs._internal(null, null, false);
  }
  factory QueryArgs.fromWorkType(String username, WorkTypeState model) {
    if (username != null && model != null) {
    if (model.rowID != null) {
        return QueryArgs._internal(
          'User = ? AND ROWID = ?',
          <dynamic>[username, model.rowID],
          true,
        );
      } else if (model.code != null) {
        return QueryArgs._internal(
          'User = ? AND Code = ?',
          <dynamic>[username, model.code],
          true,
        );
      }
    }
    return QueryArgs._internal(null, null, false);
  }
  factory QueryArgs.fromItem(String username, ItemState model) {
    if (username != null && model != null) {
      if (model.rowID != null) {
        return QueryArgs._internal(
          'User = ? AND ROWID = ?',
          <dynamic>[username, model.rowID],
          true,
        );
      } else if (model.no != null) {
        return QueryArgs._internal(
          'User = ? AND No = ?',
          <dynamic>[username, model.no],
          true,
        );
      }
    }
    return QueryArgs._internal(null, null, false);
  }
}
