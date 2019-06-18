import 'package:e7mr/utils/db_create/log_extra_content.dart';
import 'package:e7mr/utils/db_create/item_quantity.dart';
import 'package:e7mr/utils/db_create/job_journal_line.dart';
import 'package:e7mr/utils/db_create/job_ledger_entry.dart';
import 'package:e7mr/utils/db_create/job_planning_line.dart';
import 'package:e7mr/utils/db_create/job_task.dart';
import 'package:e7mr/utils/db_create/job.dart';
import 'package:e7mr/utils/db_create/location.dart';
import 'package:e7mr/utils/db_create/log.dart';
import 'package:e7mr/utils/db_create/rejected_hour.dart';
import 'package:e7mr/utils/db_create/setup.dart';
import 'package:e7mr/utils/db_create/user_location.dart';
import 'package:e7mr/utils/db_create/user_setup.dart';
import 'package:e7mr/utils/db_create/work_type.dart';

const CREATE_TABLES = [
  CREATE_TABLE_LOG_EXTRA_CONTENT,
  CREATE_TABLE_ITEM_QUANTITY,
  CREATE_TABLE_JOB_JOURNAL_LINE,
  CREATE_TABLE_JOB_LEDGER_ENTRY,
  CREATE_TABLE_JOB_PLANNING_LINE,
  CREATE_TABLE_JOB_TASK,
  CREATE_TABLE_JOB,
  CREATE_TABLE_LOCATION,
  CREATE_TABLE_LOG,
  CREATE_TABLE_REJECTED_HOUR,
  CREATE_TABLE_SETUP,
  CREATE_TABLE_USER_LOCATION,
  CREATE_TABLE_USER_SETUP,
  CREATE_TABLE_WORK_TYPE,
];

const CREATE_INDICES = [
  CREATE_INDICES_LOG_EXTRA_CONTENT,
  CREATE_INDICES_ITEM_QUANTITY,
  CREATE_INDICES_JOB_JOURNAL_LINE,
  CREATE_INDICES_JOB_LEDGER_ENTRY,
  CREATE_INDICES_JOB_PLANNING_LINE,
  CREATE_INDICES_JOB_TASK,
  CREATE_INDICES_JOB,
  CREATE_INDICES_LOCATION,
  CREATE_INDICES_LOG,
  CREATE_INDICES_REJECTED_HOUR,
  CREATE_INDICES_SETUP,
  CREATE_INDICES_USER_LOCATION,
  CREATE_INDICES_USER_SETUP,
  CREATE_INDICES_WORK_TYPE,
];