

create type TipoCalle as 
    enum ('Calle','Avenida','Partida');
   
create type RolVendedor as 
    enum ('telefonico','distribuidor','puerta');
   
create type ZonaComercial as 
    enum ('Levante','Sur','Centro','Norte');
   
create type Direccion as (
	tipo TipoCalle,
	calle varchar,
	numero int
);

create table Empleado(
	idEmpleado serial primary key,
	nombre varchar,
	direccion Direccion,
	telefonos text[],
	idJefe int references Empleado(idEmpleado)
);

create table Vendedor(
	comision float,
	rol RolVendedor
) inherits(Empleado);


create table Comercial(
	retribucion float,
	zona ZonaComercial
) inherits(Empleado);



insert into empleado(nombre,direccion,telefonos,idjefe) values('Pedro Garcia Lopez',('Calle','Hispanidad',34),array[123456789,222333444],null); 
insert into empleado(nombre,direccion,telefonos,idjefe) values('Ana Belen Lopez',('Avenida','Peris y Valero',334),array[555666777],1);

insert into vendedor (nombre,direccion,telefonos,idjefe,comision,rol) values('Luis Gomez',('Partida','Les eres',10),null,2,500,'puerta');
insert into vendedor (nombre,direccion,telefonos,idjefe,comision,rol) values('Ana Fra',('Calle','Epsilon',25),array[123456789,222333444,888999777],2,500,'telefonico');
insert into vendedor (nombre,direccion,telefonos,idjefe,comision,rol) values('Joan Llopis',('Calle','Newton',130),null,2,500,'distribuidor');

insert into comercial (nombre,direccion,telefonos,idjefe,retribucion,zona) values('Silvia Climent',('Calle','Newton',132),null,1,500,'Centro');
insert into comercial (nombre,direccion,telefonos,idjefe,retribucion,zona) values('Ainara Perry',('Partida','Camino de la playa',130),null,2,500,'Sur');
insert into comercial (nombre,direccion,telefonos,idjefe,retribucion,zona) values('Leila Gabaldon',('Avenida','Cobol',40),array[777777777],4,650,'Levante');
insert into comercial (nombre,direccion,telefonos,idjefe,retribucion,zona) values('Marina Camarena',('Avenida','Goliat',23),array[134253463],4,400,'Levante');

select * from empleado e ;
select * from comercial;
select * from vendedor;
