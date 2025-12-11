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

insert into Cliente (Nombre, Telefono, Direccion)
values ('david', '11335577', 'av. Pirai  entre 3er y 2do anillo'),
       ('luis', '11446677', 'av. Guapay entre 2do y 3er anillo'),
	   ('jose', '11558899', 'av. Mutualista entre 7mo y 8vo anillo'),
	   ('leonel', '22550066', 'av. Radial 27 entre 3er y 4to anillo'), 
	   ('pedro', '00448822', '4to anillo entre radial 21 y av. Busch');

--MASCOTA
insert into Mascota (Nombre, Temperamento, ID_Cliente, Raza, FechaNacimiento)
values ('toby', 'expolsivo', 1, 'pug', '2025-01-01'),
       ('pepe', 'pasivo-agresivo', 2, 'pitbull', '2020-02-01'),
	   ('estrella', 'pasivo', 3, 'pitbull', '2021-05-01'),
	   ('sebastian', 'bravo', 4, 'pug', '2018-03-01'),
	   ('juancho', 'amable', 5, 'dogo', '2015-12-25'),
	   ('tongo', 'expolsivo', 6, 'chihuahua', '2025-01-01'),
	   ('luciano', 'pasivo', 7, 'pitbull', '2022-03-01');

insert into Mascota (Nombre, Temperamento, ID_Cliente, Raza, FechaNacimiento)
values ('romeo', 'calmado', 8, 'san bernardo', '2024-01-01'),
       ('julian', 'agresivo', 9, 'chihuahua', '2023-11-15'),
	   ('felipe', 'nervioso', 10, 'pastor aleman', '2022-09-21'),
	   ('roberto', 'explosivo', 11, 'pug', '2017-10-22'),
	   ('saturno', 'amable', 12, 'rottweiler', '2019-07-13');

--CITA
insert into Cita (FechayHora, ID_Mascota, ID_Groomer, ID_Recepcionista, Estado, Nota)
values ('2025-12-26 14:00:00', 1, 1, 1, 'Confirmada', 'ninguna'),
       ('2025-12-20 16:00:00', 2, 2, 1, 'Confirmada', 'tratar con amor al animalito'),
	   ('2025-12-12 17:00:00', 3, 3, 2, 'Confirmada', 'ninguna'),
       ('2025-12-27 09:00:00', 4, 2, 2, 'Cancelada', 'tener cuidado'),
	   ('2025-12-12 16:00:00', 5, 1, 1, 'Confirmada', 'nada'),
	   ('2025-12-20 10:00:00', 6, 2, 2, 'Atendida', 'ser amable'),
	   ('2025-12-22 09:00:00', 7, 2, 2, 'Confirmada', 'ninguna');

insert into Cita (FechayHora, ID_Mascota, ID_Groomer, ID_Recepcionista, Estado, Nota)
values ('2025-12-11 14:00:00', 8, 3, 1, 'Pendiente', 'ninguna'),
       ('2025-12-19 15:00:00', 9, 1, 2, 'Confirmada', 'tener cuidado'),
	   ('2025-12-21 11:00:00', 10, 2, 1, 'Pendiente', 'ser amable'),
       ('2025-12-23 08:00:00', 11, 3, 2, 'Cancelada', 'cuidarse de sus mordidas'),
	   ('2025-12-26 18:00:00', 12, 1, 1, 'Confirmada', 'nada');

--CITADETALLE
insert into CitaDetalle (ID_Cita, ID_Servicio, CantidadServicios)
values (4, 10, 1),
       (5, 10, 1),
	   (6, 9, 1),
	   (7, 10, 1);

insert into CitaDetalle (ID_Cita, ID_Servicio, CantidadServicios)
values (8, 2, 1),
       (9, 1, 1),
	   (11, 4, 1);

insert into CitaDetalle (ID_Cita, ID_Servicio, CantidadServicios)
values (15, 8, 1),
       (16, 9, 1),
	   (17, 6, 1),
	   (18, 1, 1),
	   (19, 8, 1);


--FACTURA
insert into Factura (ID_Cita, Total, Metodo)
values (4, 150, 'Efectivo'),
       (5, 150, 'QR'),
	   (6, 70, 'QR'), 
	   (7, 200, 'QR');

insert into Factura (ID_Cita, Total, Metodo)
values (8, 120, 'Efectivo'),
       (9, 70, 'QR'),
	   (11, 149, 'Tarjeta');

insert into Factura (ID_Cita, Total, Metodo)
values (15, 180, 'Efectivo'),
       (16, 80, 'Tarjeta'),
	   (17, 180, 'QR'), 
	   (18, 70, 'Tarjeta'),
	   (19, 180, 'Efectivo');
