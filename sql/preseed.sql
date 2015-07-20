/*
 * Tests to ensure that objects/data that exists pre-clone is successfully
 * cloned. The results are checked, after the clone, in preseed_check.sql.
 */

-- Unfortunately the cloned DB currently isn't the same between bdr and udr
SELECT current_setting('bdrtest.origdb') AS origdb
\gset
\c :origdb

DO $DO$BEGIN
IF bdr.bdr_variant() = 'BDR' THEN
    SET default_sequenceam = local;
END IF;
END; $DO$;

CREATE SEQUENCE some_local_seq;
CREATE TABLE some_local_tbl(id serial primary key, key text unique not null, data text);
INSERT INTO some_local_tbl(key, data) VALUES('key1', 'data1');
INSERT INTO some_local_tbl(key, data) VALUES('key2', NULL);
INSERT INTO some_local_tbl(key, data) VALUES('key3', 'data3');

ALTER TABLE some_local_tbl ADD COLUMN col_to_drop text;
UPDATE some_local_tbl SET col_to_drop = 'dropped';
INSERT INTO some_local_tbl(key,data,col_to_drop) VALUES ('key4', 'data4', 'dropme');
ALTER TABLE some_local_tbl DROP COLUMN col_to_drop;
