--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/
select Department, Employee, Salary
from (select Department.name as Department, Employee.Name as Employee, Salary, dense_rank() over(partition by Department.name order by salary desc) as d 
from Department
join Employee
on Department.Id = Employee.departmentId) a
where d < 4
--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17
select member_name, status, sum(amount*unit_price) as costs
from FamilyMembers
join Payments
on FamilyMembers.member_id = Payments.family_member
where Payments.date BETWEEN '2005-01-01' and '2006-01-01'
group by member_name, status
--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13
select name
FROM Passenger
group by name
having count(id) > 1
--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38
select count(id) as count
from Student
where first_name like 'Anna'
GROUP BY first_name
--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35
select count(classroom) as count
from Schedule
where date = '2019-09-02'
group by date
--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38
select count(id) as count
from Student
where first_name like 'Anna'
GROUP BY first_name
--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32
SELECT floor(AVG(age)) as age
from (SELECT birthday, ((YEAR(CURRENT_DATE) - YEAR(birthday)) - (DATE_FORMAT(CURRENT_DATE, '%m%d') < DATE_FORMAT(birthday, '%m%d'))) AS age
FROM FamilyMembers) a
--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27
select good_type_name, sum(amount*unit_price) as costs  
from (
select*
from Payments
join Goods
on Payments.good = Goods.good_id
join GoodTypes
on Goods.type = GoodTypes.good_type_id
where date BETWEEN '2005-01-01' and '2006-01-01'
) s
group by good_type_name
--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37
select min(((YEAR(CURRENT_DATE) - YEAR(birthday)) - (DATE_FORMAT(CURRENT_DATE, '%m%d') < DATE_FORMAT(birthday, '%m%d')))) AS year
from Student
--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44
select max(((YEAR(CURRENT_DATE) - YEAR(birthday)) - (DATE_FORMAT(CURRENT_DATE, '%m%d') < DATE_FORMAT(birthday, '%m%d')))) AS max_year
from (select birthday
from Class
join Student_in_class
on Class.id = Student_in_class.class
join Student
on Student_in_class.student = Student.id
where name like '10%') a
--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20
select status, member_name, sum(amount*unit_price) as costs  
from (
select status, member_name, amount, unit_price
from FamilyMembers
join Payments
on FamilyMembers.member_id = Payments.family_member
join Goods
on Payments.good = Goods.good_id
join GoodTypes
on Goods.type = GoodTypes.good_type_id
where good_type_name = 'entertainment') a
group by member_name, status
--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55
select *
from Company
join Trip
on Company.id = Trip.company


delete from Company
where name in (select name, count(plane) as number_plane
from Company
join Trip
on Company.id = Trip.company
GROUP BY name
order by number_plane
limit 1)
--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45
select classroom
from (select classroom, ROW_NUMBER() over(PARTITION BY classroom) as f
from Schedule) a
where f = (select count(*) a
from Schedule
group by classroom
order by count(*) DESC 
limit 1)
--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43
select last_name
from Subject
join Schedule
on Schedule.subject = Subject.id
join Teacher
on Teacher.id = Schedule.teacher
WHERE name = 'Physical Culture'
order by last_name
--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63
select concat_ws('.', last_name, SUBSTRING(first_name, 1, 1), SUBSTRING(middle_name, 1, 1), '') as name
from Student
order by name
