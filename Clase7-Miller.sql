use sakila;

-- query 1 - Find the films with less duration, show the title and rating.
select f.title AS 'Título', f.rating AS 'Rating', f.`length` AS 'Duración'
FROM film f
WHERE f.`length` <= ALL (SELECT `length` FROM film);



-- query 2 - Write a query that returns the tiltle of the film which duration is the lowest. If there are more than one film with the lowest durtation, the query returns an empty resultset.
select f.title AS 'Título', f.`length` AS 'Duración'
FROM film f
WHERE f.`length` < ALL (SELECT `length` FROM film);

-- query 3 - Generate a report with list of customers showing the lowest payments done by each of them. Show customer information, the address and the lowest amount, provide both solution using ALL and/or ANY and MIN.\
select c.first_name AS 'Nombre', c.last_name AS 'Apellido', a1.address AS 'Dirección Cliente', a2.address AS 'Dirección Tienda', p.amount AS 'Cantidad', f.title AS 'Película'
FROM customer c
INNER JOIN payment p ON c.customer_id = p.customer_id
INNER JOIN rental r ON p.rental_id = r.rental_id
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN store s ON i.store_id = s.store_id
INNER JOIN address a2 ON s.address_id = a2.address_id
INNER JOIN film f ON i.film_id = f.film_id
INNER JOIN address a1 ON c.address_id = a1.address_id
WHERE p.amount <= ALL (SELECT p2.amount FROM customer c2 INNER JOIN payment p2 ON c2.customer_id = p2.customer_id WHERE c.customer_id = c2.customer_id)
order by c.first_name;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT c.first_name AS 'Nombre', c.last_name AS 'Apellido', a1.address AS 'Dirección Cliente', a2.address AS 'Dirección Tienda', p.amount AS 'Cantidad', f.title AS 'Película'
FROM customer c
INNER JOIN payment p ON c.customer_id = p.customer_id
INNER JOIN rental r ON p.rental_id = r.rental_id
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN store s ON i.store_id = s.store_id
INNER JOIN address a2 ON s.address_id = a2.address_id
INNER JOIN film f ON i.film_id = f.film_id
INNER JOIN address a1 ON c.address_id = a1.address_id
WHERE p.amount = ANY (SELECT MIN(p2.amount) FROM customer c2 INNER JOIN payment p2 ON c2.customer_id = p2.customer_id WHERE c.customer_id = c2.customer_id)
ORDER BY c.first_name;

-- query 4 - Generate a report that shows the customer's information with the highest payment and the lowest payment in the same row.
Select c.first_name as 'nombre',c.last_name as 'apellido', max(p.amount) as 'maximo', min(p.amount) as 'minimo' from customer c
INNER JOIN payment p ON c.customer_id = p.customer_id
group by c.customer_id