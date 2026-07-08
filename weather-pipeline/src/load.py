from sqlalchemy import create_engine
import os
import pandas as pd
from dotenv import load_dotenv


def create_db_engine():
    load_dotenv()
    DB_USER = os.getenv("DB_USER")
    DB_PASSWORD = os.getenv("DB_PASSWORD")
    DB_NAME = os.getenv("DB_NAME")
    host = os.getenv("DB_HOST", "localhost")
    port = os.getenv("DB_PORT", "5432")

    db_url = f"postgresql://{DB_USER}:{DB_PASSWORD}@{host}:{port}/{DB_NAME}"

    print(f"Connecting to database at {host} ...")
    engine = create_engine(db_url)

    return engine


def load_data(df: pd.DataFrame, table_name: str):
    try:
        engine = create_db_engine()

        print(f"Loading data into the '{table_name}' table...")

        df.to_sql(name=table_name, con=engine, if_exists="replace", index=False)

        print(f"Data loaded into the table {table_name} succesfully!")
    except Exception as e:
        raise RuntimeError(f"Database load failed: {e}")
