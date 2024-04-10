USE sakila;

-- query 1 - Show title and special_features of films that are PG-13
select title as 'titulo', special_features , rating FROM film f
WHERE rating = 'PG-13';

-- query 2 - Get a list of all the different films duration.???
Select title as 'titulo', length FROM film f;

-- query 3 - Show title, rental_rate and replacement_cost of films that have replacement_cost from 20.00 up to 24.00
select f.title as 'titulo', f.rental_rate , f.replacement_cost FROM film f
where replacement_cost between '20.00' AND '24.00';

-- query 4 - Show title, category and rating of films that have 'Behind the Scenes' as special_features
select f.title as 'titulo', c.name as 'categoria', f.rating, f.special_features FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
where f.special_features = 'Behind the Scenes';

-- query 5 - Show first name and last name of actors that acted in 'ZOOLANDER FICTION'
select a.first_name as 'nombre', a.last_name as 'apellido' From actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
INNER JOIN film f ON fa.film_id = f.film_id 
where f.title = 'ZOOLANDER FICTION';

-- query 6 - Show the address, city and country of the store with id 1
select s.store_id, a.address as 'direccion', ci.city as 'ciudad', co.country as 'pais' FROM store s
INNER JOIN address a ON s.address_id = a.address_id
INNER JOIN city ci ON a.city_id = ci.city_id
INNER JOIN country co ON ci.country_id = co.country_id
where s.store_id = 1;

-- query 7 - Show pair of film titles and rating of films that have the same rating.
select f1.title as 'titulo 1 ', f2.title as 'titulo 2', f1.rating FROM film f1,film f2
WHERE f1.rating = f2.rating 
AND f1.film_id > f2.film_id;

-- query 8 - Get all the films that are available in store id 2 and the manager first/last name of this store (the manager will appear in all the rows).
Select f.title as 'titulo',stf.first_name as 'nombre manager',stf.last_name as 'apellido manager' from film f
INNER JOIN inventory i ON f.film_id = i.film_id
INNEr JOIn store s ON i.store_id = s.store_id
INNER JOIN staff stf ON s.manager_staff_id = stf.staff_id
WHERE s.store_id = 2;


