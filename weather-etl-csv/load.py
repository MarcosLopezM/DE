import os
import polars as pl
from dotenv import load_dotenv


def get_connection() -> str:
    load_dotenv()
    user = os.getenv("DB_USER", "DB_USER")
    password = os.getenv("DB_PASSWORD", "DB_PASSWORD")
    host = os.getenv("DB_HOST", "localhost")
    db_name = os.getenv("DB_NAME", "DB_NAME")

    return f"postgresql://{user}:{password}@{host}:5432/{db_name}"


def load_db(hourly_df: pl.DataFrame, daily_df: pl.DataFrame):
    connection = get_connection()
    print("Connecting to database...")

    if not hourly_df.is_empty():
        hourly_df.write_database(
            table_name="hourly_weather",
            connection=connection,
            if_table_exists="append",
            engine="adbc",
        )
        print(f"Succesfully loaded {hourly_df.height} rows into hourly_weather!")

    if not daily_df.is_empty():
        daily_df.write_database(
            table_name="daily_weather",
            connection=connection,
            if_table_exists="append",
            engine="adbc",
        )
        print(f"Succesfully loaded {daily_df.height} rows into daily_weather!")
