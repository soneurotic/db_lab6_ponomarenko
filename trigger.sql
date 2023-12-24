-- Даний триггер відслідковує нові внесені дані у будь-яку з таблиці.
-- Для Вас я лишив лише цикл з loop.sql з 5 лабораторної, аби можна було
-- переконатися у тому, що все працює.

-- До лабораторної я лишив файл trigger.png, у якому на скріншоті показав,
-- що занесені дані з kaggle_import.py заносяться триггером у таблицю
-- audit_log

DROP TABLE IF EXISTS audit_log;

-- Створення таблиці для зберігання інформації про додавання даних
CREATE TABLE audit_log (
  log_id SERIAL PRIMARY KEY,
  table_name VARCHAR(50) NOT NULL,
  added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  user_added VARCHAR(50) NOT NULL
);

-- Створення триггера для кожної таблиці
CREATE OR REPLACE FUNCTION log_changes()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_log (table_name, user_added)
  VALUES (TG_TABLE_NAME, CURRENT_USER);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Прив'язка триггера до кожної таблиці
CREATE OR REPLACE TRIGGER character_trigger AFTER INSERT ON character
FOR EACH ROW EXECUTE FUNCTION log_changes('character');

CREATE OR REPLACE TRIGGER phase_trigger AFTER INSERT ON phase
FOR EACH ROW EXECUTE FUNCTION log_changes('phase');

CREATE OR REPLACE TRIGGER weapon_trigger AFTER INSERT ON weapon
FOR EACH ROW EXECUTE FUNCTION log_changes('weapon');

CREATE OR REPLACE TRIGGER is_at_trigger AFTER INSERT ON is_at
FOR EACH ROW EXECUTE FUNCTION log_changes('is_at');

CREATE OR REPLACE TRIGGER has_trigger AFTER INSERT ON has
FOR EACH ROW EXECUTE FUNCTION log_changes('has');

-- Перегляд новоствореної таблиці, у яку заноситимуться дані
-- про нові зміни
SELECT * FROM audit_log;

CREATE OR REPLACE FUNCTION insert_default_phases()
RETURNS VOID AS $$
DECLARE
    char_lvl  phase.level%TYPE;
BEGIN
    FOR char_lvl IN SELECT UNNEST(ARRAY[1, 90])
    LOOP
        INSERT INTO phase (level, rised)
        VALUES 
            (1, 'N'),
            (90, 'N')
        ON CONFLICT (level, rised) DO NOTHING;
    END LOOP;
    
    FOR char_lvl IN SELECT UNNEST(ARRAY[20, 40, 50, 60, 70, 80])
    LOOP
        INSERT INTO phase (level, rised)
        VALUES 
            (char_lvl, 'N'),
            (char_lvl, 'Y')
        ON CONFLICT (level, rised) DO NOTHING;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Запуск циклу, наведеного вище (огорнутого в функцію)
SELECT insert_default_phases();

-- Перевірка внесених змін
SELECT * FROM audit_log;