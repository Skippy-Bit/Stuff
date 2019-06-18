const CREATE_TABLE_JOB_JOURNAL_LINE = '''
CREATE TABLE JobJournalLine(
  User TEXT,
  _InternalState INTEGER,
  ETag TEXT,
  Fields TEXT,
  Journal_Template_Name TEXT,
  Journal_Batch_Name TEXT,
  Line_No INTEGER,
  Job_No TEXT,
  Job_Task_No TEXT,
  Posting_Date TEXT,
  Document_No TEXT,
  TypeAsInt INTEGER,
  No TEXT,
  Description TEXT,
  Quantity REAL,
  Unit_of_Measure_Code TEXT,
  Location_Code TEXT,
  Work_Type_Code TEXT,
  Serial_No TEXT,
  Lot_No TEXT,
  Extended_Description TEXT,
  Posting_Date_Time TEXT,
  User_ID TEXT,
  UserName TEXT,
  UUID TEXT,
  _DetailFields BLOB
)''';
const CREATE_INDICES_JOB_JOURNAL_LINE = [
  'CREATE INDEX IF NOT EXISTS index_pk_job_journal_line ON JobJournalLine(User,Journal_Template_Name,Journal_Batch_Name,Line_No,_InternalState);',
  'CREATE INDEX IF NOT EXISTS index_internalstate_job_journal_line ON JobJournalLine(User,_InternalState);',
  'CREATE INDEX IF NOT EXISTS index_uuid_job_journal_line ON JobJournalLine(User,UUID);',
];