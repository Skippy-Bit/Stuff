import 'package:sqflite/sqflite.dart';
import 'package:e7mr/utils/db_repair/column.dart';
import 'package:e7mr/utils/db_create/log_extra_content.dart';
import 'package:e7mr/utils/db_create/item.dart';
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

class _RepairDBModel {
  Iterable<Column> existing;
  Iterable<Column> inModel;

  Iterable<Column> get overflow => existing.where((c) => !inModel.contains(c));
  Iterable<Column> get missing => inModel.where((c) => !existing.contains(c));
  Iterable<Column> get correct => existing.where((c) => inModel.contains(c));
}

repairDB(Database db) async {
  await _repairTable(
    db,
    'LogExtraContent',
    [CREATE_TABLE_LOG_EXTRA_CONTENT]..addAll(CREATE_INDICES_LOG_EXTRA_CONTENT),
    [
      Column(name: 'User', type: 'TEXT', notNull: false),
      Column(name: 'UUID', type: 'TEXT', notNull: false),
      Column(name: 'ExtraContentBLOB', type: 'BLOB', notNull: false),
    ],
  );
  await _repairTable(
    db,
    'ItemQuantity',
    [CREATE_TABLE_ITEM_QUANTITY]..addAll(CREATE_INDICES_ITEM_QUANTITY),
    [
      Column(name: 'User', type: 'TEXT', notNull: false),
      Column(name: '_InternalState', type: 'INTEGER', notNull: false),
      Column(name: 'ETag', type: 'TEXT', notNull: false),
      Column(name: 'Fields', type: 'TEXT', notNull: false),
      Column(name: 'No', type: 'TEXT', notNull: false),
      Column(name: 'Quantity', type: 'REAL', notNull: false),
      Column(name: 'Global_Dimension_1_Filter', type: 'TEXT', notNull: false),
      Column(name: 'Global_Dimension_2_Filter', type: 'TEXT', notNull: false),
      Column(name: 'Location_Filter', type: 'TEXT', notNull: false),
      Column(name: 'Drop_Shipment_Filter', type: 'TEXT', notNull: false),
      Column(name: 'Variant_Filter', type: 'TEXT', notNull: false),
      Column(name: 'Lot_No_Filter', type: 'TEXT', notNull: false),
      Column(name: 'Serial_No_Filter', type: 'TEXT', notNull: false),
    ],
  );
  await _repairTable(
    db,
    'Item',
    [CREATE_TABLE_ITEM]..addAll(CREATE_INDICES_ITEM),
    [
      Column(name: 'User', type: 'TEXT', notNull: false),
      Column(name: 'no', type: 'TEXT', notNull: false),
      Column(name: 'description', type: 'TEXT', notNull: false),
      Column(name: 'description2', type: 'TEXT', notNull: false),
      Column(name: 'uom', type: 'TEXT', notNull: false),
      Column(name: 'vendorNo', type: 'TEXT', notNull: false),
      Column(name: 'vendorItemNo', type: 'TEXT', notNull: false),
      Column(name: 'gtin', type: 'TEXT', notNull: false),
      Column(name: 'detailFields', type: 'BLOB', notNull: false),
    ],
  );
  await _repairTable(
    db,
    'JobJournalLine',
    [CREATE_TABLE_JOB_JOURNAL_LINE]..addAll(CREATE_INDICES_JOB_JOURNAL_LINE),
    [
      Column(name: 'User', type: 'TEXT', notNull: false),
      Column(name: '_InternalState', type: 'INTEGER', notNull: false),
      Column(name: 'ETag', type: 'TEXT', notNull: false),
      Column(name: 'Fields', type: 'TEXT', notNull: false),
      Column(name: 'Journal_Template_Name', type: 'TEXT', notNull: false),
      Column(name: 'Journal_Batch_Name', type: 'TEXT', notNull: false),
      Column(name: 'Line_No', type: 'INTEGER', notNull: false),
      Column(name: 'Job_No', type: 'TEXT', notNull: false),
      Column(name: 'Job_Task_No', type: 'TEXT', notNull: false),
      Column(name: 'Posting_Date', type: 'TEXT', notNull: false),
      Column(name: 'Document_No', type: 'TEXT', notNull: false),
      Column(name: 'TypeAsInt', type: 'INTEGER', notNull: false),
      Column(name: 'No', type: 'TEXT', notNull: false),
      Column(name: 'Description', type: 'TEXT', notNull: false),
      Column(name: 'Quantity', type: 'REAL', notNull: false),
      Column(name: 'Unit_of_Measure_Code', type: 'TEXT', notNull: false),
      Column(name: 'Location_Code', type: 'TEXT', notNull: false),
      Column(name: 'Work_Type_Code', type: 'TEXT', notNull: false),
      Column(name: 'Serial_No', type: 'TEXT', notNull: false),
      Column(name: 'Lot_No', type: 'TEXT', notNull: false),
      Column(name: 'Extended_Description', type: 'TEXT', notNull: false),
      Column(name: 'Posting_Date_Time', type: 'TEXT', notNull: false),
      Column(name: 'User_ID', type: 'TEXT', notNull: false),
      Column(name: 'UserName', type: 'TEXT', notNull: false),
      Column(name: 'UUID', type: 'TEXT', notNull: false),
      Column(name: '_DetailFields', type: 'BLOB', notNull: false),
    ],
  );
  await _repairTable(
    db,
    'Item',
    [CREATE_TABLE_ITEM]..addAll(CREATE_INDICES_ITEM),
    [
      Column(name: 'User', type: 'TEXT', notNull: false),
      Column(name: 'no', type: 'TEXT', notNull: false),
      Column(name: 'description', type: 'TEXT', notNull: false),
      Column(name: 'description2', type: 'TEXT', notNull: false),
      Column(name: 'uom', type: 'TEXT', notNull: false),
      Column(name: 'vendorNo', type: 'TEXT', notNull: false),
      Column(name: 'vendorItemNo', type: 'TEXT', notNull: false),
      Column(name: 'gtin', type: 'TEXT', notNull: false),
      Column(name: 'detailFields', type: 'BLOB', notNull: false),
    ],
  );
  await _repairTable(
    db,
    'JobLedgerEntry',
    [CREATE_TABLE_JOB_LEDGER_ENTRY]..addAll(CREATE_INDICES_JOB_LEDGER_ENTRY),
    [
      Column(name: 'User', type: 'TEXT', notNull: false),
      Column(name: '_InternalState', type: 'INTEGER', notNull: false),
      Column(name: 'ETag', type: 'TEXT', notNull: false),
      Column(name: 'Fields', type: 'TEXT', notNull: false),
      Column(name: 'Entry_No', type: 'INTEGER', notNull: false),
      Column(name: 'Job_No', type: 'TEXT', notNull: false),
      Column(name: 'Posting_Date', type: 'TEXT', notNull: false),
      Column(name: 'TypeAsInt', type: 'INTEGER', notNull: false),
      Column(name: 'No', type: 'TEXT', notNull: false),
      Column(name: 'Description', type: 'TEXT', notNull: false),
      Column(name: 'Quantity', type: 'REAL', notNull: false),
      Column(name: 'Unit_of_Measure_Code', type: 'TEXT', notNull: false),
      Column(name: 'Location_Code', type: 'TEXT', notNull: false),
      Column(name: 'Work_Type_Code', type: 'TEXT', notNull: false),
      Column(name: 'User_ID', type: 'TEXT', notNull: false),
      Column(name: 'Job_Task_No', type: 'TEXT', notNull: false),
      Column(name: 'Description_2', type: 'TEXT', notNull: false),
      Column(name: 'Line_Type', type: 'TEXT', notNull: false),
      Column(name: 'Posting_Date_Time', type: 'TEXT', notNull: false),
      Column(name: '_DetailFields', type: 'BLOB', notNull: false),
    ],
  );
  await _repairTable(
    db,
    'Item',
    [CREATE_TABLE_ITEM]..addAll(CREATE_INDICES_ITEM),
    [
      Column(name: 'User', type: 'TEXT', notNull: false),
      Column(name: 'no', type: 'TEXT', notNull: false),
      Column(name: 'description', type: 'TEXT', notNull: false),
      Column(name: 'description2', type: 'TEXT', notNull: false),
      Column(name: 'uom', type: 'TEXT', notNull: false),
      Column(name: 'vendorNo', type: 'TEXT', notNull: false),
      Column(name: 'vendorItemNo', type: 'TEXT', notNull: false),
      Column(name: 'gtin', type: 'TEXT', notNull: false),
      Column(name: 'detailFields', type: 'BLOB', notNull: false),
    ],
  );
  await _repairTable(
    db,
    'JobPlanningLine',
    [CREATE_TABLE_JOB_PLANNING_LINE]..addAll(CREATE_INDICES_JOB_PLANNING_LINE),
    [
      Column(name: 'User', type: 'TEXT', notNull: false),
      Column(name: '_InternalState', type: 'INTEGER', notNull: false),
      Column(name: 'ETag', type: 'TEXT', notNull: false),
      Column(name: 'Fields', type: 'TEXT', notNull: false),
      Column(name: 'Job_No', type: 'TEXT', notNull: false),
      Column(name: 'Job_Task_No', type: 'TEXT', notNull: false),
      Column(name: 'Line_No', type: 'INTEGER', notNull: false),
      Column(name: 'Type', type: 'INTEGER', notNull: false),
      Column(name: 'No', type: 'TEXT', notNull: false),
      Column(name: 'Quantity', type: 'REAL', notNull: false),
      Column(name: 'Description', type: 'TEXT', notNull: false),
      Column(name: 'Unit_of_Measure_Code', type: 'TEXT', notNull: false),
      Column(name: 'Description_2', type: 'TEXT', notNull: false),
      Column(name: '_DetailFields', type: 'BLOB', notNull: false),
    ],
  );
  await _repairTable(
    db,
    'Item',
    [CREATE_TABLE_ITEM]..addAll(CREATE_INDICES_ITEM),
    [
      Column(name: 'User', type: 'TEXT', notNull: false),
      Column(name: 'no', type: 'TEXT', notNull: false),
      Column(name: 'description', type: 'TEXT', notNull: false),
      Column(name: 'description2', type: 'TEXT', notNull: false),
      Column(name: 'uom', type: 'TEXT', notNull: false),
      Column(name: 'vendorNo', type: 'TEXT', notNull: false),
      Column(name: 'vendorItemNo', type: 'TEXT', notNull: false),
      Column(name: 'gtin', type: 'TEXT', notNull: false),
      Column(name: 'detailFields', type: 'BLOB', notNull: false),
    ],
  );
  await _repairTable(
    db,
    'JobTask',
    [CREATE_TABLE_JOB_TASK]..addAll(CREATE_INDICES_JOB_TASK),
    [
      Column(name: 'User', type: 'TEXT', notNull: false),
      Column(name: '_InternalState', type: 'INTEGER', notNull: false),
      Column(name: 'ETag', type: 'TEXT', notNull: false),
      Column(name: 'Fields', type: 'TEXT', notNull: false),
      Column(name: 'Job_No', type: 'TEXT', notNull: false),
      Column(name: 'Job_Task_No', type: 'TEXT', notNull: false),
      Column(name: 'Description', type: 'TEXT', notNull: false),
      Column(name: 'Job_Task_Type', type: 'TEXT', notNull: false),
      Column(name: 'Start_Date', type: 'TEXT', notNull: false),
      Column(name: 'End_Date', type: 'TEXT', notNull: false),
      Column(name: 'Person_Responsible', type: 'TEXT', notNull: false),
      Column(name: 'PersonResponsibleName', type: 'TEXT', notNull: false),
      Column(name: '_DetailFields', type: 'BLOB', notNull: false),
    ],
  );
  await _repairTable(
    db,
    'Item',
    [CREATE_TABLE_ITEM]..addAll(CREATE_INDICES_ITEM),
    [
      Column(name: 'User', type: 'TEXT', notNull: false),
      Column(name: 'no', type: 'TEXT', notNull: false),
      Column(name: 'description', type: 'TEXT', notNull: false),
      Column(name: 'description2', type: 'TEXT', notNull: false),
      Column(name: 'uom', type: 'TEXT', notNull: false),
      Column(name: 'vendorNo', type: 'TEXT', notNull: false),
      Column(name: 'vendorItemNo', type: 'TEXT', notNull: false),
      Column(name: 'gtin', type: 'TEXT', notNull: false),
      Column(name: 'detailFields', type: 'BLOB', notNull: false),
    ],
  );
  await _repairTable(
    db,
    'Job',
    [CREATE_TABLE_JOB]..addAll(CREATE_INDICES_JOB),
    [
      Column(name: 'User', type: 'TEXT', notNull: false),
      Column(name: '_InternalState', type: 'INTEGER', notNull: false),
      Column(name: 'ETag', type: 'TEXT', notNull: false),
      Column(name: 'Fields', type: 'TEXT', notNull: false),
      Column(name: 'No', type: 'TEXT', notNull: false),
      Column(name: 'Description', type: 'TEXT', notNull: false),
      Column(name: 'Starting_Date', type: 'TEXT', notNull: false),
      Column(name: 'Ending_Date', type: 'TEXT', notNull: false),
      Column(name: 'Status', type: 'TEXT', notNull: false),
      Column(name: 'Person_Responsible', type: 'TEXT', notNull: false),
      Column(name: 'PersonResponsibleName', type: 'TEXT', notNull: false),
      Column(name: 'Project_Manager', type: 'TEXT', notNull: false),
      Column(name: 'Project_Manager_Name', type: 'TEXT', notNull: false),
      Column(name: 'Ship_to_Name', type: 'TEXT', notNull: false),
      Column(name: 'Ship_to_Name_2', type: 'TEXT', notNull: false),
      Column(name: 'Ship_to_Contact', type: 'TEXT', notNull: false),
      Column(name: 'Ship_to_Address', type: 'TEXT', notNull: false),
      Column(name: 'Ship_to_Address_2', type: 'TEXT', notNull: false),
      Column(name: 'Ship_to_City', type: 'TEXT', notNull: false),
      Column(name: 'Ship_to_Post_Code', type: 'TEXT', notNull: false),
      Column(name: 'Bill_to_Name', type: 'TEXT', notNull: false),
      Column(name: 'Bill_to_Address', type: 'TEXT', notNull: false),
      Column(name: 'Bill_to_City', type: 'TEXT', notNull: false),
      Column(name: 'Bill_to_County', type: 'TEXT', notNull: false),
      Column(name: 'Bill_to_Post_Code', type: 'TEXT', notNull: false),
      Column(name: 'Bill_to_Country_Region_Code', type: 'TEXT', notNull: false),
      Column(name: 'Bill_to_Contact', type: 'TEXT', notNull: false),
      Column(name: 'Last_Date_Modified', type: 'TEXT', notNull: false),
      Column(name: '_DetailFields', type: 'BLOB', notNull: false),
    ],
  );
  await _repairTable(
    db,
    'Item',
    [CREATE_TABLE_ITEM]..addAll(CREATE_INDICES_ITEM),
    [
      Column(name: 'User', type: 'TEXT', notNull: false),
      Column(name: 'no', type: 'TEXT', notNull: false),
      Column(name: 'description', type: 'TEXT', notNull: false),
      Column(name: 'description2', type: 'TEXT', notNull: false),
      Column(name: 'uom', type: 'TEXT', notNull: false),
      Column(name: 'vendorNo', type: 'TEXT', notNull: false),
      Column(name: 'vendorItemNo', type: 'TEXT', notNull: false),
      Column(name: 'gtin', type: 'TEXT', notNull: false),
      Column(name: 'detailFields', type: 'BLOB', notNull: false),
    ],
  );
  await _repairTable(
    db,
    'Location',
    [CREATE_TABLE_LOCATION]..addAll(CREATE_INDICES_LOCATION),
    [
      Column(name: 'User', type: 'TEXT', notNull: false),
      Column(name: '_InternalState', type: 'INTEGER', notNull: false),
      Column(name: 'ETag', type: 'TEXT', notNull: false),
      Column(name: 'Fields', type: 'TEXT', notNull: false),
      Column(name: 'Code', type: 'TEXT', notNull: false),
      Column(name: 'Name', type: 'TEXT', notNull: false),
      Column(name: 'Name_2', type: 'TEXT', notNull: false),
      Column(name: 'Address', type: 'TEXT', notNull: false),
      Column(name: 'Address_2', type: 'TEXT', notNull: false),
      Column(name: 'City', type: 'TEXT', notNull: false),
      Column(name: 'Phone_No', type: 'TEXT', notNull: false),
      Column(name: 'Phone_No_2', type: 'TEXT', notNull: false),
      Column(name: 'Contact', type: 'TEXT', notNull: false),
      Column(name: 'Post_Code', type: 'TEXT', notNull: false),
      Column(name: 'County', type: 'TEXT', notNull: false),
      Column(name: 'E_Mail', type: 'TEXT', notNull: false),
      Column(name: 'Country_Region_Code', type: 'TEXT', notNull: false),
      Column(name: 'Home_Page', type: 'TEXT', notNull: false),
    ],
  );
  await _repairTable(
    db,
    'Item',
    [CREATE_TABLE_ITEM]..addAll(CREATE_INDICES_ITEM),
    [
      Column(name: 'User', type: 'TEXT', notNull: false),
      Column(name: 'no', type: 'TEXT', notNull: false),
      Column(name: 'description', type: 'TEXT', notNull: false),
      Column(name: 'description2', type: 'TEXT', notNull: false),
      Column(name: 'uom', type: 'TEXT', notNull: false),
      Column(name: 'vendorNo', type: 'TEXT', notNull: false),
      Column(name: 'vendorItemNo', type: 'TEXT', notNull: false),
      Column(name: 'gtin', type: 'TEXT', notNull: false),
      Column(name: 'detailFields', type: 'BLOB', notNull: false),
    ],
  );
  await _repairTable(
    db,
    'Log',
    [CREATE_TABLE_LOG]..addAll(CREATE_INDICES_LOG),
    [
      Column(name: 'User', type: 'TEXT', notNull: false),
      Column(name: '_InternalState', type: 'INTEGER', notNull: false),
      Column(name: 'ETag', type: 'TEXT', notNull: false),
      Column(name: 'Fields', type: 'TEXT', notNull: false),
      Column(name: 'Entry_No', type: 'INTEGER', notNull: false),
      Column(name: 'Time_Stamp', type: 'TEXT', notNull: false),
      Column(name: 'StatusAsInt', type: 'INTEGER', notNull: false),
      Column(name: 'Status_Message', type: 'TEXT', notNull: false),
      Column(name: 'ContentBLOB', type: 'BLOB', notNull: false),
      Column(name: 'User_ID', type: 'TEXT', notNull: false),
      Column(name: 'UUID', type: 'TEXT', notNull: false),
      Column(name: 'Command', type: 'TEXT', notNull: false),
      Column(name: 'Hash', type: 'TEXT', notNull: false),
      Column(name: 'ExtraContentBLOB', type: 'BLOB', notNull: false),
    ],
  );
  await _repairTable(
    db,
    'Item',
    [CREATE_TABLE_ITEM]..addAll(CREATE_INDICES_ITEM),
    [
      Column(name: 'User', type: 'TEXT', notNull: false),
      Column(name: 'no', type: 'TEXT', notNull: false),
      Column(name: 'description', type: 'TEXT', notNull: false),
      Column(name: 'description2', type: 'TEXT', notNull: false),
      Column(name: 'uom', type: 'TEXT', notNull: false),
      Column(name: 'vendorNo', type: 'TEXT', notNull: false),
      Column(name: 'vendorItemNo', type: 'TEXT', notNull: false),
      Column(name: 'gtin', type: 'TEXT', notNull: false),
      Column(name: 'detailFields', type: 'BLOB', notNull: false),
    ],
  );
  await _repairTable(
    db,
    'RejectedHour',
    [CREATE_TABLE_REJECTED_HOUR]..addAll(CREATE_INDICES_REJECTED_HOUR),
    [
      Column(name: 'User', type: 'TEXT', notNull: false),
      Column(name: '_InternalState', type: 'INTEGER', notNull: false),
      Column(name: 'ETag', type: 'TEXT', notNull: false),
      Column(name: 'Fields', type: 'TEXT', notNull: false),
      Column(name: 'Entry_No', type: 'INTEGER', notNull: false),
      Column(name: 'Job_No', type: 'TEXT', notNull: false),
      Column(name: 'Job_Task_No', type: 'TEXT', notNull: false),
      Column(name: 'Description', type: 'TEXT', notNull: false),
      Column(name: 'Reason', type: 'TEXT', notNull: false),
      Column(name: 'Original_Quantity', type: 'REAL', notNull: false),
      Column(name: 'Adjusted_Quantity', type: 'REAL', notNull: false),
      Column(name: 'GUID', type: 'TEXT', notNull: false),
    ],
  );
  await _repairTable(
    db,
    'Item',
    [CREATE_TABLE_ITEM]..addAll(CREATE_INDICES_ITEM),
    [
      Column(name: 'User', type: 'TEXT', notNull: false),
      Column(name: 'no', type: 'TEXT', notNull: false),
      Column(name: 'description', type: 'TEXT', notNull: false),
      Column(name: 'description2', type: 'TEXT', notNull: false),
      Column(name: 'uom', type: 'TEXT', notNull: false),
      Column(name: 'vendorNo', type: 'TEXT', notNull: false),
      Column(name: 'vendorItemNo', type: 'TEXT', notNull: false),
      Column(name: 'gtin', type: 'TEXT', notNull: false),
      Column(name: 'detailFields', type: 'BLOB', notNull: false),
    ],
  );
  await _repairTable(
    db,
    'Setup',
    [CREATE_TABLE_SETUP]..addAll(CREATE_INDICES_SETUP),
    [
      Column(name: 'User', type: 'TEXT', notNull: false),
      Column(name: '_InternalState', type: 'INTEGER', notNull: false),
      Column(name: 'ETag', type: 'TEXT', notNull: false),
      Column(name: 'Fields', type: 'TEXT', notNull: false),
      Column(name: 'Primary_Key', type: 'INTEGER', notNull: false),
      Column(name: 'Max_Hours_per_Day', type: 'REAL', notNull: false),
      Column(name: 'Max_Hours_per_Day_Work_Types', type: 'TEXT', notNull: false),
      Column(name: 'Hour_Description_Required', type: 'INTEGER', notNull: false),
      Column(name: 'Hour_Date_Offset_Backward', type: 'INTEGER', notNull: false),
      Column(name: 'Hour_Date_Offset_Forward', type: 'INTEGER', notNull: false),
      Column(name: 'Hour_Quantity_Shortcuts', type: 'TEXT', notNull: false),
      Column(name: 'Hour_Quantity_Increment', type: 'REAL', notNull: false),
      Column(name: 'Hour_Quantity_Decrement', type: 'REAL', notNull: false),
    ],
  );
  await _repairTable(
    db,
    'Item',
    [CREATE_TABLE_ITEM]..addAll(CREATE_INDICES_ITEM),
    [
      Column(name: 'User', type: 'TEXT', notNull: false),
      Column(name: 'no', type: 'TEXT', notNull: false),
      Column(name: 'description', type: 'TEXT', notNull: false),
      Column(name: 'description2', type: 'TEXT', notNull: false),
      Column(name: 'uom', type: 'TEXT', notNull: false),
      Column(name: 'vendorNo', type: 'TEXT', notNull: false),
      Column(name: 'vendorItemNo', type: 'TEXT', notNull: false),
      Column(name: 'gtin', type: 'TEXT', notNull: false),
      Column(name: 'detailFields', type: 'BLOB', notNull: false),
    ],
  );
  await _repairTable(
    db,
    'UserLocation',
    [CREATE_TABLE_USER_LOCATION]..addAll(CREATE_INDICES_USER_LOCATION),
    [
      Column(name: 'User', type: 'TEXT', notNull: false),
      Column(name: '_InternalState', type: 'INTEGER', notNull: false),
      Column(name: 'ETag', type: 'TEXT', notNull: false),
      Column(name: 'Fields', type: 'TEXT', notNull: false),
      Column(name: 'User_ID', type: 'TEXT', notNull: false),
      Column(name: 'Location_Code', type: 'TEXT', notNull: false),
    ],
  );
  await _repairTable(
    db,
    'Item',
    [CREATE_TABLE_ITEM]..addAll(CREATE_INDICES_ITEM),
    [
      Column(name: 'User', type: 'TEXT', notNull: false),
      Column(name: 'no', type: 'TEXT', notNull: false),
      Column(name: 'description', type: 'TEXT', notNull: false),
      Column(name: 'description2', type: 'TEXT', notNull: false),
      Column(name: 'uom', type: 'TEXT', notNull: false),
      Column(name: 'vendorNo', type: 'TEXT', notNull: false),
      Column(name: 'vendorItemNo', type: 'TEXT', notNull: false),
      Column(name: 'gtin', type: 'TEXT', notNull: false),
      Column(name: 'detailFields', type: 'BLOB', notNull: false),
    ],
  );
  await _repairTable(
    db,
    'UserSetup',
    [CREATE_TABLE_USER_SETUP]..addAll(CREATE_INDICES_USER_SETUP),
    [
      Column(name: 'User', type: 'TEXT', notNull: false),
      Column(name: '_InternalState', type: 'INTEGER', notNull: false),
      Column(name: 'ETag', type: 'TEXT', notNull: false),
      Column(name: 'Fields', type: 'TEXT', notNull: false),
      Column(name: 'User_ID', type: 'TEXT', notNull: false),
      Column(name: 'Resource_No', type: 'TEXT', notNull: false),
      Column(name: 'Auxiliary_Location', type: 'TEXT', notNull: false),
      Column(name: 'Warehouse_Location', type: 'TEXT', notNull: false),
    ],
  );
  await _repairTable(
    db,
    'Item',
    [CREATE_TABLE_ITEM]..addAll(CREATE_INDICES_ITEM),
    [
      Column(name: 'User', type: 'TEXT', notNull: false),
      Column(name: 'no', type: 'TEXT', notNull: false),
      Column(name: 'description', type: 'TEXT', notNull: false),
      Column(name: 'description2', type: 'TEXT', notNull: false),
      Column(name: 'uom', type: 'TEXT', notNull: false),
      Column(name: 'vendorNo', type: 'TEXT', notNull: false),
      Column(name: 'vendorItemNo', type: 'TEXT', notNull: false),
      Column(name: 'gtin', type: 'TEXT', notNull: false),
      Column(name: 'detailFields', type: 'BLOB', notNull: false),
    ],
  );
  await _repairTable(
    db,
    'WorkType',
    [CREATE_TABLE_WORK_TYPE]..addAll(CREATE_INDICES_WORK_TYPE),
    [
      Column(name: 'User', type: 'TEXT', notNull: false),
      Column(name: '_InternalState', type: 'INTEGER', notNull: false),
      Column(name: 'ETag', type: 'TEXT', notNull: false),
      Column(name: 'Fields', type: 'TEXT', notNull: false),
      Column(name: 'Code', type: 'TEXT', notNull: false),
      Column(name: 'Description', type: 'TEXT', notNull: false),
      Column(name: 'Unit_of_Measure_Code', type: 'TEXT', notNull: false),
    ],
  );
  await _repairTable(
    db,
    'Item',
    [CREATE_TABLE_ITEM]..addAll(CREATE_INDICES_ITEM),
    [
      Column(name: 'User', type: 'TEXT', notNull: false),
      Column(name: 'no', type: 'TEXT', notNull: false),
      Column(name: 'description', type: 'TEXT', notNull: false),
      Column(name: 'description2', type: 'TEXT', notNull: false),
      Column(name: 'uom', type: 'TEXT', notNull: false),
      Column(name: 'vendorNo', type: 'TEXT', notNull: false),
      Column(name: 'vendorItemNo', type: 'TEXT', notNull: false),
      Column(name: 'gtin', type: 'TEXT', notNull: false),
      Column(name: 'detailFields', type: 'BLOB', notNull: false),
    ],
  );
}

_repairTable(Database db, String tableName, Iterable<String> createTableStmts,
    Iterable<Column> modelColumns) async {
  await db.transaction((txn) async {
    _RepairDBModel columns = _RepairDBModel();
    columns.existing = await _extractColumnsFromTable(txn, tableName);
    columns.inModel = modelColumns;

    if (columns.existing == null || columns.existing.isEmpty) {
      // The table doesn't exist, so create it:
      createTableStmts.forEach((stmt) => txn.execute(stmt));
    } else {
      final overflow = columns.overflow;
      final missing = columns.missing;
      if (overflow.isEmpty && missing.isNotEmpty) {
        // Alter table to add missing columns.
        final batch = txn.batch();
        missing.forEach((c) {
          batch.execute(
              'ALTER TABLE ' + tableName + ' ADD COLUMN ' + c.sqlDefinition);
        });
        await batch.commit(noResult: true);
      } else if (overflow.isNotEmpty) {
        // Replace table to remove existing columns.
        final oldTableName = tableName + '___OLD';
        await txn.execute('DROP TABLE IF EXISTS ' + oldTableName);
        await txn
            .execute('ALTER TABLE ' + tableName + ' RENAME TO ' + oldTableName);
        createTableStmts.forEach((stmt) => txn.execute(stmt));

        final colsToCopy = columns.correct.map((c) => c.name).join(',');

        await txn.execute('INSERT INTO ' +
            tableName +
            ' (' +
            colsToCopy +
            ') SELECT ' +
            colsToCopy +
            ' FROM ' +
            oldTableName);
        await txn.execute('DROP TABLE ' + oldTableName);
      }
    }
  });
}

Future<Iterable<Column>> _extractColumnsFromTable(
    DatabaseExecutor exec, String tableName) async {
  final rows = await exec.rawQuery('PRAGMA table_info(' + tableName + ')');
  return rows.map((row) => Column.decodeDB(row));
}