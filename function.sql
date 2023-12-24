-- У даній грі (Genshin Impact) чим вища рідкість зброї (найбільша рідкість (rarity) це 5)
-- тим кращою є зброя. Зброя рідкістю 1 та 2 отримується неймовірно легко, через що вона
-- не має додаткових атрибутів (substat) окрім базової атаки.
-- Зброя рідкістю 5 називається легендарною і є найкращою у своєму роді.
-- Зброя рідкістю 4 називається епічною, і чим далі Ви граєте, тим краще було б спорядити
-- нею усіх своїх персонажів, яким з певних причин Ви не можете дозволити легендарну зброю.
-- Зброя рідкістю 3 зазвичай отримується навіть на початкових етапах гри (вважається, що варто
-- докласти трохи зусиль, щоб на початку гри отримати її, бо вона буде достатньо ефективною),
-- але попри це є деяка зброя яка отримується доволі рідко.

-- Ідея написання функції була у тому, щоб з наявного списку усієї зброї відфільтрувати ту, яка
-- не являє собою практичної користі. Уся зброя, що лишилася, має достатньо причин для того
-- щоб за конкретних обставин звернути на неї увагу.

DROP FUNCTION IF EXISTS leave_useful_weapons(); 
 
CREATE OR REPLACE FUNCTION leave_useful_weapons() 
    RETURNS TABLE (weapon_name VARCHAR(50), rarity INT, max_atk INT, substat_type VARCHAR(25), max_substat VARCHAR(10))
    LANGUAGE plpgsql
AS $$ 
BEGIN  
    RETURN QUERY
    SELECT *
    FROM weapon
    WHERE weapon.substat_type IS NOT NULL;
END; 
$$;

SELECT * FROM leave_useful_weapons();