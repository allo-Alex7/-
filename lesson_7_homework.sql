--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson7)
-- sqlite3: Сделать тестовый проект с БД (sqlite3, project name: task1_7). В таблицу table1 записать 1000 строк с случайными значениями (3 колонки, тип int) от 0 до 1000.
-- Далее построить гистаграмму распределения этих трех колонко

--task2  (lesson7)
-- oracle: https://leetcode.com/problems/duplicate-emails/

select Email
from Person
group by Email
having count(Email) > 1

--task3  (lesson7)
-- oracle: https://leetcode.com/problems/employees-earning-more-than-their-managers/
-- почему- то  не принимает этот вариант:
select e."name" as 'Employee'
from Employee e join Employee ee on e.managerid = ee.id
where e.salary > ee.salary


select e.name as 'Employee'
from Employee e, Employee ee
where e.managerId = ee.id and e.salary > ee.salary


--task4  (lesson7)
-- oracle: https://leetcode.com/problems/rank-scores/

SELECT Score,
    dense_rank() OVER(order by Score desc) as "rank"
from Scores
order by Score desc;
--task5  (lesson7)
-- oracle: https://leetcode.com/problems/combine-two-tables/

select FirstName, LastName, City, State
from Person p left join Address a on p.PersonId = a.PersonId;
