from usage_insights_pypl.ingestion.bigquery import (
    get_bigquery_client,
    get_bigquery_result,
    pypi_query,
)


def main():
    df = get_bigquery_result(
        pypi_query(), get_bigquery_client("data-engineering-507201")
    )
    print(df.head())


if __name__ == "__main__":
    main()
