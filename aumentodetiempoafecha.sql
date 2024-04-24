CREATE DEFINER=`root`@`localhost` FUNCTION `test`.`fecha_vencimiento`(fecha_inicio_str VARCHAR(19), horas INT) RETURNS DATETIME
BEGIN
    
    DECLARE hora_fin DATETIME;
    DECLARE minutos_a_sumar INT;
    DECLARE fecha_inicio DATETIME;
    
    SET minutos_a_sumar = horas * 60;
    SET fecha_inicio = STR_TO_DATE(fecha_inicio_str, '%Y-%m-%d %H:%i:%s');
	
    WHILE minutos_a_sumar > 0 DO
        -- Verificar si la hora actual es laboral (entre 9 y 18 horas)
        IF HOUR(fecha_inicio) >= 9 AND HOUR(fecha_inicio) < 18 AND WEEKDAY(fecha_inicio) BETWEEN 0 AND 4 THEN
            SET minutos_a_sumar = minutos_a_sumar - 1; -- Restar un minuto laboral
        ELSEIF HOUR(fecha_inicio) >= 18 OR WEEKDAY(fecha_inicio) = 5 THEN
            -- Si pasamos las 18 horas o es viernes, avanzar al siguiente día laboral
            SET fecha_inicio = DATE_ADD(DATE(fecha_inicio), INTERVAL 1 DAY);
            SET fecha_inicio = STR_TO_DATE(CONCAT(DATE(fecha_inicio), ' 09:00:00'), '%Y-%m-%d %H:%i:%s');
        END IF;

        -- Avanzar al siguiente minuto
        SET fecha_inicio = DATE_ADD(fecha_inicio, INTERVAL 1 MINUTE);
    END WHILE;

    -- Calcular la hora de finalización
    SET hora_fin = DATE_SUB(fecha_inicio, INTERVAL 1 MINUTE);

    RETURN hora_fin;
END;
