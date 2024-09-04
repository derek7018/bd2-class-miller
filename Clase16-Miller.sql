use sakila;

-- Needs the employee table (defined in the triggers section) created and populated.

CREATE TABLE `employees` (
  `employeeNumber` int(11) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `extension` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `officeCode` varchar(10) NOT NULL,
  `reportsTo` int(11) DEFAULT NULL,
  `jobTitle` varchar(50) NOT NULL,
  PRIMARY KEY (`employeeNUmber`)
);

INSERT INTO `employees`(`employeeNumber`,`lastName`,`firstName`,`extension`,`email`,`officeCode`,`reportsTo`,`jobTitle`) VALUES 
(1002,'Pattinson','Robert','x5800','rpattinson@gmail.com','1',NULL,'CEO'),
(1056,'poppins','Mary','x4611','mpoppins@gmail.com','1',1002,'Ventas'),
(1076,'doe','John','x9273','jdoe@gmail.com','1',1002,'Marketing');

-- QUERY 1
-- Insert a new employee to , but with an null email. Explain what happens.

INSERT INTO `employees`(`employeeNumber`,`lastName`,`firstName`,`extension`,`email`,`officeCode`,`reportsTo`,`jobTitle`) VALUES
(3856,'Peter','Parker','x0486',NULL,'1','1002','Manager');

/*Esta consulta devuelve la siguiente respuesta: Error Code: 1048. Column 'email' cannot be null.
Esto se debe a que, al crear la tabla de empleados, se agregó una restricción NOT NULL al campo de email para evitar que se inserten valores nulos.
Al intentar hacerlo, te da el error mencionado anteriormente y los valores no se insertan.*/


-- QUERY 2


-- Run the first the query
UPDATE employees SET employeeNumber = employeeNumber - 20;
#Al employeeNumber se le resta 20 a todas las filas al numero almacendado en ese campo ejemplo 1056 era el id y si lo ejecutas va a ser 1036

-- What did happen? Explain. Then run this other
UPDATE employees SET employeeNumber = employeeNumber + 20;

-- Explain this case also.
/* al ejectutar la segunda consulta sale este error:  Error Code: 1062. Duplicate entry '1056' for key 'employees.PRIMARY'
Esto se debe a que cada employeeNumber se incrementa en el orden en que fueron declarados, y la segunda instancia de empleado se establece en 1056, un valor que ya existe, antes de que el employeeNumber existente con ese valor sea incrementado. 
Dado que no pueden existir dos valores iguales para la clave primaria, se lanza el error mencionado anteriormente.*/


-- QUERY 3
-- Add a age column to the table employee where and it can only accept values from 16 up to 70 years old.

ALTER TABLE employees ADD COLUMN age INT(3) CHECK (age >= 16 AND age <= 70);


-- QUERY 4
-- Describe the referential integrity between tables film, actor and film_actor in sakila db.
/*
La integridad de referencia entre esas tablas esta dada por la foreign key que conecta la tabla film con cator mediante una tabla intermedia,
la cual guarda las claves primarias de ambas tablas y no permite el borrado de ninguna film o un actor sin antes borrar algun film_actor que contenga a ese a borrar
*/


#5- Create a new column called lastUpdate to table employee and use trigger(s) to keep the date-time updated on inserts and updates operations. 
#Bonus: add a column lastUpdateUser and the respective trigger(s) to specify who was the last MySQL user that changed the row (assume multiple users, other than root, 
#can connect to MySQL and change this table).

ALTER TABLE employees ADD COLUMN lastUpdate DATETIME, ADD COLUMN lastMySqlUser VARCHAR(100);
CREATE TRIGGER before_employees_update BEFORE UPDATE ON employees FOR EACH ROW SET NEW.lastUpdate = NOW(), NEW.lastMySqlUser = USER();



-- QUERY 6
-- Find all the triggers in sakila db related to loading film_text table. What do they do? Explain each of them using its source code for the explanation.


/*
film_text tiene 3 triggers relacionado a cargarlo:

CREATE TRIGGER `ins_film` AFTER INSERT ON `film` FOR EACH ROW BEGIN
    INSERT INTO film_text (film_id, title, description)
        VALUES (new.film_id, new.title, new.description);
  END;;
  
Este trigger crea una inserción en la tabla film_text después de que se crea una película, tomando los valores de la película recién creada para sus campos. 
Esto significa que, después de insertar una película, los valores de film_id, title y description también se usarán para crear una inserción en film_text.
  

CREATE TRIGGER `upd_film` AFTER UPDATE ON `film` FOR EACH ROW BEGIN
    IF (old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)
    THEN
        UPDATE film_text
            SET title=new.title,
                description=new.description,
                film_id=new.film_id
        WHERE film_id=old.film_id;
    END IF;
  END;;
  
Este trigger es muy similar al anterior, excepto que funciona después de que una película se actualiza en lugar de insertarse. 
Si se modifica el title, description o film_id de una película, el correspondiente registro en film_text, cuyo film_id coincidía con la película modificada, también recibirá estas modificaciones.
  

CREATE TRIGGER `del_film` AFTER DELETE ON `film` FOR EACH ROW BEGIN
    DELETE FROM film_text WHERE film_id = old.film_id;
  END;;
  
  
El trigger final sigue una lógica similar a los dos anteriores. Después de que se elimina una película, el registro en film_text que coincide con el film_id de la película también se eliminará.

Estos triggers se crean para generar un registro en film_text siempre que se inserta una película, utilizando sus valores. Siempre que se actualiza o elimina una película, el mismo tratamiento se aplica a su correspondiente registro en film_text.
*/
