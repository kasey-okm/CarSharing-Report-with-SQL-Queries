# CarSharing Report with SQL Queries

SIWES Project 2 - Car-sharing database management and SQL analysis.

## Full report

**[Read the complete CarSharing report](REPORT.md)**

The report documents the data-cleaning process, normalized database design, SQL analysis, all answers to Tasks 6(a)-6(e), result tables, and business interpretation.

## Live Google Sheets

- Final normalized workbook: https://docs.google.com/spreadsheets/d/1MJ_31lchOy_HkSXETRO-SBBf-55QbsxqsNN-zfTyh8M/edit?usp=drivesdk
- Drive folder containing the four normalized tables: https://drive.google.com/drive/folders/1PvME6m_e6i0YdaiInnwZecMfMUtLsB9A

### Individual table links

- CarSharing_df: https://docs.google.com/spreadsheets/d/1-p-gFWMFJC5d_zytz5krS96Fj_0Gp94rDiyOZhSo0B4/edit?usp=drivesdk
- temperature: https://docs.google.com/spreadsheets/d/1sNRDVmLoaOkU5JXziDA0ovEtoapF1t5VcQ0YBlCMRJA/edit?usp=drivesdk
- weather: https://docs.google.com/spreadsheets/d/1Q_YI3TH6qfKnWx0pa4gKB9ZLDqYdIRQ25kjhgkcGsJ0/edit?usp=drivesdk
- time: https://docs.google.com/spreadsheets/d/1Klwv2kqvbIwR7mOszJCV2Ck1dPeNov5bVqfgRaK0ijI/edit?usp=drivesdk

## Repository contents

- `REPORT.md` - GitHub-native final written report
- `carsharing_schema.sql` - SQLite database/table creation and relationships
- `carsharing_queries.sql` - commented and validated SQL for Tasks 6(a)-6(e)
- `query_results/` - CSV result tables used in the report

## Project summary

The source dataset was cleaned, missing temperature values were filled with their required averages, time/weather/temperature fields were derived, and the data was normalized into four related tables before the SQLite analysis.

## Key 2017 findings

- Highest demand: **15 June 2017 at 17:00**, demand **6.458338**
- Highest weekday average: **Saturday**
- Lowest weekday average: **Thursday**
- Highest month average: **July**
- Lowest month average: **January**
- Highest season average: **Fall**
- Lowest season average: **Spring**
- Most prevalent temperature category: **Mild**
- Most prevalent weather: **Clear or partly cloudy**
- Highest average demand by temperature category: **Hot**

## Database relationships

- `CarSharing_df.id -> time.id`
- `CarSharing_df.temp_code -> temperature.temp_code`
- `CarSharing_df.weather_code -> weather.weather_code`

The completed SQLite database passed `PRAGMA foreign_key_check` with no violations.
