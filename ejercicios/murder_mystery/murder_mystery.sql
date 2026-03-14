/*
Desde el CMD descargar la base de datos
sqlcmd -S localhost -E -i "C:\Users\HP\Documents\base-de-datos\ejercicios\murder_mystery\data\sql_murder_mystery.sql"

CASO: 
Se ha cometido un crimen y necesitas encontrar al culpable.
Todo lo que sabes es que el crimen fue un asesinato (murder),
ocurrió el 15 de enero de 2018 y tuvo lugar en SQL City.

Empieza consultando la tabla crime_scene_report para obtener
más información. Luego usa las demás tablas para resolver el misterio.

Para verificar tu respuesta, ejecuta:
  INSERT INTO solution ("user", value) VALUES (1, 'Nombre del Sospechoso');
  SELECT value FROM solution;
*/

USE sql_murder_mystery;
GO

-- Obtener las tablas

SELECT TABLE_NAME as tablas
FROM INFORMATION_SCHEMA.TABLES

-- 1. Consultamos cuantos asesinatos ocurren en esa fecha, 
-- Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave".

SELECT *
FROM crime_scene_report
WHERE date = '20180115' AND type= 'murder' AND city = 'SQL City'

-- 2. Investigamos a los 2 sospechosos

SELECT *
FROM person
WHERE address_street_name = 'Northwestern Dr'

SELECT *
FROM person
WHERE address_street_name = 'Franklin Ave' AND name like 'Annabel%'

/*
3. Investigar la declaración la mujer sospechosa con id 16371
I saw the murder happen, and I recognized the killer from my gym when 
I was working out last week on January the 9th.
*/
SELECT *
FROM interview
WHERE person_id = 16371

/*
4. Revisar quienes ingresaron al gimnasio en esa fecha y revisar las declaraciones de cada uno
15247
28073
55662
10815
83186
31523
92736
67318
16371
*/

SELECT *
FROM person as p
INNER JOIN get_fit_now_member as gm ON (p.id = gm.person_id)
INNER JOIN get_fit_now_check_in gc ON (gm.id = gc.membership_id)
WHERE gc.check_in_date = '20180109'

SELECT *
FROM interview
WHERE person_id IN (15247, 28073, 55662, 10815, 83186, 31523, 92736, 67318, 16371)

-- El asesino es Jeremy Bowers 
SELECT *
FROM person
WHERE id = 67318

/*
5. Congrats, you found the murderer! But wait, there is more... If you think you are up for a challenge, 
try querying the interview transcript of the murderer to find the real villain behind this crime. 
If you feel especially confident in your SQL skills, try to complete this final step with no more than 2 queries. 
Use this same INSERT statement with your new suspect to check your answer.

Encontrar al verdadero culpable en el evento SQL Symphony Concert, No sé su nombre, pero sé que mide entre 1,65 y 
1,70 m. Es pelirroja y conduce un Tesla Model S. Sé que asistió al concierto sinfónico de SQL tres veces en diciembre 
de 2017
*/
SELECT *
FROM facebook_event_checkin as f 
INNER JOIN person as p ON(f.person_id = p.id) 
INNER JOIN drivers_license as dl ON (p.license_id = dl.id)
WHERE gender = 'female' AND event_name = 'SQL Symphony Concert' AND hair_color = 'red'
AND car_make = 'Tesla'


-- Probar
INSERT INTO solution ([user], value) VALUES (1, 'Jeremy Bowers');
SELECT value FROM solution;
GO
INSERT INTO solution ([user], value) VALUES (1, 'Miranda Priestly');
SELECT value FROM solution;
GO

-- Limpiar solución
DELETE FROM solution;
GO