# Usage insights from a Python library

## Set up

### Google Cloud Platform (GCP)

First, we need to have a Google Cloud account. Then in the Google Cloud Console we move
to the Bigquery Studio and in the explorer we search for `file_downloads`. This table
is huge and contains a large number of rows, so by default it is partitioned by day, which means that we can
only query this data by `timestap` (day), which stills results in a pretty big dataset,
so we'll truncate more by filtering by `duckdb` project.

```sql
SELECT * FROM `bigquery-public-data.pypi.file_downloads` WHERE TIMESTAMP_TRUNC(timestamp, DAY) = TIMESTAMP("2026-08-31") AND project='duckdb' LIMIT 1000
```

Now we can save the results.

### Installing dependencies

For this project we will not contenarized it, we'll use `uv`. We need to add the
following libraries to our project with `uv add`.

```bash
uv add duckdb google-cloud-bigquery google-cloud-bigquery-storage pyarrow pandas fire loguru pydantic db-dtypes
```

<!-- We need to create a new Service Account with the following roles: -->
<!---->
<!-- - BigQuery Data Editor -->
<!-- - BigQuery Job User -->
<!-- - BigQuery User -->

```bash
uv add --dev ruff pytest
```

### Configuring Google Cloud

Before doing any work we need to install the `gcloud CLI` following the instructions
found in <https://docs.cloud.google.com/sdk/docs/install-sdk>.

Now we can initialize and authorize the `gcloud CLI` by running

```bash
gcloud init
```

and login to your google account. Or if you want to skip the waiting time, you can
excute the following to speed up the process:

```bash
gcloud auth application-default login
```
