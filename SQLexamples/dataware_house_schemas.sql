-- ********************************************************************************
-- * EXAMPLES FOR THE STAR AND SNOWFLAKE SCHEMAS USED TO ENCODE DATA CUBES
-- * AS RELATIONAL DATABASES
-- ********************************************************************************

-- ********************************************************************************
-- * STAR SCHEMA
-- ********************************************************************************
DROP SCHEMA star CASCADE;
CREATE SCHEMA star;

-- DIMENSION TIME: year --> month ------> day (D_min)
--                      \            /
--                       -> woy    -/
CREATE TABLE star.time (
  time_id SERIAL PRIMARY KEY,
  tyear INT,
  tmonth INT,
  twoy INT,
  tday INT
  );

-- DIMENSION LOCATION: country -> state -> zip -> street
CREATE TABLE star.location (
  location_id SERIAL PRIMARY KEY,
  country TEXT,
  state TEXT,
  zip NUMERIC(5,5),
  street TEXT
  );

-- FACT TABLE (num_sales) for dimensions location and time
CREATE TABLE star.fact (
  time_id INT NOT NULL,
  location_id INT NOT NULL,
  num_sales INT,
  PRIMARY KEY (time_id, location_id),
  FOREIGN KEY (time_id) REFERENCES star.time,
  FOREIGN KEY (location_id) REFERENCES star.location
  );

-- ********************************************************************************
-- * STAR SCHEMA
-- ********************************************************************************
DROP SCHEMA snowflake CASCADE;
CREATE SCHEMA snowflake;

-- DIMENSION TIME
CREATE TABLE snowflake.time_year (
  time_year_id SERIAL PRIMARY KEY,
  tyear INT
);

CREATE TABLE snowflake.time_month (
  time_month_id SERIAL PRIMARY KEY,
  time_year_id INT NOT NULL REFERENCES snowflake.time_year,
  tmonth INT
);

CREATE TABLE snowflake.time_woy (
  time_woy_id INT PRIMARY KEY,
  time_year_id INT NOT NULL REFERENCES snowflake.time_year,
  woy INT
);

-- this is D_min for dimension time
CREATE TABLE snowflake.time_day (
  time_day_id SERIAL PRIMARY KEY,
  time_month_id INT NOT NULL REFERENCES snowflake.time_month,
  time_woy_id INT NOT NULL REFERENCES snowflake.time_woy,
  day INT
);

-- DIMENSION LOCATION
CREATE TABLE snowflake.location_country (
  location_country_id SERIAL PRIMARY KEY,
  country TEXT
);

CREATE TABLE snowflake.location_state (
  location_state_id SERIAL PRIMARY KEY,
  location_country_id INT NOT NULL REFERENCES snowflake.location_country,
  state TEXT
  );

CREATE TABLE snowflake.location_zip (
  location_zip_id SERIAL PRIMARY KEY,
  location_state_id INT NOT NULL REFERENCES snowflake.location_state,
  zip NUMERIC(5,5)
  );

CREATE TABLE snowflake.location_street (
  location_street_id SERIAL PRIMARY KEY,
  location_zip_id INT NOT NULL REFERENCES snowflake.location_zip,
  street TEXT
  );

-- the fact table
CREATE TABLE snowflake.fact (
  time_id INT NOT NULL,
  location_id INT NOT NULL,
  num_sales INT,
  PRIMARY KEY (time_id, location_id),
  FOREIGN KEY (time_id) REFERENCES snowflake.time_day,
  FOREIGN KEY (location_id) REFERENCES snowflake.location_street
  );


-- ********************************************************************************
-- * INSERT EXAMPLE DATA
-- ********************************************************************************
INSERT INTO star.location VALUES (DEFAULT, 'USA', 'IL', 60616, '10 W 31st Street');
INSERT INTO star.location VALUES (DEFAULT, 'USA', 'IL', 60616, '155 W 33st Street');
INSERT INTO star.location VALUES (DEFAULT, 'USA', 'IL', 60615, '1034 53rd Street');
-- and so on
