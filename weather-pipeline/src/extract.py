import openmeteo_requests
import requests_cache
from retry_requests import retry
from src.utils import get_coordinates


def fetch_weather_data(city: str, start_date: str, end_date: str):
    cache_session = requests_cache.CachedSession(".cache", expire_after=3600)
    retry_session = retry(cache_session, retries=5, backoff_factor=0.2)
    openmeteo = openmeteo_requests.Client(session=retry_session)

    location = get_coordinates(city)
    params = {
        "latitude": location["latitude"],
        "longitude": location["longitude"],
        "start_date": start_date,
        "end_date": end_date,
        "daily": ["temperature_2m_mean", "temperature_2m_max", "temperature_2m_min"],
        "hourly": [
            "temperature_2m",
            "relative_humidity_2m",
            "apparent_temperature",
            "rain",
            "weather_code",
        ],
        "timezone": "auto",
    }

    url = "https://archive-api.open-meteo.com/v1/archive"
    responses = openmeteo.weather_api(url, params=params)

    return responses[0]


def fetch_air_data(city: str, start_date: str, end_date: str):
    cache_session = requests_cache.CachedSession(".cache", expire_after=3600)
    retry_session = retry(cache_session, retries=5, backoff_factor=0.2)
    openmeteo = openmeteo_requests.Client(session=retry_session)
    url = "https://air-quality-api.open-meteo.com/v1/air-quality"

    location = get_coordinates(city)
    params = {
        "latitude": location["latitude"],
        "longitude": location["longitude"],
        "start_date": start_date,
        "end_date": end_date,
        "hourly": [
            "pm10",
            "pm2_5",
            "carbon_monoxide",
            "carbon_dioxide",
            "uv_index",
            "uv_index_clear_sky",
        ],
        "timezone": "auto",
    }
    responses = openmeteo.weather_api(url, params=params)

    return responses[0]


def main():
    CITY = "Mexico City"
    START_DATE = "2026-06-21"
    END_DATE = "2026-07-05"

    print(f"Extracting data for {CITY} from {START_DATE} to {END_DATE}")

    weather_data = fetch_weather_data(CITY, START_DATE, END_DATE)
    air_data = fetch_air_data(CITY, START_DATE, END_DATE)

    print(type(weather_data))
    print(type(air_data))


if __name__ == "__main__":
    main()
