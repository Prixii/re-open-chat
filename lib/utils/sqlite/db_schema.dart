const createApplicationTable = '''
CREATE TABLE IF NOT EXISTS application (
  id INTEGER NOT NULL,
  contact_id INTEGER NOT NULL,
  sender_id INTEGER NOT NULL,
  state integer NOT NULL,
  PRIMARY KEY ("id")
);''';
const createContactTable = '''
CREATE TABLE IF NOT EXISTS contact (
  id integer NOT NULL,
  avatar_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  profile TEXT NOT NULL,
  last_message_id INTEGER NOT NULL DEFAULT 0,
  unread_message_count integer NOT NULL DEFAULT 0,
  added_on integer NOT NULL DEFAULT 0,
  PRIMARY KEY ("id")
);''';
const createGroupMemberTable = '''
CREATE TABLE IF NOT EXISTS group_member (
  group_id INTEGER NOT NULL,
  member_id INTEGER NOT NULL,
  permission integer NOT NULL DEFAULT 0
);''';
const createMessageTable = '''
CREATE TABLE IF NOT EXISTS message (
  id integer NOT NULL,
  contact_id INTEGER NOT NULL,
  sender_id INTEGER NOT NULL,
  content TEXT NOT NULL,
  time DATE NOT NULL,
  imgs TEXT NOT NULL DEFAULT [],
  is_voice integer NOT NULL DEFAULT 0,
  PRIMARY KEY ("id")
);''';

const tableSchemas = [
  createApplicationTable,
  createContactTable,
  createGroupMemberTable,
  createMessageTable
];
