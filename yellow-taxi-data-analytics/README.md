# NYC Yellow Taxi Analytics

## Introduction

We will want to transform our flat data into a fact and dimension table.

But, what are each of these kind of tables?

- **Fact Table**
  - Contains quantitative measures or metrics that are used for analysis.
  - Typically contains foreign keys that link to dimension tables.
  - Contains columns that have high cardinality[^cardinality] and change frequently.
  - Contains columns that are not useful for analysis by themselves, but are
    necessary for calculating metrics.

- **Dimension Table**
  - Contains columns that describe attributes of the data being analyzed.
  - Typically contains primary keys that link to _fact tables_.
  - Contains columns that have low cardinality and don't change frequently.
  - Contains columns that can be used for grouping or filtering data for analysis.

We'll use a subset of January 2026 data for [Yellow Taxi Trip Records](https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2026-01.parquet) from [NYC Taxi & Limousine Commision](https://www.nyc.gov/site/tlc/index.page). When working with new data, most of the time, there will be a data dictionary describing the data. For this case, the data dictionary can be found here <https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf>.

## Setting up our project

For this project I will use [uv](https://docs.astral.sh/uv/) to manage our project.

1. Start the project

```bash
uv init yellow-taxi-data-analytics
```

1. Create a virtual environment

```bash
uv venv .venv
```

1. Activate the environment
   I am using fish, so I activate the environment as follows:

```bash

  source .venv/bin/activate.fish


```

> [!WARNING]
> This step depends on the shell you are using.

1. Set up Jupyter

To work with **Jupyter** we have to first add `ipykernel` to our project as a
development dependency.

```bash
uv add --dev ipykernel
```

1. Create the kernel for our project with

```bash
uv run ipython kernel install --user --env VIRTUAL_ENV $(pwd)/.venv --name=yellow-taxi-data-analytics --display-name "Python (uv: yellow-taxi)"

```

1. Start the server

```bash
uv run --with jupyter jupyter notebook
```

[^cardinality]: Cardinality refers to the number of unique or distinct data values contained in a specific column. A column with high cardinality has almost or all unique values.
