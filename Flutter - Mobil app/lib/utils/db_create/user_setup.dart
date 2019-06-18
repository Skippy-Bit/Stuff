const CREATE_TABLE_USER_SETUP = '''
CREATE TABLE UserSetup(
  User TEXT,
  _InternalState INTEGER,
  ETag TEXT,
  Fields TEXT,
  User_ID TEXT,
  Resource_No TEXT,
  Auxiliary_Location TEXT,
  Warehouse_Location TEXT
)''';
const CREATE_INDICES_USER_SETUP = [
  'CREATE INDEX IF NOT EXISTS index_pk_user_setup ON UserSetup(User,User_ID,_InternalState);',
  'CREATE INDEX IF NOT EXISTS index_internalstate_user_setup ON UserSetup(User,_InternalState);',
];