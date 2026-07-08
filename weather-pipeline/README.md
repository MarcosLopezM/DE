# Weather data pipeline with Python and PostgreSQL

## Project Overview

This project demonstrates an ETL (Extract, Transform, Load) pipeline that integrates
weather for an specified city over a defined time period. We'll use Python to extract
the data from [https://open-meteo.com/](Open-Meteo). Once the data is collected, we'll
process the raw JSON, which may involve converting temperature units, handling missing
values, or standardizing location names. Finally, we'll store the cleansed data in a
PostgreSQL database.

The goal is to provide a clean, well-structured dataset for further analysis or
reporting.

## Technologies Used

- Programming Language: Python
- Database: PostgreSQL
- Data Source: [https://open-meteo.com/](Open-Meteo)
- Python Libraries:
  - `geopy`: For latitude and longitude values given the city name.
  - `openmeteo-request`: For interacting with Open-Meteo APIs.
  - `pandas`: For data manipulation and cleaning.
  - `SQLAlchemy`: For database interaction.
  - `dotenv`: To handle environment variables (DB credentials)

## ETL Pipeline Breakdown
