const CREATE_TABLE_JOB_LEDGER_ENTRY = '''
CREATE TABLE JobLedgerEntry(
  User TEXT,
  _InternalState INTEGER,
  ETag TEXT,
  Fields TEXT,
  Entry_No INTEGER,
  Job_No TEXT,
  Posting_Date TEXT,
  TypeAsInt INTEGER,
  No TEXT,
  Description TEXT,
  Quantity REAL,
  Unit_of_Measure_Code TEXT,
  Location_Code TEXT,
  Work_Type_Code TEXT,
  User_ID TEXT,
  Job_Task_No TEXT,
  Description_2 TEXT,
  Line_Type TEXT,
  Posting_Date_Time TEXT,
  _DetailFields BLOB
)''';
const CREATE_INDICES_JOB_LEDGER_ENTRY = [
  'CREATE INDEX IF NOT EXISTS index_pk_job_ledger_entry ON JobLedgerEntry(User,Entry_No,_InternalState);',
  'CREATE INDEX IF NOT EXISTS index_internalstate_job_ledger_entry ON JobLedgerEntry(User,_InternalState);',
];