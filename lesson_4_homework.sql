--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type
select p.model, maker, p."type"
from printer p join product p2 on p.model = p2.model
union
select pc.model, maker, p2."type"
from pc join product p2 on pc.model = p2.model
union
select l.model, maker, p2."type"
from laptop l join product p2 on l.model = p2.model
--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"

select printer.model, printer.color, printer.type, product.maker, case when product.maker in (select maker
from (SELECT maker,
CASE WHEN pc.price > (select avg(price) from pc ) THEN 1 ELSE 0 END AS "more"
FROM pc join product on pc.model = product.model) ma
where "more" > 0) THEN 1 ELSE 0 END AS mor
from printer join product on printer.model = product.model


--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)


select ship
from (select name, c."class" 
from ships s right join classes c on s."class" = c."class") f full outer join (select ship from outcomes group by ship) ou on f.name = ou.ship
where class is null


--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.

select name, EXTRACT(YEAR FROM date) as date
from Battles b
where EXTRACT(YEAR FROM date) not in (select launched from ships)

--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

select name from ships where "class" = 'Kongo' and name in (select ship 
from outcomes o join battles b on o.battle = b."name" )

--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300. Во view три колонки: model, price, flag
create view all_products_flag_300
as (select model, price, case when price > 300 then 1 else 0 end as flag
from pc
union all
select model, price, case when price > 300 then 1 else 0 end as flag
from printer
union all
select model, price, case when price > 300 then 1 else 0 end as flag
from laptop)

select *
from all_products_flag_300
--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше cредней . Во view три колонки: model, price, flag
create view all_products_flag_avg_price
as (select model, price, case when price > (select avg(price) from all_products_flag_300) then 1 else 0 end as flag
from pc
union all
select model, price, case when price > (select avg(price) from all_products_flag_300) then 1 else 0 end as flag
from printer
union all
select model, price, case when price > (select avg(price) from all_products_flag_300) then 1 else 0 end as flag
from laptop);

select *
from all_products_flag_avg_price
--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model
select p.model
from printer p join product p1 on p.model = p1.model
where price > (select avg(price) from printer p join product p1 on p.model = p1.model where maker in ('D', 'C')) and maker = 'A'


--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model
select model 
from (select p.model, price, maker
from printer p join product p2 on p.model = p2.model
union all
select pc.model, price, maker
from pc join product p2 on pc.model = p2.model
union all
select l.model, price, maker
from laptop l join product p2 on l.model = p2.model) d
where price > (select avg(price) from printer p join product p1 on p.model = p1.model where maker in ('D', 'C')) and maker = 'A'
group by model

	

--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)
select avg(price)
from (select p.model, maker, p."type", price
from printer p join product p2 on p.model = p2.model
union
select pc.model, maker, p2."type", price
from pc join product p2 on pc.model = p2.model
union
select l.model, maker, p2."type", price
from laptop l join product p2 on l.model = p2.model) l
where maker = 'A'
--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count
create view count_products_by_makers
as select maker, count(model)
from (select p.model, price, maker
from printer p join product p2 on p.model = p2.model
union all
select pc.model, price, maker
from pc join product p2 on pc.model = p2.model
union all
select l.model, price, maker
from laptop l join product p2 on l.model = p2.model) d
group by maker

select *
from count_products_by_makers
--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)
select *
from count_products_by_makers
--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'
select *
into printer_updated
from printer
 
delete from printer_updated where model in (select p.model
from printer p join product p2 on p.model = p2.model
where maker = 'D')

select *
from printer_updated

--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)
create view printer_updated_view  
as select code, p.model, color, p.type, price, maker
from printer_updated p join product p2 on p.model = p2.model

select *
from printer_updated_view
--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)
CREATE VIEW  sunk_ships_by_classe
as select SUM(sh.sunked) as "count", c."class" as "class"
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


select *
from sunk_ships_by_classe
--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)
select *
from sunk_ships_by_classe
--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0
select *
into classes_with_flag
from (select *, case when numguns > 8 then 1 else 0 end as flag
from classes) c

select *
from classes_with_flag
--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)
select country, count("class") 
from classes
group by country

--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".
select count(*)
from (select name
from ships s 
union 
select ship
from outcomes) f
where name like 'O%' or name like 'M%'
--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.
select count(*)
from (select name
from ships s 
union 
select ship
from outcomes) f
where name like '% %'
--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)

select launched, count(name)
from ships
group by launched
order by launched 
