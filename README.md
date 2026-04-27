# Welcome to Git-R-Done Enterprises

This is an example project to practice learning git concepts.

This project deploys a streamlit app at [to be added].

## Pre-run Setup

1. Install Python
2. Setup `.streamlit/secrets.toml`
   1. Copy the [.streamlit/secrets-example.toml](.streamlit/secrets-example.toml) and save it as `secrets.toml`

### Python and dbt Setup

1. Run `.\build.ps1` from the project root.
2. The script will create `.venv`, install dependencies, and run `dbt deps`.
3. Python 3.12, 3.13, and 3.14 are supported by the script. On 3.14, it applies a dependency compatibility override automatically.
4. If no compatible Python version is installed, the script will attempt to install Python 3.13 via `winget`.
5. Activate the environment using `.\.venv\Scripts\activate`
6. Run `dbt --version` to make sure everything is working.

## Looking at data

Use a database client such as DBeaver to connect to the DuckDB database file located at `database/dev/git_r_done_enterprises.duckdb`.

## Exercise 

1. Come up with an idea for doing some analytics with movie data - you can see the data schema here: [models\staging\stg_movies.yml](models/staging/stg_movies.yml).
2. Write a GitHub issue describing the idea and what you would like to do with it.
3. Create a descriptive branch name (e.g., `analytics-movie-revenue`).
4. Add a dbt model under [models/marts/](models/marts/) similar to [models\marts\sample_model.sql](models\marts\sample_model.sql) that implements what you described in your GitHub Issue.
5. Run `dbt run` and make sure everything is working.
6. Commit your changes and push them to GitHub.
7. Open a pull request against the main branch of this repository.
8. Once done, review your PR with someone else and get feedback.

## Extra

If you are interested, you can tinker with the `streamlit_app.py` script and add some visualizations or other features to it.

To run it, do `streamlit run streamlit_app.py`.

Once merged, you can see the hosted app at [https://git-r-done-enterpise-2026-04-30.streamlit.app/](https://git-r-done-enterpise-2026-04-30.streamlit.app/)