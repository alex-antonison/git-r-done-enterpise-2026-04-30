import os

import duckdb
import streamlit as st


# Set page config
st.set_page_config(
    page_title="Git-R-Done Enterprises Movie Analysis", page_icon="🎬", layout="wide"
)

# Title
st.title("🎬 Git-R-Done Enterprises Movie Analysis")


# Connect to DuckDB
def get_connection():
    db_path = os.path.join(
        os.path.dirname(__file__),
        "database",
        st.secrets["db_path"]["duckdb_db_path"],
        "git_r_done_enterprises.duckdb",
    )
    return duckdb.connect(db_path, read_only=True)


# will query the database once
@st.cache_data
def get_staging_movie_data():
    conn = get_connection()
    try:
        return conn.execute("""
            SELECT *
            FROM sample_model_revenue
        """).fetchdf()
    finally:
        conn.close()


df = get_staging_movie_data()

# Sidebar filters
st.sidebar.header("Filters")
min_year = int(df["release_year"].min())
max_year = int(df["release_year"].max())
year_range = st.sidebar.slider(
    "Select Release Year Range",
    min_value=min_year,
    max_value=max_year,
    value=(min_year, max_year),
)

min_rating = st.sidebar.slider(
    "Minimum Rating", min_value=0.0, max_value=10.0, value=0.0, step=0.1
)

filtered_df = duckdb.sql(
    f"""
    select *
    from df
    where release_year between {year_range[0]} and {year_range[1]}
    """
).to_df()

# Top movies table
st.subheader("Sample of Top Movies by Worldwide Gross")
top_movies = filtered_df.nsmallest(20, "total_worldwide_gross")
st.dataframe(
    top_movies,
    use_container_width=True,
)
