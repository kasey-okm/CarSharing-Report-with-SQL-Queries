-- CarSharing database schema (SQLite)
PRAGMA foreign_keys = ON;

CREATE TABLE time (
    id INTEGER PRIMARY KEY,
    timestamp TEXT NOT NULL,
    season TEXT NOT NULL,
    hour INTEGER NOT NULL,
    weekday_name TEXT NOT NULL,
    monthday_name TEXT NOT NULL
);

CREATE TABLE weather (
    weather TEXT NOT NULL,
    weather_code INTEGER PRIMARY KEY
);

CREATE TABLE temperature (
    temp REAL NOT NULL,
    temp_feel REAL NOT NULL,
    temp_category TEXT NOT NULL,
    temp_code TEXT PRIMARY KEY
);

CREATE TABLE CarSharing_df (
    id INTEGER PRIMARY KEY,
    holiday TEXT NOT NULL,
    workingday TEXT NOT NULL,
    humidity REAL,
    windspeed REAL,
    demand REAL NOT NULL,
    temp_code TEXT NOT NULL,
    weather_code INTEGER NOT NULL,
    FOREIGN KEY (id) REFERENCES time(id),
    FOREIGN KEY (temp_code) REFERENCES temperature(temp_code),
    FOREIGN KEY (weather_code) REFERENCES weather(weather_code)
);

-- SQLite CLI import sequence after creating the tables:
-- .mode csv
-- .headers on
-- .import --skip 1 csv_tables/time.csv time
-- .import --skip 1 csv_tables/weather.csv weather
-- .import --skip 1 csv_tables/temperature.csv temperature
-- .import --skip 1 csv_tables/CarSharing_df.csv CarSharing_df
-- PRAGMA foreign_key_check;
