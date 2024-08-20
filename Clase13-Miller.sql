use sakila;

-- Query 1: 

INSERT INTO customer (store_id, first_name, last_name, email, address_id, create_date) VALUES
(1, 'Derek', 'Miller', 'miller@gmail.com', 
(SELECT MAX(a.address_id) FROM address a 
INNER JOIN city ci USING (city_id) 
INNER JOIN country co USING (country_id)
WHERE co.country = 'United States'), 
NOW());
-- Created ID: 600

-- Query 2: 


INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update) VALUES
(NOW(), 
(SELECT MAX(i.inventory_id) FROM inventory i 
INNER JOIN film f USING (film_id) 
WHERE i.store_id = 2
AND f.title = 'ALASKA PHANTOM'), -- Ingrese el título de la película que quiera rentar
(SELECT customer_id FROM customer c
WHERE first_name = 'Derek' AND last_name = 'Miller' AND email = 'miller@gmail.com'), -- Customer es el que se creó anteriormente
DATE_ADD(NOW(), INTERVAL 1 MONTH), -- Return date es un mes despues de la fecha de renta
(SELECT s.staff_id FROM staff s WHERE s.store_id = 2 ORDER BY RAND() LIMIT 1), -- Seleccióna un staff aleatorio de la store 2
NOW());
-- Created ID: 16050

-- Query 3: 


update film set
release_year = 2001
where rating = 'G';
update film
set release_year= '2002'
where rating='PG';
update film
set release_year= '2003'
where rating='NC-17';
update film
set release_year= '2004'
where rating='PG-13';
update film
set release_year= '2005'
where rating='R';
select * from film order by rating;

-- Query 4: Return a film

UPDATE rental SET 
return_date = NOW()
WHERE rental_id = (SELECT MAX(rental_id) WHERE rental_date = 
(SELECT MAX(rental_date) WHERE return_date IS null));
-- Updated ID: 15966

-- Query 5: 


DELETE FROM film 
WHERE film_id = 100;
/* Response: Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails 
(`sakila`.`film_actor`, CONSTRAINT `fk_film_actor_film` FOREIGN KEY (`film_id`) REFERENCES `film` (`film_id`) ON DELETE RESTRICT ON UPDATE CASCADE) */

-- NUEVO ORDEN: Se pueden borrar las filas de la tabla film_actor y film_category que tienen como film_id 100 o el id de la peli que querramos borrar
DELETE FROM film_actor
WHERE film_id = 100;
DELETE FROM film_category
WHERE film_id = 100;
-- Despues tenemos que borrar inventory, pero para ello debemos borrar todas las rentas que dependen de los inventarios de las películas selecionadas
DELETE FROM rental
WHERE inventory_id IN (SELECT inventory_id FROM inventory WHERE film_id = 100);
DELETE FROM inventory
WHERE film_id = 100;
-- Finalmente, podemos borrar la film
DELETE FROM film 
WHERE film_id = 100;

-- Query 6: Rent a film


SELECT * FROM inventory LEFT JOIN rental USING (inventory_id) WHERE rental_id IS null LIMIT 1;

INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update) VALUES
(NOW(), 5, (SELECT customer_id FROM customer ORDER BY RAND() LIMIT 1), DATE_ADD(NOW(), INTERVAL 1 MONTH),
(SELECT staff_id FROM staff WHERE store_id = (SELECT store_id FROM inventory  WHERE inventory_id = 5) ORDER BY RAND() LIMIT 1), NOW());

INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date, last_update) VALUES
((SELECT customer_id FROM rental WHERE inventory_id = 5), (SELECT staff_id FROM rental WHERE inventory_id = 5), (SELECT rental_id FROM rental WHERE inventory_id = 5),
3.99, DATE_ADD((SELECT rental_date FROM rental WHERE inventory_id = 5), INTERVAL 1 DAY), NOW());

SELECT * FROM rental WHERE inventory_id = 5;
SELECT * FROM payment WHERE rental_id = 16050;