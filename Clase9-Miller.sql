use sakila;

-- query 1 - Get the amount of cities per country in the database. Sort them by country, country_id.
select co.country_id AS 'Country ID', co.country AS 'Country', COUNT(ci.city_id) AS 'Cantidad de Ciudades' FROM city ci
INNER JOIN country co ON ci.country_id=co.country_id
group by co.country_id;


-- query 2 - Get the amount of cities per country in the database. Show only the countries with more than 10 cities, order from the highest amount of cities to the lowest
SELECT co.country_id AS 'Country ID', co.country AS 'Country', COUNT(ci.city_id) AS 'Cantidad de Ciudades' FROM city ci
INNER JOIN country co ON ci.country_id=co.country_id
group by co.country_id
HAVING COUNT(ci.city_id) > 10
ORDER BY COUNT(ci.city_id) DESC;


-- query 3 - Generate a report with customer (first, last) name, address, total films rented and the total money spent renting films.   o  Show the ones who spent more money first .
select c.first_name AS 'Nombre', c.last_name AS 'Apellido', a.address AS 'Dirección Cliente', COUNT(r.rental_id) AS 'Cantidad Rentas', SUM(p.amount) AS 'Gasto Total'
FROM customer c
INNER JOIN payment p ON c.customer_id = p.customer_id
INNER JOIN rental r ON p.rental_id = r.rental_id
INNER JOIN address a ON c.address_id = a.address_id
group by c.first_name, c.last_name, a.address
order by SUM(p.amount) DESC;


-- query 4 - Which film categories have the larger film duration (comparing average)?   o  Order by average in descending order
select c.`name` AS 'Nombre', AVG(f.`length`) FROM category c
INNER JOIN film_category fc ON c.category_id = fc.category_id
INNER JOIN film f ON fc.film_id = f.film_id
group by c.`name`
order by AVG(f.`length`) DESC;


-- query 5 - Show sales per film rating
select f.rating AS 'Rating', SUM(p.amount) AS 'Gasto Total' FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
INNER JOIN payment p ON r.rental_id = p.rental_id
group by f.rating
order by SUM(p.amount) asc;