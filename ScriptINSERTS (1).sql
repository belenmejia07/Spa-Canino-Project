use SpaCanino

/*-------------------------------------------------------------
	PROYECTO: Spa Canino
	DESCRIPCION: Agregacion de datos base
-------------------------------------------------------------*/

--RECEPCIONISTAS
INSERT INTO Recepcionista (Nombre, Telefono, Usuario, PasswordHash)
VALUES ('Jose Perez', '70012345', 'jose.perez','pepita123'),
		('Luisa Cespedez', '72134567', 'luisa.cespedez','cepedez2435');

--GROOMERS
INSERT INTO Groomer (Nombre, Telefono, Especialidad)
VALUES ('Gabriel Ortiz', '70098989' , 'Corte creativo y estilismo'),
		('Mari Vega', '78811223', 'Baño y masajes'),
		('Miguel Arnez', '77776665', 'Corte de pelaje largo');    

--SERVICIOS
INSERT INTO Servicio (NombreServicio, Precio, Descripcion, Duracion) 
VALUES ('Baño básico', 70, 'Perro Pequeño: Baño con shampoo neutro, secado y corte incluido.', 45),
		('Baño básico', 120, 'Perro Grande: Baño con shampoo neutro, secado y corte incluido.', 60),
		('Baño medicado', 90, 'Perro Pequeño: Baño con shampoo hipoalergénico o especial para piel sensible. Incluye corte.', 60), 
		('Baño medicado', 140, 'Perro Grande: Baño con shampoo hipoalergénico o especial para piel sensible. Incluye corte.', 90), 
		('Baño antipulgas', 180, 'Perro Pequeño: Baño con productos antiparasitarios especializados. Incluye corte.', 50),
		('Baño antipulgas', 130, 'Perro Grande: Baño con productos antiparasitarios especializados. Incluye corte.', 70),
		('Baño + Deslanado y cepillado profundo', 100, 'Perro Pequeño: Eliminación de nudos, pelo muerto y exceso de pelaje. Incluye corte.', 60),
		('Baño + Deslanado y cepillado profundo', 180, 'Perro Grande: Eliminación de nudos, pelo muerto y exceso de pelaje. Incluye corte.', 110),		
		('Baño + Tratamiento hidratante de pelaje', 80, 'Perro Pequeño: Aplicación de mascarilla hidratante para mejorar brillo y textura del pelaje. Incluye corte.', 45),
		('Baño + Tratamiento hidratante de pelaje', 150, 'Perro Grande: Aplicación de mascarilla hidratante para mejorar brillo y textura del pelaje. Incluye corte.', 60);

--CLIENTE
insert into Cliente (Nombre, Telefono, Direccion)
values ('paola', '12345678', 'zona cumavi'),
       ('adriana', '87654321', '4to anillo'),
	   ('luna', '23456789', 'zona madre india'),
	   ('nicol', '34567890', 'zona la ramada'),
	   ('yaquelin', '09876543', 'zona trompillo'),
	   ('rut', '11223344', '1er anillo'), 
	   ('lucia', '11222345', 'zona los pozos');

--MASCOTA
insert into Mascota (Nombre, Temperamento, ID_Cliente, Raza, FechaNacimiento)
values ('toby', 'expolsivo', 1, 'pug', '2025-01-01'),
       ('pepe', 'pasivo-agresivo', 2, 'pitbull', '2020-02-01'),
	   ('estrella', 'pasivo', 3, 'pitbull', '2021-05-01'),
	   ('sebastian', 'bravo', 4, 'pug', '2018-03-01'),
	   ('juancho', 'amable', 5, 'dogo', '2015-12-25'),
	   ('tongo', 'expolsivo', 6, 'chihuahua', '2025-01-01'),
	   ('luciano', 'pasivo', 7, 'pitbull', '2022-03-01');

--CITA
insert into Cita (FechayHora, ID_Mascota, ID_Groomer, ID_Recepcionista, Estado, Nota)
values ('2025-12-26 14:00:00', 1, 1, 1, 'Confirmada', 'ninguna'),
       ('2025-12-20 16:00:00', 2, 2, 1, 'Confirmada', 'tratar con amor al animalito'),
	   ('2025-12-12 17:00:00', 3, 3, 2, 'Confirmada', 'ninguna'),
       ('2025-12-27 09:00:00', 4, 2, 2, 'Cancelada', 'tener cuidado'),
	   ('2025-12-12 16:00:00', 5, 1, 1, 'Confirmada', 'nada'),
	   ('2025-12-20 10:00:00', 6, 2, 2, 'Atendida', 'ser amable'),
	   ('2025-12-22 09:00:00', 7, 2, 2, 'Confirmada', 'ninguna');

--FACTURA
insert into Factura (ID_Cita, Total, Metodo)
values (4, 150, 'Efectivo'),
       (5, 150, 'QR'),
	   (6, 70, 'QR'), 
	   (7, 200, 'QR');

insert into Factura (ID_Cita, Total, Metodo)
values (8, 150, 'Efectivo'),
       (9, 150, 'QR'),
	   (11, 70, 'QR');

--CITADETALLE
insert into CitaDetalle (ID_Cita, ID_Servicio, CantidadServicios)
values (4, 10, 1),
       (5, 10, 1),
	   (6, 9, 1),
	   (7, 10, 1);

insert into CitaDetalle (ID_Cita, ID_Servicio, CantidadServicios)
values (8, 10, 1),
       (9, 10, 1),
	   (11, 9, 1);

