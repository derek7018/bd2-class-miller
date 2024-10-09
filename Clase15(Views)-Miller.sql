USE sakila;

-- QUERY 1
-- Create a view named list_of_customers, it should contain the following columns:
--    customer id
--    customer full name,
--    address
--    zip code
--    phone
--    city
--    country
--    status (when active column is 1 show it as 'active', otherwise is 'inactive')
--    store id

CREATE VIEW list_of_customers AS 
	SELECT cus.customer_id AS 'Customer ID', CONCAT(cus.first_name, ' ', cus.last_name) AS 'Customer Name', a.address AS 'Address', a.postal_code AS 'Zip code', a.phone AS 'Phone', ci.city AS 'City', co.country AS 'Country',
    CASE WHEN cus.active = 1 THEN 'active' ELSE 'inactive' END AS 'Status', cus.store_id AS 'Store ID' 
    FROM customer cus INNER JOIN address a USING (address_id) INNER JOIN city ci USING (city_id) INNER JOIN country co USING (country_id);
    
SELECT * FROM list_of_customers;


-- QUERY 2
-- Create a view named film_details, it should contain the following columns: 
-- film id, title, description, category, price, length, rating, actors - as a string of all the actors separated by comma. 
-- Hint use GROUP_CONCAT

drop view film_details;
create view film_details as
	select f.film_id as 'film id', f.title as 'title', f.description , c.name as 'category', f.rental_rate,f.`length`, f.rating, group_concat(a.first_name, " ", a.last_name) as actors from film_actor f_a 
	inner join film_category f_c using(film_id) 
	inner join category c using(category_id) 
	inner join film f using(film_id) 
	inner join actor a using(actor_id) 
	group by film_id, c.name;

select * from film_details;
    
-- QUERY 3
-- Create view sales_by_film_category, it should return 'category' and 'total_rental' columns.
drop view sales_by_film_category;
create view sales_by_film_category as 
	select c.name as 'category', count(r.rental_id) as 'total_rental' from rental r
	inner join inventory i using(inventory_id)
	inner join film f using(film_id)
	inner join film_category fc using(film_id) 
	inner join category c using(category_id)
	group by category_id;

select * from sales_by_film_category;

-- QUERY 4
-- Create a view called actor_information where it should return, actor id, first name, last name and the amount of films he/she acted on.
drop view actor_information;
create view actor_information as 
	select a.actor_id, a.first_name as 'name',a.last_name as 'last name',count(fa.film_id) as 'film acted' from actor a
    inner join film_actor fa using(actor_id)
    group by a.actor_id;
    
select * from actor_information;

-- QUERY 5
-- Analyze view actor_info, explain the entire query and specially how the sub query works. 
-- Be very specific, take some time and decompose each part and give an explanation for each.

SELECT * FROM actor_info;

/*
Esta vista está diseñada para devolver información de cada actor en la base de datos, junto con las películas en las que han participado, agrupadas por la categoría de la película. La vista selecciona el actor_id, first_name, last_name y un campo llamado film_info, que consiste en una concatenación de cada categoría distinta y una lista de todas las películas que son parte de esa categoría y en las que el actor ha aparecido. 
Esto se logra utilizando un LEFT JOIN desde la tabla actor hacia las tablas film_actor, film_category y category para recopilar datos sobre las películas en las que ha trabajado cada actor y sus respectivas categorías, asegurando que los actores que no han participado en ninguna película también sean incluidos.

La subquery que realiza film_info funciona de la siguiente manera: primero, el GROUP_CONCAT externo une cada nombre de categoría distinto con el resultado de la inner subquery, separado por dos puntos (:). 
La inner subquery devuelve un GROUP_CONCAT de todos los títulos de películas (ordenados alfabéticamente y separados por comas) para cada película que coincida tanto con el category_id de la categoría actual (de la tabla film_category) como con el actor_id del actor actual (de la tabla film_actor). 
De esta manera, la vista completa devolverá: actor_id, actor_name, actor_surname y un campo similar a [categoría1: película1, película2..., categoría2:...] para cada actor.
*/


-- QUERY 6
-- Materialized views, write a description, why they are used, alternatives, DBMS were they exist, etc.

/*
Una materialized view es un tipo de vista que almacena el resultado de una consulta como una tabla física en el disco. 
La principal diferencia entre este tipo de view y las views regulares es que las materialized views guardan el resultado específico de una consulta en un momento dado directamente en el disco, en lugar de almacenarse virtualmente y actualizarse dinámicamente cuando se requiere. 
Esto significa que la información puede ser accedida sin consumir los recursos necesarios para recuperar los datos, lo cual es especialmente beneficioso para consultas grandes con muchos JOIN y filtros. 
Sin embargo, debido a la forma en que se almacenan, los datos en una vista materializada no se actualizarán a menos que se actualice manualmente, por lo que la información podría quedar desactualizada.

Este tipo de view es útil cuando se tienen tablas con una gran cantidad de operaciones, como JOIN, agregaciones y filtros, que no necesitan actualizarse con frecuencia. 
Un ejemplo de esto sería un informe periódico que captura el estado actual de la base de datos y que no necesita actualizarse en tiempo real.

Algunas alternativas a las vistas materializadas son las vistas regulares y los índices. Las vistas regulares tienen la ventaja de actualizarse constantemente, pero esto puede causar problemas de rendimiento. 
Los índices pueden utilizarse para almacenar columnas específicas en la RAM, los cuales también se actualizan automáticamente, pero tienen un alcance limitado y disminuyen el rendimiento a medida que se utilizan más índices.

Algunos de los sistemas de gestión de bases de datos (DBMS) que soportan materialized views incluyen Oracle, PostgreSQL, Snowflake y BigQuery de Google. 
Aunque MySQL no soporta materialized views de forma nativa, se pueden simular utilizando views regulares y triggers.




*/
    




