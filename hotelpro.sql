CREATE DATABASE HOTELPRO;

USE HOTELPRO;

DROP DATABASE HOTELPRO

-- ================= HOTEL =================

CREATE TABLE empleado (
	 ID_empleado INT PRIMARY KEY AUTO_INCREMENT,
	 nombre VARCHAR (255) NOT NULL,
	 cargo VARCHAR (255) NOT NULL,
	 telefono VARCHAR(20),
	 correo VARCHAR (255) NOT NULL
);

INSERT INTO empleado (nombre, cargo, telefono, correo) VALUES
('Carlos Ramirez', 'Gerente', '3001234567', 'carlos.ramirez@hotelpro.com'),
('Laura Gomez', 'Recepcionista', '3002345678', 'laura.gomez@hotelpro.com'),
('Andres Martinez', 'Recepcionista', '3003456789', 'andres.martinez@hotelpro.com'),
('Sofia Herrera', 'Atencion al cliente', '3004567890', 'sofia.herrera@hotelpro.com'),
('Juan Perez', 'Mantenimiento', '3005678901', 'juan.perez@hotelpro.com'),
('Maria Lopez', 'Limpieza', '3006789012', 'maria.lopez@hotelpro.com'),
('Pedro Castillo', 'Seguridad', '3007890123', 'pedro.castillo@hotelpro.com'),
('Ana Torres', 'Spa', '3008901234', 'ana.torres@hotelpro.com'),
('Luis Fernandez', 'Restaurante', '3009012345', 'luis.fernandez@hotelpro.com'),
('Diana Rojas', 'Gerente', '3010123456', 'diana.rojas@hotelpro.com');


CREATE TABLE hotel (
	 ID_hotel INT PRIMARY KEY AUTO_INCREMENT,
	 nombre VARCHAR (255) NOT NULL,
	 categoria INT,
	 direccion VARCHAR (255) NOT NULL,
	 telefono VARCHAR(20),
	 correo VARCHAR (255) NOT NULL,
	 anio_inauguracion YEAR,
	 num_habitaciones INT NOT NULL,
	 hora_checkin TIME,
	 hora_checkout TIME
);

ALTER TABLE hotel
ADD ID_gerente INT

ALTER TABLE hotel
ADD FOREIGN KEY (ID_gerente)
REFERENCES empleado (ID_empleado)

INSERT INTO hotel (nombre,categoria,direccion,telefono,correo,anio_inauguracion,num_habitaciones,hora_checkin,hora_checkout,ID_gerente) VALUES
('Hotel 1',5,'Ciudad1','111','h1@mail.com',2010,100,'14:00','12:00',1),
('Hotel 2',4,'Ciudad2','222','h2@mail.com',2011,90,'14:00','12:00',10),
('Hotel 3',3,'Ciudad3','333','h3@mail.com',2012,80,'14:00','12:00',1),
('Hotel 4',5,'Ciudad4','444','h4@mail.com',2013,70,'14:00','12:00',10),
('Hotel 5',4,'Ciudad5','555','h5@mail.com',2014,60,'14:00','12:00',1),
('Hotel 6',3,'Ciudad6','666','h6@mail.com',2015,50,'14:00','12:00',10),
('Hotel 7',5,'Ciudad7','777','h7@mail.com',2016,40,'14:00','12:00',1),
('Hotel 8',4,'Ciudad8','888','h8@mail.com',2017,30,'14:00','12:00',10),
('Hotel 9',3,'Ciudad9','999','h9@mail.com',2018,20,'14:00','12:00',1),
('Hotel 10',5,'Ciudad10','1010','h10@mail.com',2019,10,'14:00','12:00',10);
-- ================= SERVICIO =================

CREATE TABLE servicio (
	 ID_servicio INT PRIMARY KEY AUTO_INCREMENT,
	 nombre VARCHAR (255) NOT NULL,
	 descripcion VARCHAR (255) NOT NULL,
	 hora_inicio TIME,
	 hora_fin TIME,
	 precio FLOAT NOT NULL,
	 duracion TIME,
	 capacidad INT NOT NULL
);

INSERT INTO servicio (nombre,descripcion,hora_inicio,hora_fin,precio,duracion,capacidad) VALUES
('Spa','Spa','09:00','18:00',80,'01:00',10),
('Restaurante','Comida','06:00','22:00',50,'01:30',50),
('Gimnasio','Gym','05:00','23:00',20,'01:00',20),
('Piscina','Piscina','08:00','20:00',30,'01:00',30),
('Bar','Bebidas','10:00','02:00',40,'01:00',40),
('Lavanderia','Ropa','07:00','19:00',15,'00:30',10),
('Transporte','Taxi','00:00','23:59',60,'01:00',5),
('Tours','Turismo','08:00','18:00',120,'04:00',15),
('Masajes','Relax','09:00','18:00',90,'01:00',8),
('Guarderia','Niños','08:00','17:00',30,'02:00',12);


CREATE TABLE hotel_servicio (
	 ID_hotel_servicio INT PRIMARY KEY AUTO_INCREMENT,
	 ID_hotel INT,
	 FOREIGN KEY (ID_hotel) REFERENCES hotel (ID_hotel)
);

ALTER TABLE hotel_servicio
ADD ID_servicio INT

ALTER TABLE hotel_servicio
ADD FOREIGN KEY (ID_servicio)
REFERENCES servicio (ID_servicio)

INSERT INTO hotel_servicio (ID_hotel,ID_servicio) VALUES
(1,1),
(1,2),
(2,2),
(2,3),
(3,1),
(4,4),
(5,5),
(6,6),
(7,7),
(8,8),
(9,9),
(10,10);

-- ================= HABITACION =================
CREATE TABLE tipo_habitacion (
	 ID_tipo INT PRIMARY KEY AUTO_INCREMENT,
	 descripcion VARCHAR (255) NOT NULL,
	 capacidad INT NOT NULL,
	 tamano_m2 INT NOT NULL,
	 num_camas INT NOT NULL,
	 tipo_cama VARCHAR (255)
);

INSERT INTO tipo_habitacion (descripcion,capacidad,tamano_m2,num_camas,tipo_cama) VALUES
('Tipo1',1,20,1,'Simple'),
('Tipo2',2,25,2,'Doble'),
('Tipo3',3,30,2,'Queen'),
('Tipo4',4,35,3,'King'),
('Tipo5',2,28,2,'Doble'),
('Tipo6',1,18,1,'Simple'),
('Tipo7',3,40,3,'King'),
('Tipo8',2,22,2,'Doble'),
('Tipo9',4,45,3,'King'),
('Tipo10',5,60,4,'Suite');

CREATE TABLE habitacion_amenidad (
	 ID_habitacion_amenidad INT PRIMARY KEY AUTO_INCREMENT,
	 ID_tipo INT,
	 FOREIGN KEY (ID_tipo) REFERENCES tipo_habitacion (ID_tipo),
	 amenidad VARCHAR (255)
);

INSERT INTO habitacion_amenidad (ID_tipo, amenidad)VALUES
(1,'WiFi'),
(2,'TV'),
(3,'Aire'),
(4,'Jacuzzi'),
(5,'Balcon'),
(6,'WiFi'),
(7,'TV'),
(8,'Aire'),
(9,'Jacuzzi'),
(10,'Piscina');

CREATE TABLE habitacion (
	 ID_habitacion INT PRIMARY KEY AUTO_INCREMENT,
	 numero_habitacion INT NOT NULL,
	 piso INT NOT NULL,
	 ID_tipo INT,
	 FOREIGN KEY (ID_tipo) REFERENCES tipo_habitacion (ID_tipo),
	 orientacion ENUM ('Norte', 'Sur', 'Este', 'Oeste'),
	 estado ENUM ('Disponible', 'Ocupada', 'Mantenimiento'),
	 tarifa_base FLOAT NOT NULL,
	 ID_hotel INT,
	 FOREIGN KEY (ID_hotel) REFERENCES hotel (ID_hotel)
);

INSERT INTO habitacion (numero_habitacion,piso,ID_tipo,ID_hotel,orientacion,estado,tarifa_base) VALUES
(101,1,1,1,'Norte','Disponible',100),
(102,1,2,1,'Sur','Ocupada',150),
(103,1,3,2,'Este','Disponible',200),
(104,1,4,2,'Oeste','Disponible',250),
(105,2,5,3,'Norte','Mantenimiento',180),
(106,2,6,3,'Sur','Disponible',90),
(107,2,7,4,'Este','Disponible',30),
(108,2,8,4,'Oeste','Ocupada',140),
(109,3,9,5,'Norte','Disponible',32),
(110,3,10,5,'Sur','Disponible',50);

CREATE TABLE habitacion_caracteristica (
	 ID_habitacion_caracteristica INT PRIMARY KEY AUTO_INCREMENT,
	 ID_habitacion INT,
	 FOREIGN KEY (ID_habitacion) REFERENCES habitacion (ID_habitacion),
	 caracteristica VARCHAR (255) NOT NULL
);

INSERT INTO habitacion_caracteristica (ID_habitacion,caracteristica)VALUES
(1,'Vista al mar'),
(2,'Balcón'),
(3,'Jacuzzi'),
(4,'Silenciosa'),
(5,'Amplia'),
(6,'Moderna'),
(7,'Iluminada'),
(8,'Decorada'),
(9,'VIP'),
(10,'Económica');

-- ================= CLIENTE =================

CREATE TABLE cliente (
	 ID_cliente INT PRIMARY KEY AUTO_INCREMENT,
	 nombre VARCHAR (255) NOT NULL,
	 apellido VARCHAR (255) NOT NULL,
	 documento INT NOT NULL,
	 nacionalidad VARCHAR (255) NOT NULL,
	 fecha_nacimiento DATE,
	 direccion VARCHAR (255) NOT NULL,
	 telefono VARCHAR(20),
	 correo VARCHAR (255) NOT NULL,
	 nivel_fidelizacion INT NOT NULL
);

INSERT INTO cliente (nombre,apellido,documento,nacionalidad,fecha_nacimiento,direccion,telefono,correo,nivel_fidelizacion) VALUES
('C1','A1','11111111','Colombiana','1990-01-01','Dir1','30013001','c1@gmail.com',1),
('C2','B2','22222222','Mexicana','1991-01-01','Dir2','30023002','c2@gmail.com',2),
('C3','C3','33333333','Peruana','1992-01-01','Dir3','30033003','c3@gmail.com',1),
('C4','D4','44444444','Española','1993-01-01','Dir4','30043004','c4@gmail.com',3),
('C5','E5','55555555','Argentina','1994-01-01','Dir5','30053005','c5@gmail.com',2),
('C6','F6','66666666','Colombiana','1995-01-01','Dir6','30063006','c6@gmail.com',1),
('C7','G7','77777777','Colombiana','1996-01-01','Dir7','30073007','c7@gmail.com',2),
('C8','H8','88888888','Mexicana','1997-01-01','Dir8','30083008','c8@gmail.com',3),
('C9','I9','99999999','Colombiana','1998-01-01','Dir9','30093009','c9@gmail.com',1),
('C10','J10','1010101010','Peruana','1999-01-01','Dir10','30103010','c10@gmail.com',2);

CREATE TABLE cliente_preferencia (
	 ID_cliente_preferencia INT PRIMARY KEY AUTO_INCREMENT,
	 ID_cliente INT,
	 FOREIGN KEY (ID_cliente) REFERENCES cliente (ID_cliente),
	 preferencia VARCHAR (255) NOT NULL
);

INSERT INTO cliente_preferencia (ID_cliente,preferencia) VALUES
(1,'No fumador'),
(2,'Piso alto'),
(3,'Vista al mar'),
(4,'Cama doble'),
(5,'Silencioso'),
(6,'Cerca ascensor'),
(7,'Balcón'),
(8,'Suite'),
(9,'Aire acondicionado'),
(10,'TV grande');

-- ================= RESERVA =================

CREATE TABLE reserva (
	 ID_reserva INT PRIMARY KEY AUTO_INCREMENT,
	 fecha_creacion DATE,
	 ID_cliente INT,
	 FOREIGN KEY (ID_cliente) REFERENCES cliente (ID_cliente),
	 fecha_llegada DATE,
	 fecha_salida DATE,
	 num_habitaciones INT NOT NULL,
	 ID_tipo INT,
	 FOREIGN KEY (ID_tipo) REFERENCES tipo_habitacion (ID_tipo),
	 adultos INT NOT NULL,
	 ninos INT NOT NULL,
	 tarifa_aplicada FLOAT NOT NULL,
	 deposito FLOAT NOT NULL,
	 metodo_pago ENUM ('Efectivo', 'Transferencia', 'Tarjeta'),
	 estado ENUM ('Confirmada', 'Cancelada', 'Completada', 'Pendiente')
);

INSERT INTO reserva (fecha_creacion,ID_cliente,fecha_llegada,fecha_salida,num_habitaciones,ID_tipo,adultos,ninos,tarifa_aplicada,deposito,metodo_pago,estado) VALUES
('2026-01-01',1,'2026-02-01','2026-02-03',1,1,2,0,100,50,'Tarjeta','Confirmada'),
('2026-01-02',2,'2026-02-02','2026-02-04',1,2,2,1,150,60,'Efectivo','Confirmada'),
('2026-01-03',3,'2026-02-03','2026-02-05',1,3,3,0,200,70,'Transferencia','Confirmada'),
('2026-01-04',4,'2026-02-04','2026-02-06',1,4,2,2,250,80,'Tarjeta','Cancelada'),
('2026-01-05',5,'2026-02-05','2026-02-07',1,5,2,0,180,50,'Efectivo','Confirmada'),
('2026-01-06',6,'2026-02-06','2026-02-08',1,6,1,0,90,30,'Transferencia','Confirmada'),
('2026-01-07',7,'2026-02-07','2026-02-09',1,7,3,1,30,9,'Tarjeta','Confirmada'),
('2026-01-08',8,'2026-02-08','2026-02-10',1,8,2,0,140,50,'Efectivo','Completada'),
('2026-01-09',9,'2026-02-09','2026-02-11',1,9,4,0,32,10,'Transferencia','Confirmada'),
('2026-01-10',10,'2026-02-10','2026-02-12',1,10,5,2,50,15,'Tarjeta','Pendiente');
CREATE TABLE solicitud_reserva (
	 ID_solicitud_reserva INT PRIMARY KEY AUTO_INCREMENT,
	 ID_reserva INT,
	 FOREIGN KEY (ID_reserva) REFERENCES reserva (ID_reserva),
	 solicitud VARCHAR (255)
);

INSERT INTO solicitud_reserva (ID_reserva, solicitud) VALUES
(1,'Cama extra'),
(2,'Vista al mar'),
(3,'Sin ruido'),
(4,'Piso alto'),
(5,'Decoracion especial'),
(6,'Check-in temprano'),
(7,'Check-out tarde'),
(8,'Habitacion conectada'),
(9,'Cuna'),
(10,'Servicio especial');

-- ================= CHECK =================

CREATE TABLE checkin_checkout (
	 ID_registro INT PRIMARY KEY AUTO_INCREMENT,
	 ID_reserva INT,
	 FOREIGN KEY (ID_reserva) REFERENCES reserva (ID_reserva),
	 ID_habitacion INT,
	 FOREIGN KEY (ID_habitacion) REFERENCES habitacion (ID_habitacion),
	 fecha_llegada_real DATE,
	 fecha_salida_real DATE,
	 ID_empleado INT,
	 FOREIGN KEY (ID_empleado) REFERENCES empleado (ID_empleado),
	 forma_pago ENUM ('Efectivo', 'Transferencia', 'Tarjeta'),
	 deposito_garantia FLOAT NOT NULL,
	 observaciones VARCHAR (255)
);

INSERT INTO checkin_checkout 
(ID_reserva, ID_habitacion, fecha_llegada_real, fecha_salida_real, ID_empleado, forma_pago, deposito_garantia, observaciones) VALUES
(1,1,'2026-02-01','2026-02-03',2,'Tarjeta',50,'OK'),
(2,2,'2026-02-02','2026-02-04',3,'Efectivo',60,'OK'),
(3,3,'2026-02-03','2026-02-05',2,'Transferencia',70,'OK'),
(4,4,'2026-02-04','2026-02-06',3,'Tarjeta',80,'Cancelado'),
(5,5,'2026-02-05','2026-02-07',2,'Efectivo',50,'OK'),
(6,6,'2026-02-06','2026-02-08',3,'Transferencia',30,'OK'),
(7,7,'2026-02-07','2026-02-09',2,'Tarjeta',90,'OK'),
(8,8,'2026-02-08','2026-02-10',3,'Efectivo',50,'OK'),
(9,9,'2026-02-09','2026-02-11',2,'Transferencia',100,'OK'),
(10,10,'2026-02-10','2026-02-12',3,'Tarjeta',150,'OK');

-- ================= TARIFA =================

CREATE TABLE temporada (
	 ID_temporada INT PRIMARY KEY AUTO_INCREMENT,
	 nombre ENUM ('Alta', 'Media', 'Baja'),
	 fecha_inicio DATE,
	 fecha_fin DATE,
	 factorr float
);

INSERT INTO temporada (nombre, fecha_inicio, fecha_fin, factorr) VALUES
('Alta','2026-12-01','2026-12-31',1.5),
('Media','2026-06-01','2026-08-31',1.2),
('Baja','2026-01-01','2026-05-31',1.0),
('Alta','2027-12-01','2027-12-31',1.6),
('Media','2027-06-01','2027-08-31',1.3),
('Baja','2027-01-01','2027-05-31',1.1),
('Alta','2028-12-01','2028-12-31',1.7),
('Media','2028-06-01','2028-08-31',1.4),
('Baja','2028-01-01','2028-05-31',1.2),
('Alta','2029-12-01','2029-12-31',1.8);

CREATE TABLE tarifa (
	 ID_tarifa INT PRIMARY KEY AUTO_INCREMENT,
	 ID_tipo INT,
	 FOREIGN KEY (ID_tipo) REFERENCES tipo_habitacion (ID_tipo),
	 tarifa_base FLOAT NOT NULL,
	 impuestos FLOAT NOT NULL,
	 descuento FLOAT NOT NULL,
	 condiciones VARCHAR (255)
);

ALTER TABLE tarifa
ADD ID_temporada INT

ALTER TABLE tarifa
ADD FOREIGN KEY (ID_temporada)
REFERENCES temporada (ID_temporada)

INSERT INTO tarifa (ID_tipo, ID_temporada, tarifa_base, impuestos, descuento, condiciones) VALUES
(1,1,100,19,0,'Normal'),
(2,2,150,28,5,'Promo'),
(3,3,200,38,10,'Especial'),
(4,4,250,47,15,'Alta'),
(5,5,180,34,80,'Media'),
(6,6,90,17,20,'Baja'),
(7,7,300,57,20,'Premium'),
(8,8,140,26,4,'Oferta'),
(9,9,320,60,25,'VIP'),
(10,10,500,95,30,'Lujo');

-- ================= CONSUMO =================

CREATE TABLE consumo_servicio (
	 ID_consumo_servicio INT PRIMARY KEY AUTO_INCREMENT,
	 ID_cliente INT,
	 FOREIGN KEY (ID_cliente) REFERENCES cliente (ID_cliente),
	 ID_habitacion INT,
	 FOREIGN KEY (ID_habitacion) REFERENCES habitacion (ID_habitacion),
	 ID_servicio INT,
	 FOREIGN KEY (ID_servicio) REFERENCES servicio (ID_servicio),
	 fecha DATE,
	 cantidad INT NOT NULL,
	 precio FLOAT NOT NULL,
	 ID_empleado INT,
	 FOREIGN KEY (ID_empleado) REFERENCES empleado (ID_empleado),
	 observaciones VARCHAR (255)
);

INSERT INTO consumo_servicio 
(ID_cliente, ID_habitacion, ID_servicio, fecha, cantidad, precio, ID_empleado, observaciones) VALUES
(1,1,1,'2026-02-01',1,80,4,'Spa'),
(2,2,2,'2026-02-02',2,100,4,'Restaurante'),
(3,3,3,'2026-02-03',1,20,4,'Gym'),
(4,4,4,'2026-02-04',1,30,4,'Piscina'),
(5,5,5,'2026-02-05',2,80,4,'Bar'),
(6,6,6,'2026-02-06',3,45,4,'Lavanderia'),
(7,7,7,'2026-02-07',1,60,4,'Transporte'),
(8,8,8,'2026-02-08',1,120,4,'Tour'),
(9,9,9,'2026-02-09',1,90,4,'Masaje'),
(10,10,10,'2026-02-10',1,30,4,'Guarderia');

-- ================= EVENTO =================

CREATE TABLE evento (
	 ID_evento INT PRIMARY KEY AUTO_INCREMENT,
	 tipo ENUM ('Conferencia', 'Boda', 'Reunion'),
	 ID_cliente INT,
	 FOREIGN KEY (ID_cliente) REFERENCES cliente (ID_cliente),
	 fecha_inicio DATE,
	 duracion TIME,
	 asistentes INT NOT NULL,
	 precio_total FLOAT NOT NULL,
	 estado ENUM('Planificado', 'Confirmado', 'En curso', 'Finalizado', 'Cancelado')
);

INSERT INTO evento (tipo, ID_cliente, fecha_inicio, duracion, asistentes, precio_total, estado) VALUES
('Conferencia',1,'2026-03-01','03:00:00',50,500,'Planificado'),
('Boda',2,'2026-03-02','05:00:00',100,2000,'Confirmado'),
('Reunion',3,'2026-03-03','02:00:00',20,200,'Finalizado'),
('Conferencia',4,'2026-03-04','04:00:00',70,700,'Confirmado'),
('Boda',5,'2026-03-05','06:00:00',150,3000,'Planificado'),
('Reunion',6,'2026-03-06','01:00:00',10,100,'Cancelado'),
('Conferencia',7,'2026-03-07','03:00:00',60,600,'Confirmado'),
('Boda',8,'2026-03-08','05:00:00',120,2500,'Confirmado'),
('Reunion',9,'2026-03-09','02:00:00',30,300,'Finalizado'),
('Conferencia',10,'2026-03-10','04:00:00',80,800,'Planificado');

ALTER TABLE evento
ADD ID_salon INT,
ADD FOREIGN KEY (ID_salon) REFERENCES salon(ID_salon);

CREATE TABLE evento_servicio (
	 ID_evento_servicio INT PRIMARY KEY AUTO_INCREMENT,
	 ID_evento INT,
	 FOREIGN KEY (ID_evento) REFERENCES evento (ID_evento),
	 ID_servicio INT,
	 FOREIGN KEY (ID_servicio) REFERENCES servicio (ID_servicio)
);

INSERT INTO evento_servicio (ID_evento, ID_servicio) VALUES
(1,1),
(1,2),
(2,2),
(2,3),
(3,1),
(4,4),
(5,5),
(6,6),
(7,7),
(8,8),
(9,9),
(10,10);

-- ================= EQUIPO =================

CREATE TABLE evento_equipo (
	 ID_evento_equipo INT PRIMARY KEY AUTO_INCREMENT,
	 ID_evento INT,
	 FOREIGN KEY (ID_evento) REFERENCES evento (ID_evento),
	 equipo VARCHAR (255)
);

INSERT INTO evento_equipo (ID_evento, equipo) VALUES
(1,'Proyector'),
(2,'Sonido'),
(3,'Microfono'),
(4,'Pantalla'),
(5,'Luces'),
(6,'Camara'),
(7,'Laptop'),
(8,'Router'),
(9,'Aire'),
(10,'Tarima');

-- ================= SALON =================

CREATE TABLE salon (
	 ID_salon INT PRIMARY KEY AUTO_INCREMENT,
	 nombre VARCHAR (255) NOT NULL,
	 ubicacion VARCHAR (255) NOT NULL,
	 capacidad INT NOT NULL,
	 tamano_m2 INT NOT NULL
);


INSERT INTO salon (nombre, ubicacion, capacidad, tamano_m2) VALUES
('Salon1','Piso1',50,40),
('Salon2','Piso2',60,50),
('Salon3','Piso3',70,60),
('Salon4','Piso4',80,70),
('Salon5','Piso5',90,80),
('Salon6','Piso6',100,90),
('Salon7','Piso7',110,100),
('Salon8','Piso8',120,110),
('Salon9','Piso9',130,120),
('Salon10','Piso10',140,130);

CREATE TABLE salon_tarifa (
	 ID_salon_tarifa INT PRIMARY KEY AUTO_INCREMENT,
	 ID_salon INT,
	 FOREIGN KEY (ID_salon) REFERENCES salon (ID_salon),
	 duracion TIME,
	 tarifa FLOAT
);

INSERT INTO salon_tarifa (ID_salon, duracion, tarifa) VALUES
(1,'02:00:00',200),
(2,'03:00:00',250),
(3,'04:00:00',300),
(4,'05:00:00',350),
(5,'06:00:00',400),
(6,'02:00:00',220),
(7,'03:00:00',270),
(8,'04:00:00',320),
(9,'05:00:00',370),
(10,'06:00:00',420);
