--Crear base de datos
create database Prueba
--Borrar base de datos
drop database Prueba
--Ver la base de datos que se crearon
select*from sys.databases;
--Editar el nombre de la base de datos
alter database Prueba modify name = PruebaEditado

--Tipos de datos
-- char -> Almacenar datos de ancho fijo, especialmente alfanumerico.
-- varchar -> Almacena datos alfanumericos de ancho variable, los espacios que sobren los deja disponible.
-- tex -> Almacena datos texto.
-- nchar -> almacena datos de ancho fijo.
--nvarchar -> Almacena datos alfanumericos e ancho variable, los espacios que sobren los elimina
-- bit -> Almacena valores 1 y 0.
-- int -> Almacena valores entre -2,147,483,648 y 2,147,483,647.
-- bigint-> almacena valores entre -9,223,372,036,854,775,808 y 9,223,372,036,854,775,807.
--decimal -> Almacena valores entre -1^38+1 al 10^30-1.
--numeric --> Almacena valores entre -1^38+1 al 10^30-1, permite aumentar de valores enteros a decimal.
--money --> Almacena valores entre -9,223,036,854,775,808 y 9,223,372,036,854,775,807, se usa con base de datos donde se trabajara con mucha información fianciera.
-- float --> Almacena valores entre -1.79E al 1.79E + 308.

--Crear tabla
create table Empleados(
idEmpleado int primary key,
nombre varchar(20),
apellido varchar(20),
edad numeric(2),
telefono numeric(10),
direccion varchar(100),
fecha_nacimiento date,
salario decimal(18,2),
activo char(2)
)

create table salarios(
nombre varchar(20),
apellido varchar(30),
salario decimal(18,2)
)

--null -> Vacio, no existe ningun valor
--Primary key (pk)-> Insertar registros unicos de una tabla, no permite insertar null, solo permite un unico pk, facilita el enlace entre tablas
create table Personas(
--idPersona int primary key,
idPersona int,
--primary key(idPersona),
--Crear regla (Constraint)
constraint PK_enlace_persona primary key(idPersona),
nombre varchar(10) not null,
edad int not null
)
--Borrar llave primaruia
alter table Personas drop constraint PK_enlace

--Unique -> Es una regla que se asegura que todos los valores en una columna de una tabla son diferentes, no permite valores repetidos pero si permite valores de tipo null.
create table Categorias(
--idCateogrias int  not null unique,
idCategoria int  not null,
nombre varchar(10) not null,
descrpcion varchar(10) not null,
--constraint UQ_IDCATEGORIA unique(idCategoria)
)
--Alterar tabla poniendo el unique al id.
alter table Categorias add constraint UQ_idCategorias unique (idCategoria)
--Borrar el unique
alter table Categorias drop constraint UQ_idCategorias

--Check-> Es usado para limitar el rango de valores que se puede permitir como registro dentro de una columna, solo permite los valores según la regla especificada.
create table Logo(
idLogo int  not null,
nombre varchar(10) not null,
imagen int,

--check(imagen>=18)
constraint CK_imagen check (imagen>=18)
)
--alter table Logo add check (edad>=8)
--BORRAR CHECK
alter table	Logo drop constraint CK_imagen

--DEFAULT->UTILIZADA PARA ESTABLECER VALOR POR DEFECTO EN UNA COLUMNA.
create table Logo2(
idLogo int  not null,
--nombre varchar(10) default 'No tiene',
nombre varchar(10),
imagen int,
)
insert into Logo2 values(1,default, 30)
--ALTERAR TABLA AGREGAR DEFAULT
alter table Logo2 add constraint DF_CIUDAD DEFAULT 'NO TIENE' FOR nombre
--BORRAR DEFAULT
alter table	Logo2 drop constraint DF_CIUDAD

--IDENTITY -> INCREMENTA VALOR AUTOMATICAMENTE A MEDIDA QUE VA RECIBIENDO INSERTS de valores en esa tabla, se utiliza para codigo de identificacion en tablas o generar valores unicos para cada nuevo registro que se inserte en esa tabla, solo puede haber un campo tipo identity por tabla solo uno.
create table libros(
--codigo int  identity, --Administra los valores automatico
codigo int  identity(10,1), --Administra los valores automatico, primer registro empiece desde 10 y aumentar el valor siguiente de 1 en 1
titulo varchar(10) not null,
autor varchar(60) not null
)
insert into libros values('libro1','chris')
insert into libros values('libro2','chris')

--Ver el valor inicial del campo identity en este caso es 10
select ident_seed('libros')
--Ver el rango de incremento de cada valor del identity
select ident_incr('libros')
--Desactivar la regla de un identity en una tabla
set identity_insert libros on --ON o OFF
insert into libros (codigo, titulo, autor) values(15,'libro2','chris')

--FOREIGN KEY(LLAVE FORANEA) -> SE USA PARA PREVENIR DAÑOS EN LAS RELACIONES DE REGISTROS ENTRE TABLAS, REALIZA EL ENLACE CON UNA LLAVE PRIMARIA, evitan el insert de datos no compatibles con el campo de la llave primaria, permite poner null.
create table libros2(
--codigo int  identity, --Administra los valores automatico
codigo int, --Administra los valores automatico, primer registro empiece desde 10 y aumentar el valor siguiente de 1 en 1
titulo varchar(10) not null,
autor varchar(60) not null

constraint PK_LIBROS2 PRIMARY KEY (codigo)
)
create table Ordenes(
--codigo int  identity, --Administra los valores automatico
idOrden int not null, --Administra los valores automatico, primer registro empiece desde 10 y aumentar el valor siguiente de 1 en 1
articulo varchar(10) not null,
codigo int

constraint FK_Ordenes foreign key references libros2(codigo) --Llave de enlace a otra llave primaria.
on delete cascade --Permite borrar registros relacionados entre ambas tablas o cualquier tabla a la que esté enlazada la llave foranea.
)
--Borrar un foreign key
Alter table Ordenes drop constraint FK_Ordenes

--VISTAS (VIEWS)-> ES UNA TABLA VIRTUAL BASADA EN EL RESULTADO DE UNA CONSULTA CONTIENE FILAS Y COLUMNAS IGUAL QUE UNA TABLA REAL PERO LOS CAMPOS DE UNA VISTA PROVIENEN DE UNA SELECCIÓN ESPECIFICA CREADA DESDE UNA CONSULTA HACIA OTRA TABLA, SE PUEDEN AGREGAR INSTRUCCIONES Y FUNCIONES DE SQL TAL COMO SI PROVENIERAN DE UNA SOLA TABLA.
CREATE VIEW Categorias
AS
SELECT*FROM Categorias
--Alterar view
Alter view Categorias
AS
SELECT*FROM Categorias
--Borrar vista
drop view Categorias

--Index -> Se usan para megorar el rendimiento de nuestras consultas. Hay 2 tipos de indices: Clustered y Noclustered(No agrupados)
--Clustered: Definen el orden de los datos.
create clustered index I_idCateogerias
on Categorias(idCategoria)
--Noclustered: No definen dicho orden.
create nonclustered index I_idCateogerias
on Categorias(idCategoria)
--Cambiar el nombre del indice
exec sp_rename 'Categorias. I_idCateogerias', ' I_idCat', 'INDEX'
--Borrar indice
drop index  I_idCat on Categorias

--Renombrar nombre a la tabla
exec sp_rename 'Empleados', 'Usuarios'
--Ver los detalles de la tabla
exec sp_help empleados;

--Insertar registro a la tabla
Insert into Empleados values(1, 'Chrisardo', 'Rolo', 24, 1234567890, 'Calle primero', '1980-06-02', 2000, 'SI');
Insert into Empleados values(2, 'Eduardo', 'Rojas', 24, 1234567890, 'Calle primero', '1980-06-02', 2000, 'SI');
Insert into Empleados values(3, 'Christian', 'Lozano', 24, 1234567890, 'Calle primero', '1980-06-02', 2000, 'SI');
insert into empleados values (1, 'Juan', 'Pérez', 25, 1234567890, 'Calle 123', '1978-06-15', 2500.00, 'SI');
  insert into Empleados values (2, 'María', 'López', 30, 9876543210, 'Avenida 456', '1980-03-20', 3000.00, 'SI');
  insert into Empleados values (3, 'Carlos', 'González', 28, 5555555555, 'Calle 789', '1979-11-10', 2800.00, 'SI');
  insert into Empleados values (4, 'Ana', 'Martínez', 35, 9998887770, 'Avenida 012', '1977-09-05', 3500.00, 'SI');
  insert into Empleados values (5, 'Pedro', 'Sánchez', 22, 1112223334, 'Calle 567', '1980-01-25', 2000.00, 'SI');
  insert into Empleados values (6, 'Laura', 'Ramírez', 31, 4444444444, 'Avenida 890', '1978-07-12', 3200.00, 'SI');
  insert into Empleados values (7, 'Luis', 'Torres', 29, 7777777777, 'Calle 345', '1979-04-18', 2700.00, 'SI');
  insert into Empleados values (8, 'Carmen', 'Hernández', 27, 6666666666, 'Avenida 678', '1980-02-03', 2600.00, 'SI');
  insert into Empleados values (9, 'Jorge', 'García', 33, 2223334445, 'Calle 901', '1977-12-27', 3400.00, 'SI');
  insert into Empleados values (10, 'Silvia', 'Lara', 24, 8889990000, 'Avenida 234', '1980-05-09', 2200.00, 'SI');
  insert into Empleados values (11, 'Roberto', 'Rojas', 26, 3334445556, 'Calle 567', '1979-02-14', 2400.00, 'SI');
  insert into Empleados values (12, 'Patricia', 'Cruz', 32, 2223334444, 'Avenida 890', '1978-08-21', 3100.00, 'SI');
  insert into Empleados values (13, 'Daniel', 'Gómez', 29, 5556667778, 'Calle 123', '1979-06-06', 2800.00, 'SI');
  insert into Empleados values (14, 'Sara', 'Vargas', 34, 6667778889, 'Avenida 456', '1977-04-01', 3300.00, 'SI');
  insert into Empleados values (15, 'Hugo', 'Orozco', 23, 9998887776, 'Calle 789', '1980-03-16', 2100.00, 'SI');


--Consulta a una tabla
select*from Empleados
select nombre, apellido, salario from Empleados
select*from sys.tables

--Borrar tabla
drop table Empleados

--Filtrar con el where
select*from Empleados where nombre = 'Jorge'

--Eliminar registros de la tabla
truncate table Empleados

--Eliminar el campo de registro de la tabla
delete from Empleados where idEmpleado=7

--Alterar tabla
Alter table Empleados add sexo char(1)

--Eliminar columna de la tabla
Alter table Empleados drop column sexo

--Renombrar los nombre de los campos de una tabla
exec sp_rename 'Empleados.idempleado', 'id';

--Actualizar registro de una tabla
update Empleados set telefono = 8033344 where id in(1,3,5)

--Insertar datos desde otra tabla
insert into salarios(nombre, apellido,salario)
select nombre, apellido, salario from Empleados

--Seleccionar cantidad y porcentaje de registro
select top 5 percent *from Empleados

  CREATE TABLE clientes (
  id_cliente INT NOT NULL PRIMARY KEY,
  nombre VARCHAR(20) NOT NULL,
  apellido VARCHAR(20) NOT NULL,
  pais VARCHAR(50) NOT NULL,
  compras INT NULL
);
  
  insert into Clientes values(1, 'Juan', 'Pérez', 'Estados Unidos', 1);
  insert into Clientes values(2, 'María', 'Gómez', 'Argentina', 2);
  insert into Clientes values(3, 'Carlos', 'López', 'Brasil', NULL);
  insert into Clientes values(4, 'Laura', 'Martínez', 'Canadá', 4);
  insert into Clientes values(5, 'Pedro', 'Hernández', 'China', 5);
    insert into Clientes values(6, 'Ana', 'Ruiz', 'Brasil', NULL);

--DISTINCT -> UTILIZADA PARA SELECCIONAR VALORES UNICOS DE UNA COLUMNA O  UN CONJUNTO DE COLUMNAS DENTRO DE UNA CONSULTA ESTO DEVUELVE SOLO LOS VALORES DISTINTOS Y ELIMINA LAS REPETICIONES DE DATOS EN EL RESULTADO.
SELECT DISTINCT pais from clientes

--Alias-> Es un nombre especifico que se le da a un campo al momento de realizar una consulta en una tabla.
SELECT id_cliente as Identificador, nombre as "nombre cliente" from clientes

--CONCATENAR CAMPOS -> Unir  registros
SELECT cast(id_cliente as varchar(2)) + ' ' +nombre+' '+ apellido from clientes

--Operadores matematicos
select nombre, compras+(compras*0.1) as "Nueva compra" from clientes

--ESQUEMAS(INSTANCE) -> ES UNA ESTRUCTURA LÓGICA QUE SE UTILIZA PARA ORGANIZR Y AGRUPAR OBJETOS de la base de datos como tablas, vistas, procedimientos, funciones, etc. Proporciona como una forma de organizar y gestionar mas eficientemente los objetos dentro de la BD, actua como una especie de contenedor logico y permite aislar y controlar los permisos de acceso a esos objetos, cada objeto de la BD DEBE ESTAR DENTRO DE UN ESQUEMA ESPECIFICO.
create schema Ventas
create schema Cobros
create table ventas.clientes(
id_cliente int,
nombre int
)
select*from ventas.clientes

--Restaurar una base de datos .back
/*
1. Click dercho de Databases -> Restore Database -> Device
*/

--Order by-> Organiza consultas por un campo especificos ya sea en valores ascendentes o descentes.
select*from clientes order by compras desc

--Max -> Extraer el valor maximo de un campo.
select max(compras) from clientes
--Min -> Extraer el valor minimo de un campo.
select min(compras) from clientes





