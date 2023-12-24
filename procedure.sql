-- Процедура дозволяє отримати інформацію про зброю за її назвою

-- Нагадування щодо вмісту таблиці weapon
SELECT * FROM weapon;


DROP PROCEDURE IF EXISTS get_weapon_by_rarity(integer); 
 
CREATE OR REPLACE PROCEDURE get_weapon_by_name(weapon_name_param VARCHAR(50)) 
LANGUAGE plpgsql 
AS $$ 
DECLARE 
    weapon_row weapon%ROWTYPE;
BEGIN 
    SELECT * INTO weapon_row FROM weapon WHERE weapon_name = weapon_name_param; 
    
    IF FOUND THEN
        RAISE INFO 'Weapon name: %, Rarity: %, Max ATK: %, Substat type: %, Max substat value: %', 
            TRIM(weapon_row.weapon_name), weapon_row.rarity, weapon_row.max_atk, 
            TRIM(weapon_row.substat_type), TRIM(weapon_row.max_substat);
    ELSE
        RAISE INFO 'За назвою % не знайдено жодної зброї', weapon_name_param;
    END IF;
END; 
$$;

CALL get_weapon_by_name('Primordial Jade Cutter');

CALL get_weapon_by_name('Non-existing weapon');