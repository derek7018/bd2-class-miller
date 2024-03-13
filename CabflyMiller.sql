drop database if exists cabfly;
create database if not exists cabfly;
use cabfly;

drop table if exists Provincia;
drop table if exists Ciudad;
drop table if exists Avion;
drop table if exists Pasajes;
drop table if exists Aeropuerto;
drop table if exists Asientos;
drop table if exists Estadoasiento;
drop table if exists Reserva;
drop table if exists Vuelo;
drop table if exists Pasajero;


create table Provincia(
id_provincia int not null primary key auto_increment,
nombre varchar(30),
descripcion varchar(30)
)ENGINE=INNODB;

create table Aviones(
id_avion int not null primary key auto_increment,
nombre varchar(30),
descripcion varchar(30)
)ENGINE=INNODB;


create table Ciudad(
id_ciudad int not null primary key auto_increment,
nombre varchar(30),
descripcion varchar(30),
id_provincia int not null,
foreign key (id_provincia) references Provincia(id_provincia)
)ENGINE=INNODB;


create table Aeropuerto(
id_aeropuerto int not null primary key auto_increment,
nombre varchar(30),
descripcion varchar(30),
id_ciudad int not null,
foreign key (id_ciudad) references Ciudad(id_ciudad)
)ENGINE=INNODB;


create table Pasajeros(
id_pasajeros int not null primary key auto_increment,
nombre varchar(30),
descripcion varchar(30),
id_ciudad int not null,
foreign key (id_ciudad) references Ciudad(id_ciudad)
)ENGINE=INNODB;

create table Estadoasiento(
id_estadoasiento int not null primary key auto_increment,
nombre varchar(30),
descripcion varchar(30)
)ENGINE=INNODB;


create table Reserva(
id_reserva int not null primary key auto_increment,
nombre varchar(30),
apellido varchar(30),
dni int not null,
numtelefono int not null,
correo varchar(30),
fecha date,
fechaemision date,
venta varchar(30),
atrjetadeembarque varchar(30)
)ENGINE=INNODB;


create table Asiento(
id_asientos int not null primary key auto_increment,
nombre varchar(30),
descripcion varchar(30),
id_estadoasiento int not null,
foreign key (id_estadoasiento) references Estadoasiento(id_estadoasiento)
)ENGINE=INNODB;


create table Vuelo(
id_vuelo int not null primary key auto_increment,
nombreEmpresa varchar(30),
destino varchar(30),
horasalida datetime,
horallegada datetime,
caract varchar(30),
fecha date,
id_pasajeros int not null,
id_asientos int not null,
foreign key (id_pasajeros) references Pasajeros(id_pasajeros),
foreign key (id_asientos) references Asiento(id_asientos)
)ENGINE=INNODB;


create table Pasajes(
id_pasajes int not null primary key auto_increment,
fecha_hora_conf datetime,
preciovuelo varchar(30),
nrotarjeta int not null,
id_pasajeros int not null,
id_asientos int not null,
id_vuelo int not null,
foreign key (id_vuelo) references Vuelo(id_vuelo),
foreign key (id_pasajeros) references Pasajeros(id_pasajeros),
foreign key (id_asientos) references Asiento(id_asientos)
)ENGINE=INNODB;