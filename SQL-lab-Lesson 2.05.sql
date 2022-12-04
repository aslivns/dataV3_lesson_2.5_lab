-- Use sakila database
USE sakila;

-- 1. Select all the actors with the first name ‘Scarlett’
SELECT * 
FROM actor 
WHERE first_name = 'Scarlett';

-- 2. How many films (movies) are available for rent and how many films have been rented?
-- I compared the dates, if return date is null it is rented.
-- for returned, I would say IS NOT null but I wanted to be sure date difference

SELECT 
(SELECT COUNT(*) FROM rental WHERE return_date IS NULL) AS rented, -- 183 mmovies rented
(SELECT COUNT(*) FROM rental WHERE DATE(rental_date) < DATE(return_date)) AS returned;  -- 15756 movies available

-- 3. What are the shortest and longest movie duration? Name the values max_duration and min_duration.
SELECT MAX(length) AS max_duration,  MIN(length) AS min_duration
FROM film;   -- 185 min and 46 min

-- 4. What's the average movie duration expressed in format (hours, minutes)?
SELECT AVG(length) AS average_duration FROM film; -- 115 min to convert
SELECT SEC_TO_TIME(round(avg(length*60),0)) AS "average" FROM film;

-- 5. How many distinct (different) actors' last names are there?
SELECT COUNT(DISTINCT last_name) AS distinct_surnames FROM actor;   -- 121 different surnames

-- 6. Since how many days has the company been operating (check DATEDIFF() function)?
SELECT MAX(last_update) FROM rental;   -- last update is on 2006-02-23
SELECT DATEDIFF("2006-02-23", MIN(rental_date)) FROM rental;  
-- assuming since first rental date to last update of the table , 275 days

-- 7. Show rental info with additional columns month and weekday. Get 20 results.
SELECT *, MONTHNAME(rental_date) AS month, DAYNAME(rental_date) AS day FROM rental LIMIT 20;
 -- or
SELECT *, DATE_FORMAT(rental_date,'%M') AS 'month', DATE_FORMAT(rental_date,'%a') AS 'day'
FROM rental
LIMIT 20;

-- 8. Add an additional column day_type with values 'weekend' and 'workday' depending on the rental day of the week.
SELECT *, MONTHNAME(rental_date) AS month, DAYNAME(rental_date) AS weekday, 
       CASE 
       WHEN DAYNAME(rental_date) IN ('Saturday', 'Sunday') THEN 'Weekend' 
       ELSE 'Weekday' END AS column_day_type
FROM rental;

-- or
SELECT *,
CASE
WHEN DATE_FORMAT(rental_date,'%a') = 'Sat' then 'weekend'
WHEN DATE_FORMAT(rental_date,'%a') = 'Sun' then 'weekend'
ELSE 'weekday'
END AS column_day_type
FROM rental;
-- 9. Get release years.
SELECT title, release_year 
FROM film;  

SELECT DISTINCT release_year
FROM film;
-- only 2006;

-- 10. Get all films with ARMAGEDDON in the title.

SELECT * 
FROM film 
WHERE title LIKE '%ARMAGEDDON%';  

-- 11. Get all films which title ends with APOLLO.
SELECT * 
FROM film 
WHERE title LIKE '%APOLLO';

-- 12. Get 10 the longest films.
SELECT title, length 
FROM film 
ORDER BY length DESC 
LIMIT 10;

-- 13. How many films include Behind the Scenes content?
SELECT COUNT(special_features) AS BTS_content
FROM film 
WHERE special_features LIKE '%Behind the Scenes%';   -- 538 films include
