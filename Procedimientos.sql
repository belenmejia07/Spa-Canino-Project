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
-- y para evitar errores, se implemento return para salir del SP, se añadio SET NOCOUNT ON 
-- para evitar confundir al programa con el mensaje de las filas afectadas
---------------------------------------------------------------------------------------------------
alter PROCEDURE RegistrarCliente
	 @Nombre VARCHAR(50),
    @Telefono VARCHAR(10),
    @Direccion VARCHAR(50) = NULL,
    @Resultado VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NuevoID INT;

    -- Validar teléfono duplicado
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

    SET @Resultado = 'SUCCESS:ID=' + CAST(@NuevoID AS VARCHAR(50));
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
-- se implemento return para salir del SP, se añadio SET NOCOUNT ON 
-- para evitar confundir al programa con el mensaje de las filas afectadas
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

    -- Validar que el cliente exista
    IF NOT EXISTS (SELECT 1 FROM Cliente WHERE id_cliente = @IdCliente)
    BEGIN
        SET @Resultado = 'El cliente no existe.';
        RETURN;
    END

    -- Validar fecha futura
    IF @FechaNac IS NOT NULL AND @FechaNac >= CAST(GETDATE() AS DATE)
    BEGIN
        SET @Resultado = 'La fecha no puede ser futura ni de hoy.';
        RETURN;
    END

    -- Insertar mascota
    INSERT INTO Mascota (Nombre, Temperamento, id_cliente, Raza, FechaNacimiento)
    VALUES (@Nombre, @Temperamento, @IdCliente, @Raza, @FechaNac);

    SET @Resultado = 'OK';
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
-- se implemento return para salir del SP, se añadio SET NOCOUNT ON 
-- para evitar confundir al programa con el mensaje de las filas afectadas, se añadio OUTPUT
-- para devolver un mensaje a quien llame al SP (para el EXEC se debe espicificar OUTPUT al mandar 
-- el parametro, y donde se guardara ese mensaje)
---------------------------------------------------------------------------------------------------
alter PROCEDURE RegistrarCita
    @FechaHora DATETIME,
    @IdMascota INT,
    @IdGroomer INT,
    @IdRecepcionista INT,
    @Estado VARCHAR(20) = 'Pendiente',
    @Nota VARCHAR(200) = NULL,
    @Resultado VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar existencia de mascota
    IF NOT EXISTS (SELECT 1 FROM Mascota WHERE id_mascota = @IdMascota)
    BEGIN
        SET @Resultado = 'La mascota no existe.';
        RETURN;
    END

    -- Validar existencia de groomer
    IF NOT EXISTS (SELECT 1 FROM Groomer WHERE id_groomer = @IdGroomer)
    BEGIN
        SET @Resultado = 'El groomer no existe.';
        RETURN;
    END

    -- Validar existencia de recepcionista
    IF NOT EXISTS (SELECT 1 FROM Recepcionista WHERE id_recepcionista = @IdRecepcionista)
    BEGIN
        SET @Resultado = 'La recepcionista no existe.';
        RETURN;
    END

    -- Validar fecha futura
    IF @FechaHora <= GETDATE()
    BEGIN
        SET @Resultado = 'La fecha debe ser futura.';
        RETURN;
    END

    -- Validar estado
    IF @Estado NOT IN ('Pendiente', 'Confirmada', 'Atendida', 'Cancelada')
    BEGIN
        SET @Resultado = 'Estado de cita no válido.';
        RETURN;
    END

    -- Insertar cita
    INSERT INTO Cita (FechaYHora, Estado, Nota, id_mascota, id_groomer, id_recepcionista)
    VALUES (@FechaHora, @Estado, @Nota, @IdMascota, @IdGroomer, @IdRecepcionista);

    SET @Resultado = 'OK';
END;


	EXEC dbo.RegistrarCita
    go
---------------------------------------------------------------------------------------------------
-- author: Paola Rosenda Quinteros Perez
-- Create Date: 2025-27-11
-- Description: Agrega un servicio del catalogo a una cita, esto crea un registro en la tabla CitaDetalle
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Cambio por: Belen Mejia Medina
-- Fecha de cambio: 2025-07-12
-- Descripcion del cambio: Se cambio el case por el if para un mejor control del procedimiento, 
-- se implemento return para salir del SP, se añadio SET NOCOUNT ON 
-- para evitar confundir al programa con el mensaje de las filas afectadas, se añadio OUTPUT
-- para devolver un mensaje a quien llame al SP (para el EXEC se debe espicificar OUTPUT al mandar 
-- el parametro, y donde se guardara ese mensaje)
---------------------------------------------------------------------------------------------------
create PROCEDURE AgregarServicioaCita
    @IdCita INT,
    @IdServicio INT,
    @Cantidad INT = 1,
    @Resultado VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar existencia de la cita
    IF NOT EXISTS (SELECT 1 FROM Cita WHERE id_cita = @IdCita)
    BEGIN
        SET @Resultado = 'La cita no existe.';
        RETURN;
    END

    -- Validar existencia del servicio
    IF NOT EXISTS (SELECT 1 FROM Servicio WHERE id_servicio = @IdServicio)
    BEGIN
        SET @Resultado = 'El servicio no existe.';
        RETURN;
    END

    -- Validar cantidad
    IF @Cantidad <> 1
    BEGIN
        SET @Resultado = 'Cantidad de servicios permitida es 1.';
        RETURN;
    END

    -- Inserción en citaDetalle
    INSERT INTO CitaDetalle (cantidadServicios, id_cita, id_servicio)
    VALUES (@Cantidad, @IdCita, @IdServicio);

    SET @Resultado = 'OK';
END;


	EXEC dbo.AgregarServicioaCita
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
-- se implemento return para salir del SP, se añadio SET NOCOUNT ON 
-- para evitar confundir al programa con el mensaje de las filas afectadas, se añadio OUTPUT
-- para devolver un mensaje a quien llame al SP (para el EXEC se debe espicificar OUTPUT al mandar 
-- el parametro, y donde se guardara ese mensaje)
---------------------------------------------------------------------------------------------------
alter PROCEDURE RegistrarFactura
    @IdCita INT,
    @Total INT,
    @Metodo VARCHAR(20),
    @Resultado VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar existencia de la cita
    IF NOT EXISTS (SELECT 1 FROM Cita WHERE id_cita = @IdCita)
    BEGIN
        SET @Resultado = 'La cita no existe.';
        RETURN;
    END

    -- Validar que no exista factura previa
    IF EXISTS (SELECT 1 FROM Factura WHERE id_cita = @IdCita)
    BEGIN
        SET @Resultado = 'Ya existe una factura para esta cita.';
        RETURN;
    END

    -- Validar total
    IF @Total <= 0
    BEGIN
        SET @Resultado = 'El total debe ser mayor a 0.';
        RETURN;
    END

    -- Validar método de pago
    IF UPPER(@Metodo) NOT IN ('TARJETA','QR','EFECTIVO')
    BEGIN
        SET @Resultado = 'Método de pago no permitido.';
        RETURN;
    END

    -- Insertar factura
    INSERT INTO Factura (total, metodo, id_cita)
    VALUES (@Total, @Metodo, @IdCita);

    SET @Resultado = 'OK';
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
-- se implemento return para salir del SP, se añadio SET NOCOUNT ON 
-- para evitar confundir al programa con el mensaje de las filas afectadas, se añadio OUTPUT
-- para devolver un mensaje a quien llame al SP (para el EXEC se debe espicificar OUTPUT al mandar 
-- el parametro, y donde se guardara ese mensaje)
---------------------------------------------------------------------------------------------------
alter PROCEDURE ActualizarEstadoCita
    @IdCita INT,
    @Estado VARCHAR(20),
    @Resultado VARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que la cita exista
    IF NOT EXISTS (SELECT 1 FROM Cita WHERE id_cita = @IdCita)
    BEGIN
        SET @Resultado = 'La cita no existe.';
        RETURN;
    END

    -- Validar estado válido
    IF @Estado NOT IN ('Pendiente', 'Confirmada', 'Atendida', 'Cancelada')
    BEGIN
        SET @Resultado = 'Estado no válido.';
        RETURN;
    END

    -- Actualizar estado
    UPDATE Cita
    SET estado = @Estado
    WHERE id_cita = @IdCita;

    SET @Resultado = 'OK';
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
alter PROCEDURE ListarCitasDeDiaHoy
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        c.id_cita,
        c.fechayhora,
        c.estado,
        cl.nombre AS cliente,
        m.nombre AS mascota,
        g.nombre AS groomer
    FROM Cita c
    INNER JOIN Mascota m ON c.id_mascota = m.id_mascota
    INNER JOIN Cliente cl ON m.id_cliente = cl.id_cliente
    INNER JOIN Groomer g ON c.id_groomer = g.id_groomer
    WHERE CONVERT(date, c.fechayhora) = CONVERT(date, GETDATE())
    ORDER BY c.fechayhora;
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
-- se implemento return para salir del SP, se añadio SET NOCOUNT ON 
-- para evitar confundir al programa con el mensaje de las filas afectadas, se cambio
-- COALESCE por ISNULL para que devuelva un tipo de dato especifico y no uno global
---------------------------------------------------------------------------------------------------
alter PROCEDURE VerDetallesDeCita
    @IdCita INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar si existe la cita
    IF NOT EXISTS (SELECT 1 FROM Cita WHERE id_cita = @IdCita)
    BEGIN
        RAISERROR ('ERROR: No existe una cita con ese ID.', 16, 1);
        RETURN;
    END

    -- Retornar datos
    SELECT 
        c.id_cita AS cita_id,
        c.fechayhora AS fecha_hora,
        c.estado AS estado_cita,
        c.nota AS nota_cita,
        cl.nombre AS nombre_cliente,
        m.nombre AS nombre_mascota,
        g.nombre AS nombre_groomer,
        ISNULL(s.nombreservicio, 'Sin servicio') AS nombre_servicio,
        ISNULL(s.precio, 0) AS precio_servicio,
        ISNULL(cd.cantidadservicios, 0) AS cantidad_servicio
    FROM Cita c
    INNER JOIN Mascota m ON c.id_mascota = m.id_mascota
    INNER JOIN Cliente cl ON m.id_cliente = cl.id_cliente
    INNER JOIN Groomer g ON c.id_groomer = g.id_groomer
    LEFT JOIN CitaDetalle cd ON c.id_cita = cd.id_cita
    LEFT JOIN Servicio s ON cd.id_servicio = s.id_servicio
    WHERE c.id_cita = @IdCita;
END;

	EXEC dbo.VerDetallesDeCita