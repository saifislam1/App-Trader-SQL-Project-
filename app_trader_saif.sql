select * from app_store_apps 
order by name asc ;

select * from play_store_apps
order by name asc;

Select * 
from app_store_apps 
Inner join play_store_apps 
on app_store_apps .name = play_store_apps.name;

/*SELECT a.name, (cast (price as float)), a.rating ,p.name, p.price, p.rating
FROM app_store_apps as a , play_store_apps as p
order by price desc;*/

UPDATE play_store_apps
SET price = REPLACE(price, '$', '' );

/*select  P.name, P.type,P.review_count,P.rating, (cast(A.price as numeric)),P.install_count, A.name,A.rating,A.review_count
from play_store_apps P,  app_store_apps A
where A.name = P.name;*/

select  P.name, P.type,P.review_count as playstore_rev_count,P.rating as playstore_rating,P.content_rating, (cast(A.price as numeric)),P.install_count, A.rating as appstore_rating,A.review_count as appstore_rev_count,
 ((P.rating + A.rating)/2 ) as combined
 from play_store_apps P,  app_store_apps A
where A.name = P.name
Order by a.review_count desc
limit 10; 

/*select *
from  play_store_apps
where substr(name,1,6) = 'Shadow'*/

with combined_table as (Select distinct(name) ,playstore_rev_count,appstore_rev_count, 
						playstore_rating ,appstore_rating,content_rating,price,install_count, combined_rating 
from( select  P.name, P.type,(cast(P.review_count as numeric)) as playstore_rev_count,P.rating as playstore_rating,
	 P.content_rating, (cast(A.price as numeric)),P.install_count, A.rating as 
	 appstore_rating,(cast(A.review_count as numeric)) as appstore_rev_count,
 ((P.rating + A.rating)/2 ) as combined_rating
 from play_store_apps P,  app_store_apps A
where A.name = P.name) as subquery
Order by combined_rating desc )
select Distinct(name),price,combined_rating from combined_table
where playstore_rev_count >= 150000 and appstore_rev_count >= 90000 and combined_rating >= 4.55 and price = 0.00;

\copy (select * from my_table limit 10) TO '~/Downloads/export.csv' CSV HEADER

/*Select distinct (name), combined_rating from combined_table
Order by combined_rating desc ;

select avg(cast(review_count as numeric)) from app_store_apps; */
/*SELECT
(((((((app_store_apps.rating+play_store_apps.rating)/2)*2)+1)*12)*5000)-(((((((app_store_apps.rating+play_store_apps.rating)/2)*2)+1)*12)*1000)+(10000*app_store_apps.price))) as profit
from app_store_apps, play_store_apps
where play_store_apps.price is not null
limit (10);*/





/*COPY app_store_apps TO 'C:\Users\shaju\Git\Projects\app-trader-angry_birds\data\appstore.csv' DELIMITER ',' CSV HEADER*/