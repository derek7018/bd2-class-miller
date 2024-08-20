use sakila;

-- Query 1

SELECT CONCAT(c.first_name, ' ', c.last_name) AS 'Customer', 
CONCAT(a.address, ', ', a.district) AS 'Address', 
CONCAT(ci.city, ', ', co.country) AS 'City' FROM customer c 
INNER JOIN address a USING (address_id)
INNER JOIN city ci USING (city_id) 
INNER JOIN country co USING (country_id)
WHERE co.country = 'Argentina';

-- Query 2

SELECT f.title AS 'Título', l.name AS 'Lenguaje', CASE f.rating 
WHEN 'G' THEN 'G (General Audiences) – All ages admitted.'
WHEN 'PG' THEN 'PG (Parental Guidance Suggested) – Some material may not be suitable for children.'
WHEN 'PG-13' THEN 'PG-13 (Parents Strongly Cautioned) – Some material may be inappropriate for children under 13.'
WHEN 'R' THEN 'R (Restricted) – Under 17 requires accompanying parent or adult guardian.'
WHEN 'NC-17' THEN 'NC-17 (Adults Only) – No one 17 and under admitted.' END AS 'Rating' 
FROM film f INNER JOIN language l USING (language_id);


-- Query 3

SELECT CONCAT(a.first_name, ' ', a.last_name) AS 'Actor', GROUP_CONCAT(' ', f.title, ' ', f.release_year) AS 'Película'
FROM actor a 
INNER JOIN film_actor fa USING (actor_id) 
INNER JOIN film f USING (film_id)
WHERE CONCAT(a.first_name, ' ', a.last_name) LIKE '%%' -- <- Insertar el nombre actor o actriz entre los %
GROUP BY a.actor_id; 

-- Query 4

SELECT f.title AS 'Título', r.rental_date AS 'Fecha de Renta', CONCAT(c.first_name, ' ', c.last_name) AS 'Customer', IF(r.return_date IS NOT NULL, 'Yes', 'No') AS 'Devuelto'
FROM rental r 
INNER JOIN inventory i USING (inventory_id) 
INNER JOIN customer c USING (customer_id) 
INNER JOIN film f USING (film_id)
WHERE MONTH(r.rental_date) BETWEEN 5 AND 6;


-- Query 5
/*
CAST y CONVERT solo tienen una diferencia menor cuando se usan en MySQL, y es su sintaxis:
CAST(expr AS type) // CONVERT(expr, type)
Sin embargo, en SQL Server, esto no es así. Mientras que CAST sigue siendo el mismo, CONVERT tiene una entrada adicional llamada 'style' que permite más opciones de formato.
Otro aspecto importante es que CONVERT se puede usar de 2 maneras. Usar la sintaxis mencionada anteriormente es lo mismo que usar CAST, mientras que usarlo como
CONVERT(expr USING type) convierte el conjunto de caracteres de una cadena.
Al final, CAST y CONVERT deberían ser intercambiables cuando se operan en MySQL, pero esto puede variar en diferentes dialectos de SQL.
Esto significa que CAST es mejor cuando se intenta crear un código portátil, mientras que CONVERT puede aprovechar opciones de personalización más flexibles dependiendo del dialecto.
Aquí hay un ejemplo usando ambos:
*/

SELECT CAST(create_date AS DATE) AS 'Date from CAST' FROM customer; -- Convierte datetime field create_date en una fecha.
SELECT CONVERT(create_date, DATE) AS 'Date from CONVERT' FROM customer; --  lo mismo que usando CAST




-- Query 6

/*
NVL es una función diseñada para verificar si un valor es NULL y reemplazarlo con un valor especificado si lo es. Sin embargo, NO está disponible en MySQL (se utiliza en bases de datos Oracle).
Sintaxis: NVL(campo, valor_de_reemplazo). Ejemplo: NVL(rental_date, '2005-05-24') <- Reemplazaría rental_date con la fecha dada si es NULL.

IFNULL cumple la misma función que NVL, con la diferencia clave de que este SÍ está disponible en MySQL.
Sintaxis: IFNULL(campo, valor_de_reemplazo).

ISNULL es diferente en MySQL que las otras dos. En lugar de reemplazar un valor, devuelve 1 si el valor es NULL, y 0 si no lo es.
Sintaxis: ISNULL(valor).

Finalmente, COALESCE devuelve el primer valor no NULL en una lista de expresiones. Si todos los valores listados son NULL, también devuelve NULL. Esto significa que debes darle una lista de valores en el orden en que deseas que sean verificados.
Sintaxis: COALESCE(valor1, valor2, valor3, valor4, valor5...).

También existe NULLIF, que compara 2 valores y devuelve NULL si son iguales. Si no lo son, devuelve el primer valor.
Sintaxis: NULLIF(valor1, valor2).
*/

SELECT address AS 'Address', IFNULL(address2, 'Esta dirección no posee address 2') FROM address; -- Some address2 are ''
SELECT address AS 'Address', ISNULL(address2) AS 'the return date is NULL?' FROM address;
SELECT COALESCE(address2, address) AS 'Address' FROM address; -- esto devolvera address si address2 es nulo por el orden de la sintaxis
SELECT NULLIF(c.first_name, s.first_name) AS 'Customer name' -- Devuelve customer name si el customer y el staff no tienen el mismo nombre
FROM rental r INNER JOIN customer c USING (customer_id) INNER JOIN staff s USING (staff_id);



