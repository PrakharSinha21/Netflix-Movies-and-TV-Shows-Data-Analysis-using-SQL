-- SQL Netflix Project

--Create table
drop table if exists netflix;
create table netflix
	(
	    show_id	varchar(10),
		type varchar(10),
		title varchar(150),
		director varchar(250),	
		casts varchar(1000),
		country	varchar(150),
		date_added	varchar(50),
		release_year int,
		rating varchar(20),
		duration varchar(25),
		listed_in varchar(100),
		description varchar(250)
	);

select * from netflix; --Can see whole data in table

select count (*) from netflix; --Number of rows in table

select distinct type from netflix;


--Data Analysis
--Q1.Count the number of movies & tv shows
select type,count(*) as total_content
from netflix
group by type;


--Q2.Find the most common rating for movies and tv shows
select type,rating
from
	(
		select type,rating,
				count(*),
				rank() over(partition by type order by count(*) desc) as ranking
		from netflix
		group by 1,2
	) as t1
where ranking =1;


--Q3.List all movies released in a specific year(eg.2020)
select *,release_year
from netflix
where type ='Movie'
		and
		release_year=2020;


--Q4.Find the top 5 countries with the most content on netflix
select unnest(string_to_array(country,',')) as new_country,
		count(show_id) as total_content
from netflix
group by 1
order by 2 desc
limit 5;


--Q5.Identify the longest movie
select *
from netflix
where type = 'Movie'
		and
		duration =(
					select max(duration) from netflix
					);


--Q6.Find content addded in the last 5 years
select *
from netflix
where
	to_date(date_added,'Month DD,YYYY') >= current_date - interval '5 years';
	


--Q7.Find all the movie/tv shows by director 'Rajiv chilaka'
select *
from netflix
where director Ilike '%Rajiv Chilaka%';


--Q8.List all tv shows with more than 5 seasons
SELECT  *
from netflix
where type = 'TV Show'
			and
			split_part(duration, ' ',1) ::numeric > 5; 


--Q9.Count the number of content items in each genre
select unnest(string_to_array(listed_in, ',')) as genre,
		count(show_id) as total_count
from netflix
group by 1;


--Q10.Find the average release year for content produced in India.
select
		extract(year from to_date(date_added,'Month DD,YYYY')) as Year,
		count(*) as Yearly_Content,
		ROUND(
			   count(*)::numeric/(select count(*) from netflix
				where country='India')::numeric * 100,2) as Avg_per_year
		
from netflix
where country='India'
group by 1;



--Q11.List all movies that are documentaries
SELECT *
from netflix
where listed_in Ilike '%documentaries%';



--Q12.Find all content without a director
select *
from netflix
where director is null;


--Q13.Find how many movies actor 'Salman khan' appeared in last 10 years
select *
from netflix 
where  casts Ilike '%Salman Khan%'
		and
		release_year > extract(year from current_date) - 10;


--Q14.Find the top 10 actors who have appeared in the highest number of movies produced in india
select
unnest(string_to_array(casts, ',')) as actors,
count(*) as total_content
from netflix
where country ILIKE '%india%'
group by 1
order by 2 desc
limit 10;

/*
--Q15.Categories the content bases on the presence of the keywords 'kill' and 'violence' in the 
 description field.Label content containing these words as 'Bad' and all other content as 'Good'.
 Count how many items fall into each category.    
*/	  
with new_table
as
(
select *,
		case
		when description ILIKE '%kill%' or
			 description ILIKE '%violence%'
		then 'Bad Content'
		else 'Good Content'
		end category
from netflix
)
select category,
	 count(*) as total_content
from new_table
group by 1;




------END OF PROJECT 






