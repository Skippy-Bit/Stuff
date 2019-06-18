const INTERNAL_STATE_NONE = 0;
const INTERNAL_STATE_POST = 1;
const INTERNAL_STATE_PUT = 2;

const ODATA_MAX_ENTITIES = 1000;

const SETTING_ENABLE_HOUR_MGMT = 'ENABLE_HOUR_MGMT';
const SETTING_ENABLE_INV_MGMT = 'ENABLE_INV_MGMT';

const JOB_JOURNAL_LINE_TYPE_RESOURCE = 0;
const JOB_JOURNAL_LINE_TYPE_ITEM = 1;
const JOB_JOURNAL_LINE_TYPE_GL_ACCOUNT = 2;

const HOUR_REG_TYPE_QTY = 0;
const HOUR_REG_TYPE_FROM = 1;
const HOUR_REG_TYPE_FROM_TO = 2;

const ATTACHMENT_TYPE_IMAGE = 0;
const ATTACHMENT_TYPE_PDF = 1;
const ATTACHMENT_TYPE_EMAIL = 2;

const MIN_YEAR = 2000;
const MAX_DATE_OFFSET = Duration(days: 60);

const SCHEMA_LINE_TYPE_NONE = 0;
const SCHEMA_LINE_TYPE_TEXT = 1;
const SCHEMA_LINE_TYPE_INTEGER = 2;
const SCHEMA_LINE_TYPE_DOUBLE = 3;
const SCHEMA_LINE_TYPE_BOOLEAN = 4;
const SCHEMA_LINE_TYPE_RADIO = 5;
const SCHEMA_LINE_TYPE_DROPDOWN = 6;
const SCHEMA_LINE_TYPE_CHECKBOX = 7;
const SCHEMA_LINE_TYPE_DATE = 8;
const SCHEMA_LINE_TYPE_TIME = 9;
const SCHEMA_LINE_TYPE_DATETIME = 10;
const SCHEMA_LINE_TYPE_PICTURE = 11;
const SCHEMA_LINE_TYPE_FILE = 12;
const SCHEMA_LINE_TYPE_BUTTON = 13;

const SCHEMA_LINE_RELATIONAL_LOOKUP_TYPE_NONE = 0;
const SCHEMA_LINE_RELATIONAL_LOOKUP_TYPE_DROPDOWN = 1;
const SCHEMA_LINE_RELATIONAL_LOOKUP_TYPE_SEARCH = 2;

const SCHEMA_LINE_ACTION_NONE = 0;
const SCHEMA_LINE_ACTION_CANCEL = 1;
const SCHEMA_LINE_ACTION_SAVE = 2;
const SCHEMA_LINE_ACTION_RESET = 3;
const SCHEMA_LINE_ACTION_SAVE_AND_RESET = 4;

const SCHEMA_LINE_POSITION_NONE = 0;
const SCHEMA_LINE_POSITION_FOOTER = 1;
const SCHEMA_LINE_POSITION_ACTION_BAR = 2;

const SCHEMA_LINE_IMPORTANCE_NONE = 0;
const SCHEMA_LINE_IMPORTANCE_PRIMARY = 1;
const SCHEMA_LINE_IMPORTANCE_SECONDARY = 2;
