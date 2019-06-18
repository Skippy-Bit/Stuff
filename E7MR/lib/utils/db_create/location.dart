const CREATE_TABLE_LOCATION = '''
CREATE TABLE Location(
  User TEXT,
  _InternalState INTEGER,
  ETag TEXT,
  Fields TEXT,
  Code TEXT,
  Name TEXT,
  Name_2 TEXT,
  Address TEXT,
  Address_2 TEXT,
  City TEXT,
  Phone_No TEXT,
  Phone_No_2 TEXT,
  Contact TEXT,
  Post_Code TEXT,
  County TEXT,
  E_Mail TEXT,
  Country_Region_Code TEXT,
  Home_Page TEXT
)''';
const CREATE_INDICES_LOCATION = [
  'CREATE INDEX IF NOT EXISTS index_pk_location ON Location(User,Code,_InternalState);',
  'CREATE INDEX IF NOT EXISTS index_internalstate_location ON Location(User,_InternalState);',
];