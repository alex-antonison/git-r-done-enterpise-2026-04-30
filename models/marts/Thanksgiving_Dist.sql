with thanksgiving_dates as (
    select
        year,
        -- November 1 of the year
        make_date(year, 11, 1) as nov_1,
        -- Day of week for Nov 1 (0=Sunday, 1=Monday, ..., 6=Saturday)
        dayofweek(make_date(year, 11, 1)) as dow_nov_1,
        -- Days to first Thursday (Thursday = 4)
        case
            when dayofweek(make_date(year, 11, 1)) <= 4 then 4 - dayofweek(make_date(year, 11, 1))
            else 4 - dayofweek(make_date(year, 11, 1)) + 7
        end as days_to_first_thursday,
        -- First Thursday in November
        make_date(year, 11, 1) + 
        case
            when dayofweek(make_date(year, 11, 1)) <= 4 then 4 - dayofweek(make_date(year, 11, 1))
            else 4 - dayofweek(make_date(year, 11, 1)) + 7
        end as first_thursday,
        -- Fourth Thursday (Thanksgiving) = first Thursday + 21 days
        make_date(year, 11, 1) + 
        case
            when dayofweek(make_date(year, 11, 1)) <= 4 then 4 - dayofweek(make_date(year, 11, 1))
            else 4 - dayofweek(make_date(year, 11, 1)) + 7
        end + 21 as thanksgiving_date
    from (
        -- Generate years (adjust range as needed, e.g., 1900 to 2100)
        select unnest(generate_series(1900, 2100)) as year
    )



with movie_dates as (
    select
        movie_id,
        title,
        release_date,
        extract(month from release_date) as month,
        extract(day from release_date) as day, 
        extract(year from release_date) as year
    from movies
)