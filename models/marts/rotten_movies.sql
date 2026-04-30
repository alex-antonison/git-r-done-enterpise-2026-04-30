

select 
distinct title 
from {{ ref('stg_movies') }}
order by rotten_tomatoes_rating asc
limit 10 