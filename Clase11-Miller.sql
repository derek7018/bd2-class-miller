use sakila;

-- Query 4 - Find all the film titles that are not in the inventory.
select f.title, f.film_id from film f 
where not f.film_id in(select film_id from inventory);



-- Query 5 - Find all the films that are in the inventory but were never rented. (Show title and inventory_id. This exercise is complicated.hint: use sub-queries in FROM and in WHERE or use left join and ask if one of the fields is null)
select f.title,i.inventory_id from film f
inner join inventory i using(film_id)
left outer join rental r using(inventory_id)
where r.rental_id = null;

-- Query 6 - Generate a report with: customer (first, last) name, store id, film title, when the film was rented and returned for each of these customers order by store_id, customer last_name
select CONCAT(c.first_name, ' ', c.last_name) AS nombre, s.store_id, f.title
FROM customer c
inner join store s USING (store_id)
inner join rental r USING (customer_id)
inner join inventory y USING (inventory_id)
inner join film f USING (film_id)
where r.return_date IS NOT NULL 
order by s.store_id, c.last_name;

-- Query 7 - Show sales per store (money of rented films) / show store's city, country, manager info and total sales (money) (optional) Use concat to show city and country and manager first and last name
select co.country, ci.city, ma.*, SUM(pa.amount) AS amount
FROM country co
inner join city ci USING (country_id)
inner join address USING (city_id)
inner join store st USING (address_id)
inner join staff ma ON st.manager_staff_id = ma.staff_id
inner join rental USING (staff_id)
inner join payment pa USING (rental_id)
group by st.store_id, co.country_id, ci.city_id;


-- Query 8 - Which actor has appeared in the most films?
select a.actor_id AS 'ID Actor', CONCAT(a.first_name, ' ', a.last_name) AS 'Actor', COUNT(fa.film_id) AS 'Películas Actuadas' FROM actor a
inner join film_actor fa USING (actor_id)
group by a.actor_id
having COUNT(fa.film_id) >= ALL (select COUNT(fa2.film_id) from actor a2 
inner join film_actor fa2 USING (actor_id)
where a2.actor_id <> a.actor_id
group by a2.actor_id);

