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