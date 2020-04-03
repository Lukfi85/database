					-- “Операторы, фильтрация, сортировка и ограничение”
#1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.#

UPDATE products 
	SET created_at = CURRENT_TIMESTAMP(), updated_at = CURRENT_TIMESTAMP() 
;
	
/*2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в
них долгое время помещались значения в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME, 
сохранив введеные ранее значения.*/
ALTER table products 
	modify created_at datetime,
	modify updated_at datetime
;
-- Наполняем данными storehouses
INSERT INTO storehouses_products
  (storehouse_id , product_id , value)
VALUES
  (1,1,5),
  (1,2,10),
  (1,3,0),
  (1,4,8),
  (1,5,12),
  (1,6,0),
  (1,7,5)
  ;
/* 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры:
 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, 
 чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, 
 после всех записей. */
 SELECT value FROM storehouses_products ORDER BY CASE WHEN value = 0 THEN 1 ELSE 0 END, value;

-- 4. Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
-- Месяцы заданы в виде списка английских названий ('may', 'august')

SELECT name FROM users
	where MONTH(birthday_at ) = 5 or MONTH(birthday_at ) = 9 ;

-- 5. Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs 
-- WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.
 SELECT * FROM catalogs WHERE id IN (5, 1, 2) order BY FIELD(id, 5, 1, 2) 
 
					-- Агрегация данных

-- 1.Подсчитайте средний возраст пользователей в таблице users
SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at , curdate())) FROM users 

-- 2.Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
-- Следует учесть, что необходимы дни недели текущего года, а не года рождения.
select WEEKDAY(CONCAT(YEAR(NOW()), SUBSTRING(birthday_at, 5, 10))) as wk, COUNT(*) FROM users group by  wk ;
-- 0 понедельник, 1 вторник и т.д.
 
-- 3.Подсчитайте произведение чисел в столбце таблицы .
select exp(sum(ln(price))) from products
