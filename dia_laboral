CREATE FUNCTION `test`.`es_dia_laboral`(fecha DATE) RETURNS tinyint(1)
BEGIN
    DECLARE dia_semana INT;
    DECLARE es_laboral BOOLEAN;
    
    SET dia_semana = DAYOFWEEK(fecha);
    
    IF dia_semana BETWEEN 2 AND 6 THEN
        SET es_laboral = TRUE;
    ELSE
        SET es_laboral = FALSE;
    END IF;
    
    RETURN es_laboral;
END;
