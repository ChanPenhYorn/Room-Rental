BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "chat_message" ADD COLUMN "messageType" text NOT NULL DEFAULT 'text'::text;
ALTER TABLE "chat_message" ADD COLUMN "attachmentUrl" text;
ALTER TABLE "chat_message" ADD COLUMN "attachmentDuration" bigint;
ALTER TABLE "chat_message" ADD COLUMN "attachmentName" text;
ALTER TABLE "chat_message" ADD COLUMN "attachmentSize" bigint;

--
-- MIGRATION VERSION FOR dwellly
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('dwellly', '20260305151033802', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260305151033802', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20260129181059877', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181059877', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260129181124635', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181124635', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260129181112269', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181112269', "timestamp" = now();


COMMIT;
