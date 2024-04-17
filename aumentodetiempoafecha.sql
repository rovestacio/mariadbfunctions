CREATE FUNCTION `test`.`fecha_vencimiento`(fecha_inicio_str VARCHAR(19)) RETURNS DATETIME
BEGIN
    DECLARE fecha_inicio DATETIME;
    DECLARE horas_a_sumar INT;
    DECLARE dias_a_sumar INT;
    DECLARE hora_fin DATETIME;
 
   
    SET fecha_inicio = STR_TO_DATE(fecha_inicio_str, '%Y-%m-%d %H:%i:%s');
 
   
    IF HOUR(fecha_inicio) < 9 THEN
        SET horas_a_sumar = 0;
        SET fecha_inicio = DATE_ADD(fecha_inicio, INTERVAL (9 - HOUR(fecha_inicio)) HOUR); -- Ajustando la hora de inicio a las 9:00 si es antes de las 9:00
    ELSEIF HOUR(fecha_inicio) >= 18 THEN
        SET horas_a_sumar = 0;
        SET fecha_inicio = DATE_ADD(fecha_inicio, INTERVAL 1 DAY); -- Añado un día si la hora de inicio es después de las 18:00
    ELSE
        SET horas_a_sumar = 18 - HOUR(fecha_inicio);
    END IF;
 
    
    IF es_dia_laboral(fecha_inicio) THEN
        IF DAYOFWEEK(fecha_inicio) = 6 AND HOUR(fecha_inicio) + horas_a_sumar >= 18 THEN
            SET dias_a_sumar = 3; -- Si es viernes y la suma supera las 18 horas, sumar hasta el lunes
        ELSE
            SET dias_a_sumar = FLOOR((horas_a_sumar + HOUR(TIMEDIFF('18:00:00', '09:00:00'))) / 9);
        END IF;
    ELSE
        SET dias_a_sumar = 1; -- Si no es un día laboral, sumar hasta el siguiente día laboral
    END IF;
 
    
    SET hora_fin = DATE_ADD(fecha_inicio, INTERVAL (dias_a_sumar * 24 + horas_a_sumar) HOUR);
 
    
    IF HOUR(hora_fin) >= 18 THEN
        SET hora_fin = DATE_ADD(hora_fin, INTERVAL (24 - HOUR(hora_fin) + 9) HOUR);
    END IF;
 
    RETURN hora_fin;
END;



