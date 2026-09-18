# CarSharing Report with SQL Queries

## 1. Project overview

This SIWES project analyzes hourly car-sharing demand data covering January 2017 through August 2018. The source contains time, season, holiday/working-day status, weather condition, temperature, feels-like temperature, humidity, wind speed, and demand.

The `demand` field represents customers' willingness to rent a car at a particular time. Higher values indicate stronger willingness to rent.

## 2. Data preparation

The dataset contains 8,708 observations.

Following the assignment instructions:

- Missing `temp` values were filled using the rounded mean **20.09**.
- Missing `temp_feel` values were filled using the rounded mean **23.531**.
- `temp_category` was created as:
  - Cold: `temp_feel < 10`
  - Mild: `10 <= temp_feel <= 25`
  - Hot: `temp_feel > 25`
- `temp_code` was created by concatenating `temp`, `temp_feel`, and `temp_category`.
- `weather_code` mapping:
  - Clear or partly cloudy = 1
  - Mist = 2
  - Light snow or rain = 3
  - heavy rain/ice pellets/snow + fog = 4
- `hour`, `weekday_name`, and `monthday_name` were extracted from the timestamp.
- Missing humidity and wind speed values were retained as NULL because the brief did not instruct that those fields be imputed.

## 3. Normalized database structure

The final database uses four tables:

| Table | Main fields |
|---|---|
| CarSharing_df | id, holiday, workingday, humidity, windspeed, demand, temp_code, weather_code |
| time | id, timestamp, season, hour, weekday_name, monthday_name |
| temperature | temp, temp_feel, temp_category, temp_code |
| weather | weather, weather_code |

Relationships:

- `CarSharing_df.id -> time.id`
- `CarSharing_df.temp_code -> temperature.temp_code`
- `CarSharing_df.weather_code -> weather.weather_code`

SQLite `PRAGMA foreign_key_check` returned no violations.

## 4. Business questions

### 6(a) Highest demand date and time in 2017

| timestamp | demand |
|---|---:|
| 2017-06-15 17:00:00 | 6.458338 |

The highest recorded demand in 2017 occurred on **15 June 2017 at 17:00**.

### 6(b) Highest and lowest average demand in 2017

| Dimension | Level | Value | Average demand |
|---|---|---|---:|
| Weekday | Highest | Saturday | 4.4114 |
| Weekday | Lowest | Thursday | 4.1193 |
| Month | Highest | July | 4.7877 |
| Month | Lowest | January | 3.3883 |
| Season | Highest | fall | 4.6603 |
| Season | Lowest | spring | 3.6069 |

### 6(c) Hourly demand for the selected weekdays

The selected weekdays are **Saturday** and **Thursday**, based on Question 6(b).

The complete 48-row table is stored in:
[`query_results/6c_hourly_selected_weekdays.csv`](query_results/6c_hourly_selected_weekdays.csv)

The highest hourly average for both selected weekdays occurs at **17:00**:

| Weekday | Hour | Average demand |
|---|---:|---:|
| Saturday | 17 | 5.8951 |
| Thursday | 17 | 5.7656 |

### 6(d) Weather and temperature in 2017

#### Temperature category prevalence

| Temperature category | Observations |
|---|---:|
| Mild | 2735 |
| Hot | 2297 |
| Cold | 390 |

**Mild** conditions were the most prevalent in 2017.

#### Weather condition prevalence

| Weather | Observations |
|---|---:|
| Clear or partly cloudy | 3583 |
| Mist | 1366 |
| Light snow or rain | 473 |

**Clear or partly cloudy** was the most prevalent weather condition.

#### Monthly wind-speed statistics

| Month | Average | Highest | Lowest |
|---|---:|---:|---:|
| January | 13.748 | 39.001 | 0.000 |
| February | 15.578 | 51.999 | 0.000 |
| March | 15.975 | 40.997 | 0.000 |
| April | 15.852 | 40.997 | 0.000 |
| May | 12.427 | 40.997 | 0.000 |
| June | 11.828 | 35.001 | 0.000 |
| July | 12.016 | 56.997 | 0.000 |
| August | 12.411 | 43.001 | 0.000 |
| September | 11.564 | 40.997 | 0.000 |
| October | 10.892 | 36.997 | 0.000 |
| November | 12.142 | 36.997 | 0.000 |
| December | 10.836 | 43.001 | 0.000 |

#### Monthly humidity statistics

| Month | Average | Highest | Lowest |
|---|---:|---:|---:|
| January | 56.31 | 100 | 28 |
| February | 53.58 | 100 | 8 |
| March | 56.00 | 100 | 0 |
| April | 66.25 | 100 | 22 |
| May | 71.37 | 100 | 24 |
| June | 58.37 | 100 | 20 |
| July | 60.29 | 94 | 17 |
| August | 62.17 | 94 | 25 |
| September | 74.84 | 100 | 42 |
| October | 71.57 | 100 | 29 |
| November | 64.17 | 100 | 27 |
| December | 65.18 | 100 | 26 |

#### Average demand by temperature category

| Temperature category | Average demand |
|---|---:|
| Hot | 4.7982 |
| Mild | 4.0217 |
| Cold | 3.1903 |

Although Mild weather occurred most often, **Hot** conditions produced the highest average demand.

### 6(e) Highest-demand month comparison

The month with the highest average demand in 2017 was **July**, with average demand **4.7877**.

#### July temperature prevalence

| Temperature category | Observations |
|---|---:|
| Hot | 449 |
| Mild | 7 |

#### July weather prevalence

| Weather | Observations |
|---|---:|
| Clear or partly cloudy | 386 |
| Mist | 56 |
| Light snow or rain | 14 |

#### July wind speed and humidity

| Metric | Value |
|---|---:|
| Average wind speed | 12.016 |
| Highest wind speed | 56.997 |
| Lowest wind speed | 0.000 |
| Average humidity | 60.292 |
| Highest humidity | 94 |
| Lowest humidity | 17 |

#### July average demand by temperature category

| Temperature category | Average demand |
|---|---:|
| Mild | 4.8081 |
| Hot | 4.7873 |

## 5. Business interpretation

- Peak demand occurred at 17:00 on 15 June 2017, making late afternoon an important fleet-allocation period.
- Saturday had the highest weekday average demand, which suggests strong weekend rental interest.
- July had the highest monthly average demand, while January had the lowest.
- Fall had the highest seasonal average demand; spring had the lowest.
- Mild conditions were most common, but Hot conditions were associated with the highest average demand across 2017.
- Clear or partly cloudy weather dominated the year.
- Marketing and fleet planning can emphasize summer, Saturdays, and late-afternoon demand peaks.

## 6. SQL documentation

All SQL is in [`carsharing_queries.sql`](carsharing_queries.sql). Each section is commented to identify the business question it answers.

The database schema and relationships are in [`carsharing_schema.sql`](carsharing_schema.sql).

## 7. Google Drive tables

- Final normalized workbook: https://docs.google.com/spreadsheets/d/1MJ_31lchOy_HkSXETRO-SBBf-55QbsxqsNN-zfTyh8M/edit?usp=drivesdk
- Drive folder containing the normalized tables: https://drive.google.com/drive/folders/1PvME6m_e6i0YdaiInnwZecMfMUtLsB9A
- CarSharing_df: https://docs.google.com/spreadsheets/d/1-p-gFWMFJC5d_zytz5krS96Fj_0Gp94rDiyOZhSo0B4/edit?usp=drivesdk
- temperature: https://docs.google.com/spreadsheets/d/1sNRDVmLoaOkU5JXziDA0ovEtoapF1t5VcQ0YBlCMRJA/edit?usp=drivesdk
- weather: https://docs.google.com/spreadsheets/d/1Q_YI3TH6qfKnWx0pa4gKB9ZLDqYdIRQ25kjhgkcGsJ0/edit?usp=drivesdk
- time: https://docs.google.com/spreadsheets/d/1Klwv2kqvbIwR7mOszJCV2Ck1dPeNov5bVqfgRaK0ijI/edit?usp=drivesdk
