with 

all_releases AS (
    SELECT
        title,
        release_year,
        major_genres,
        worldwide_gross
    FROM {{ ref('stg_movies') }}
    where release
),

top_event as (
    SELECT
        max(total_worldwide_gross) as max_gross
    FROM all_releases
),

final as (
    SELECT
        a.title,
        a.release_year,
        a.major_genres,
        a.worldwide_gross
    FROM all_releases a
    INNER JOIN top_event t 
        ON a.worldwide_gross = t.max_gross
)

SELECT * FROM final
