    SELECT
        director,
        avg(imdb_rating) as average_imdb_rating
    FROM {{ ref('stg_movies') }}
    group by director
    order by average_imdb_rating