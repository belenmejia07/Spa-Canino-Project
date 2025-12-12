use SpaCanino

-------------------------------------------------
-- EXEC para cada procedimiento
-------------------------------------------------

-- SP RegistrarCliente
declare @Respuesta varchar(200);
exec RegistrarCliente
@Nombre='maria',
@Telefono='77440011',
@Direccion='av. Moscu entre 5to y 4to anillo',
@Resultado=@Respuesta output;

select @Respuesta as Resultado;