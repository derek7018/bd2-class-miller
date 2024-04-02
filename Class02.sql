DROP DATABASE IF exists imdb;
create database if not exists imdb;


use imdb;

drop table if exists Film;
drop table if exists Actor;
drop table if exists Film_actor;

create table if not exists Film(
film_id int not null primary key auto_increment,
title varchar(40),
descript varchar(60),
release_year year

)ENGINE=INNODB;


create table if not exists Actor(
actor_id int not null primary key auto_increment,
first_name varchar(40),
last_name varchar(60)

)ENGINE=INNODB;

create table if not exists Film_actor(
film_id int not null,
actor_id int not null,
primary key(film_id,actor_id) 
)ENGINE=INNODB;

ALTER TABLE Film
  ADD last_update date
	AFTER release_year;
    
ALTER TABLE Actor
  ADD last_update date
	AFTER last_name;

ALTER TABLE Film_actor ADD 
  CONSTRAINT fk_Film_actor_Film
    FOREIGN KEY (film_id)
    REFERENCES Film (film_id);
    
ALTER TABLE Film_actor ADD 
  CONSTRAINT fk_Film_actor_Actor
    FOREIGN KEY (actor_id)
    REFERENCES Actor (actor_id);
    
    
INSERT INTO Film (title, descript, release_year, last_update) VALUES 
('Dune 2','Secuela del increible director Denis Villeneuve','2024','2024-03-24'),
('Drive','Soy ese','2011','2022-02-21'),
('Fight Club','Cual es la primera regla?','1999','2020-05-01'),
('Blade runner 2049','Ryan gosling','2017','2023-06-18');

INSERT INTO Actor (first_name, last_name, last_update) VALUES 
('Timothee','Chalamet','2024-02-15'),
('Ryan','Gosling','2024-09-20'),
('Brad','Pitt','2023-03-16'),
('harrison','Ford','2024-08-16');

INSERT INTO Film_actor (film_id, actor_id) VALUES 
('1','1'),
('2','2'),
('3','3'),
('4','4');


    
    
SELECT title AS 'Titulo', descript AS 'Descripción', release_year AS 'Año de Lanzamiento', last_update AS 'Última Actualización' FROM Film;

SELECT first_name AS 'Nombre', last_name AS 'Apellido', last_update AS 'Última Actualización' FROM Actor;

SELECT Film.title AS 'Titulo', Film.descript AS 'Descripción', Actor.first_name AS 'Nombre Actor', Actor.last_name AS 'Apellido Actor' FROM Film_Actor
INNER JOIN Film ON Film_Actor.film_id=Film.film_id
INNER JOIN Actor ON Film_Actor.actor_id=Actor.actor_id;