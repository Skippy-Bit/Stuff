const CREATE_TABLE_WORK_TYPE = '''
CREATE TABLE WorkType(
  User TEXT,
  _InternalState INTEGER,
  ETag TEXT,
  Fields TEXT,
  Code TEXT,
  Description TEXT,
  Unit_of_Measure_Code TEXT
)''';
const CREATE_INDICES_WORK_TYPE = [
  'CREATE INDEX IF NOT EXISTS index_pk_work_type ON WorkType(User,Code,_InternalState);',
  'CREATE INDEX IF NOT EXISTS index_internalstate_work_type ON WorkType(User,_InternalState);',
];