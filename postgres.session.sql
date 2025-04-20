CREATE DATABASE "music"  WITH
  OWNER DEFAULT
  TABLESPACE DEFAULT
  LC_COLLATE DEFAULT
  LC_CTYPE DEFAULT
  ICU_RULES DEFAULT
  LOCALE_PROVIDER DEFAULT
  STRATEGY WAL_LOG
  ALLOW_CONNECTIONS TRUE
  CONNECTION LIMIT -1
  IS_TEMPLATE FALSE
  ENCODING DEFAULT
;

BEGIN TRANSACTION;
CREATE TABLE "genres" (
  "id" SERIAL PRIMARY KEY,
  "genre" VARCHAR(30),
  CONSTRAINT genre_not_pop CHECK("genre" NOT LIKE '%pop%')
);
CREATE ROLE "user1";
CREATE ROLE "user2";
CREATE GROUP "users" WITH;
GRANT "users" TO 
  "user1", 
  "user2"
;
GRANT SELECT 
  ON "genres"
  TO "users" 
;
END;

DROP FUNCTION IF EXISTS "add_genres";
CREATE FUNCTION "add_genres"(
  new_genres VARIADIC VARCHAR(30)[]
)
  RETURNS TABLE (
    "genre" VARCHAR(30)
  )
  LANGUAGE plpgsql
  AS $$
DECLARE
  elem VARCHAR(30);
BEGIN
  FOREACH elem IN ARRAY new_genres LOOP
    INSERT INTO "genres" ("genre") VALUES (
      elem
    );
  END LOOP;
  RETURN QUERY 
    SELECT g."genre" 
    FROM "genres" AS g;
END;
$$;

REVOKE SELECT ON TABLE "genres" FROM "users";
GRANT SELECT ON TABLE "genres" TO "user2";

--
DROP TYPE IF EXISTS genre_name;
CREATE TYPE genre_name AS (
  genre VARCHAR(30)
);

DROP FUNCTION IF EXISTS "add_genres2";
CREATE FUNCTION "add_genres2"(
  new_genres VARIADIC genre_name[]
  -- new_genres VARIADIC VARCHAR(30)[]
)
  RETURNS SETOF "genres"
  LANGUAGE plpgsql
  AS $$
DECLARE
  elem genres.genre%TYPE;
BEGIN
  FOREACH elem IN ARRAY new_genres LOOP
    INSERT INTO "genres" ("genre") VALUES (elem);
  END LOOP;
  RETURN QUERY
    SELECT g."genre"
    FROM "genres" AS g
  ;
END;
$$;

-- 
DROP TYPE IF EXISTS cat_things;
CREATE TYPE cat_things AS (
  name VARCHAR(10),
  age SMALLINT
);

DROP TABLE IF EXISTS cats;
CREATE TABLE cats (
  id SERIAL PRIMARY KEY,

)


CREATE TYPE genre_type AS (
  "name" VARCHAR(30),
  "start_year" DATE
);

CREATE TABLE genre_table (
  id SERIAL PRIMARY KEY,
  genre_info genre_type
);

INSERT INTO "genre_table" ("genre_info") VALUES 
  (ROW('cat music', '2004-01-01')::genre_type)
;

SELECT (genre_info).start_year FROM "genre_table";

CREATE TYPE cat AS (name VARCHAR(20), age SMALLINT);
CREATE TABLE cats (id SERIAL PRIMARY KEY, cat_info cat);

INSERT INTO "cats" ("cat_info")
VALUES (ROW('jo', 2)::cat);

DROP DOMAIN IF EXISTS "human_name";
CREATE DOMAIN "human_name" AS 
  VARCHAR(30)
  NOT NULL
  CONSTRAINT "min_length" CHECK (length(VALUE) > 5)
  CONSTRAINT "no_spaces" CHECK (VALUE !~ '^.* .*$')
;

DROP TABLE IF EXISTS "humans";
CREATE TABLE "humans" (
  "id" SERIAL PRIMARY KEY,
  "name" human_name
);

INSERT INTO "humans" ("name") VALUES 
  ('aa booa')
;

CREATE FUNCTION add("left" SMALLINT, "right" SMALLINT)
  RETURNS SMALLINT
  LANGUAGE plpgsql
  AS $$
BEGIN
  RETURN "left" + "right";
END;
$$;
  

CREATE TABLE "some_random_table" (
  id SERIAL PRIMARY KEY
);

CREATE TYPE "some_random_table" as (
  "name" varchar(2)
);

CREATE TYPE "mood" AS ENUM ('sad', 'ok', 'happy');

CREATE TABLE "moody" (
  current mood
);

INSERT INTO "moody" ("current") VALUES
  ('ss');

CREATE FUNCTION add2("left" SMALLINT, "right" SMALLINT) 
  RETURNS SMALLINT 
  LANGUAGE plpgsql
  AS $$ 
BEGIN 
  RETURN "left" + "right";
END;
$$;

-- fibonacci baby
DROP FUNCTION IF EXISTS fibonacci;
CREATE FUNCTION fibonacci("count" INT) 
  RETURNS INT[]
  LANGUAGE plpgsql
  AS $$
DECLARE
  "items" INT[] = ARRAY[]::INT[];
  "memo" INT[] = ARRAY[0, 1];
BEGIN
  FOR i IN 1.."count" LOOP
    IF array_length("memo", 1) = i - 1 THEN
      "memo" = "memo" || memo[i - 1] + memo[i - 2];
    END IF;
    "items" = "items" || memo[i];
  END LOOP;
  RETURN "items";
END;
$$;

-- generator
DROP FUNCTION IF EXISTS generate_series2;
CREATE FUNCTION generate_series2("start" INT, "end" INT)
  RETURNS SETOF INT
  LANGUAGE plpgsql
  AS $$
BEGIN
  FOR i IN "start".."end" LOOP
    RETURN NEXT i;
  END LOOP;
END;
$$;

DROP TABLE IF EXISTS "nums";
CREATE TABLE "nums" (
  num INT
);

INSERT INTO "nums" ("num") SELECT generate_series2(20, 50);

SELECT * FROM "nums";

DROP TABLE IF EXISTS "fib1";
CREATE TABLE "fib1" (
  "nums" INT[]
);

INSERT INTO "fib1" ("nums") SELECT fibonacci(6::SMALLINT);
SELECT "nums"[1:4] FROM "fib1";

DROP FUNCTION IF EXISTS "squares";
CREATE FUNCTION "squares"("start" INT, "end" INT)
  RETURNS SETOF INT
  LANGUAGE plpgsql
  AS $$
BEGIN
  FOR i IN "start".."end" LOOP
    RETURN NEXT power(i, 2);
  END LOOP;
  RETURN;
END;
$$;

CREATE TABLE "squares_table" (
  "num" INT,
  "square" INT
);

SELECT 
  ROW_NUMBER() OVER () - 1 as "number", 
  * 
FROM squares(1, 4) as "square";

SELECT 
  ROW_NUMBER() OVER () AS "num",
  *
FROM unnest(ARRAY[3,4,5]) AS "arr";


SELECT 
  generate_series(0, "row_num") as "se",
  "nums"
FROM (
  SELECT 
    ROW_NUMBER() OVER () as "row_num",
    *
  FROM (
    SELECT unnest("nums") AS "nums"
    FROM "fib1"
  )
)
;

DROP TYPE IF EXISTS "num_type";
CREATE TYPE "num_type" AS ENUM (
  'one', 
  'two', 
  'three'
);
DROP TABLE IF EXISTS "some_nums";
CREATE TABLE "some_nums"(
  "num" INT,
  "type" num_type
);

INSERT INTO "some_nums" ("num", "div")
  SELECT 
    "num",
    CASE
      WHEN "num" % 3 = 1 THEN 'one'::num_type
      WHEN "num" % 3 = 2 THEN 'two'::num_type
      ELSE 'three'::num_type
    END AS "div"
  FROM generate_series(0, 20) AS "num"
;

DROP VIEW IF EXISTS "fb_kind";
CREATE TYPE "fb_kind" AS ENUM (
  '',
  'fizz',
  'buzz',
  'fizzbuzz'
);



DROP VIEW IF EXISTS "fizzbuzz" CASCADE;
CREATE VIEW "fizzbuzz" AS
  SELECT 
    "number",
    (
      CASE
        WHEN "number" % 3 = 0 THEN 'fizz'
        ELSE ''
      END 
      || 
      CASE
        WHEN "number" % 5 = 0 THEN 'buzz'
        ELSE ''
      END
    )::fb_kind AS "kind"
  FROM generate_series(1, 200) AS "number"
;

SELECT * FROM "fizzbuzz";

DROP VIEW IF EXISTS "fizzbuzz_count";
CREATE VIEW "fizzbuzz_count" AS
  SELECT
    "number",
    "kind",
    row_number() OVER (
      PARTITION BY "kind"
      ORDER BY "number"
    )
  FROM "fizzbuzz"
  WHERE "kind" != ''::fb_kind
  ORDER BY "number"
;
SELECT * FROM "fizzbuzz_count";

START TRANSACTION;
  CREATE ROLE "a";
  CREATE ROLE "b";
  CREATE ROLE "g" WITH ROLE "a", "b";
END;

SELECT 
  g."rolname" AS "group",
  r."rolname" AS "role"
FROM "pg_auth_members" AS m
  JOIN "pg_roles" AS r ON r."oid" = m."member"
  JOIN "pg_roles" AS g ON g."oid" = m."roleid"
ORDER BY
  "role",
  "group"
;

SELECT 
  "nums",
  ROW_NUMBER() OVER () AS "count"
FROM 
  unnest(ARRAY[5,6,7]) as "nums"
;

-- Connection limit 0 for a connection
CREATE ROLE "a" WITH
  CONNECTION LIMIT 1;

ALTER ROLE "a" WITH 
  LOGIN
  ENCRYPTED PASSWORD 'hello'
;
GRANT CONNECT ON DATABASE "postgres" TO "a";

SELECT * FROM "pg_roles";

CREATE TABLE "cats" (
  "id" INT,
  "name" VARCHAR(30)
);

INSERT INTO "cats" ("id", "name") VALUES 
  (1, 'lulu'),
  (2, 'lili');

SELECT * FROM "cats";

INSERT INTO "public"."cats" ("id", "name") VALUES
  (6, 'ter'),
  (7, '99');

SHOW hba_file;
