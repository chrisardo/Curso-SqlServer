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
idEmpleado int,
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











