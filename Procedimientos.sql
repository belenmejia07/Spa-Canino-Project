USE SpaCanino;
---------------------------------------------------------------------------------------------------
-- author: Paola Rosenda Quinteros Perez
-- Create Date: 2025-27-11
-- Description: Inserta un nuevo cliente con validacion de telefono unico
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Cambio por: Belen Mejia Medina
-- Fecha de cambio: 2025-07-12
-- Descripcion del cambio: Se cambio el case por el if para un mejor control del procedimiento
-- y para evitar errores, se implemento return para salir del SP inmediatamente y no llegue a insert into,
-- se añadio SET NOCOUNT ON para evitar confundir al programa con el mensaje de las filas afectadas
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Cambio por: Belen Mejia Medina
-- Fecha de cambio: 2025-11-12
-- Descripcion del cambio: Se anadio BEGIN TRY y BEGIN END y todo lo que este entre ambos se ejecutara 
-- con normalidad pero cuando surge un problema se saltara al bloque BEGIN CATCH y END CATCH, se anadio
-- la variable @NuevoID para retornar el id generado y poder mostrarlo en el message box de la interfaz,
-- se anadio una nueva variable @Resultdo OUTPUT para retornar un mensaje al ejecutar el SP, se anadio
-- SCOPE_IDENTITY() para devolver el ultimo id generado por la tabla y guardarlo en @NuevoID 
-- y asi retornarlo en el mensaje de salida, ERROR_MESSAGE() devuelve el mensaje de error que genera
-- SQL Server. 
---------------------------------------------------------------------------------------------------

ALTER PROCEDURE RegistrarCliente
    @Nombre VARCHAR(50),
    @Telefono VARCHAR(10),
    @Direccion VARCHAR(50) = NULL,
    @Resultado VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NuevoID INT;

    BEGIN TRY
        -- Verificar si existe el teléfono
        IF EXISTS (SELECT 1 FROM Cliente WHERE Telefono = @Telefono)
        BEGIN
            SET @Resultado = 'ERROR: Ya existe un cliente con este teléfono.';
            RETURN;
        END

        -- Insertar cliente
        INSERT INTO Cliente (Nombre, Telefono, Direccion, FechaRegistro)
        VALUES (@Nombre, @Telefono, @Direccion, CAST(GETDATE() AS DATE));

        -- Obtener ID recién insertado
        SET @NuevoID = SCOPE_IDENTITY();

        -- Retornar resultado con el ID
        SET @Resultado = 'SUCCESS:ID=' + CAST(@NuevoID AS VARCHAR(50));
    END TRY
    BEGIN CATCH
        -- Captura de errores
        SET @Resultado = 'ERROR: ' + ERROR_MESSAGE();
    END CATCH
END;

	
	EXEC dbo.RegistrarCliente 
    go
---------------------------------------------------------------------------------------------------
-- author: Paola Rosenda Quinteros Perez
-- Create Date: 2025-27-11
-- Description: Inserta una mascota asociada a un cliente y valida la fecha de nacimiento
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Cambio por: Belen Mejia Medina
-- Fecha de cambio: 2025-07-12
-- Descripcion del cambio: Se cambio el case por el if para un mejor control del procedimiento, 
-- se implemento return para salir del SP inmediata, se añadio SET NOCOUNT ON 
-- para evitar confundir al programa con el mensaje de las filas afectadas
--------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Cambio por: Belen Mejia Medina
-- Fecha de cambio: 2025-11-12
-- Descripcion del cambio: Las variables @Raza y @FechaNac en caso de que no se digite nada en esos campos
-- se aignara un valor NULL, se anadio BEGIN TRY y END TRY y dentro de ese campo todo se desarrolla con normalidad,
-- si surge un error se salta al bloque BEGIN CATCH y END CATCH, se anadio la variable @Resultado OUTPUT
-- en donde se se retornara el mensaje resultante del SP, se declara una varible interna llamada @NuevoID 
-- en donde se guardara el nuevo id generado por la tabla, SCOPE_IDENTITY() devuelve el ultimo id 
-- generado por la tabla, en la variable @Resultado se retorna y guarda el nuevo id previamente 
-- convertido a varchar, ERROR_MESSAGE() devuelve el mensaje de error que genera SQL Server
---------------------------------------------------------------------------------------------------

alter PROCEDURE RegistrarMascota
    @Nombre VARCHAR(50),
    @Temperamento VARCHAR(50),
    @IdCliente INT,
    @Raza VARCHAR(50) = NULL,
    @FechaNac DATE = NULL,
    @Resultado VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NuevoID INT;

    BEGIN TRY
        -- Verificar que exista el cliente
        IF NOT EXISTS (SELECT 1 FROM Cliente WHERE Id_Cliente = @IdCliente)
        BEGIN
            SET @Resultado = 'ERROR: El cliente no existe.';
            RETURN;
        END

        -- Verificar fecha de nacimiento válida
        IF @FechaNac IS NOT NULL AND @FechaNac >= CAST(GETDATE() AS DATE)
        BEGIN
            SET @Resultado = 'ERROR: La fecha de nacimiento no puede ser futura ni de hoy.';
            RETURN;
        END

        -- Insertar mascota
        INSERT INTO Mascota (Nombre, Temperamento, Id_Cliente, Raza, FechaNacimiento)
        VALUES (@Nombre, @Temperamento, @IdCliente, @Raza, @FechaNac);

        -- Obtener ID recién insertado
        SET @NuevoID = SCOPE_IDENTITY();

        -- Retornar resultado
        SET @Resultado = 'OK ID=' + CAST(@NuevoID AS VARCHAR(50));
    END TRY
    BEGIN CATCH
        SET @Resultado = 'ERROR: ' + ERROR_MESSAGE();
    END CATCH
END;


	EXEC dbo.RegistrarMascota
    go
---------------------------------------------------------------------------------------------------
-- author: Paola Rosenda Quinteros Perez
-- Create Date: 2025-27-11
-- Description: Registra una cita para la mascota con un groomer y el recepcionista, tambien valida la fecha futura y estado.
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Cambio por: Belen Mejia Medina
-- Fecha de cambio: 2025-07-12
-- Descripcion del cambio: Se cambio el case por el if para un mejor control del procedimiento, 
-- se implemento return para salir del SP inmediatamente y para que no se haga el INSERT INTO,
-- se añadio SET NOCOUNT ON para evitar confundir al programa con el mensaje de las filas afectadas,
-- se añadio OUTPUT para devolver un mensaje a quien llame al SP (para el EXEC se debe espicificar 
-- OUTPUT al mandar el parametro, y donde se guardara ese mensaje)
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Cambio por: Belen Mejia Medina
-- Fecha de cambio: 2025-11-12
-- Descripcion del cambio: Se anadio BEGIN TRY y END TRY en donde todo se desarrolla con normalidad,
-- si surge un problema se pasa directamente a la seccion de BEGIN CATCH y END CATCH, tambien se anadio 
-- un nuevo parametro de entrada en el SP, el parametro es el id del servicio que la cita quiere, 
-- esto hizo innecesario al SP AgregarServicioACita por lo que se lo borro, a la varible @Estado 
-- se le dio el valor de Pendiente en caso de que no se digite nada en ese campo, la variable @Nota 
-- sera null en caso de que no se digite nada en ese campo,en la variable @Resultado se guardara 
-- y devolvera el resultado del SP, se declaran dos variables internas @NuevoID y @CitaConflicto, 
-- con GETDATE() ser verifica que la fecha ingresada no sea pasada, se verifica que el @Estado ingresado 
-- no sea Cancelada o Atendida, se verifica que el id del servicio este entre 1 y 10, se verifica 
-- por medio de @CitaConflicto que no haya una cita ya registrada en esa fecha, en esa hora, 
-- con ese groomer y que @Estado de esa cita no sea Pendiente o Confirmada, en @NuevoID se guarda 
-- el nuevo id generado por la tabla gracias a SCOPE_IDENTITY() que retorna el ultimo id generado, 
-- ERROR_MESSAGE() devuelve el error devuelto por SQL Server .
---------------------------------------------------------------------------------------------------

alter PROCEDURE RegistrarCita
    @FechaHora DATETIME,
    @IdMascota INT,
    @IdGroomer INT,
    @IdRecepcionista INT,
    @IdServicio INT,
    @Estado VARCHAR(15) = 'Pendiente',
    @Nota VARCHAR(200) = NULL,
    @Resultado VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NuevoID INT;
    DECLARE @CitaConflicto INT;

    BEGIN TRY
        -- Validaciones básicas
        IF NOT EXISTS (SELECT 1 FROM Mascota WHERE Id_Mascota = @IdMascota)
        BEGIN
            SET @Resultado = 'ERROR: La mascota no existe.';
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM Groomer WHERE Id_Groomer = @IdGroomer)
        BEGIN
            SET @Resultado = 'ERROR: El groomer no existe.';
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM Recepcionista WHERE Id_Recepcionista = @IdRecepcionista)
        BEGIN
            SET @Resultado = 'ERROR: La recepcionista no existe.';
            RETURN;
        END

        IF @FechaHora <= GETDATE()
        BEGIN
            SET @Resultado = 'ERROR: La fecha debe ser futura.';
            RETURN;
        END

        -- Solo permitir Pendiente o Confirmada
        IF @Estado NOT IN ('Pendiente','Confirmada')
        BEGIN
            SET @Resultado = 'ERROR: No se puede registrar una cita con estado Atendida o Cancelada.';
            RETURN;
        END

        -- Validar ID de servicio
        IF @IdServicio NOT BETWEEN 1 AND 10
        BEGIN
            SET @Resultado = 'ERROR: ID del servicio no válido.';
            RETURN;
        END

        -- Validación de cita solapada: mismo groomer y misma fecha/hora
        SELECT TOP 1 @CitaConflicto = Id_Cita
        FROM Cita
        WHERE Id_Groomer = @IdGroomer
          AND FechaYHora = @FechaHora
          AND Estado IN ('Pendiente', 'Confirmada');

        IF @CitaConflicto IS NOT NULL
        BEGIN
            SET @Resultado = 'ERROR: Ya existe una cita pendiente o confirmada para este groomer a esa hora.';
            RETURN;
        END

        -- Insertar la cita
        INSERT INTO Cita (FechaYHora, Estado, Nota, Id_Mascota, Id_Groomer, Id_Recepcionista, Id_Servicio)
        VALUES (@FechaHora, @Estado, @Nota, @IdMascota, @IdGroomer, @IdRecepcionista, @IdServicio);

        SET @NuevoID = SCOPE_IDENTITY();

        -- Devolver resultado con ID
        SET @Resultado = 'OK ID=' + CAST(@NuevoID AS VARCHAR(50));

    END TRY
    BEGIN CATCH
        SET @Resultado = 'ERROR: ' + ERROR_MESSAGE();
    END CATCH
END;


	EXEC dbo.RegistrarCita
    go

---------------------------------------------------------------------------------------------------
-- author: Paola Rosenda Quinteros Perez
-- Create Date: 2025-27-11
-- Description: Registra una factura asociada a una cita unicamente si esta existe, no tenga factura previa y que el total no sea 0.
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Cambio por: Belen Mejia Medina
-- Fecha de cambio: 2025-07-12
-- Descripcion del cambio: Se cambio el case por el if para un mejor control del procedimiento, 
-- se implemento return para salir del SP, se añadio SET NOCOUNT ON para evitar confundir al programa 
-- con el mensaje de las filas afectadas, se añadio OUTPUT para devolver un mensaje a quien llame al SP
-- (para el EXEC se debe espicificar OUTPUT al mandar el parametro, y donde se guardara ese mensaje)
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Cambio por: Belen Mejia Medina
-- Fecha de cambio: 2025-11-12
-- Descripcion del cambio: Se anadio BEGIN TRY y END TRY  en donde todo se desarrolla con normalidad,
-- pero si surge un error se saltara a la seccion de BEGIN CATCH y END CATCH en donde se retorna 
-- el mensaje de error gracias a ERROR_MESSAGE() que devuelve el mensaje de error que retorna SQL Server.
---------------------------------------------------------------------------------------------------

alter PROCEDURE RegistrarFactura
    @IdCita INT,
    @Total INT,
    @Metodo VARCHAR(20),
    @Resultado VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validar que exista la cita
        IF NOT EXISTS (SELECT 1 FROM Cita WHERE Id_Cita = @IdCita)
        BEGIN
            SET @Resultado = 'ERROR: La cita no existe.';
            RETURN;
        END

        -- Validar que no exista factura para esa cita
        IF EXISTS (SELECT 1 FROM Factura WHERE Id_Cita = @IdCita)
        BEGIN
            SET @Resultado = 'ERROR: Ya existe una factura para esta cita.';
            RETURN;
        END

        -- Validar total
        IF @Total <= 0
        BEGIN
            SET @Resultado = 'ERROR: El total debe ser mayor a 0.';
            RETURN;
        END

        -- Validar método de pago
        IF UPPER(@Metodo) NOT IN ('TARJETA','QR','EFECTIVO')
        BEGIN
            SET @Resultado = 'ERROR: Método de pago no permitido.';
            RETURN;
        END

        -- Insertar factura
        INSERT INTO Factura (Total, Metodo, Id_Cita)
        VALUES (@Total, @Metodo, @IdCita);

        SET @Resultado = 'OK';

    END TRY
    BEGIN CATCH
        SET @Resultado = 'ERROR: ' + ERROR_MESSAGE();
    END CATCH
END;


	EXEC dbo.RegistrarFactura
go

---------------------------------------------------------------------------------------------------
-- author: 
-- Create Date: 2025-05-12
-- Description: Actualiza el estado de una cita existente
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Cambio por: Belen Mejia Medina
-- Fecha de cambio: 2025-07-12
-- Descripcion del cambio: Se cambio el case por el if para un mejor control del procedimiento, 
-- se implemento return para salir del SP, se añadio SET NOCOUNT ON para evitar confundir al programa 
-- con el mensaje de las filas afectadas, se añadio OUTPUT para devolver un mensaje a quien llame al SP 
-- (para el EXEC se debe espicificar OUTPUT al mandar el parametro, y donde se guardara ese mensaje)
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Cambio por: Belen Mejia Medina
-- Fecha de cambio: 2025-11-12
-- Descripcion del cambio: Se anadio BEGIN TRY y BEGIN END en donde todo se desarrolla con normalidad,
-- y si hay error se pasara directamente a la seccion BEGIN CATCH y END CATCH, ERROR_MESSAGE() devuelve
-- el mensaje de error que genero SQL Server.
---------------------------------------------------------------------------------------------------

alter PROCEDURE ActualizarEstadoCita
    @IdCita INT,
    @Estado VARCHAR(15),
    @Resultado VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validar que exista la cita
        IF NOT EXISTS (SELECT 1 FROM Cita WHERE Id_Cita = @IdCita)
        BEGIN
            SET @Resultado = 'ERROR: La cita no existe.';
            RETURN;
        END

        -- Validar estado permitido
        IF @Estado NOT IN ('Pendiente','Confirmada','Atendida','Cancelada')
        BEGIN
            SET @Resultado = 'ERROR: Estado no válido.';
            RETURN;
        END

        -- Actualizar estado de la cita
        UPDATE Cita
        SET Estado = @Estado
        WHERE Id_Cita = @IdCita;

        SET @Resultado = 'OK';

    END TRY
    BEGIN CATCH
        SET @Resultado = 'ERROR: ' + ERROR_MESSAGE();
    END CATCH
END;


	EXEC dbo.ActualizarEstadoCita
go
---------------------------------------------------------------------------------------------------
-- author: 
-- Create Date: 2025-27-11
-- Description: Muestra las citas programadas para el dia actual, muestra cita, fecha, estado, cliente, mascota, y groomer.
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Cambio por: Belen Mejia Medina
-- Fecha de cambio: 2025-07-12
-- Descripcion del cambio: Se añadio SET NOCOUNT ON para no confundir con el mensaje de cuantas filas
-- fueron alteradas al que llame al SP
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Cambio por: Belen Mejia Medina
-- Fecha de cambio: 2025-11-12
-- Descripcion del cambio: Se elimino el INNER JOIN con la tabla CitaDetalle, ya que tal tabla fue eliminada.
---------------------------------------------------------------------------------------------------

alter PROCEDURE ListarCitasDeDiaHoy
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        c.Id_Cita AS id_cita,
        c.FechaYHora AS fechahora,
        c.Estado AS estado,
        cl.Nombre AS cliente,
        m.Nombre AS mascota,
        g.Nombre AS groomer
    FROM Cita c
    INNER JOIN Mascota m ON c.Id_Mascota = m.Id_Mascota
    INNER JOIN Cliente cl ON m.Id_Cliente = cl.Id_Cliente
    INNER JOIN Groomer g ON c.Id_Groomer = g.Id_Groomer
    WHERE CAST(c.FechaYHora AS DATE) = CAST(GETDATE() AS DATE)
    ORDER BY c.FechaYHora;
END;

	EXEC dbo.ListarCitasDeDiaHoy
    go
---------------------------------------------------------------------------------------------------
-- author: Paola
-- Create Date: 202est5-27-11
-- Description: Muestra la información completa de una cita específica
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Cambio por: Belen Mejia Medina
-- Fecha de cambio: 2025-07-12
-- Descripcion del cambio: Se cambio el case por el if para un mejor control del procedimiento,
-- se implemento return para salir del SP, se añadio SET NOCOUNT ON para evitar confundir al programa 
-- con el mensaje de las filas afectadas, se cambio COALESCE por ISNULL para que devuelva un tipo de dato
-- especifico y no uno global.
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Cambio por: Belen Mejia Medina
-- Fecha de cambio: 2025-07-12
-- Descripcion del cambio: Se anadio un LEFT JOIN porque queremos saber todos los id de los servicios
-- de la cita.
---------------------------------------------------------------------------------------------------

ALTER PROCEDURE VerDetallesDeCita
    @IdCita INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar si existe la cita
    IF NOT EXISTS (SELECT 1 FROM Cita WHERE Id_Cita = @IdCita)
    BEGIN
        RAISERROR ('ERROR: No existe una cita con ID %d.', 16, 1, @IdCita);
        RETURN;
    END

    -- Retornar datos de la cita
    SELECT 
        c.Id_Cita AS cita_id,
        c.FechaYHora AS fecha_hora,
        c.Estado AS estado_cita,
        c.Nota AS nota_cita,
        cl.Nombre AS nombre_cliente,
        m.Nombre AS nombre_mascota,
        g.Nombre AS nombre_groomer,
        ISNULL(s.NombreServicio, 'Sin servicio') AS nombre_servicio,
        ISNULL(s.Precio, 0) AS precio_servicio
    FROM Cita c
    INNER JOIN Mascota m ON c.Id_Mascota = m.Id_Mascota
    INNER JOIN Cliente cl ON m.Id_Cliente = cl.Id_Cliente
    INNER JOIN Groomer g ON c.Id_Groomer = g.Id_Groomer
    LEFT JOIN Servicio s ON c.Id_Servicio = s.Id_Servicio
    WHERE c.Id_Cita = @IdCita;
END;


	EXEC dbo.VerDetallesDeCita