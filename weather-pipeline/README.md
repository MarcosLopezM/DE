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

### Data Extraction

We collect the weather data and air quality with specified parameters via the Open-Meteo
API. This step does not require an API key.

> [!NOTE] We can specify the coordinates for the data, but we chose to use the `geopy`
> package to get this information using only the city name.

### Data Transformation

In this step we only take care of missing values, since the source of our data has taken
care of most of the problems.

### Data Loading

Once we have transform the data, we store it into a PostgreSQL database.
