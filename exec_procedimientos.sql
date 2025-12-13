use SpaCanino

-------------------------------------------------
-- EXEC para cada procedimiento
-------------------------------------------------

-- SP RegistrarCliente
declare @Resultado varchar(200);
exec RegistrarCliente
@Nombre='maria',
@Telefono='77440011',
@Direccion='av. Moscu entre 5to y 4to anillo',
@Resultado=@Resultado output;

select @Resultado as Resultado;

go

-- SP RegistrarMascota
declare @Respuesta varchar(200);
exec dbo.RegistrarMascota
@Nombre='joaquin',
@Temperamento='pasivo',
@IdCliente=14,
@Raza='cane corso',
@FechaNac='2025-05-05',
@Resultado=@Respuesta output;

select @Respuesta as Resultado;

go

-- SP RegistrarCita
declare @Resultado varchar(200);
exec dbo.RegistrarCita
    @FechaHora='2025-12-29 16:00:00',  
    @IdMascota=14,                      
    @IdGroomer=1,                      
    @IdRecepcionista=1,               
    @IdServicio=10,                     
    @Estado='Pendiente',              
    @Nota='Ser amables',
    @Resultado=@Resultado output;

select @Resultado as Resultado;

go

-- SP RegistrarFactura
declare @Resultado varchar(200);
exec dbo.RegistrarFactura
    @IdCita=21,            
    @Total=150,
    @Metodo='Efectivo',    
    @Resultado=@Resultado output;

select @Resultado as Resultado;

go

-- SP ActualizarEstadoCita
declare @Resultado varchar(200);
exec dbo.ActualizarEstadoCita
    @IdCita=4,         
    @Estado='Atendida',  
    @Resultado=@Resultado output;

select @Resultado as Resultado;

go

-- SP ListarCitasDeDiaHoy
exec dbo.ListarCitasDeDiaHoy;

go

-- SP VerDetallesDeCita
exec dbo.VerDetallesDeCita
    @IdCita=4;   