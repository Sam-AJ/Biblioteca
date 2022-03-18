-- 1. Crear el modelo en una base de datos llamada biblioteca, considerando las tablas definidas y sus atributos.
create database biblioteca;

create table socio(
	rut varchar primary key,
	nombre varchar not null,
	apellido varchar not null,
	direccion varchar not null,
	telefono varchar not null
);

create table libro(
	isbn varchar primary key,
	titulo varchar not null,
	num_paginas int not null
);

create table autor(
	codigo int primary key,
	nombre varchar not null,
	apellido varchar not null,
	nacimiento varchar not null,
	muerte varchar
);

create table tipo_autor(
	id serial primary key,
	tipo varchar not null
);

create table autor_libro(
	codigo_autor int not null,
	isbn_libro varchar not null,
	tipo_autor_id int not null,
	primary key (codigo_autor, isbn_libro),
	foreign key (codigo_autor) references autor(codigo),
	foreign key (isbn_libro) references libro(isbn),
	foreign key (tipo_autor_id) references tipo_autor(id)
);

create table prestamo(
	id serial primary key,
	rut_socio varchar not null,
	isbn_libro varchar not null,
	fecha_inicio date,
	fecha_real_devolucion date,
	foreign key (rut_socio) references socio(rut),
	foreign key (isbn_libro) references libro(isbn)
);

-- 2. Se deben insertar los registros en las tablas correspondientes.

insert into socio (rut, nombre, apellido, direccion, telefono) values ('1111111-1', 'JUAN', 'SOTO', 'AVENIDA 1, SANTIAGO', 911111111), 
	('2222222-2', 'ANA', 'PÉREZ', 'PASAJE 2, SANTIAGO', 922222222), 
	('3333333-3', 'SANDRA', 'AGUILAR', 'AVENIDA 2, SANTIAGO', 933333333), 
	('4444444-4', 'ESTEBAN', 'JEREZ', 'AVENIDA 3, SANTIAGO', 944444444), 
	('5555555-5', 'SILVANA', 'MUÑOZ', 'PASAJE 3, SANTIAGO', 955555555);

insert into libro (isbn, titulo, num_paginas) values ('111-1111111-111', 'CUENTOS DE TERROR', 344 ),
	('222-2222222-222', 'POESÍAS CONTEMPORANEAS', 167),
	('333-3333333-333', 'HISTORIA DE ASIA', 511),
	('444-4444444-444', 'MANUAL DE MECÁNICA', 298);

insert into autor (codigo, nombre, apellido, nacimiento, muerte) values (1, 'ANDRÉS', 'ULLOA', '1982', null), 
	(2, 'SERGIO', 'MARDONES', '1950', '2012'), 
	(3, 'JOSÉ', 'SALGADO', '1968', '2020'), 
	(4, 'ANA', 'SALGADO', '1972', null), 
	(5, 'MARTÍN', 'PORTA', '1976', null);

insert into tipo_autor (tipo) values ('PRINCIPAL'), ('COAUTOR');

insert into autor_libro (codigo_autor, isbn_libro, tipo_autor_id) values (1, '222-2222222-222', 1),
	(2, '333-3333333-333', 1),
	(3, '111-1111111-111', 1),
	(4, '111-1111111-111', 2),
	(5, '444-4444444-444', 1);

insert into prestamo (rut_socio, isbn_libro, fecha_inicio, fecha_real_devolucion) values ('1111111-1', '111-1111111-111', '2020-01-20', '2020-01-27'),
	('5555555-5', '222-2222222-222', '2020-01-20', '2020-01-30'),
	('3333333-3', '333-3333333-333', '2020-01-22', '2020-01-30'),
	('4444444-4', '444-4444444-444', '2020-01-23', '2020-01-30'),
	('2222222-2', '111-1111111-111', '2020-01-27', '2020-02-04'),
	('1111111-1', '444-4444444-444', '2020-01-31', '2020-02-12'),
	('3333333-3', '222-2222222-222', '2020-01-31', '2020-02-12');

-- 3. Realizar las siguientes consultas:

-- a. Mostrar todos los libros que posean menos de 300 páginas.
select * from libro where num_paginas < 300;

-- b. Mostrar todos los autores que hayan nacido después del 01-01-1970.
select * from autor where nacimiento > '1970';

-- c. ¿Cuál es el libro más solicitado?
select count(p.isbn_libro), l.titulo 
from prestamo p
	inner join libro l on p.isbn_libro = l.isbn
group by l.titulo
order by count(p.isbn_libro) desc, l.titulo;

-- d. Si se cobrara una multa de $100 por cada día de atraso, mostrar cuánto debería pagar cada usuario que entregue el préstamo después de 7 días.
select p.id préstamo, s.nombre, s.apellido, ((p.fecha_real_devolucion - p.fecha_inicio) - 7) dias_de_atraso,(((p.fecha_real_devolucion - p.fecha_inicio) - 7) *100) multa 
from prestamo p
	inner join socio s on p.rut_socio = s.rut 
where (p.fecha_real_devolucion  - p.fecha_inicio) > 7;