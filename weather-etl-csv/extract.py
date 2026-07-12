import datetime as dt
from typing import TypedDict

from geopy.geocoders import Nominatim
from pydantic import BaseModel
import requests


class Location(TypedDict):
    latitude: float
    longitude: float


class WeatherParams(BaseModel):
    latitude: float
    longitude: float
    start_date: dt.date
    end_date: dt.date
    daily: list[str]
    hourly: list[str]


def get_coordinates(city_name: str) -> Location:
    geolocator = Nominatim(user_agent="weather-etl")
    location = geolocator.geocode(city_name)

    if not location:
        raise ValueError(f"Location '{city_name}' not found.")

    return {
        "latitude": location.latitude,
        "longitude": location.longitude,
    }


def get_params(city: str, start_date: dt.date, end_date: dt.date):
    location = get_coordinates(city)
    params = WeatherParams(
        latitude=location["latitude"],
        longitude=location["longitude"],
        start_date=start_date,
        end_date=end_date,
        daily=["temperature_2m_mean", "temperature_2m_max", "temperature_2m_min"],
        hourly=[
            "temperature_2m",
            "relative_humidity_2m",
            "apparent_temperature",
            "rain",
            "weather_code",
            "wind_speed_100m",
        ],
    )

    return params.model_dump(mode="json")


def get_json(city: str, start_date: dt.date, end_date: dt.date):
    url = "https://archive-api.open-meteo.com/v1/archive"
    params = get_params(city, start_date, end_date)
    response = requests.get(url, params=params)
    response.raise_for_status()

    return response.json()
