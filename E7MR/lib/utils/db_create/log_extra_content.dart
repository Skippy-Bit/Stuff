const CREATE_TABLE_LOG_EXTRA_CONTENT = '''
CREATE TABLE LogExtraContent(
  User TEXT,
  UUID TEXT,
  ExtraContentBLOB BLOB
)''';
const CREATE_INDICES_LOG_EXTRA_CONTENT = [
  'CREATE INDEX IF NOT EXISTS index_pk_ ON LogExtraContent(User,UUID);',
];