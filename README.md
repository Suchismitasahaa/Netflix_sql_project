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

