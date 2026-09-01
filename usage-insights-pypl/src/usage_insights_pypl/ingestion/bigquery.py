from google.cloud import bigquery
import pandas as pd
from loguru import logger
import time


def get_bigquery_client(project_name: str) -> bigquery.Client:
    """Get BigQuery Client"""
    try:
        bigquery_client = bigquery.Client(project=project_name)

        return bigquery_client

    except Exception as e:
        raise


def get_bigquery_result(
    query_str: str, bigquery_client: bigquery.Client
) -> pd.DataFrame:
    """Get query result from BigQuery and yield rows as dictionaries"""
    try:
        start_time = time.time()
        logger.info(f"Running query: {query_str}")
        dataframe = bigquery_client.query(query_str).to_dataframe()

        elapsed_time = time.time() - start_time
        logger.info(f"Query executed and data loaded in {elapsed_time:.2f} seconds")

        return dataframe

    except Exception as e:
        logger.error(f"Error running query: {e}")
        raise


def pypi_query() -> str:
    """Query the public PyPI dataset from BigQuery"""
    return f"""
        SELECT *
        FROM
            `bigquery-public-data.pypi.file_downloads` 
        WHERE 
            project='duckdb'
            AND timestamp >= TIMESTAMP("2026-08-25") 
            AND timestamp < TIMESTAMP("2026-08-31") 
    """
