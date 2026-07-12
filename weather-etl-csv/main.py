import datetime as dt
from transform import transform_weather_data, get_data
from load import load_db


def main():
    cities = ["Mexico City", "Ozumba de Alzate", "Morelos", "Veracruz"]
    start_date = dt.date(2026, 1, 1)
    end_date = dt.date(2026, 7, 11)

    print("Extrancting the data from API...")
    data = get_data(cities, start_date, end_date)

    print("Transforming data...")
    hourly_df, daily_df = transform_weather_data(data)

    load_db(hourly_df, daily_df)

    print("ETL Pipeline completed successfully!")


if __name__ == "__main__":
    main()
