-- Функція
SELECT * FROM leave_useful_weapons();


-- Процедура
CALL get_weapon_by_name('Primordial Jade Cutter');
CALL get_weapon_by_name('Non-existing weapon');


-- Триггер
-- Перегляд новоствореної таблиці, у яку заноситимуться дані про нові зміни
SELECT * FROM audit_log;

-- Запуск циклу, що вносить дані
SELECT insert_default_phases();

-- Перевірка внесених змін
SELECT * FROM audit_log;