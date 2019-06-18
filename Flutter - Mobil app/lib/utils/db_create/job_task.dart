const CREATE_TABLE_JOB_TASK = '''
CREATE TABLE JobTask(
  User TEXT,
  _InternalState INTEGER,
  ETag TEXT,
  Fields TEXT,
  Job_No TEXT,
  Job_Task_No TEXT,
  Description TEXT,
  Job_Task_Type TEXT,
  Start_Date TEXT,
  End_Date TEXT,
  Person_Responsible TEXT,
  PersonResponsibleName TEXT,
  _DetailFields BLOB
)''';
const CREATE_INDICES_JOB_TASK = [
  'CREATE INDEX IF NOT EXISTS index_pk_job_task ON JobTask(User,Job_No,Job_Task_No,_InternalState);',
  'CREATE INDEX IF NOT EXISTS index_internalstate_job_task ON JobTask(User,_InternalState);',
];