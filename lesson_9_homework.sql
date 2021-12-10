--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

SELECT (CASE WHEN Grade < 8 THEN 'NULL' ELSE Name END), Grade, Marks 
from (select Name, Marks, (CASE WHEN Marks = 100 THEN Marks / 10 else floor((Marks / 10)) + 1 end) Grade 
from Students order by Grade desc, Name) a;
--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem
--не принимает(
select (CASE when Doctor is null THEN 'NULL' ELSE Doctor END), (CASE when Professor is null THEN 'NULL' ELSE Professor end),
(CASE when Singer is null THEN 'NULL' ELSE Singer end), (CASE when Actor is null THEN 'NULL' ELSE Actor end)
from 
(select name as Doctor, row_number() over(order by Name) a 
from occupation
where occupation = 'Doctor') d
full outer join
(select name as Professor, row_number(*) over(order by Name) a
from occupation
where occupation = 'Professor') p on d.a = p.a
full outer join
(select name as Singer, row_number(*) over(order by Name) a
from occupation
where occupation = 'Singer') s on p.a = s.a
full outer join
(select name as Actor, row_number(*) over(order by Name) a
from occupation 
where occupation = 'Actor') a on p.a = a.a;

-- вот
select doctor,professor,singer,actor 
from (select * from (select Name, occupation, (ROW_NUMBER() OVER (PARTITION BY occupation ORDER BY name)) as row_num from occupations order by name asc) 
pivot (min(name) for occupation in ('Doctor' as doctor,'Professor' as professor,'Singer' as singer,'Actor' as actor)) 
order by row_num);

--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem
select distinct(city) from station where regexp_like (city, '^[^aeiouAEIOU](*)');

--MySQL
select distinct city 
from station
where city not rlike '^[aeiouAEIOU].*$'
--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem
 select distinct city from station where regexp_like(city, '*[^aeiouAEIOU]$');

--MySQL
select distinct city 
from station
where city not rlike '^.*[aeiouAEIOU]$'
--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem

select distinct city from station where regexp_like(city, '^[^aeiouAEIOU]|*[^aeiouAEIOU]$');
--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem
select distinct(city) from station where regexp_like (city, '^[^aeiouAEIOU](*)') and regexp_like(city, '*[^aeiouAEIOU]$');
--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem
select name from Employee where salary > 2000 and months < 10 order by employee_id;
--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
SELECT (CASE WHEN Grade < 8 THEN 'NULL' ELSE Name END), Grade, Marks from (select Name, Marks, (CASE WHEN Marks = 100 THEN Marks / 10 else floor((Marks / 10)) + 1 end) Grade  from Students order by Grade desc, Name) a;
