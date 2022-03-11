DROP FUNCTION IF EXISTS mibase.extraeAnio;

DELIMITER $$
$$
CREATE DEFINER=`miusuario`@`%` FUNCTION `mibase`.`extraeAnio`(str varchar(512) ) RETURNS varchar(512) CHARSET utf8
    DETERMINISTIC
BEGIN
DECLARE i, len SMALLINT DEFAULT 1; 
  DECLARE limpio varchar(512) DEFAULT '';
  DECLARE ret varchar(512) DEFAULT ''; 
  DECLARE c CHAR(1); 
  SET len = CHAR_LENGTH( str ); 
  REPEAT 
    BEGIN 
      SET c = MID( str, i, 1 ); 
      IF c REGEXP '[[:digit:]]' THEN
        set ret = MID(str, i, 4);
        IF ret REGEXP '^[0-9]+$'THEN
			return ret;
        END IF;
      END IF; 
      SET i = i + 1; 
    END; 
  UNTIL i > len END REPEAT;
  RETURN '';
END$$
DELIMITER ;
