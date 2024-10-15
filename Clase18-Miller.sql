use sakila;


-- query 1

drop procedure CopiesofFilms;

DELIMITER //
create procedure CopiesofFilms(titleOrID VARCHAR(50), IN storeID INT, OUT total INT)
begin

select count(i.film_id) as 'copias en tienda' from inventory i
inner join film f using(film_id)
where storeID = i.store_id and (titleOrID = i.film_id or titleOrID = f.title)
group by i.film_id; 




end//
DELIMITER ;

call CopiesofFilms('ACE GOLDFINGER',2,@total);


-- query 2 

drop procedure CustomerByCountry;

DELIMITER //
create procedure CustomerByCountry(IN countrynameorID varchar(100), OUT customerlist text)
	begin

	declare finished integer default 0; 
	declare customerInfo varchar(200) default "";

	declare customer_cursor cursor for
		select group_concat(c.first_name,'',c.last_name,';') from customer c 
		inner join address a using(address_id)
		inner join city ci using(city_id)
		inner join country co using(country_id)
		where countrynameorID = co.country_id or countrynameOrID = co.country;
		
	declare continue handler for not found set finished = 1;

	set customerlist = "";

			
	OPEN customer_cursor;

	get_customer_info: LOOP
		FETCH customer_cursor INTO customerInfo;
		
		IF finished = 1 THEN
			LEAVE get_customer_info;
		END IF;
		
		SET customerList = CONCAT(customerInfo, '; ', customerList);
	END LOOP get_customer_info;

	CLOSE customer_cursor;

end//
DELIMITER ;

call CustomerByCountry('argentina',@customerlist);
select @customerlist;

-- query 3

/*
La función inventory_in_stock está diseñada para verificar si un artículo específico del inventario de la tienda está disponible (en stock).
Funciona de la siguiente manera: se pasa un inventory_id como parámetro. 
El primer paso consiste en verificar si se han realizado alquileres de ese artículo contando las filas en la tabla rental que coinciden con el inventory_id proporcionado. Si no se encuentran alquileres, la función devuelve TRUE, lo que indica que el artículo está en stock. Si existen alquileres, la función procede al siguiente paso.

En este segundo paso, la función verifica si alguna de las filas en la tabla rental para ese artículo tiene un return_date que aún sea NULL.
Cuenta cuántos alquileres no tienen una fecha de devolución (lo que significa que no han sido devueltos). Si el conteo es cero, es decir, si todos los alquileres han sido devueltos, la función devuelve TRUE, ya que el artículo ha vuelto a estar en stock.
Si al menos un return_date sigue siendo NULL, la función devuelve FALSE, lo que significa que el artículo aún está alquilado.

El procedimiento film_in_stock tiene un propósito similar, pero en lugar de verificar un solo artículo, devuelve la cantidad total de copias de una película en particular que están disponibles en una tienda específica. El procedimiento toma dos parámetros de entrada: p_film_id y p_store_id. El procedimiento se lleva a cabo en dos partes: primero, recupera el inventory_id de todos los artículos en la tabla inventory que coinciden con el film_id y el store_id proporcionados y que están disponibles para alquilar. La disponibilidad se verifica usando la función inventory_in_stock explicada anteriormente. 
En segundo lugar, cuenta el número de copias de la película disponibles (aquellas que pasaron la verificación de inventory_in_stock) y almacena el resultado en la variable p_film_count, la cual se devuelve para indicar cuántas copias de la película están disponibles para alquilar en esa tienda.



*/