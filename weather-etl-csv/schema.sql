CREATE TABLE IF NOT EXISTS hourly_weather (
    city VARCHAR(100) NOT NULL,
    time DATETIME NOT NULL,
    temperature_2m FLOAT,
    relative_humidity_2m INT,
    apparent_temperature FLOAT,
    rain FLOAT,
    weather_code INT,
    wind_speed_100m FLOAT,
    PRIMARY KEY (city, time)
);

CREATE TABLE IF NOT EXISTS daily_weather (
    city VARCHAR(100) NOT NULL,
    time DATE NOT NULL,
    temperature_2m_mean FLOAT,
    temperature_2m_max FLOAT,
    temperature_2m_min FLOAT,
    PRIMARY KEY (city, time)
);
