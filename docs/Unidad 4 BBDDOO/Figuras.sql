
drop type if exists Punto;

create  type Punto as (
	x integer,
	y integer 
);

drop table if exists Cuadrado;
drop table if exists Circulo;
drop table if exists Linea;
drop table if exists Cuadrado;

drop table if exists Figura;

create table Figura (
	fID serial primary key, -- identificador
	posicion Punto,			-- posición que ocupa
	color TEXT []			-- color de la figura, varios para degradados
);


create table Rectangulo(
	alto int,
	ancho int 
) inherits (Figura);


create table Cuadrado(
	lado int
) inherits (Figura);


create table Circulo(
	radio int
) inherits (Figura);


-- 
-- no funciona
-- insert into Figura(posicion,color) values (new Punto(2,3),array['#AABBCC','#FFCC00']);


insert into Figura(posicion,color) values (row(2,3),array['#AABBCC','#FFCC00']);
insert into Figura(posicion,color) values (row(0,0),array['FFFFFF','#00CC00']);
insert into Figura(posicion,color) values (row(-2,7),array['#AABB00','#FFCCCC']);

insert into Cuadrado(posicion,color,lado) values (row(10,5),array['#00BBCC','#CCCC00'],20);
insert into Cuadrado(posicion,color,lado) values (row(10,10),array['#00BBCC','#BBCC00'],40);
insert into Cuadrado(posicion,color,lado) values (row(10,15),array['#AA6633','#CCFF00'],27);

insert into Circulo(posicion,color,radio) values (row(30,25),array['#BBCC','#CCCC00'],20);
insert into Circulo(posicion,color,radio) values (row(10,-10),array['#00BBCC','#CCCC00'],20);

insert into Rectangulo(posicion,color,alto,ancho) values (row(10,5),array['#00BBCC','#CCCC00'],20,50);
insert into Rectangulo(posicion,color,alto,ancho) values (row(30,-10),array['#00BBCC','#CCCC00'],20,50);
insert into Rectangulo(posicion,color,alto,ancho) values (row(-10,15),array['#00BBCC','#CCCC00'],20,50);
insert into Rectangulo(posicion,color,alto,ancho) values (row(15,5),array['#00BBCC','#CCCC00'],20,50);

drop table if exists Dibujo;
create table Dibujo(
	idDibujo serial primary key,
	elementos int[]
);


insert into Dibujo (elementos) values(ARRAY[2,4,5,6]); 
insert into Dibujo (elementos) values(array(select fid from figura)); 


select * from dibujo;

select iddibujo,unnest(elementos) from dibujo ; 

