const CREATE_TABLE_USER_LOCATION = '''
CREATE TABLE UserLocation(
  User TEXT,
  _InternalState INTEGER,
  ETag TEXT,
  Fields TEXT,
  User_ID TEXT,
  Location_Code TEXT
)''';
const CREATE_INDICES_USER_LOCATION = [
  'CREATE INDEX IF NOT EXISTS index_pk_user_location ON UserLocation(User,User_ID,Location_Code,_InternalState);',
  'CREATE INDEX IF NOT EXISTS index_internalstate_user_location ON UserLocation(User,_InternalState);',
];