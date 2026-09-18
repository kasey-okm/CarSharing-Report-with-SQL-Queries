-- CarSharing Report with SQL Queries
-- Database: SQLite
-- All business queries use the final normalized CarSharing_df table and JOIN to related tables.

-- ============================================================
-- Task 6(a): Highest demand date and time in 2017
-- ============================================================
SELECT
    t.timestamp,
    c.demand
FROM CarSharing_df AS c
JOIN time AS t ON c.id = t.id
WHERE strftime('%Y', t.timestamp) = '2017'
ORDER BY c.demand DESC
LIMIT 1;

-- ============================================================
-- Task 6(b): Highest and lowest average demand by weekday,
-- month, and season in 2017
-- ============================================================
WITH weekday_avg AS (
    SELECT t.weekday_name AS label, AVG(c.demand) AS avg_demand
    FROM CarSharing_df c
    JOIN time t ON c.id = t.id
    WHERE strftime('%Y', t.timestamp) = '2017'
    GROUP BY t.weekday_name
)
SELECT 'Weekday' AS dimension, 'Highest' AS level, label, avg_demand
FROM weekday_avg ORDER BY avg_demand DESC LIMIT 1;

WITH weekday_avg AS (
    SELECT t.weekday_name AS label, AVG(c.demand) AS avg_demand
    FROM CarSharing_df c JOIN time t ON c.id=t.id
    WHERE strftime('%Y', t.timestamp)='2017'
    GROUP BY t.weekday_name
)
SELECT 'Weekday' AS dimension, 'Lowest' AS level, label, avg_demand
FROM weekday_avg ORDER BY avg_demand ASC LIMIT 1;

WITH month_avg AS (
    SELECT t.monthday_name AS label, AVG(c.demand) AS avg_demand
    FROM CarSharing_df c JOIN time t ON c.id=t.id
    WHERE strftime('%Y', t.timestamp)='2017'
    GROUP BY t.monthday_name
)
SELECT 'Month' AS dimension, 'Highest' AS level, label, avg_demand
FROM month_avg ORDER BY avg_demand DESC LIMIT 1;

WITH month_avg AS (
    SELECT t.monthday_name AS label, AVG(c.demand) AS avg_demand
    FROM CarSharing_df c JOIN time t ON c.id=t.id
    WHERE strftime('%Y', t.timestamp)='2017'
    GROUP BY t.monthday_name
)
SELECT 'Month' AS dimension, 'Lowest' AS level, label, avg_demand
FROM month_avg ORDER BY avg_demand ASC LIMIT 1;

WITH season_avg AS (
    SELECT t.season AS label, AVG(c.demand) AS avg_demand
    FROM CarSharing_df c JOIN time t ON c.id=t.id
    WHERE strftime('%Y', t.timestamp)='2017'
    GROUP BY t.season
)
SELECT 'Season' AS dimension, 'Highest' AS level, label, avg_demand
FROM season_avg ORDER BY avg_demand DESC LIMIT 1;

WITH season_avg AS (
    SELECT t.season AS label, AVG(c.demand) AS avg_demand
    FROM CarSharing_df c JOIN time t ON c.id=t.id
    WHERE strftime('%Y', t.timestamp)='2017'
    GROUP BY t.season
)
SELECT 'Season' AS dimension, 'Lowest' AS level, label, avg_demand
FROM season_avg ORDER BY avg_demand ASC LIMIT 1;

-- ============================================================
-- Task 6(c): Hourly average demand for the highest- and
-- lowest-average-demand weekdays from Task 6(b), sorted descending
-- ============================================================
WITH weekday_avg AS (
    SELECT t.weekday_name, AVG(c.demand) AS avg_demand
    FROM CarSharing_df c
    JOIN time t ON c.id=t.id
    WHERE strftime('%Y',t.timestamp)='2017'
    GROUP BY t.weekday_name
),
selected_weekdays AS (
    SELECT weekday_name FROM (
        SELECT weekday_name, avg_demand
        FROM weekday_avg
        ORDER BY avg_demand DESC
        LIMIT 1
    )
    UNION
    SELECT weekday_name FROM (
        SELECT weekday_name, avg_demand
        FROM weekday_avg
        ORDER BY avg_demand ASC
        LIMIT 1
    )
)
SELECT
    t.weekday_name,
    t.hour,
    AVG(c.demand) AS avg_demand
FROM CarSharing_df c
JOIN time t ON c.id=t.id
WHERE strftime('%Y',t.timestamp)='2017'
  AND t.weekday_name IN (SELECT weekday_name FROM selected_weekdays)
GROUP BY t.weekday_name, t.hour
ORDER BY t.weekday_name, avg_demand DESC;

-- ============================================================
-- Task 6(d1): Most prevalent temperature category in 2017
-- ============================================================
SELECT
    tp.temp_category,
    COUNT(*) AS observations
FROM CarSharing_df c
JOIN time t ON c.id=t.id
JOIN temperature tp ON c.temp_code=tp.temp_code
WHERE strftime('%Y',t.timestamp)='2017'
GROUP BY tp.temp_category
ORDER BY observations DESC;

-- Task 6(d2): Most prevalent weather condition in 2017
SELECT
    w.weather,
    COUNT(*) AS observations
FROM CarSharing_df c
JOIN time t ON c.id=t.id
JOIN weather w ON c.weather_code=w.weather_code
WHERE strftime('%Y',t.timestamp)='2017'
GROUP BY w.weather
ORDER BY observations DESC;

-- Task 6(d3): Monthly wind-speed statistics for 2017
SELECT
    t.monthday_name AS month,
    AVG(c.windspeed) AS avg_windspeed,
    MAX(c.windspeed) AS max_windspeed,
    MIN(c.windspeed) AS min_windspeed
FROM CarSharing_df c
JOIN time t ON c.id=t.id
WHERE strftime('%Y',t.timestamp)='2017'
GROUP BY t.monthday_name
ORDER BY CAST(strftime('%m',t.timestamp) AS INTEGER);

-- Task 6(d4): Monthly humidity statistics for 2017
SELECT
    t.monthday_name AS month,
    AVG(c.humidity) AS avg_humidity,
    MAX(c.humidity) AS max_humidity,
    MIN(c.humidity) AS min_humidity
FROM CarSharing_df c
JOIN time t ON c.id=t.id
WHERE strftime('%Y',t.timestamp)='2017'
GROUP BY t.monthday_name
ORDER BY CAST(strftime('%m',t.timestamp) AS INTEGER);

-- Task 6(d5): Average demand by temperature category in 2017
SELECT
    tp.temp_category,
    AVG(c.demand) AS avg_demand
FROM CarSharing_df c
JOIN time t ON c.id=t.id
JOIN temperature tp ON c.temp_code=tp.temp_code
WHERE strftime('%Y',t.timestamp)='2017'
GROUP BY tp.temp_category
ORDER BY avg_demand DESC;

-- ============================================================
-- Task 6(e): Repeat the weather analysis for the month with
-- the highest average demand in 2017
-- ============================================================
WITH month_avg AS (
    SELECT
        CAST(strftime('%m',t.timestamp) AS INTEGER) AS month_no,
        t.monthday_name AS month_name,
        AVG(c.demand) AS avg_demand
    FROM CarSharing_df c
    JOIN time t ON c.id=t.id
    WHERE strftime('%Y',t.timestamp)='2017'
    GROUP BY month_no, month_name
),
highest_month AS (
    SELECT month_no, month_name, avg_demand
    FROM month_avg
    ORDER BY avg_demand DESC
    LIMIT 1
)
SELECT * FROM highest_month;

-- Temperature-category prevalence in highest-demand month
WITH highest_month AS (
    SELECT CAST(strftime('%m',t.timestamp) AS INTEGER) AS month_no
    FROM CarSharing_df c JOIN time t ON c.id=t.id
    WHERE strftime('%Y',t.timestamp)='2017'
    GROUP BY month_no
    ORDER BY AVG(c.demand) DESC
    LIMIT 1
)
SELECT tp.temp_category, COUNT(*) AS observations
FROM CarSharing_df c
JOIN time t ON c.id=t.id
JOIN temperature tp ON c.temp_code=tp.temp_code
WHERE strftime('%Y',t.timestamp)='2017'
  AND CAST(strftime('%m',t.timestamp) AS INTEGER)=(SELECT month_no FROM highest_month)
GROUP BY tp.temp_category
ORDER BY observations DESC;

-- Weather-condition prevalence in highest-demand month
WITH highest_month AS (
    SELECT CAST(strftime('%m',t.timestamp) AS INTEGER) AS month_no
    FROM CarSharing_df c JOIN time t ON c.id=t.id
    WHERE strftime('%Y',t.timestamp)='2017'
    GROUP BY month_no
    ORDER BY AVG(c.demand) DESC
    LIMIT 1
)
SELECT w.weather, COUNT(*) AS observations
FROM CarSharing_df c
JOIN time t ON c.id=t.id
JOIN weather w ON c.weather_code=w.weather_code
WHERE strftime('%Y',t.timestamp)='2017'
  AND CAST(strftime('%m',t.timestamp) AS INTEGER)=(SELECT month_no FROM highest_month)
GROUP BY w.weather
ORDER BY observations DESC;

-- Wind-speed and humidity statistics in highest-demand month
WITH highest_month AS (
    SELECT CAST(strftime('%m',t.timestamp) AS INTEGER) AS month_no
    FROM CarSharing_df c JOIN time t ON c.id=t.id
    WHERE strftime('%Y',t.timestamp)='2017'
    GROUP BY month_no
    ORDER BY AVG(c.demand) DESC
    LIMIT 1
)
SELECT
    AVG(c.windspeed) AS avg_windspeed,
    MAX(c.windspeed) AS max_windspeed,
    MIN(c.windspeed) AS min_windspeed,
    AVG(c.humidity) AS avg_humidity,
    MAX(c.humidity) AS max_humidity,
    MIN(c.humidity) AS min_humidity
FROM CarSharing_df c
JOIN time t ON c.id=t.id
WHERE strftime('%Y',t.timestamp)='2017'
  AND CAST(strftime('%m',t.timestamp) AS INTEGER)=(SELECT month_no FROM highest_month);

-- Average demand by temperature category in highest-demand month
WITH highest_month AS (
    SELECT CAST(strftime('%m',t.timestamp) AS INTEGER) AS month_no
    FROM CarSharing_df c JOIN time t ON c.id=t.id
    WHERE strftime('%Y',t.timestamp)='2017'
    GROUP BY month_no
    ORDER BY AVG(c.demand) DESC
    LIMIT 1
)
SELECT tp.temp_category, AVG(c.demand) AS avg_demand
FROM CarSharing_df c
JOIN time t ON c.id=t.id
JOIN temperature tp ON c.temp_code=tp.temp_code
WHERE strftime('%Y',t.timestamp)='2017'
  AND CAST(strftime('%m',t.timestamp) AS INTEGER)=(SELECT month_no FROM highest_month)
GROUP BY tp.temp_category
ORDER BY avg_demand DESC;
