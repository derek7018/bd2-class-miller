use sakila;

-- QUERY 1
-- Create two or three queries using address table in sakila db:
--    include postal_code in where (try with in/not it operator)
--    eventually join the table with city/country tables.
--    measure execution time.
--    Then create an index for postal_code on address table.
--    measure execution time again and compare with the previous ones.
--    Explain the results

SELECT postal_code AS 'Postal Code' FROM address WHERE postal_code IN (SELECT postal_code FROM address WHERE address_id > 500);
#query1: 0.047 sec / 0.000023 sec

SELECT district AS 'District', GROUP_CONCAT('Address: ', address, ' ', address2, ', Postal Code: ', postal_code SEPARATOR ' // ') AS 'Address & Postal Code' FROM address 
GROUP BY district;
#query2: 0.0041 sec / 0.0014 sec

SELECT CONCAT(a.address, ' ', a.address2) AS 'Address', a.postal_code AS 'Postal Code', CONCAT(ci.city, ', ', co.country) AS 'City & Country' FROM address a 
INNER JOIN city ci USING (city_id) 
INNER JOIN country co USING (country_id)
WHERE a.postal_code NOT IN (SELECT a.postal_code FROM address a 
								INNER JOIN city ci USING (city_id) 
								INNER JOIN country co USING (country_id) 
								WHERE ci.city NOT LIKE 'A%' AND ci.city NOT LIKE 'E%' AND ci.city NOT LIKE 'I%' AND ci.city NOT LIKE 'O%' AND ci.city NOT LIKE 'U%');
#query3: 0.017 sec / 0.000052 sec


DROP INDEX postal_code ON address;



CREATE INDEX postal_code ON address(postal_code);

/*
duracion con indexes:
query1: 0.0031 sec / 0.000065 sec
query2: 0.0035 sec / 0.0013 sec
query3: 0.016 sec / 0.000056 sec
*/

/*
Los índices en MySQL funcionan almacenando físicamente las filas de las tablas indexadas en el disco para recuperar rápidamente la información. Esto lleva a una reducción en el tiempo de ejecución de las consultas, ya que no será necesario escanear toda la tabla al obtener la información.

Aunque es difícil de notar, hay una mejora en la velocidad de búsqueda y comparación de las consultas, principalmente en las consultas 1 y 3, donde se utiliza postal_code para filtrar y comparar. 
Dado que estas consultas son bastante simples, las diferencias en la duración pueden ser pequeñas. Sin embargo, en solicitudes de mayor escala, los cambios en la velocidad serán evidentes.


*/




#QUERY2: Run queries using actor table, searching for first and last name columns independently. Explain the differences and why is that happening?
SELECT first_name FROM actor WHERE first_name LIKE 'A%';
SELECT last_name FROM actor WHERE last_name LIKE 'A%';

#Esto es debido a que last_name tiene un index entonces va a sacar esa columna de los datos que estan almacenados y no de la consulta que tardaria mas.

-- QUERY 3
-- Compare results finding text in the description on table film with LIKE and in the film_text using MATCH ... AGAINST. Explain the results.

select * from film where description like "%Stunning%";#0.0068
select * from film_text where match (title, description) against("%Stunning%");

/*
#Hay que hacer esto porque sakila tiene el fullText como title unido al description y si no pones los 2 da error porque description no tiene un fulltext solo y va a ser mas rapido porque el fulltext tiene un index para que se almacene 
#Entonces esto hace que lo saque directamente de ahi ya que es un texto largo.
*/