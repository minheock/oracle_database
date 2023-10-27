create or replace directory MY_DUMP_DIR AS '/root';
GRANT READ, WRITE ON DIRECTORY MY_DUMP_DIR TO jdbc;