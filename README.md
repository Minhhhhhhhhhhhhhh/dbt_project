# Job Postings Analytics

A dbt project that transforms monthly job-posting data into DuckDB analytics tables. The project is configured for Python 3.9+ and uses `uv` for dependency management.

## What this project does

The pipeline reads job-posting Parquet files from `data/raw/` and builds these models in `data/prod.duckdb`:

- `job_postings` - cleans the raw postings and derives Bangkok-local search date and time fields.
- `job_per_month` - counts postings by month and search role.
- `monthly_summary` - calculates monthly totals and the percentage of remote postings.
- `top_locations` - returns the ten locations with the most postings.

The raw source is configured in [`analytics/models/sources.yml`](analytics/models/sources.yml), and all models are defined under [`analytics/models/`](analytics/models/).

## Prerequisites

- Python 3.9 or newer
- [`uv`](https://docs.astral.sh/uv/)

## Getting started

Run these commands from the repository root:

```bash
uv sync
uv run python scripts/download_data.py
cd analytics
uv run dbt build --profiles-dir ../ci
```

The download script retrieves the monthly job-posting Parquet files and the skills file into `data/raw/`. It skips files that already exist, so it is safe to run again.

The dbt profile in [`ci/profiles.yml`](ci/profiles.yml) uses the `prod` target and writes the warehouse to `data/prod.duckdb`. Because the profile uses a relative path, run dbt from the `analytics/` directory as shown above.

## Useful commands

From the repository root:

```bash
# Rebuild the models and run schema tests
cd analytics
uv run dbt build --profiles-dir ../ci

# Run only the models
uv run dbt run --profiles-dir ../ci

# Run tests only
uv run dbt test --profiles-dir ../ci

# Remove dbt-generated artifacts
uv run dbt clean
```

To inspect the generated DuckDB database, use any DuckDB-compatible client and open `data/prod.duckdb`.

## Project layout

```text
.
├── analytics/
│   ├── models/          # dbt models, sources, and schema tests
│   └── dbt_project.yml
├── ci/profiles.yml      # DuckDB connection profile used by CI and local builds
├── data/raw/            # downloaded Parquet inputs
├── scripts/             # data acquisition scripts
├── pyproject.toml       # project metadata and dependencies
└── uv.lock              # locked dependency versions
```

## Automation

GitHub Actions runs the same workflow on pushes to `main`, weekly on Mondays, or manually. The workflow installs dependencies, downloads the source data, runs `dbt build`, and publishes the resulting `data/prod.duckdb` file to the `warehouse` GitHub release.
