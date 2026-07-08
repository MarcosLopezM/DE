from src.extract import fetch_weather_data, fetch_air_data
from src.transform import transform_daily_data, transform_hourly_data
from src.load import load_data


def main():
    CITY = "Mexico City"
    START_DATE = "2026-06-21"
    END_DATE = "2026-07-05"

    try:
        print(f"Extracting data for {CITY} from {START_DATE} to {END_DATE}")
        weather_data = fetch_weather_data(CITY, START_DATE, END_DATE)
        air_data = fetch_air_data(CITY, START_DATE, END_DATE)

        df_hourly = transform_hourly_data(weather_data, air_data)
        df_daily = transform_daily_data(weather_data)

        print("Data transformation complete!")

        load_data(df_hourly, table_name="weather_air_hourly_data")
        load_data(df_daily, table_name="weather_daily_data")
    except Exception as e:
        print(f"Pipeline failed: {e}")


if __name__ == "__main__":
    main()
