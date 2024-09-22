CREATE DATABASE agencia_aseguradora;
USE agencia_aseguradora;

CREATE TABLE usuario (
id_usuario INT NOT NULL AUTO_INCREMENT,
nombre_de_usuario VARCHAR(15) NOT NULL,
nombre VARCHAR(20) NOT NULL,
apellido VARCHAR(20) NOT NULL,
PRIMARY KEY (id_usuario));

CREATE TABLE IF NOT EXISTS informacion_personal (
nombre VARCHAR(40) NOT NULL,
apellido VARCHAR(40) NOT NULL,
telefono FLOAT(20) NOT NULL,
email VARCHAR(30) NOT NULL,
dni NUMERIC(20) NOT NULL,
id_usuario INT NOT NULL,
PRIMARY KEY (dni),
CONSTRAINT FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario));

CREATE TABLE  IF NOT EXISTS seguros_vehiculos (
vehiculo VARCHAR(30) NOT NULL,
marca VARCHAR(20) NOT NULL,
modelo VARCHAR(20) NOT NULL,
id_patente FLOAT(10) NOT NULL AUTO_INCREMENT,
id_usuario INT NOT NULL,
PRIMARY KEY (id_patente),
FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario));
ALTER TABLE seguros_vehiculos ADD CONSTRAINT fk_seguros_vehiculos FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario) ON DELETE RESTRICT;

CREATE TABLE IF NOT EXISTS seguros_viviendas (
pais VARCHAR(30) NOT NULL,
localidad VARCHAR(30) NOT NULL,
direccion VARCHAR(30) NOT NULL,
altura NUMERIC(10) NOT NULL,
id_vivienda INT NOT NULL AUTO_INCREMENT,
id_usuario INT,
PRIMARY KEY (id_vivienda),
FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario));
ALTER TABLE seguros_viviendas ADD CONSTRAINT fk_seguros_viviendas FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario) ON DELETE RESTRICT;
ALTER TABLE seguros_viviendas modify localidad VARCHAR(50) NOT NULL;
ALTER TABLE seguros_viviendas modify direccion VARCHAR(50) NOT NULL;

CREATE TABLE IF NOT EXISTS servicios(
id_producto INT AUTO_INCREMENT,
tipo VARCHAR(150) NOT NULL,
precios_servicios INT NOT NULL,
PRIMARY KEY (id_producto));

CREATE TABLE IF NOT EXISTS servicios_contratados(
id_orden INT AUTO_INCREMENT,
fecha DATE NOT NULL,
nombre VARCHAR(30) NOT NULL,
tipo VARCHAR(30) NOT NULL,
id_producto INT,
id_usuario INT,
PRIMARY KEY(id_orden),
CONSTRAINT FOREIGN KEY (id_producto) REFERENCES servicios(id_producto),
CONSTRAINT FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

DROP TABLE IF EXISTS clientes;
CREATE TABLE clientes
(
id_orden INT AUTO_INCREMENT,
fecha DATE NOT NULL,
nombre VARCHAR(30) NOT NULL,
tipo VARCHAR(30) NOT NULL,
PRIMARY KEY(id_orden)
);

DROP TABLE IF EXISTS up_pedido;
CREATE TABLE up_pedido (
id_orden INT AUTO_INCREMENT,
fecha DATE NOT NULL,
nombre VARCHAR(30) NOT NULL,
tipo VARCHAR(30) NOT NULL,
PRIMARY KEY(id_orden)
);

INSERT INTO informacion_personal (nombre, apellido, telefono, email, dni, id_usuario)
	VALUES ("Dagny", "Vawton", "943036000", "dvawton0@networksolutions.com", "85022076", "1"),
    ("Maure", "Guilliatt", "36562700", "mguilliatt1@tripod.com", "69539994", "2"),
    ("Maryanna", "Neeves", "840391000", "mneeves2@discuz.net", "63500223", "3"),
    ("Murdoch", "Lexa", "62025400", "mlexa3@diigo.com", "49124895", "4"),
    ("Carline", "Ricioppo", "659266000", "cricioppo4@comcast.net", "85980777", "5"),
    ("Leticia", "Shrubshall", "123471000", "lshrubshall5@1688.com", "9889691", "6"),
    ("Bren", "Luchelli", "171838000", "bluchelli6@opensource.org", "35765741", "7"),
    ("Julie", "Oxteby", "828692000", "joxteby7@gizmodo.com", "29741803", "8"),
    ("Wilton", "Merton", "731660000", "wmerton8@amazon.de", "20611482", "9"),
    ("Fallon", "Fairholme", "679161000", "ffairholme9@addtoany.com", "23333612", "10");

INSERT INTO seguros_vehiculos (vehiculo, marca, modelo, id_patente, id_usuario) 
	VALUES ("Auto", "Alfa Romeo", "Giulietta", "132", "1"),
    ("Auto", "ASTON MARTIN", "Rapide", "667", "2"),
    ("Auto", "AUDI", "A8", "409", "3"),
	("Moto", "Benelli", "752S", "001", "4"),
	("Moto", "Ducati", "Hypermotard 698 Mono", "590", "1"),
    ("Moto", "Ducati", "Monster SP", "263", "5");
    
INSERT INTO servicios (id_producto, tipo, precios_servicios)
	VALUES (104,'Autos 2000-2010', 20000),
	(105,'Autos 2011-2020', 30000),
	(106,'Autos 2021-2024', 40000),
	(107,'Motos 2000-2010', 10000),
	(108,'Motos 2011-2020', 24000),
	(109,'Motos 2021-2024', 39000),
	(110,'Viviendas Monoambiente', 100000),
	(111,'Viviendas 4 habitaciones', 150000),
	(112,'Viviendas 4 habitaciones, patio y garage', 350000);
    
CREATE OR REPLACE VIEW servicio_contratado_vw AS
SELECT u.nombre_de_usuario, u.nombre, s.id_producto, s.tipo
FROM usuario AS u JOIN servicios AS s ;

CREATE OR REPLACE VIEW usuarios_dni_vw AS
SELECT nombre, apellido, dni
FROM informacion_personal
WHERE dni >= "44000000";

CREATE OR REPLACE VIEW precios_bajos_vw AS
SELECT tipo, precios_servicios
FROM servicios
WHERE tipo like "%2000-2010%" OR precios_servicios = 100000;

CREATE OR REPLACE VIEW pedidos_2024_vw AS
SELECT id_orden, fecha, nombre, tipo
FROM servicios_contratados
WHERE fecha BETWEEN '2024-01-01' AND '2024-12-31';

CREATE OR REPLACE VIEW ultimos_pedidos_vw AS
SELECT id_orden, fecha, nombre, tipo, id_usuario
FROM servicios_contratados
ORDER BY fecha DESC
LIMIT 8;

DELIMITER $$
CREATE PROCEDURE ordenar_tablas_sp (IN tabla VARCHAR (20), IN campo VARCHAR (20), IN orden VARCHAR (4))
BEGIN
SET @ordenar = CONCAT( 'SELECT * FROM', ' ', tabla, ' ','ORDER BY',' ', campo,' ', orden);
PREPARE consulta FROM @ordenar;
EXECUTE consulta;
DEALLOCATE PREPARE consulta;
END $$
DELIMITER ;

CALL ordenar_tablas_sp ('servicios', 'precios_servicios', 'DESC');
CALL ordenar_tablas_sp ('informacion_personal', 'dni', 'ASC');

DELIMITER $$
CREATE PROCEDURE insertar_nuevo_usuario_sp(
       IN p_nombre_de_usuario VARCHAR(15),
       IN p_nombre VARCHAR(20),
       IN p_apellido VARCHAR(20))
BEGIN
    INSERT INTO usuario (nombre_de_usuario, nombre, apellido)
    VALUES (p_nombre_de_usuario, p_nombre, p_apellido);
END $$
DELIMITER ;

CALL insertar_nuevo_usuario_sp ("CAPITAN", "Nelson", "Baigorria");
CALL insertar_nuevo_usuario_sp ("SubCapitan", "Bota", "Garcia");
CALL insertar_nuevo_usuario_sp ("Teniente", "Gabriel", "Alvarez");

DELIMITER $$
CREATE PROCEDURE servicios_contratados_sp (IN orden INT, IN sp_fecha DATE, IN sp_nombre VARCHAR (30), IN sp_tipo VARCHAR (30), IN producto INT, IN usuario INT)
BEGIN
INSERT INTO servicios_contratados
(id_orden,fecha, nombre, tipo,id_producto, id_usuario)
VALUES
(orden, sp_fecha, sp_nombre, sp_tipo, producto, usuario);
END $$
DELIMITER ;

CALL servicios_contratados_sp (1, '2024-08-15', 'Roombo', "Autos 2000", "104", "1");
CALL servicios_contratados_sp (2, '2023-02-03', 'Capitan', "Autos 2010", "104", "11");
CALL servicios_contratados_sp (3, '2021-05-11', 'SubCapitan', "Motos 2011", "108", "12");
CALL servicios_contratados_sp (4, '2022-10-29', 'Teniente', "Vivienda Monoambiente", "110", "13");
CALL servicios_contratados_sp (5, '2024-11-09', 'InnoZ', "Autos 2022", "106", "2");
CALL servicios_contratados_sp (6, '2020-06-17', 'Voonte', "Motos 2024", "109", "4");
CALL servicios_contratados_sp (7, '2024-01-10', 'Zazio', "Viviendas 4 habitaciones", "104", "6");

DELIMITER $$
CREATE FUNCTION `precio_servicio_venta_final_fn` (monto DECIMAL(11,2), cargo DECIMAL(4,2))
RETURNS DECIMAL (11,2)
NO SQL
BEGIN 
	DECLARE resultado DECIMAL(11,2);
    SET resultado = monto + monto * (cargo/100);
    RETURN resultado;
END$$
DELIMITER ;

SELECT precio_servicio_venta_final_fn(7800, 28.21) AS precio_venta;
SELECT precio_servicio_venta_final_fn(4000, 25.00) AS precio_venta;
SELECT precio_servicio_venta_final_fn(23000, 8.70) AS precio_venta;

DROP function if exists calcular_iva_venta_fn;
DELIMITER $$
CREATE FUNCTION calcular_iva_venta_fn(monto DECIMAL(11,2))
RETURNS DECIMAL(11,2)
NO SQL
BEGIN
	DECLARE resultado DECIMAL(11,2);
    DECLARE impuesto DECIMAL(11,2);
    SET impuesto = 15.00;
    SET resultado = monto * (impuesto / 100);
    RETURN resultado;
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION calcular_total_venta_fn(monto DECIMAL(11,2))
RETURNS DECIMAL (11,2)
NO SQL
BEGIN 
	DECLARE resultado DECIMAL(11,2);
    SET resultado = monto + calcular_iva_venta_fn(monto);
    RETURN resultado;
END$$
DELIMITER ; 

SELECT calcular_total_venta_fn (10000) AS precio_con_iva;
SELECT calcular_total_venta_fn (5000) AS precio_con_iva;
SELECT calcular_total_venta_fn (25000) AS precio_con_iva;

DROP TRIGGER IF EXISTS clientes_nuevos_tr;
CREATE TRIGGER `clientes_nuevos_tr`
AFTER INSERT ON `servicios_contratados`
FOR EACH ROW
INSERT INTO `clientes` (id_orden, fecha, nombre, tipo) VALUES (NEW.id_orden, NEW.fecha, NEW.nombre, NEW.tipo);

INSERT INTO servicios_contratados (fecha, nombre, tipo) VALUES
('2011-11-11', 'Sanchez', "Viviendas Monoambiente"),
('2024-08-15', 'Roombo', "Viviendas 4 habitaciones"),
('2013-04-13', 'Edgeblab', "Motos 2013"),
('2002-09-16', 'Zazio', "Motos 2002"),
('2010-12-26', 'Skidoo', "Autos 2010"),
('2015-01-19', 'Skyndu', "Autos 2015"),
('2020-10-29', 'Jazzy', "Viviendas 4 habitaciones");

DROP TRIGGER IF EXISTS up_pedido_tr;
DELIMITER $$
CREATE TRIGGER `up_pedido_tr`
BEFORE UPDATE ON `servicios_contratados`
	FOR EACH ROW
BEGIN 
	INSERT INTO up_pedido (id_orden, fecha, nombre, tipo) VALUES (OLD.id_orden, OLD.fecha, OLD.nombre, OLD.tipo);
END$$
DELIMITER ;

UPDATE servicios_contratados
SET tipo = "Vivienda Monoambiente"
WHERE id_orden = 2;