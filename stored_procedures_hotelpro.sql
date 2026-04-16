USE HOTELPRO;

-- =========================================================================
-- =========================== STORED PROCEDURES ===========================
-- =========================================================================

DELIMITER //

-- 1. CrearReserva: Crea una nueva reserva verificando disponibilidad de habitaciones para las fechas.

CREATE PROCEDURE CrearReserva(
    IN p_ID_cliente INT,
    IN p_ID_tipo INT,
    IN p_fecha_llegada DATE,
    IN p_fecha_salida DATE
)
BEGIN
	 DECLARE habitaciones_ocupadas INT;
	 -- Contar habitaciones ocupadas en ese rango
	 DECLARE total_habitaciones INT;
	 -- contar el total de habitacions
	 SELECT COUNT(*) INTO habitaciones_ocupadas
	 -- cuenta filas y las guarda en la variable
	 FROM checkin_checkout cc
	 INNER JOIN reserva r
	 ON cc.ID_reserva = r.ID_reserva
	 -- para obtener fechas
	 INNER JOIN habitacion h
	 ON cc.ID_habitacion = h.ID_habitacion
	 -- para saber el tipo
	 WHERE h.ID_tipo = p_ID_tipo
	 -- solo cuenta habitaciones de ese tipo
	 AND p_fecha_llegada <= r.fecha_salida
    AND p_fecha_salida >= r.fecha_llegada;
    -- Detecta si las fechas se cruzan

SELECT COUNT(*) INTO total_habitaciones
FROM habitacion
WHERE ID_tipo = p_ID_tipo;

	 IF habitaciones_ocupadas < total_habitaciones THEN
		 INSERT INTO reserva (
    	 	 fecha_creacion,
    	 	 ID_cliente,
    	 	 fecha_llegada,
    	  	 fecha_salida,
    	 	 num_habitaciones,
     	 	 ID_tipo,
     	 	 adultos,
    	  	 ninos,
    	 	 tarifa_aplicada,
    	 	 deposito,
    	 	 metodo_pago,
    	 	 estado
    	 )
   	 VALUES (
   	 	 CURDATE(),
    		 p_ID_cliente,
    		 p_fecha_llegada,
    		 p_fecha_salida,
    		 1,
    		 p_ID_tipo,
    	 	 2,
    		 0,
    		 100,
    		 50,
    	 	 'Efectivo',
    		 'Confirmada'
   	 );
    SELECT 'Reserva creada' AS mensaje;

    ELSE
   	 SELECT 'No hay disponibilidad' AS mensaje;
    END IF;

END //

DELIMITER ;

CALL CrearReserva(1, 2, '2024-04-20', '2024-04-25');

-- 2. ProcesarCheckIn: Registra el check-in de un cliente asignando habitación y registrando depósito.

DELIMITER //

CREATE PROCEDURE ProcesarCheckIn(
    IN p_ID_reserva INT,
    IN p_ID_empleado INT,
    IN p_deposito FLOAT
)
BEGIN
    DECLARE v_ID_habitacion INT;
    DECLARE v_ID_tipo INT;
    
-- Obtener tipo de habitación de la reserva
    SELECT ID_tipo INTO v_ID_tipo
    FROM reserva
    WHERE ID_reserva = p_ID_reserva;
    
-- Buscar una habitación disponible
    SELECT h.ID_habitacion INTO v_ID_habitacion
    -- es la habitación que se va a asignar
    FROM habitacion h
    WHERE h.ID_tipo = v_ID_tipo
    -- solo habitaciones del tipo reservado
    AND h.ID_habitacion NOT IN (
        SELECT cc.ID_habitacion
        FROM checkin_checkout cc
        INNER JOIN reserva r 
            ON cc.ID_reserva = r.ID_reserva
        WHERE CURDATE() BETWEEN r.fecha_llegada AND r.fecha_salida
    )
    LIMIT 1;
-- validar si se encontro una habitacion
    IF v_ID_habitacion IS NOT NULL THEN
       INSERT INTO checkin_checkout (
    	  	 ID_reserva,
    		 ID_habitacion,
    		 fecha_llegada_real,
    		 fecha_salida_real,
    		 ID_empleado,
    		 forma_pago,
    		 deposito_garantia,
    		 observaciones
		 )
		 VALUES (
    		 p_ID_reserva,
    		 v_ID_habitacion,
    		 NOW(),
    		 NULL, -- aún no ha salido
    		 p_ID_empleado,
    		 'Efectivo', -- o parámetro
    		 p_deposito,
    		 'Check-in realizado'
		 );
        SELECT 'Check-in realizado correctamente' AS mensaje;

    ELSE
        SELECT 'No hay habitaciones disponibles' AS mensaje;
    END IF;

END //

DELIMITER ;

CALL ProcesarCheckIn(1, 2, 200);

SELECT * FROM checkin_checkout;

-- 3. RegistrarConsumoServicio: Registra consumo de servicios adicionales durante la estancia

DELIMITER //

CREATE PROCEDURE RegistrarConsumoServicio(
    IN p_ID_cliente INT,
    IN p_ID_habitacion INT,
    IN p_ID_servicio INT,
    IN p_cantidad INT,
    IN p_ID_empleado INT
)
BEGIN

    DECLARE v_precio FLOAT;

    -- Obtener precio del servicio
    SELECT precio INTO v_precio
    FROM servicio
    WHERE ID_servicio = p_ID_servicio;

    -- Insertar consumo
    INSERT INTO consumo_servicio (
        ID_cliente,
        ID_habitacion,
        ID_servicio,
        fecha,
        cantidad,
        precio,
        ID_empleado,
        observaciones
    )
    VALUES (
        p_ID_cliente,
        p_ID_habitacion,
        p_ID_servicio,
        NOW(),
        p_cantidad,
        v_precio * p_cantidad,
        p_ID_empleado,
        'Consumo registrado'
    );

    SELECT 'Consumo registrado correctamente' AS mensaje;

END //

DELIMITER ;

CALL RegistrarConsumoServicio(1, 2, 3, 2, 1);

SELECT * FROM consumo_servicio


-- 4. ProcesarCheckOut: Gestiona el check-out calculando cargos totales y liberando la habitación.

DELIMITER //

CREATE PROCEDURE ProcesarCheckOut(
    IN p_ID_reserva INT,
    IN p_forma_pago VARCHAR(50)
)
BEGIN
    DECLARE v_total_reserva FLOAT;
    DECLARE v_total_consumos FLOAT;
    DECLARE v_total_final FLOAT;

    -- Total de la reserva
    SELECT tarifa_aplicada INTO v_total_reserva
    FROM reserva
    WHERE ID_reserva = p_ID_reserva;
    
    -- Total de consumos
    SELECT IFNULL(SUM(precio), 0) INTO v_total_consumos
    FROM consumo_servicio
    WHERE ID_cliente = (
        SELECT ID_cliente 
        FROM reserva 
        WHERE ID_reserva = p_ID_reserva
    );
    
    -- Total final
    SET v_total_final = v_total_reserva + v_total_consumos;

    -- Actualizar check-out
    UPDATE checkin_checkout
    SET 
        fecha_salida_real = NOW(),
        forma_pago = p_forma_pago,
        observaciones = 'Check-out realizado'
    WHERE ID_reserva = p_ID_reserva;

    -- Liberar habitación (cambiar estado)
    UPDATE habitacion h
    INNER JOIN checkin_checkout cc 
        ON h.ID_habitacion = cc.ID_habitacion
    SET h.estado = 'Disponible'
    WHERE cc.ID_reserva = p_ID_reserva;

    -- Mostrar total
    SELECT v_total_final AS total_pagar;

END //

DELIMITER ;

CALL ProcesarCheckOut(1, 'Tarjeta');

SELECT * FROM checkin_checkout

-- 5. ProgramarEvento: Reserva salones y servicios para eventos verificando disponibilidad.

DELIMITER //

CREATE PROCEDURE ProgramarEvento(
    IN p_ID_cliente INT,
    IN p_ID_salon INT,
    IN p_tipo VARCHAR(50),
    IN p_fecha_inicio DATETIME,
    IN p_duracion TIME,
    IN p_asistentes INT
)
BEGIN
    DECLARE eventos_existentes INT;

    -- Verificar si el salón está ocupado
    SELECT COUNT(*) INTO eventos_existentes
    FROM evento
    WHERE ID_salon = p_ID_salon
    AND p_fecha_inicio = fecha_inicio;

    -- VALIDACIÓN
    IF eventos_existentes = 0 THEN

        INSERT INTO evento (
            tipo,
            ID_cliente,
            fecha_inicio,
            duracion,
            asistentes,
            precio_total,
            estado,
            ID_salon
        )
        VALUES (
            p_tipo,
            p_ID_cliente,
            p_fecha_inicio,
            p_duracion,
            p_asistentes,
            0,
            'Planificado',
            p_ID_salon
        );

        SELECT 'Evento programado correctamente' AS mensaje;

    ELSE
        SELECT 'El salón no está disponible en esa fecha' AS mensaje;
    END IF;

END //

DELIMITER ;

CALL ProgramarEvento(1, 2, 'Boda', '2026-06-10 18:00:00', '04:00:00', 100);

SELECT * FROM evento