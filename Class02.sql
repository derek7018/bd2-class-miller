DROP DATABASE IF exists imdb;
create database if not exists imdb;

use imdb;

create table if not exists Film(
film_id int not null primary key auto_increment,
title varchar(40),
descripcion varchar(60),
realease_year date

)ENGINE=INNODB;


create table if not exists Actor(
actor_id int not null primary key auto_increment,
first_name varchar(40),
last_name varchar(60)

)ENGINE=INNODB;

create table if not exists Film_actor(
film_actor_id int not null primary key auto_increment,
film_id int not null,
actor_id int not null,
foreign key (film_id) references Film(film_id),
foreign key (actor_id) references Actor(actor_id)
)ENGINE=INNODB;