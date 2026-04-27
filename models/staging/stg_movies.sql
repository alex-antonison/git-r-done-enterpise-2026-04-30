WITH

source_data AS (

    SELECT *
    FROM
        read_json_auto('https://raw.githubusercontent.com/vega/vega-datasets/next/data/movies.json')
)

SELECT
    row_number() OVER () AS movie_id,
    "Title" AS title,
    "US Gross" AS us_gross,
    "Worldwide Gross" AS worldwide_gross,
    "US DVD Sales" AS us_dvd_sales,
    "Production Budget" AS production_budget,
    "Release Date" AS release_date,
    cast(
        date_part('year', strptime("Release Date", '%b %d %Y')) AS INTEGER
    ) AS release_year,
    "MPAA Rating" AS mpaa_rating,
    "Running Time min" AS running_time_min,
    "Distributor" AS distributor,
    "Source" AS source,
    "Major Genre" AS major_genres,
    "Creative Type" AS creative_type,
    "Director" AS director,
    "Rotten Tomatoes Rating" AS rotten_tomatoes_rating,
    "IMDB Rating" AS imdb_rating,
    "IMDB Votes" AS imdb_votes
FROM
    source_data
