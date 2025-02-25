/*
 * Test extension create/update/drop for each supported version. Should
 * probably be maintained automatedly at some point.
 */
CREATE DATABASE extension_upgrade;
\c extension_upgrade

-- Create prerequisite extensions
CREATE EXTENSION btree_gist;

-- create each version of the extension directly
CREATE EXTENSION bdr VERSION '0.8.0';
DROP EXTENSION bdr;

CREATE EXTENSION bdr VERSION '0.8.0.1';
DROP EXTENSION bdr;

CREATE EXTENSION bdr VERSION '0.8.0.2';
DROP EXTENSION bdr;

CREATE EXTENSION bdr VERSION '0.8.0.3';
DROP EXTENSION bdr;

CREATE EXTENSION bdr VERSION '0.8.0.4';
DROP EXTENSION bdr;

CREATE EXTENSION bdr VERSION '0.8.0.5';
DROP EXTENSION bdr;

CREATE EXTENSION bdr VERSION '0.8.0.6';
DROP EXTENSION bdr;

CREATE EXTENSION bdr VERSION '0.8.0.7';
DROP EXTENSION bdr;

CREATE EXTENSION bdr VERSION '0.9.0.0';
DROP EXTENSION bdr;

CREATE EXTENSION bdr VERSION '0.9.0.1';
DROP EXTENSION bdr;

CREATE EXTENSION bdr VERSION '0.9.0.2';
DROP EXTENSION bdr;

CREATE EXTENSION bdr VERSION '0.9.0.3';
DROP EXTENSION bdr;

CREATE EXTENSION bdr VERSION '0.9.0.4';
DROP EXTENSION bdr;

CREATE EXTENSION bdr VERSION '0.9.0.5';
DROP EXTENSION bdr;

CREATE EXTENSION bdr VERSION '0.9.1.0';
DROP EXTENSION bdr;

CREATE EXTENSION bdr VERSION '0.9.2.0';
DROP EXTENSION bdr;

CREATE EXTENSION bdr VERSION '0.9.3.0';
DROP EXTENSION bdr;

CREATE EXTENSION bdr VERSION '0.10.0.0';
DROP EXTENSION bdr;

CREATE EXTENSION bdr VERSION '0.10.0.1';
DROP EXTENSION bdr;

CREATE EXTENSION bdr VERSION '0.10.0.2';
DROP EXTENSION bdr;

CREATE EXTENSION bdr VERSION '0.10.0.3';
DROP EXTENSION bdr;

CREATE EXTENSION bdr VERSION '0.10.0.4';
DROP EXTENSION bdr;

CREATE EXTENSION bdr VERSION '0.10.0.5';
DROP EXTENSION bdr;

CREATE EXTENSION bdr VERSION '0.10.0.6';
DROP EXTENSION bdr;

CREATE EXTENSION bdr VERSION '0.10.0.7';
DROP EXTENSION bdr;

-- evolve version one by one from the oldest to the newest one
CREATE EXTENSION bdr VERSION '0.8.0';
ALTER EXTENSION bdr UPDATE TO '0.8.0.1';
ALTER EXTENSION bdr UPDATE TO '0.8.0.2';
ALTER EXTENSION bdr UPDATE TO '0.8.0.3';
ALTER EXTENSION bdr UPDATE TO '0.8.0.4';
ALTER EXTENSION bdr UPDATE TO '0.8.0.5';
ALTER EXTENSION bdr UPDATE TO '0.8.0.6';
ALTER EXTENSION bdr UPDATE TO '0.8.0.7';
ALTER EXTENSION bdr UPDATE TO '0.9.0.0';
ALTER EXTENSION bdr UPDATE TO '0.9.0.1';
ALTER EXTENSION bdr UPDATE TO '0.9.0.2';
ALTER EXTENSION bdr UPDATE TO '0.9.0.3';
ALTER EXTENSION bdr UPDATE TO '0.9.0.4';
ALTER EXTENSION bdr UPDATE TO '0.9.0.5';
ALTER EXTENSION bdr UPDATE TO '0.9.1.0';
ALTER EXTENSION bdr UPDATE TO '0.9.2.0';
ALTER EXTENSION bdr UPDATE TO '0.9.3.0';
ALTER EXTENSION bdr UPDATE TO '0.10.0.0';
ALTER EXTENSION bdr UPDATE TO '0.10.0.1';
ALTER EXTENSION bdr UPDATE TO '0.10.0.2';
ALTER EXTENSION bdr UPDATE TO '0.10.0.3';
ALTER EXTENSION bdr UPDATE TO '0.10.0.4';
ALTER EXTENSION bdr UPDATE TO '0.10.0.5';
ALTER EXTENSION bdr UPDATE TO '0.10.0.6';

-- We need a table with a faked "old" truncate trigger on it so we can test
-- this upgrade step. It doesn't matter that BDR will also create a new
-- tgisinternal one, we'll just get two. That won't happen in the wild.
CREATE TABLE truncate_trigger_upgrade(
	id integer
);

CREATE TRIGGER truncate_trigger AFTER TRUNCATE
ON truncate_trigger_upgrade FOR EACH STATEMENT EXECUTE PROCEDURE
bdr.queue_truncate();

SELECT
  CASE WHEN t.tgname LIKE 'truncate_trigger_%' THEN 'truncate_trigger_internal' ELSE t.tgname END,
  t.tgenabled, t.tgisinternal
FROM pg_catalog.pg_trigger t
WHERE t.tgrelid = 'truncate_trigger_upgrade'::regclass
ORDER BY t.tgname;

ALTER EXTENSION bdr UPDATE TO '0.10.0.7';

SELECT
  CASE WHEN t.tgname LIKE 'truncate_trigger_%' THEN 'truncate_trigger_internal' ELSE t.tgname END,
  t.tgenabled, t.tgisinternal
FROM pg_catalog.pg_trigger t
WHERE t.tgrelid = 'truncate_trigger_upgrade'::regclass
ORDER BY t.tgname;


-- Should never have to do anything: You missed adding the new version above.
ALTER EXTENSION bdr UPDATE;

\dx bdr

\c postgres
DROP DATABASE extension_upgrade;
