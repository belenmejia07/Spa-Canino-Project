use SpaCanino

select *
from Cita

select *
from Cliente

select *
from Factura

select *
from Groomer

select *
from Mascota

select *
from Recepcionista

select *
from Servicio

-- Corrigiendo el  precio de los servicios
update Servicio
set Precio=180
where ID_Servicio=6

update Servicio
set Precio=130
where ID_Servicio=5

-- Actualizando id de los servicios
update Cita
set ID_Servicio=10
where ID_Cita=4

update Cita
set ID_Servicio=8
where ID_Cita=19

-- Actualizando la fecha y hora de la tabla cita
--update Cita
--set FechayHora=

-- Eliminando la constraint de la columna usuario
alter table recepcionista
drop constraint UQ__Recepcio__E3237CF74D5480A0;

-- Eliminando la comlumna usuario y passwordHash de la tabla recepcionista
alter table recepcionista
drop column usuario;

-- Muestra las constraints de la tabla Recepcionista
SELECT name, type_desc
FROM sys.objects
WHERE parent_object_id = OBJECT_ID('Recepcionista');

-- Eliminando la columna passwordHash de la tabla recepcionista
alter table recepcionista
drop column passwordHash;

-- Eliminando la tabla CitaDetalle por no cumplir hasta la tercera forma normal
drop table CitaDetalle;

-- Agregando la columna del id del servicio (Primero lo agregamos con null ya que inicialmente en es columna no hay nada)
alter table cita
add ID_Servicio int null

-- Agregando la llave foranea del id del servicio
ALTER TABLE Cita
ADD CONSTRAINT FK_Cita_Servicio
FOREIGN KEY (ID_Servicio) REFERENCES Servicio(ID_Servicio);

-- Cambiando la llave foranea de null a not null ahora que ya hay datos en esa columna
alter table cita
alter column ID_Servicio int not null;