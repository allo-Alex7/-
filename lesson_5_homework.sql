--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing
-- Компьютерная фирма: Сделать view, в которой будет постраничная разбивка всех laptop (не более двух продуктов на одной странице). Вывод: все данные из laptop, номер страницы, список всех страниц
CREATE VIEW laptop_viev
AS select code, model, speed, ram, hd, price, ((s.d + 1) / 2) as page, case when (s.d % 2) = 0 then 2 else 1 end as place
from (SELECT *,
row_number(*) OVER(order by code) as d
FROM laptop) s


select *
from laptop_viev
--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов (не более двух продуктов на одной странице). Вывод: все данные из laptop, номер страницы, список всех страниц

CREATE VIEW pages_all_products
AS select maker, price, "type", ((s.d + 1) / 2) as page, case when (s.d % 2) = 0 then 2 else 1 end as place
from (SELECT *,
row_number(*) OVER(order by maker) as d
FROM (
	select maker, price, product.type
	from product 
	join pc on product.model = pc.model 
	union
	select maker, price, product.type
	from product 
	join printer on product.model = printer.model 
	union 
	select maker, price, product.type
	from product 
	join laptop on product.model = laptop.model 
) a) s


select *
from pages_all_products
where "type" = 'Laptop'
sample:
1 1
2 1
1 2
2 2
1 3
2 3

--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное соотношение всех товаров по типу устройства. Вывод: производитель, тип, процент (%)
	

create view distribution_by_type
as select "type", sa/(select sum(sa)
from (select "type", count(price) as sa
from (select maker, price, product.type
from product 
join pc on product.model = pc.model 
union all
select maker, price, product.type
from product 
join printer on product.model = printer.model 
union all
select maker, price, product.type
from product 
join laptop on product.model = laptop.model) k
group by "type") d) * 100 as "%"
from (select "type", count(price) as sa
from (select maker, price, product.type
from product 
join pc on product.model = pc.model 
union all
select maker, price, product.type
from product 
join printer on product.model = printer.model 
union all
select maker, price, product.type
from product 
join laptop on product.model = laptop.model) k
group by "type") d


select *
from distribution_by_type
--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму. Пример https://plotly.com/python/histograms/

--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но название корабля должно состоять из двух слов
select *
into ships_two_words
from (select *
from ships s 
where "name" like '% %') a
--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"
select ship
from (select name, c."class" 
from ships s right join classes c on s."class" = c."class") f full outer join (select ship from outcomes group by ship) ou on f.name = ou.ship
where class is null and ship like 'S%'
--task6 (lesson5) p.model
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'C' и три самых дорогих (через оконные функции). Вывести model
select *, row_number(*) over(partition by maker order by price desc) as rn
from printer p join product p1 on p.model = p1.model
where price > (SELECT COALESCE((select AVG(price) from printer p join product p1 on p.model = p1.model where maker = 'C'), 0)) and maker = 'A'