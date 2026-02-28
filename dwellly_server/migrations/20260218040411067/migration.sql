BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "favorite" ADD COLUMN "_roomFavoritesRoomId" bigint;
ALTER TABLE "favorite" ADD COLUMN "_userFavoritesUserId" bigint;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "review" ADD COLUMN "_roomReviewsRoomId" bigint;
ALTER TABLE "review" ADD COLUMN "_userReviewsUserId" bigint;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "user" ADD COLUMN "authUserId" text;
CREATE UNIQUE INDEX "user_auth_user_id_idx" ON "user" USING btree ("authUserId");
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "favorite"
    ADD CONSTRAINT "favorite_fk_2"
    FOREIGN KEY("_roomFavoritesRoomId")
    REFERENCES "room"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "favorite"
    ADD CONSTRAINT "favorite_fk_3"
    FOREIGN KEY("_userFavoritesUserId")
    REFERENCES "user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "review"
    ADD CONSTRAINT "review_fk_2"
    FOREIGN KEY("_roomReviewsRoomId")
    REFERENCES "room"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "review"
    ADD CONSTRAINT "review_fk_3"
    FOREIGN KEY("_userReviewsUserId")
    REFERENCES "user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- MIGRATION VERSION FOR room_rental
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('room_rental', '20260218040411067', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260218040411067', "timestamp" = now();

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
