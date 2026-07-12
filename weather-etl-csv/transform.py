import datetime as dt

import polars as pl

from extract import get_json


def get_data(city_name: list[str] | str, start_date: dt.date, end_date: dt.date):
    if isinstance(city_name, str):
        city_name = [city_name]

    weather_data = [get_json(city, start_date, end_date) for city in city_name]
    return dict(zip(city_name, weather_data))


def transform_weather_data(raw_data: dict) -> tuple[pl.DataFrame, pl.DataFrame]:
    hourly_dfs = [
        pl.DataFrame(data["hourly"]).with_columns(city=pl.lit(city))
        for city, data in raw_data.items()
        if data.get("hourly")
    ]
    daily_dfs = [
        pl.DataFrame(data["daily"]).with_columns(city=pl.lit(city))
        for city, data in raw_data.items()
        if data.get("daily")
    ]

    hourly_df = pl.concat(hourly_dfs) if hourly_dfs else pl.DataFrame
    daily_df = pl.concat(daily_dfs) if daily_dfs else pl.DataFrame

    if not hourly_df.is_empty():
        hourly_df = hourly_df.with_columns(
            pl.col("temperature_2m").forward_fill(),
            pl.col("rain").fill_null(0.0),
            time=pl.col("time").str.to_datetime(),
        )

    if not daily_df.is_empty():
        daily_df = daily_df.with_columns(time=pl.col("time").str.to_date())

    return hourly_df, daily_df
