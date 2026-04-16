USE HOTELPRO

-- =============================================================
-- =========================== VIEWS ===========================
-- =============================================================

-- 1. V_DisponibilidadHabitaciones: Muestra la disponibilidad de habitaciones por tipo y fecha.

CREATE VIEW V_DisponibilidadHabitaciones AS
SELECT h.ID_habitacion, 
		 h.numero_habitacion,
		 t.descripcion AS tipo_habitacion,
		 r.fecha_llegada,
    	 r.fecha_salida,
		 CASE 
       	 WHEN CURDATE() BETWEEN r.fecha_llegada AND r.fecha_salida 
          THEN 'Ocupada'
          ELSE 'Disponible'
    	 END AS estado_disponibilidad
FROM habitacion h
INNER JOIN tipo_habitacion t
	ON h.ID_tipo = t.ID_tipo
-- "Trae el tipo de habitación correspondiente a cada habitación"

LEFT JOIN checkin_checkout cc 
    ON h.ID_habitacion = cc.ID_habitacion
-- “Une cada habitación con los registros de check-in/check-out donde fue usada”

LEFT JOIN reserva r 
    ON cc.ID_reserva = r.ID_reserva;
-- “Une checkin_checkout con reserva, aunque no exista una reserva asociada”

SELECT * FROM V_DisponibilidadHabitaciones



-- 2. V_ReservasFuturas: Presenta todas las reservas futuras con detalles de clientes.

CREATE VIEW V_ReservasFuturas AS 
SELECT 
    c.ID_cliente,
    c.nombre,
    c.apellido,
    c.documento,
    c.telefono,
    c.correo,
    c.nivel_fidelizacion,
    r.ID_reserva,
    r.fecha_creacion,
    r.fecha_llegada,
    r.fecha_salida,
    CASE
        WHEN r.fecha_llegada > CURDATE()
        THEN 'RESERVA FUTURA'
        ELSE 'RESERVA EN CURSO O VENCIDA'
    END AS estado_reserva
FROM cliente c
INNER JOIN reserva r 
    ON c.ID_cliente = r.ID_cliente;

SELECT * FROM V_ReservasFuturas




-- 3. V_OcupacionActual: Detalla la ocupación actual del hotel por tipo de habitación.

CREATE VIEW V_OcupacionActual AS
SELECT 
		 t.descripcion AS tipo_habitacion,
		 COUNT(DISTINCT h.ID_habitacion) AS total_habitaciones, 
    	 SUM(
        CASE 
            WHEN CURDATE() BETWEEN r.fecha_llegada AND r.fecha_salida
            THEN 1
            ELSE 0
        END AS habitaciones_ocupadas
FROM habitacion h
INNER JOIN tipo_habitacion t
ON h.ID_tipo = t.ID_tipo
LEFT JOIN checkin_checkout cc
ON h.ID_habitacion = cc.ID_habitacion
LEFT JOIN reserva r
ON cc.ID_reserva = r.ID_reserva
GROUP BY t.descripcion;

SELECT * FROM V_OcupacionActual

-- 4. V_EventosProgramados: Calendario de eventos programados con salones y servicios.

CREATE VIEW V_EventosProgramados AS
SELECT s.ID_servicio,
	    e.ID_evento,
	    e.tipo,
	    e.fecha_inicio,
	    sa.ID_salon,
	    sa.nombre,
	    sa.ubicacion,
	    sa.capacidad,
	    sa.tamano_m2,
	    CASE
	    WHEN e.fecha_inicio > CURDATE()
	    THEN 'EVENTO PROXIMO'
	    ELSE 'EVENTO CONCLUIDO'
	    END AS estado_evento
FROM evento e

LEFT JOIN salon sa 
ON e.ID_salon = sa.ID_salon

LEFT JOIN evento_servicio es
ON e.ID_evento = es.ID_evento

LEFT JOIN servicio s
ON es.ID_servicio = s.ID_servicio

SELECT * FROM V_EventosProgramados

-- 5. V_EstadisticasOcupacion: Estadísticas de ocupación por periodo, habitación y temporada.

CREATE VIEW V_EstadisticasOcupacion AS
SELECT h.ID_habitacion, temp.nombre AS temporada,
	 YEAR(r.fecha_llegada) AS anio,
    MONTH(r.fecha_llegada) AS mes,
 	 COUNT(DISTINCT cc.ID_registro) AS total_ocupaciones
FROM habitacion h

INNER JOIN checkin_checkout cc 
    ON h.ID_habitacion = cc.ID_habitacion
    
INNER JOIN reserva r 
    ON cc.ID_reserva = r.ID_reserva
    
INNER JOIN tipo_habitacion t 
    ON h.ID_tipo = t.ID_tipo
    
INNER JOIN tarifa ta 
    ON t.ID_tipo = ta.ID_tipo
    
INNER JOIN temporada temp 
    ON ta.ID_temporada = temp.ID_temporada

GROUP BY 
    h.ID_habitacion,
    temp.nombre,
    YEAR(r.fecha_llegada),
    MONTH(r.fecha_llegada);

SELECT * FROM V_EstadisticasOcupacion