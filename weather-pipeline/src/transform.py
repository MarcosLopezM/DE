import pandas as pd


def transform_hourly_data(weather_res, air_res) -> pd.DataFrame:
    hourly_weather = weather_res.Hourly()
    hourly_air = air_res.Hourly()

    # Weather
    hourly_temperature_2m = hourly_weather.Variables(0).ValuesAsNumpy()
    hourly_relative_humidity_2m = hourly_weather.Variables(1).ValuesAsNumpy()
    hourly_apparent_temperature = hourly_weather.Variables(2).ValuesAsNumpy()
    hourly_rain = hourly_weather.Variables(3).ValuesAsNumpy()
    hourly_weather_code = hourly_weather.Variables(4).ValuesAsNumpy()
    # Air Quality
    hourly_pm10 = hourly_air.Variables(0).ValuesAsNumpy()
    hourly_pm2_5 = hourly_air.Variables(1).ValuesAsNumpy()
    hourly_carbon_monoxide = hourly_air.Variables(2).ValuesAsNumpy()
    hourly_carbon_dioxide = hourly_air.Variables(3).ValuesAsNumpy()
    hourly_uv_index = hourly_air.Variables(4).ValuesAsNumpy()
    hourly_uv_index_clear_sky = hourly_air.Variables(5).ValuesAsNumpy()

    hourly_data = {
        "date": pd.date_range(
            start=pd.to_datetime(hourly_weather.Time(), unit="s", utc=True),
            end=pd.to_datetime(hourly_weather.TimeEnd(), unit="s", utc=True),
            freq=pd.Timedelta(seconds=hourly_weather.Interval()),
            inclusive="left",
        ).tz_convert(weather_res.Timezone().decode())
    }

    hourly_data["temperature_2m"] = hourly_temperature_2m
    hourly_data["relative_humidity_2m"] = hourly_relative_humidity_2m
    hourly_data["apparent_temperature"] = hourly_apparent_temperature
    hourly_data["rain"] = hourly_rain
    hourly_data["weather_code"] = hourly_weather_code
    hourly_data["pm10"] = hourly_pm10
    hourly_data["pm2_5"] = hourly_pm2_5
    hourly_data["carbon_monoxide"] = hourly_carbon_monoxide
    hourly_data["carbon_dioxide"] = hourly_carbon_dioxide
    hourly_data["uv_index"] = hourly_uv_index
    hourly_data["uv_index_clear_sky"] = hourly_uv_index_clear_sky

    df = pd.DataFrame(data=hourly_data)

    return df


def transform_daily_data(weather_res) -> pd.DataFrame:
    daily = weather_res.Daily()
    daily_temperature_2m_mean = daily.Variables(0).ValuesAsNumpy()
    daily_temperature_2m_max = daily.Variables(1).ValuesAsNumpy()
    daily_temperature_2m_min = daily.Variables(2).ValuesAsNumpy()

    daily_data = {
        "date": pd.date_range(
            start=pd.to_datetime(daily.Time(), unit="s", utc=True),
            end=pd.to_datetime(daily.TimeEnd(), unit="s", utc=True),
            freq=pd.Timedelta(seconds=daily.Interval()),
            inclusive="left",
        ).tz_convert(weather_res.Timezone().decode())
    }

    daily_data["temperature_2m_mean"] = daily_temperature_2m_mean
    daily_data["temperature_2m_max"] = daily_temperature_2m_max
    daily_data["temperature_2m_min"] = daily_temperature_2m_min

    df = pd.DataFrame(data=daily_data)

    return df
