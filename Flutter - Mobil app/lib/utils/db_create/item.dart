const CREATE_TABLE_ITEM = '''
CREATE TABLE Item(
  User TEXT,
  no TEXT,
  description TEXT,
  description2 TEXT,
  uom TEXT,
  vendorNo TEXT,
  vendorItemNo TEXT,
  gtin TEXT,
  detailFields BLOB
)''';
const CREATE_INDICES_ITEM = [
  'CREATE INDEX IF NOT EXISTS index_pk_item ON Item(User,No);',
];
