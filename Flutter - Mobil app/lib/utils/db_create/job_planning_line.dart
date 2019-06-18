const CREATE_TABLE_JOB_PLANNING_LINE = '''
CREATE TABLE JobPlanningLine(
  User TEXT,
  _InternalState INTEGER,
  ETag TEXT,
  Fields TEXT,
  Job_No TEXT,
  Job_Task_No TEXT,
  Line_No INTEGER,
  Type INTEGER,
  No TEXT,
  Quantity REAL,
  Description TEXT,
  Unit_of_Measure_Code TEXT,
  Description_2 TEXT,
  _DetailFields BLOB
)''';
const CREATE_INDICES_JOB_PLANNING_LINE = [
  'CREATE INDEX IF NOT EXISTS index_pk_job_planning_line ON JobPlanningLine(User,Job_No,Job_Task_No,Line_No,_InternalState);',
  'CREATE INDEX IF NOT EXISTS index_internalstate_job_planning_line ON JobPlanningLine(User,_InternalState);',
];