const CREATE_TABLE_SETUP = '''
CREATE TABLE Setup(
  User TEXT,
  _InternalState INTEGER,
  ETag TEXT,
  Fields TEXT,
  Primary_Key INTEGER,
  Max_Hours_per_Day REAL,
  Max_Hours_per_Day_Work_Types TEXT,
  Hour_Description_Required INTEGER,
  Hour_Date_Offset_Backward INTEGER,
  Hour_Date_Offset_Forward INTEGER,
  Hour_Quantity_Shortcuts TEXT,
  Hour_Quantity_Increment REAL,
  Hour_Quantity_Decrement REAL
)''';
const CREATE_INDICES_SETUP = [
  'CREATE INDEX IF NOT EXISTS index_pk_setup ON Setup(User,Primary_Key,_InternalState);',
  'CREATE INDEX IF NOT EXISTS index_internalstate_setup ON Setup(User,_InternalState);',
];