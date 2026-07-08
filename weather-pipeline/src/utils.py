from geopy.geocoders import Nominatim
from typing import TypedDict


class Location(TypedDict):
    latitude: float
    longitude: float


def get_coordinates(city_name: str) -> Location:
    geolocator = Nominatim(user_agent="weather-etl")
    location = geolocator.geocode(city_name)

    if not location:
        return ValueError(f"Location '{city_name}' not found.")

    return {"latitude": location.latitude, "longitude": location.longitude}
