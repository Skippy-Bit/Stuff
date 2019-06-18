const CREATE_TABLE_REJECTED_HOUR = '''
CREATE TABLE RejectedHour(
  User TEXT,
  _InternalState INTEGER,
  ETag TEXT,
  Fields TEXT,
  Entry_No INTEGER,
  Job_No TEXT,
  Job_Task_No TEXT,
  Description TEXT,
  Reason TEXT,
  Original_Quantity REAL,
  Adjusted_Quantity REAL,
  GUID TEXT
)''';
const CREATE_INDICES_REJECTED_HOUR = [
  'CREATE INDEX IF NOT EXISTS index_pk_rejected_hour ON RejectedHour(User,Entry_No,_InternalState);',
  'CREATE INDEX IF NOT EXISTS index_internalstate_rejected_hour ON RejectedHour(User,_InternalState);',
];