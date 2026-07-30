--Netflix project
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
SELECT * FROM netflix;
SELECT COUNT(*) as total_content
FROM netflix;

SELECT 
   DISTINCT type
FROM netflix;


-- 1. Count of Movies vs TV Shows
SELECT type, COUNT(*) AS total
FROM netflix
GROUP BY type;


--2.Find the most common rating for movies and TV shows
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

--3.List all movies released in a specific year (eg.2020)
SELECT *
FROM netflix
WHERE 
   type='Movie'
   AND
   release_year=2020

--4.Find the top 5 countries with the most content on netflix
SELECT 
     UNNEST( STRING_TO_ARRAY(country ,',')) as new_country,
	COUNT(show_id) as total_content
FROM NETFLIX 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--5.Identify the longest movie
SELECT *
    FROM netflix 
	WHERE type='Movie'
	AND
	duration=(SELECT MAX(duration) FROM netflix);

--6.Find content added in the last 5 years
SELECT
      *,
	  TO_DATE(date_added,'Month DD, YYYY')
FROM netflix
WHERE 
   TO_DATE(date_added,'Month DD, YYYY')>=CURRENT_DATE - INTERVAL '5 years'
   
SELECT CURRENT_DATE - INTERVAL '5 years'

-- 7. Content added per year (date parsing)
SELECT EXTRACT(YEAR FROM date_added::date) AS year_added, COUNT(*)
FROM netflix
WHERE date_added IS NOT NULL
GROUP BY year_added
ORDER BY year_added;

--8.Find all the movies/TV shows by director 'Rajiv Chilaka'
SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%'

--9.LIST ALL TV SHOWS WITH MORE THAN 5 SEASONS
SELECT
    * 	
FROM netflix
WHERE type='TV Show'
AND
SPLIT_PART(duration,' ',1):: numeric> 5 

--10.Count the number of contents in each genre
SELECT 
   UNNEST(STRING_TO_ARRAY(listed_in,',')) AS genre,
   COUNT(show_id) as total_content
FROM netflix
GROUP BY genre;

--11.Find each year and the avg number of content release by India on Netflix. 
--return top 5 year with highest avg content release
SELECT 
    EXTRACT (YEAR FROM TO_DATE(date_added ,'Month DD,YYYY')) as year,
	COUNT(*) AS yearly_content,
	ROUND(
	COUNT(*)::numeric/(SELECT COUNT(*)FROM netflix WHERE country='India')::numeric * 100
	,2)as avg_content_per_year
FROM netflix 
WHERE country='India'
GROUP BY 1

--12.LIST ALL MOVIES THAT ARE DOCUMENTARIES
SELECT 
    *
FROM netflix
WHERE 
     listed_in ILIKE '%DOCUMENTARIES%'

--13.find all the content without a director
SELECT *
FROM netflix
WHERE 
    director IS NULL

--14.Find how many movies actor 'Salman Khan ' appeared in last 10 years
SELECT COUNT(*)
FROM netflix
WHERE 
   casts ILIKE '%Salman Khan%'
   AND
   release_year>EXTRACT(YEAR FROM CURRENT_DATE)-10

--15.FIND THE TOP 10 ACTORS WHO HAVE APPEARED IN THE HIGHEST NUMBER OF MOVIES PRODUCED IN INDIA
SELECT 
    UNNEST (STRING_TO_ARRAY(casts,',')) as actors,
	COUNT(*) as total_content
FROM netflix
WHERE country ILIKE '%INDIA'
GROUP  BY 1
ORDER BY 2 DESC
LIMIT 10

--16.categorize the content based on the presence of the keywords 'kill'and 'violance'
in the description field, label content containing these keywords as 'Bad' and all other
content as "good".count how many items fell into each category


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

--17. Titles released in the last 10 years
SELECT title, release_year
FROM netflix
WHERE release_year >EXTRACT(YEAR FROM CURRENT_DATE) - 10;




