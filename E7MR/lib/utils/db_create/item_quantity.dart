const CREATE_TABLE_ITEM_QUANTITY = '''
CREATE TABLE ItemQuantity(
  User TEXT,
  _InternalState INTEGER,
  ETag TEXT,
  Fields TEXT,
  No TEXT,
  Quantity REAL,
  Global_Dimension_1_Filter TEXT,
  Global_Dimension_2_Filter TEXT,
  Location_Filter TEXT,
  Drop_Shipment_Filter TEXT,
  Variant_Filter TEXT,
  Lot_No_Filter TEXT,
  Serial_No_Filter TEXT
)''';
const CREATE_INDICES_ITEM_QUANTITY = [
  'CREATE INDEX IF NOT EXISTS index_pk_item_quantity ON ItemQuantity(User,No,_InternalState);',
  'CREATE INDEX IF NOT EXISTS index_internalstate_item_quantity ON ItemQuantity(User,_InternalState);',
];