use SpaCanino
go

alter procedure mascotasMasVisitaron
@FechaInicial DATE,
@FechaFinal DATE
as
begin
select m.Nombre, COUNT(c.ID_Cita) as cantidadVisitas
from Mascota m
inner join Cita c
on m.ID_Mascota=c.ID_Mascota
where c.Estado in ('Atendida') and cast(c.FechayHora as date) > @FechaInicial and cast(c.FechayHora as date)< @FechaFinal
group by m.Nombre
end;

exec dbo.mascotasMasVisitaron '2025-12-01', '2025-12-31'