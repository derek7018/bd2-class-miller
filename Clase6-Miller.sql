USE sakila;

-- query 1 - List all the actors that share the last name. Show them in order
SELECT a1.first_name AS 'Nombre', a1.last_name AS 'Apellido' FROM actor a1
WHERE EXISTS 
	(select * 
    from actor a2 
    WHERE a1.last_name = a2.last_name
    and a1.actor_id <> a2.actor_id)
	ORDER BY a1.last_name;
    
-- query 2 - Find actors that don't work in any film
SELECT a.first_name as 'nombre', a.last_name as 'apellido' FROM actor a
where a.actor_id not in(select fi_ac.actor_id from film_actor fi_ac);

-- query 3 - Find customers that rented only one 
select c.first_name as 'nombre',c.last_name 'apellido ',count(r.customer_id) as 'cantidad de compras' from customer c
INNER JOIN rental r ON c.customer_id = r.customer_id
GROUP BY r.customer_id
HAVING COUNT(r.customer_id) = 1;

-- query 4 - Find customers that rented more than one film
select c.first_name as 'nombre',c.last_name 'apellido ',count(r.customer_id) as 'cantidad de compras' from customer c
INNER JOIN rental r ON c.customer_id = r.customer_id
GROUP BY r.customer_id
HAVING COUNT(r.customer_id) >= 2;

-- query 5 - List the actors that acted in 'BETRAYED REAR' or in 'CATCH AMISTAD'
SELECT a.first_name AS 'Nombre', a.last_name AS 'Apellido', a.actor_id AS 'ID'FROM actor a
WHERE a.actor_id IN 
	(SELECT fa.actor_id FROM film_actor fa 
	inner join film f ON fa.film_id = f.film_id 
	WHERE f.title LIKE '%BETRAYED REAR%' OR f.title LIKE '%CATCH AMISTAD%');

-- query 6 - List the actors that acted in 'BETRAYED REAR' but not in 'CATCH AMISTAD'
SELECT a.first_name AS 'nombre', a.last_name AS 'apellido' FROM actor a
WHERE a.actor_id IN 
	(SELECT fa.actor_id FROM film_actor fa 
	INNER JOIN film f ON fa.film_id = f.film_id 
	WHERE f.title LIKE '%BETRAYED REAR%') 
	AND a.actor_id NOT IN 
	(SELECT fa.actor_id FROM film_actor fa 
	INNER JOIN film f ON fa.film_id = f.film_id 
	WHERE f.title LIKE '%CATCH AMISTAD%');

-- query 7 - List the actors that acted in both 'BETRAYED REAR' and 'CATCH AMISTAD'
SELECT a.first_name AS 'nombre', a.last_name AS 'apellido' FROM actor a
WHERE a.actor_id IN 
	(SELECT fa.actor_id FROM film_actor fa 
	INNER JOIN film f ON fa.film_id = f.film_id 
	WHERE f.title LIKE '%BETRAYED REAR%') 
	AND a.actor_id IN 
	(SELECT fa.actor_id FROM film_actor fa 
	INNER JOIN film f ON fa.film_id = f.film_id 
	WHERE f.title LIKE '%CATCH AMISTAD%');

-- query 8 - List all the actors that didn't work in 'BETRAYED REAR' or 'CATCH AMISTAD'
SELECT a.first_name AS 'nombre', a.last_name AS 'apellido' FROM actor a
WHERE a.actor_id NOT IN 
	(SELECT fa.actor_id FROM film_actor fa 
	INNER JOIN film f ON fa.film_id = f.film_id 
	WHERE f.title LIKE '%BETRAYED REAR%') 
	AND a.actor_id NOT IN 
	(SELECT fa.actor_id FROM film_actor fa 
	INNER JOIN film f ON fa.film_id = f.film_id 
	WHERE f.title LIKE '%CATCH AMISTAD%');