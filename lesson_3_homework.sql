--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
select *
from Battles;

select *
from ships;



select *
from classes;

select *
from outcomes;

select *
from classes c join ships s on c."class" = s."class" 

select *
from (select ship 
from outcomes
where "result" = 'sunk') o right join (select * from ships) s on o.ship = s.name


--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей
SELECT c."class", SUM(sh.sunked)
FROM classes c
  LEFT JOIN (
     SELECT t."name" AS na, t."class" AS cl,
           CASE WHEN o.result = 'sunk' THEN 1 ELSE 0 END AS sunked
     FROM
     (
      SELECT "name", "class"
      FROM ships
       UNION
      SELECT ship, ship
      FROM outcomes
     )
     AS t
    LEFT JOIN outcomes o ON t."name" = o.ship
  ) sh ON sh.cl = c."class"
GROUP BY c."class"
--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.

select c."class", d."year"
from classes c left join (select "class", min(launched) as "year" from ships s  group by "class") d on c."class" = d."class" 

--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.
select class, SUM(CASE WHEN result='sunk' THEN 1 ELSE 0 END) as sunks
from (
    select c.class, name from classes c
      join ships s on c.class=s.class
    union
    select class, ship from classes 
      join outcomes on class=ship
  ) as sh
  left join outcomes o on sh.name=o.ship
group by class
having SUM(CASE WHEN result='sunk' THEN 1 ELSE 0 END) > 0
    and (select count(si.name) from (
            select s.name, s.class from ships s
            union
            select o.ship, o.ship from outcomes o
          ) as si
        where si.class = sh.class
        group by si.class
        )>=3
--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).


SELECT name
FROM (SELECT o.ship AS name, numguns, displacement
FROM outcomes o INNER JOIN
classes c ON o.ship = c.class AND
o.ship NOT IN (SELECT name
FROM ships
)
UNION
SELECT s.name AS name, numguns, displacement
FROM ships s INNER JOIN
classes c ON s.class = c.class
) OS INNER JOIN
(SELECT MAX(numguns) AS Maxnumguns, displacement
FROM outcomes o INNER JOIN
classes c ON o.ship = c.class AND
o.ship NOT IN (SELECT name
FROM ships
)
GROUP BY displacement
UNION
SELECT MAX(numguns) AS Maxnumguns, displacement
FROM ships s INNER JOIN
classes c ON s.class = c.class
GROUP BY displacement
) GD ON OS.numGuns = GD.MaxNumGuns AND
OS.displacement = GD.displacement

--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker
select maker 
from (select maker 
from (select maker, ram, speed
FROM PC inner join product p2 on PC.model = p2.model) po
where po.maker in (select maker 
from printer p inner join product p2 on p.model = p2.model)
order by ram, speed desc) ma
group by maker

