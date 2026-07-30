# Netflix Movies and TV shows data analysis using SQL


![Netflix logo](https://github.com/Suchismitasahaa/Netflix_sql_project/blob/main/netflix%20logo.jpg)
## Overview

This project analyzes Netflix's movies and TV shows using SQL to uncover trends in content type, genre distribution, release patterns, and more. The goal is to practice real-world SQL querying — filtering, aggregation, grouping and string/date parsing — on a realistic, messy dataset.

## Objectives
 1. Understand the overall composition of Netflix's catalog (Movies vs TV Shows).

   2.Identify which countries produce the most content on Netflix.
  
   3.Analyze how the volume of content added has changed over time (year-over-year trend).
  
   4.Determine the most common genres and how they differ across content types.
  
   5.Identify the directors and cast members with the most titles on the platform.

## Dataset
Source: Netflix Movies and TV Shows dataset on Kaggle

File:[Dataset link]( https://www.kaggle.com/datasets/shivamb/netflix-shows)

Columns: show_id, type, title, director, cast, country, date_added, release_year, rating, duration, listed_in, description 

## Tools Used

Database: PostgreSQL

## Schema

```sql

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix 
(
  show_id VARCHAR(6),
  type VARCHAR(10),
  title VARCHAR(150),
  director VARCHAR(208),
  casts VARCHAR(1000),
  country VARCHAR(150),
  date_added VARCHAR(50),
  release_year INT,
  rating VARCHAR(10),
  duration  VARCHAR(15),
  listed_in  VARCHAR(100),
  description  VARCHAR(250)
);

```
## Business Problems and Solutions

1. Count the number of Movies and TV shows
```sql

SELECT type, COUNT(*) AS total
FROM netflix
GROUP BY type;
```

2.Find the most common rating for movies and TV shows

```sql
SELECT 
  type,
  rating
FROM (
SELECT type, rating ,COUNT(*),
RANK() OVER (PARTITION BY type ORDER BY COUNT(*)DESC) as ranking
FROM
netflix
GROUP BY 1,2
) as t1
WHERE 
ranking=1
```

3.List all movies released in a specific year (eg.2020)

```sql
SELECT *
FROM netflix
WHERE 
   type='Movie'
   AND
   release_year=2020
```

4.Find the top 5 countries with the most content on netflix
```sql
SELECT 
     UNNEST( STRING_TO_ARRAY(country ,',')) as new_country,
	COUNT(show_id) as total_content
FROM NETFLIX 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

5.Identify the longest movie
```sql
SELECT *
    FROM netflix 
	WHERE type='Movie'
	AND
	duration=(SELECT MAX(duration) FROM netflix);
```

6.Find content added in the last 5 years
```sql
SELECT
      *,
	  TO_DATE(date_added,'Month DD, YYYY')
FROM netflix
WHERE 
   TO_DATE(date_added,'Month DD, YYYY')>=CURRENT_DATE - INTERVAL '5 years'
   
SELECT CURRENT_DATE - INTERVAL '5 years'
```

7. Content added per year (date parsing)
```sql
SELECT EXTRACT(YEAR FROM date_added::date) AS year_added, COUNT(*)
FROM netflix
WHERE date_added IS NOT NULL
GROUP BY year_added
ORDER BY year_added;
```

8.Find all the movies/TV shows by director 'Rajiv Chilaka'
```sql
SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%'
```

9.LIST ALL TV SHOWS WITH MORE THAN 5 SEASONS
```sql

SELECT
    * 	
FROM netflix
WHERE type='TV Show'
AND
SPLIT_PART(duration,' ',1):: numeric> 5 
```
10.Count the number of contents in each genre
```sql
SELECT 
   UNNEST(STRING_TO_ARRAY(listed_in,',')) AS genre,
   COUNT(show_id) as total_content
FROM netflix
GROUP BY genre;
```

11.Find each year and the avg number of content release by India on Netflix. Return top 5 year with highest avg content release
```sql
SELECT 
    EXTRACT (YEAR FROM TO_DATE(date_added ,'Month DD,YYYY')) as year,
	COUNT(*) AS yearly_content,
	ROUND(
	COUNT(*)::numeric/(SELECT COUNT(*)FROM netflix WHERE country='India')::numeric * 100
	,2)as avg_content_per_year
FROM netflix 
WHERE country='India'
GROUP BY 1
```

12.LIST ALL MOVIES THAT ARE DOCUMENTARIES
```sql
SELECT 
    *
FROM netflix
WHERE 
     listed_in ILIKE '%DOCUMENTARIES%'
```

13.find all the content without a director
```sql
SELECT *
FROM netflix
WHERE 
    director IS NULL
```

14.Find how many movies actor 'Salman Khan ' appeared in last 10 years
```sql
SELECT COUNT(*)
FROM netflix
WHERE 
   casts ILIKE '%Salman Khan%'
   AND
   release_year>EXTRACT(YEAR FROM CURRENT_DATE)-10
```
15.FIND THE TOP 10 ACTORS WHO HAVE APPEARED IN THE HIGHEST NUMBER OF MOVIES PRODUCED IN INDIA
```sql
SELECT 
    UNNEST (STRING_TO_ARRAY(casts,',')) as actors,
	COUNT(*) as total_content
FROM netflix
WHERE country ILIKE '%INDIA'
GROUP  BY 1
ORDER BY 2 DESC
LIMIT 10
```
16.categorize the content based on the presence of the keywords 'kill'and 'violance' in the description field, label content containing these keywords as 'Bad' and all other content as "good". count how many items fell into each category

```sql
WITH new_table 
AS (
SELECT 
   *,
   CASE
   WHEN
       description ILIKE '%KILL%' OR
	   description ILIKE '%violance%' THEN 'BAD_CONTENT'
	   ELSE 'GOOD CONTENT'
	END category
FROM netflix
)
SELECT 
     category ,
	 count(*) as total_content
FROM new_table
GROUP BY 1
```

17. Titles released in the last 10 years
```sql
SELECT title, release_year
FROM netflix
WHERE release_year >EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

## Findings
### Content Distribution: 
The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
### Geographical Insights:
The top countries and the average content releases by India highlight regional content distribution.
### Common genre:
Dramas and International Movies are the most common genres.

## Contact
### Name: Suchismita Saha
### Linkedin :
