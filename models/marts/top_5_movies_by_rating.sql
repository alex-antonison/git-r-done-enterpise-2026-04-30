SELECT *
FROM {{ ref('stg_movies') }}
WHERE imdb_rating IS NOT NULL
ORDER BY imdb_rating DESC
LIMIT 5
