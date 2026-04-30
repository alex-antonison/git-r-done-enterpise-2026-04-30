    SELECT
        director,
        avg(imdb_rating)
    FROM {{ ref('stg_movies') }}
    group by director