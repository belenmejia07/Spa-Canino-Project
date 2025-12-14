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

insert into Cliente (Nombre, Telefono, Direccion)
values ('pablo', '00552244', 'av. Paragua entre 2do y 3er anillo');

insert into Cliente (Nombre, Telefono, Direccion)
values ('maria', '77440011', 'av. Moscu entre 5to y 4to anillo');

insert into Cliente (Nombre, Telefono, Direccion)
values ('juana', '66001133', 'radial 21 entre 4to y 5to anillo'),
       ('felipe', '00119922', 'av. Busch entre 4to y 3er anillo'),
	   ('juliana', '55005599', 'av. La Salle entre 2do y 3er anillo'),
	   ('rene', '01928374', 'calle Bolivar entre Beni y Murillo'),
	   ('marta', '65748392', 'calle Sarah entre Junin y Florida');
	   
insert into Cliente (Nombre, Telefono, Direccion)
values ('ruben', '55110099', 'av. Brasil entre 1er y 2do anillo');

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

insert into Mascota(Nombre, Temperamento, ID_Cliente, Raza, FechaNacimiento)
values ('fiorella', 'calmada', 13, 'doberman', '2020-08-15');

insert into Mascota(Nombre, Temperamento, ID_Cliente, Raza, FechaNacimiento)
values ('joaquin', 'pasivo', 14, 'cane corso', '2025-05-05');

insert into Mascota(Nombre, Temperamento, ID_Cliente, Raza, FechaNacimiento)
values ('flaco', 'calmada', 15, 'bulldog', '2015-09-25'),
       ('rosalia', 'calmada', 16, 'poodle', '2025-05-21'),
       ('rufino', 'calmada', 17, 'boxer', '2016-06-06'),
       ('choco', 'calmada', 18, 'bull terrier', '2022-01-30'),
       ('gordo', 'calmada', 19, 'chihuahua', '2025-11-11');
	   
insert into Mascota(Nombre, Temperamento, ID_Cliente, Raza, FechaNacimiento)
values ('chocolate', 'explosivo', 20, 'pitbull', '2019-09-09');

insert into Mascota(Nombre, Temperamento, ID_Cliente, Raza, FechaNacimiento)
values ('lana', 'explosivo', 19, 'poodle', '2015-01-01'),
       ('rebeca', 'pasiva', 15, 'pitbull', '2020-10-09'),
       ('chiqui', 'calmado', 18, 'desconocida', '2025-11-09'),
	   ('yiyi', 'pasiva', 18, 'desconocida', '2019-11-09');

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

insert into Cita (FechayHora, ID_Mascota, ID_Groomer, ID_Recepcionista, Estado, Nota, ID_Servicio)
values ('2025-12-18 08:00:00', 13, 1, 1, 'Confirmada', 'tener cuidado con sus dientes', 10);

insert into Cita (FechayHora, ID_Mascota, ID_Groomer, ID_Recepcionista, Estado, Nota, ID_Servicio)
values ('2025-12-29 16:00:00', 14, 1, 1, 'Pendiente', 'ser amables', 10);

insert into Cita (FechayHora, ID_Mascota, ID_Groomer, ID_Recepcionista, Estado, Nota, ID_Servicio)
values ('2025-12-27 09:00:00', 18, 2, 2, 'Pendiente', 'ninguna', 5),
       ('2025-12-29 09:00:00', 19, 3, 2, 'Pendiente', 'ninguna', 5),
       ('2025-12-26 18:00:00', 20, 1, 1, 'Cancelada', 'ninguna', 4),
       ('2025-12-19 18:00:00', 21, 1, 1, 'Cancelada', 'ninguna', 10),
       ('2025-12-22 15:00:00', 22, 1, 2, 'Confirmada', 'no tenerle miedo', 1);
	   
insert into Cita (FechayHora, ID_Mascota, ID_Groomer, ID_Recepcionista, Estado, Nota, ID_Servicio)
values ('2025-12-30 14:00:00', 23, 3, 2, 'Pendiente', 'ninguna', 10);

insert into Cita (FechayHora, ID_Mascota, ID_Groomer, ID_Recepcionista, Estado, Nota, ID_Servicio)
values ('2025-12-27 14:00:00', 24, 3, 2, 'Pendiente', 'ninguna', 1),
       ('2025-12-14 08:00:00', 25, 1, 2, 'Pendiente', 'ninguna', 10),
       ('2025-12-21 11:00:00', 26, 2, 2, 'Confirmada', 'tener cuidado', 10),
       ('2025-12-22 08:00:00', 27, 1, 2, 'Pendiente', 'ninguna', 10);

	   
insert into Cita (FechayHora, ID_Mascota, ID_Groomer, ID_Recepcionista, Estado, Nota, ID_Servicio)
values ('2025-12-27 14:00:00', 24, 3, 2, 'Pendiente', 'ninguna', 1),
       ('2025-12-14 09:00:00', 25, 2, 2, 'Pendiente', 'ninguna', 10),
       ('2025-12-21 10:00:00', 25, 3, 1, 'Confirmada', 'ninguna', 10),
       ('2025-12-22 11:00:00', 25, 1, 1, 'Pendiente', 'ninguna', 10);

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

insert into Factura (ID_Cita, Total, Metodo)
values (20, 150, 'Efectivo');

insert into Factura (ID_Cita, Total, Metodo)
values (21, 150, 'Efectivo'),
       (22, 130, 'QR'),
	   (23, 130, 'QR'),
	   (24, 140, 'QR'),
	   (25, 160, 'Tarjeta'),
	   (26, 70, 'Efectivo');
	   
insert into Factura (ID_Cita, Total, Metodo)
values (27, 150, 'Efectivo');

insert into Factura (ID_Cita, Total, Metodo)
values (28, 70, 'Efectivo'),
       (29, 150, 'QR'),
	   (30, 150, 'QR'),
	   (31, 150, 'QR');

	   
insert into Factura (ID_Cita, Total, Metodo)
values (32, 70, 'Efectivo'),
       (33, 150, 'QR'),
	   (34, 150, 'QR'),
	   (35, 150, 'Tarjeta');
