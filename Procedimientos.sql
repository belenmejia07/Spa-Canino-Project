USE SpaCanino
---------------------------------------------------------------------------------------------------
-- author: Paola Rosenda Quinteros Perez
-- Create Date: 2025-27-11
-- Description: Inserta un nuevo cliente con validacion de telefono unico
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Cambio por: Belen Mejia Medina
-- Fecha de cambio: 2025-06-12
-- Descripcion del cambio: Se cambio el case por el if para un mejor control del procedimiento
-- y para evitar errores
---------------------------------------------------------------------------------------------------
create PROCEDURE RegistrarCliente
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
GO
	
	EXEC dbo.RegistrarCliente
---------------------------------------------------------------------------------------------------
-- author: Paola Rosenda Quinteros Perez
-- Create Date: 2025-27-11
-- Description: Inserta una mascota asociada a un cliente y valida la fecha de nacimiento
---------------------------------------------------------------------------------------------------

CREATE PROCEDURE RegistrarMascota
	@Nombre Varchar(50),
	@Raza Varchar(50) = NULL,
	@FechaNacimiento Date = NULL,
	@Temperamento Varchar(50),
	@ID_Cliente INT
	AS
	BEGIN

	SELECT 
	CASE WHEN NOT EXISTS(SELECT 1 FROM Cliente WHERE ID_Cliente = @ID_Cliente) THEN 'El cliente no existe.'
		 WHEN @FechaNacimiento IS NOT NULL AND @FechaNacimiento >= CAST(GETDATE() AS DATE) THEN 'La fecha no puede ser futura ni de hoy.'
		 ELSE 'OK'
		 END AS Validacion
	
	INSERT INTO Mascota (Nombre, Raza, FechaNacimiento, Temperamento, ID_Cliente)
    SELECT @Nombre, @Raza, @FechaNacimiento, @Temperamento, @ID_Cliente
    WHERE EXISTS (SELECT 1 FROM Cliente WHERE ID_Cliente = @ID_Cliente) AND (@FechaNacimiento IS NULL OR @FechaNacimiento < CAST(GETDATE() AS DATE));

	END

	EXEC dbo.RegistrarMascota
---------------------------------------------------------------------------------------------------
-- author: Paola Rosenda Quinteros Perez
-- Create Date: 2025-27-11
-- Description: Registra una cita para la mascota con un groomer y el recepcionista, tambien valida la fecha futura y estado.
---------------------------------------------------------------------------------------------------
CREATE PROCEDURE RegistrarCita
	@FechaHora        DATETIME,
    @ID_Mascota       INT,
    @ID_Groomer       INT,
    @ID_Recepcionista INT,
    @Estado           VARCHAR(15) = 'Pendiente',
    @Nota             VARCHAR(200) = NULL
	AS
	BEGIN

    SELECT
	CASE WHEN NOT EXISTS (SELECT 1 FROM Mascota WHERE ID_Mascota = @ID_Mascota) THEN 'La mascota no existe.'
            WHEN NOT EXISTS (SELECT 1 FROM Groomer WHERE ID_Groomer = @ID_Groomer) THEN 'El groomer no existe.'
            WHEN NOT EXISTS (SELECT 1 FROM Recepcionista WHERE ID_Recepcionista = @ID_Recepcionista) THEN 'La recepcionista no existe.'
            WHEN @FechaHora <= GETDATE() THEN 'La fecha y hora de la cita debe ser futura.'
            WHEN @Estado NOT IN ('Pendiente','Confirmada','Atendida','Cancelada') THEN 'Estado de cita no valido.'
            ELSE 'OK'
	END AS Validacion;

    INSERT INTO Cita (FechayHora, Estado, Nota, ID_Mascota, ID_Groomer, ID_Recepcionista)
    SELECT @FechaHora, @Estado, @Nota, @ID_Mascota, @ID_Groomer, @ID_Recepcionista
    WHERE EXISTS (SELECT 1 FROM Mascota WHERE ID_Mascota = @ID_Mascota)
			AND EXISTS (SELECT 1 FROM Groomer WHERE ID_Groomer = @ID_Groomer)
			AND EXISTS (SELECT 1 FROM Recepcionista WHERE ID_Recepcionista = @ID_Recepcionista)
			AND @FechaHora > GETDATE()
			AND @Estado IN ('Pendiente','Confirmada','Atendida','Cancelada');

	END

	EXEC dbo.RegistrarCita
---------------------------------------------------------------------------------------------------
-- author: Paola Rosenda Quinteros Perez
-- Create Date: 2025-27-11
-- Description: Agrega un servicio del catalogo a una cita, esto crea un registro en la tabla CitaDetalle
---------------------------------------------------------------------------------------------------
ALTER PROCEDURE AgregarServicioaCita
    @ID_Cita           INT,
    @ID_Servicio       INT,
    @CantidadServicios INT = 1
	AS
	BEGIN

    SELECT
    CASE WHEN NOT EXISTS (SELECT 1 FROM Cita WHERE ID_Cita = @ID_Cita) THEN 'La cita no existe.'
         WHEN NOT EXISTS (SELECT 1 FROM Servicio WHERE ID_Servicio = @ID_Servicio) THEN 'El servicio no existe.'
         WHEN @CantidadServicios <> 1 THEN 'Cantidad de servicios permitida es 1.'
            ELSE 'OK'
        END AS Validacion;

    INSERT INTO CitaDetalle (CantidadServicios, ID_Cita, ID_Servicio)
    SELECT @CantidadServicios, @ID_Cita, @ID_Servicio
    WHERE EXISTS (SELECT 1 FROM Cita WHERE ID_Cita = @ID_Cita) 
			AND EXISTS (SELECT 1 FROM Servicio WHERE ID_Servicio = @ID_Servicio)
			AND @CantidadServicios = 1;

	END

	EXEC dbo.AgregarServicioaCita
---------------------------------------------------------------------------------------------------
-- author: Paola Rosenda Quinteros Perez
-- Create Date: 2025-27-11
-- Description: Registra una factura asociada a una cita unicamente si esta existe, no tenga factura previa y que el total no sea 0.
---------------------------------------------------------------------------------------------------
CREATE PROCEDURE RegistrarFactura
    @ID_Cita INT,
    @Total   INT,
    @Metodo  VARCHAR(10)
	AS
	BEGIN
    SELECT
    CASE WHEN NOT EXISTS (SELECT 1 FROM Cita WHERE ID_Cita = @ID_Cita) THEN 'La cita indicada no existe.'
         WHEN EXISTS (SELECT 1 FROM Factura WHERE ID_Cita = @ID_Cita) THEN 'Ya existe una factura para esta cita.'
         WHEN @Total <= 0 THEN 'El total debe ser mayor a 0.'
         WHEN UPPER(@Metodo) NOT IN ('TARJETA','QR','EFECTIVO') THEN 'Metodo de pago no permitido.'
         ELSE 'OK'
	END AS Validacion;

    INSERT INTO Factura (Total, Metodo, ID_Cita)
    SELECT @Total, @Metodo, @ID_Cita
    WHERE EXISTS (SELECT 1 FROM Cita WHERE ID_Cita = @ID_Cita)
			AND NOT EXISTS (SELECT 1 FROM Factura WHERE ID_Cita = @ID_Cita)
			AND @Total > 0
			AND UPPER(@Metodo) IN ('TARJETA','QR','EFECTIVO');

END

	EXEC dbo.RegistrarFactura


---------------------------------------------------------------------------------------------------
-- author: 
-- Create Date: 2025-05-12
-- Description: Actualiza el estado de una cita existente
---------------------------------------------------------------------------------------------------
CREATE PROCEDURE ActualizarEstadoCita
	@ID_Cita INT,
	@NuevoEstado Varchar (15)
	AS
	BEGIN
	
	SELECT
    CASE WHEN NOT EXISTS (SELECT 1 FROM Cita WHERE ID_Cita = @ID_Cita) THEN 'La cita no existe.'
		 WHEN @NuevoEstado NOT IN ('Pendiente','Confirmada','Atendida','Cancelada') THEN 'Estado no valido.'
         ELSE 'OK'
	END AS Validacion;


    UPDATE Cita
    SET Estado = @NuevoEstado
    WHERE ID_Cita = @ID_Cita AND @NuevoEstado IN ('Pendiente','Confirmada','Atendida','Cancelada')
							 AND EXISTS (SELECT 1 FROM Cita WHERE ID_Cita = @ID_Cita);

END

	EXEC dbo.ActualizarEstadoCita
---------------------------------------------------------------------------------------------------
-- author: 
-- Create Date: 2025-27-11
-- Description: Muestra las citas programadas para el dia actual, muestra cita, fecha, estado, cliente, mascota, y groomer.
---------------------------------------------------------------------------------------------------
CREATE PROCEDURE ListarCitasDeDiaHoy
	AS
	BEGIN

	SELECT C.ID_Cita, C.FechayHora, C.Estado,
			CL.Nombre AS Cliente,
			M.Nombre AS Mascota,
			G.Nombre AS Groomer
	FROM Cita as C
	INNER JOIN Mascota as M
	ON C.ID_Mascota = M.ID_Mascota
	INNER JOIN Cliente as CL
	ON M.ID_Cliente = CL.ID_Cliente
	INNER JOIN Groomer as G 
	on C.ID_Groomer = G.ID_Groomer
	WHERE CONVERT (DATE, C.FechayHora) = CONVERT(DATE, GETDATE())
	ORDER BY C.FechayHora

END

	EXEC dbo.ListarCitasDeDiaHoy
---------------------------------------------------------------------------------------------------
-- author: Paola
-- Create Date: 202est5-27-11
-- Description: Muestra la información completa de una cita específica
---------------------------------------------------------------------------------------------------
CREATE PROCEDURE VerDetallesDeCita
    @ID_Cita INT
    AS
    BEGIN
    SELECT
    CASE WHEN NOT EXISTS (SELECT 1 FROM Cita WHERE ID_Cita = @ID_Cita) THEN 'La cita no existe.'
    ELSE 'OK'
    END AS Validacion;

    SELECT  c.ID_Cita, c.FechayHora, c.Estado, c.Nota,
			cl.Nombre AS Cliente,
			m.Nombre AS Mascota,
			g.Nombre AS Groomer,
			s.NombreServicio  AS Servicio,
			s.Precio, cd.CantidadServicios
    FROM Cita c
    INNER JOIN Mascota      m  ON c.ID_Mascota = m.ID_Mascota
    INNER JOIN Cliente      cl ON m.ID_Cliente = cl.ID_Cliente
    INNER JOIN Groomer      g  ON c.ID_Groomer = g.ID_Groomer
    INNER JOIN CitaDetalle  cd ON c.ID_Cita    = cd.ID_Cita
    INNER JOIN Servicio     s  ON cd.ID_Servicio = s.ID_Servicio
    WHERE c.ID_Cita = @ID_Cita;

END

	EXEC dbo.VerDetallesDeCita