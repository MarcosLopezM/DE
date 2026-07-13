# Weather data ETL pipeline with Python and PostgreSQL

## Project Overview

This project demonstrates an automated ETL (Extract, Transform, Load) pipeline that
ingests hitorical and real-time weather data for target cities, processes and cleanses
the raw JSON, and loads it into a relational PostgreSQL database using Docker container.

## Technologies Used

- Programming Language: Python 3.14+ with [uv](https://docs.astral.sh/uv/)
- Database: PostgreSQL (Containerized)
- Data Source: [Open-Meteo](https://open-meteo.com/) (No API required)
- Python Libraries:
  - `polars`: For data manipulation, schema validation and handling missing values.
  - `geopy`: To resolve city names into exact latitude and longitude coordinates.
  - `adbc-driver-postgresql`: For efficient Arrow-like data loading into PostgreSQL.
  - `dotenv`: For managing environment variables (DB credentials).

## ETL Pipeline Breakdown

### Data Extraction

The pipeline accepts target city names and resolve their geographical coordinates
dynamically using `geopy`. It then uses Open-Meteo's `archive` endpoint to retrieve raw
JSON weather metrics across the defined time period with the following parameters:

- Hourly:
  - temperature_2m
  - relative_humidity_2m
  - apparent_temperature
  - rain
  - weather_code
  - wind_speed_100m
- Daily:
  - temperature_2m_mean
  - temperature_2m_min
  - temperature_2m_max

### Data Transformation

Raw JSON responses are parsed into Polars DataFrames.

### Data Loading

Transformed is loaded into a PostgreSQL database via Arrow Database Connectivity (ADBC).
The database schema is optimize into two tables:

- `hourly_weather`
- `daily_weather`

## Getting Started

### Prerequisites

- Docker 29.6+ and Docker Compose 5.3+

### Configuration

1. Clone the repository and create your environment file:

```bash
git clone --no-checkout git@github.com:MarcosLopezM/DE.git
cd DE
git sparse-checkout init --cone
git sparse-checkout set weather-etl-csv
git checkout
```

2. Define your database credentials:

```
DB_USER=your_user
DB_PASSWORD='your_password'
DB_NAME=your_db_name
```

3. (Optional) Configure target cities and date ranges inside `main.py` .

4. Running the pipeline

Build and launch the database and ETL containers:

```bash
docker compose up --build
```

5. Inspecting the data

To verify the loaded tables, open an interactive PostgreSQL terminal inside the running
container:

```bash
docker exec -it openmeteo-db psql -U your_user -d your_db_name
```

> [!NOTE] The `-i` flags stands keeps the STDIN open even if the container is not
> attached and `-t` allocates a pseudo-TTY session for the PostgreSQL CLI.
