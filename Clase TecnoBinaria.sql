--Crear base de datos
create database Ventas1
on 
primary(
 name = ventas1primary,
 filename = 'c:\db ventas sql\ventas1primary.mdf',
 size = 50MB,
 Maxsize = 200,
 filegrowth = 20),

filegroup ventas1FG(
 name = ventas1Data1,
 filename = 'c:\db ventas sql\ventas1primary.ndf',
 size = 200MB,
 Maxsize = 800,
 filegrowth = 100)

Log on (
 name = ventas1log,
 filename = 'c:\db ventas sql\ventas1primary.ldf',
 size = 300MB,
 Maxsize = 800,
 filegrowth = 100)

 drop database Ventas1 --Eliminar la base de datos
 use Ventas1
 --Crear tabla --
 create table producto(
  id int primary key not null,
  nombreProducto nvarchar(50),
  descripcion nvarchar(200))

drop table producto --Borrar tabla--

--Alterar una tabla--
Alter table producto add imagen int not null

--Borrar columna de una tabla--
Alter table producto drop column imagen

--Alterar una columna--
Alter table producto alter column descripcion nvarchar(150)

--Select y vistas--
SELECT nombre, telefono, id FROM dbo.Clientes
SELECT*FROM dbo.producto

SELECT telefono AS [telefonoCliente], id AS [idCliente] --Alias > AS
FROM dbo.Clientes ORDER BY [idCliente] DESC --Ordenar-> Order by, ASC-> ASCENDENTE, DESC-> DESCENDENTE

--Insertar datos a la tabla---
Insert into producto(id, nombreProducto, descripcion, precio) 
values (11, 'producto11', 'efsf', 500)
--Actualizar datos de una tabla--
Update producto set descripcion ='producto nuevo', precio ='10'
where id=1

--Delete->Eliminar datos, borra o formatea los de una tabla pero no reinicia los archivos borrados de una tabla--
Delete from producto where id=11

--Cargar datos de copia csv de una tabla--
Bulk Insert producto from 'c:\csv\productos.csv'
with (firstrow=2,fieldterminator = ';', rowterminator = '\n')

--Top-> elegir la cantidad de registro que se quiere ver
--Percent-> porcentaje de todos los datos
select top(3) percent *from dbo.producto

--Between--
select*from dbo.producto where  (id between 4 and 8)
--Like--
select*from dbo.producto where nombreProducto like '%dv'
--In, es como el or resumido--
select*from dbo.producto where (nombreProducto IN('asd','fdv'))

--	Consultas multiples--
select*from dbo.Clientes where (nombreProducto like '%dv') or  (precio like '10')

--Foreing key-> Llave foranea
create table infocliente (
id_cliente int foreign key (id_cliente)
references dbo.Clientes (id),
direccion nvarchar(50),
cedula int not null)

select*from infocliente
insert into infocliente values (1,'sdcs', 1212)

--Inner join->Unir tablas
SELECT dbo.Clientes.*, dbo.infocliente.*
FROM     dbo.Clientes INNER JOIN dbo.infocliente ON dbo.Clientes.id = dbo.infocliente.id_cliente

--Right join-> busca todos lo datos de la tabla derecha .
--full join-> Mustra informacion de datos tanto de la tabla derecha e izquierda

--AVG->PROMEDIO
SELECT AVG(total) AS PROMEDIO FROM dbo.ventas

--SUM-> SUMA
SELECT SUM(total) AS [Total de ventas] FROM dbo.ventas where (anio='2014') and (mes = '01') or (mes='3')

--Ver primer y ultimo registro--
SELECT top(1) * FROM dbo.ventas
SELECT top(1) * FROM dbo.ventas order by id desc

--Count->	Contar la cantidad de registros
SELECT count(id) as [Cantidad de ventas] FROM dbo.ventas where mes=3

--Diccionario de datos de una base de datos ----
--Un diccionario de datos es un conjunto de metadatos que contiene las caracteristicas lògicas y puntuales de los datos que se van a utilizar
--en el sistema que se programa, incluyendo nombre, descripcion, alias, contenido y organizaciòn.
select 
	d.object_id,
	a.name [table], -- identificara la Tabla
	b.name [column], -- identificara la columna
	c.name [type], -- identificara el Tipo
	CASE-- recibe el tipo de columna
	  --cuando c es   numerico  o   c es     decimal   o  c es      Float   entonces se precisa el numero
		WHEN c.name = 'numeric' OR  c.name = 'decimal' OR c.name = 'float'  THEN b.precision
		ELSE null
	END [Precision], 
--  recibe maximo tama�o de b
	b.max_length, 
	CASE -- recibe si la columna acepta nulos
		WHEN b.is_nullable = 0 THEN 'NO'
		ELSE 'SI'
	END [Permite Nulls],
	CASE -- recibe si la columna es identity (autoincrementable)
		WHEN b.is_identity = 0 THEN 'NO'
		ELSE 'SI'
	END [Es Autonumerico],	
	ep.value [Descripcion],-- recibe la descripcion de la columna(si la hay)
	f.ForeignKey, -- recibe si es llave foranea
	f.ReferenceTableName, -- recibe la referencia de la tabla
	f.ReferenceColumnName -- recibe la referencia de la columna
from sys.tables a   
      --          //    Seleciona y muestra toda la informacion   \\          --
	inner join sys.columns b on a.object_id= b.object_id 
	inner join sys.systypes c on b.system_type_id= c.xtype 
	inner join sys.objects d on a.object_id= d.object_id 
	LEFT JOIN sys.extended_properties ep ON d.object_id = ep.major_id AND b.column_Id = ep.minor_id
	LEFT JOIN (SELECT 
				f.name AS ForeignKey,
				OBJECT_NAME(f.parent_object_id) AS TableName,
				COL_NAME(fc.parent_object_id,fc.parent_column_id) AS ColumnName,
				OBJECT_NAME (f.referenced_object_id) AS ReferenceTableName,
				COL_NAME(fc.referenced_object_id,fc.referenced_column_id) AS ReferenceColumnName
				FROM sys.foreign_keys AS f
				INNER JOIN sys.foreign_key_columns AS fc ON f.OBJECT_ID = fc.constraint_object_id) 	f ON f.TableName =a.name AND f.ColumnName =b.name
WHERE a.name <> 'sysdiagrams' 
ORDER BY a.name,b.column_Id

--Stored Procedures (Procedimientos almacenados) - Parametros de entrada y salida
create procedure sp_consulta @nombre nvarchar(20), @telefono int 
as begin
	select*from Clientes where nombre = @nombre and telefono = @telefono;
	print 'hecho correctamente';

end
--Ejecutar el procedure
exec sp_consulta 'edu', 34432

create procedure SP_VerSalida @num1 float, @num2 float, @resultado float output
as begin
set @resultado = @num1 + @num2;
end
--Ejecutar el procedure
declare @salida float
exec SP_VerSalida 20, 30, @salida output
select @salida


--Identity
create table pruebaIdentity(
id int primary key identity(20,5) not null,
nombre nvarchar(100)
)

insert into pruebaIdentity values('LOZANO')
select*from pruebaIdentity

--Drop y truncate -> Son formas de eliminar archivos de una tablaç
--Truncate -> Formatea y reinicia las tablas
truncate table pruebaIdentity
--Drop->Elimina lo que se le diga, no formatea los archivos, sino borra tanto archivos como tablas
drop table pruebaIdentity
drop database Ventas1

--Mayusculas y minusculas (Upper y Lower)
select upper(nombre) from pruebaIdentity

--Transact-SQL (T-SQL) es una extención al Sql Server
--SQL, que frecuentemente se dice ser un lenguaje de búsquedas estructurado(por sus siglas en inglés), es un lengiaje de cómputo estandarizado,
--desarrollado originalmente por IBM para realizar búsquedas, alterar y definir bases de datos relacionales utilizando sentencias declarativas. 
--T-SQL expande el estándar de SQL para incluir programación procedural, variables locales, varias funciones de soporte para procesamiento de string, procesamiento de fechas, matemáticas, ect, 
--y cambios a las sentencias DELETE Y UPDATE.
-- SQL -> Lenguaje de peticiones DML
--T-SQL = SQL-> Lenguaje de programación.

--T-SQL - VARIABLES
declare @texto nvarchar(20)
set @texto = 'hola mundo'
declare @numero int
set @numero = 35

print 'T-SQL dice: '+ @texto + 'y el numero: '+ convert(nvarchar(20), @numero)

--T-SQL - El lenguaje sql normal combinado con el t-sql
declare @texto nvarchar(20)
--set @texto = 'dd'
declare @edad int

--create table tsql(
--nonbre nvarchar(20),
--edad int
--)

select @texto = nonbre, @edad = edad from tsql where edad = 22

print @texto+ ' '+ convert(nvarchar(15), @edad)

--Estructura de control If (SI)
declare @num1 int
declare @num2 int

set @num1 = 10
set @num2 = 5

if @num1 = @num2 and @num2 <= @num1
print 'Si, coinciden'
else
print 'no es cierto'

--Ciclo While
declare @cont int
set @cont = 0

while (@cont <10)
begin
print 'Hola, soy el número: ' + convert(nvarchar(20),@cont)
set @cont = @cont +1
end

--Case (Switch) | T-SQL
declare @avion nvarchar(59)
declare @estado nvarchar(50)
declare @aviso nvarchar (50)

set @avion ='Condor'
set @estado ='volando'

set @aviso = (case @estado
				when 'volando' then 'avion:' + @avion+ ' esta volando'
				when 'detenido' then 'avión:'+@avion+ ' está detendio'
			end)
print @aviso

--Try catch -> controlar errores | T-SQL
begin try
declare @edad int
set @edad = 'veinte'
print @edad
end try
begin catch
print 'Error al leer numero'
print error_message()
end catch

--Cursor-> Es una estructura que se carga en la memoria ram de lo cual podemos ver 
--por medio de un select fila por fila la información de cada registro que hay en la tabla que se quiere usar
-- con un cursor se puede cambiar la información uno por uno.
declare CursorEjemplo Cursor scroll
for select*from pruebaIdentity

open CursorEjemplo
--fetch next from CursorEjemplo
fetch prior from CursorEjemplo --first, last

close CursorEjemplo
deallocate CursorEjemplo

--Triggers (Disparadores)
create trigger trigger_producto
on	producto
for insert --after insert-> Inserta despues del registro
as
print 'Hubo un cambio en la tabla persona';

insert into producto values(6,'chrisedu','rolo','12');

select*from dbo.producto

--Ejemplo insertar en log(Historial)
create trigger trigger_clientes_insert
on	Clientes
for insert --after insert-> Inserta despues del registro
as
begin
set nocount on; --evita que se muestre que se haya hecho cambios en alguna tabla
insert into log_historial(nombre,fecha, descripcion) select nombre, getdate(), 'Datos insertados'
from inserted
end

insert into Clientes values(3,'chrisedu',122);

--Ejemplo eliminar-Trigger
create trigger tr_cliente_delete
on Clientes instead of delete
as
begin
set nocount on;
insert into dbo.log_historial(nombre, fecha, descripcion)
select nombre, getdate(), 'Registros eliminados'
from deleted
end

delete from Clientes where nombre='chrisedu'
select*from dbo.log_historial

--Exportar registros a XML
select*from Clientes
for Xml raw('Registro'), elements, root('XML')

--Insertar en una tabla el contenido de otra
insert into dbo.Clientes (id, nombre, telefono)
select*from [dbo].infocliente

--Datename (Controlar fecha) -> Permite saber la hora, minuto, segundo dias, mes a consultar
--month"mes", quarter"cuarto", year"año", dayofyear"dia del año", day"dia", week"semana", hour"hora", second"segundo", millisecond"milisegundo"
print datename(month,getdate()) 

--Información de las vistas
create view view_ejemplo as
select nombre, telefono from dbo.Clientes

select * from dbo.view_ejemplo
--sp_help -> Da toda la informacion que hay en la base de datos
--sp_helptext view_ejemplo --Muestra la vista que se escribió(query)
--sp_depends view_ejemplo --Enseña de cuales tablas depende de esta vista se tiene.

--Encriptar información de una vista
create view view_seguridad
with encryption as
select nombre, telefono from dbo.Clientes

sp_helptext view_seguridad

--with Check option -> Si se hace algun cambio con alguna sentencia insert o update o delete solo se va a ser a lo que cumpla la vista.
create view ver_paisesTest as
select*from dbo.Clientes where nombre = 'edu' with check option

select*from ver_paisesTest
update ver_paisesTest set [nombre] = 'Test2'

--Modificar o eliminar una vista
alter view ver_paisesTest as
select*from dbo.Clientes where nombre = 'edu' with check option

--Clausula Group by (Agrupar registros) -> Si algun registro o alguna fila tienen los mismos datos se van a agrupar y se tomará como si fuera uno.
select *from dbo.Clientes
where nombre = 'chrisedu'  group by id, nombre, telefono

--Clausula HAVING (Teniendo en cuenta, necesita del group by)
--Order by (Ordenar registro)
select *from dbo.Clientes
where nombre = 'chrisedu'  group by id, nombre, telefono having telefono=122

--Clausula Exists(Congruencia entre los campos)-> Para averiguar si algún dato de una tabla está dentro de otra.
select nombre from dbo.Clientes as c
where Not EXISTS (select*from dbo.infocliente as ic where c.id = ic.id_cliente)

--DISTINCT-> Sirve para que no se vea ningun duplicado de información o de registro a la hora de hacer la consulta
select distinct nombre from dbo.Clientes

--Pivot y UnPivot -> 
select Año, Mes, Monto from Calendario
pivot(
sum Monto)
for Mes in (Enero, Febrero, Marzo, Abril, Mayo, Junio, Julio, Agosto, Septiembre, Octubre, Noviembre, Diciembre)
) as PVT

--Columna calculable con condicional CASE
alter table dbo.Clientes
add DigitoTelefono as
case
when Telefono >300 then 'Es mayor el numero de digitos'
else 'Es menor el digito'
end

select*from dbo.Clientes

--Crear job-> Tarea programada o automatizada a realizar en el servidor.




