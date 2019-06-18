const CREATE_TABLE_LOG = '''
CREATE TABLE Log(
  User TEXT,
  _InternalState INTEGER,
  ETag TEXT,
  Fields TEXT,
  Entry_No INTEGER,
  Time_Stamp TEXT,
  StatusAsInt INTEGER,
  Status_Message TEXT,
  ContentBLOB BLOB,
  User_ID TEXT,
  UUID TEXT,
  Command TEXT,
  Hash TEXT,
  ExtraContentBLOB BLOB
)''';
const CREATE_INDICES_LOG = [
  'CREATE INDEX IF NOT EXISTS index_pk_log ON Log(User,Entry_No,_InternalState);',
  'CREATE INDEX IF NOT EXISTS index_internalstate_log ON Log(User,_InternalState);',
  'CREATE INDEX IF NOT EXISTS index_uuid_log ON Log(User,UUID);',
  'CREATE INDEX IF NOT EXISTS index_command_log ON Log(Command);',
];