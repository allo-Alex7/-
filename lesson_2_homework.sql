--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing
SELECT *
FROM ships

-- Задание 1: Вывести name, class по кораблям, выпущенным после 1920
SELECT name
FROM ships
WHERE launched > 1920
--

-- Задание 2: Вывести name, class по кораблям, выпущенным после 1920, но не позднее 1942
--
SELECT name, "class"
FROM ships
WHERE launched > 1920 and launched < 1942
-- Задание 3: Какое количество кораблей в каждом классе. Вывести количество и class
--
SELECT count(*), "class"
FROM ships
GROUP BY ("class")
-- Задание 4: Для классов кораблей, калибр орудий которых не менее 16, укажите класс и страну. (таблица classes)
select "class", country
from classes
where bore >= 16
--

-- Задание 5: Укажите корабли, потопленные в сражениях в Северной Атлантике (таблица Outcomes, North Atlantic). Вывод: ship.
--
select ship
from outcomes
where battle = 'North Atlantic' and "result" = 'sunk'
-- Задание 6: Вывести название (ship) последнего потопленного корабля
--
select ship 
from Outcomes join battles on Outcomes.battle = battles."name"
where "result" = 'sunk'
order by date desc
limit 1

-- Задание 7: Вывести название корабля (ship) и класс (class) последнего потопленного корабля
--
select "name", s."class"
from classes c join ships s on c."class" = s."class" 
where s."name" in (select ship 
from Outcomes join battles on Outcomes.battle = battles."name"
where "result" = 'sunk'
order by date desc
limit 1)
-- Задание 8: Вывести все потопленные корабли, у которых калибр орудий не менее 16, и которые потоплены. Вывод: ship, class
--
select ship, bore from outcomes o
  left join ships s on o.ship = s."name"
  join classes c on (o.ship=c."class" or s."class"=c."class")
where result = 'sunk' and bore >= 16

-- Задание 9: Вывести все классы кораблей, выпущенные США (таблица classes, country = 'USA'). Вывод: class
--
select "class" 
from classes c 
where country = 'USA'

-- Задание 10: Вывести все корабли, выпущенные США (таблица classes & ships, country = 'USA'). Вывод: name, class
select s."name", s."class"
from classes c join ships s on c."class" = s."class"
where country = 'USA'