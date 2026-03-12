USE music_stream;

-- ======================================================
/* 1. El Semáforo de Popularidad

Clasificación de los artistas según su número de listeners, transformando un dato numérico en una categoría más visual.

Utilizamos CASE WHEN para asignar un estado de industria en tres niveles: Leyenda, Consolidado o Emergente. 
CONCAT permite construir una etiqueta final más descriptiva. 
ORDER BY prioriza los artistas con mayor relevancia para que las categorías más altas aparezcan primero. */
-- ======================================================

SELECT nombre AS nombre_artista, listeners AS oyentes,
	CASE 
        WHEN listeners > 7000000 THEN '⭐⭐⭐ Superestrella Global'
        WHEN listeners BETWEEN 1000000 AND 7000000 THEN '⭐⭐ Artista Consolidado'
        ELSE '⭐ Promesa Emergente'
    END AS "Ranking Comercial"
	FROM artistas
    WHERE listeners >= (SELECT AVG(listeners) 
							FROM artistas)
	ORDER BY listeners DESC
    LIMIT 500;


-- ======================================================
/* 2. "Club de los géneros exclusivos"

Identificamos a los artistas con canciones en un único genero musical, por ejemplo, rap. 
Mostramos su nombre, el género en el que está especializado y su playcount.

Unimos artistas con canciones a través de un INNER JOIN.
A través de GROUP BY contamos cuántos géneros distintos tiene cada artista.
Con HAVING filtramos aquellos artistas con un solo género y con un playcount superior al promedio general de la tabla artistas. 
El resultado final se ordena de mayor a menor playcount. */
-- ======================================================

SELECT artist_name, genre AS genero             
	FROM canciones
    WHERE  genre = 'Rap'
	GROUP BY artist_name;

SELECT a.nombre, MAX(c.genre) AS genero, a.playcount
	FROM artistas AS a
	INNER JOIN canciones AS c            
		ON a.nombre = c.artist_name
	GROUP BY a.nombre, a.playcount
	HAVING COUNT(DISTINCT c.genre) = 1 AND MAX(c.genre) = 'Rap' AND a.playcount > ( SELECT AVG(playcount)
																						FROM artistas)
	ORDER BY a.playcount DESC             
	LIMIT 5;


-- ======================================================
/* 3. Artistas con más canciones que la media del catálogo

Identificamos a los artistas cuyo número total de canciones supera el promedio de canciones por artista.

Agrupamos con GROUP BY las canciones por artista para calcular cuántas tiene cada uno. 
A través de una subconsulta, calculamos la media de canciones por artista. 
Con HAVING comparamos el total de cada artista con ese promedio y devolvemos solo los que estén por encima de la media. 
Ordenamos el resultado de mayor a menor. */
-- ======================================================

SELECT artist_name AS nombre_artista,
	COUNT(*) AS total_canciones
	FROM canciones
    GROUP BY artist_name
    HAVING COUNT(*) > ( 
		SELECT AVG(total_temas) 
			FROM (
				SELECT COUNT(*) AS total_temas  
					FROM canciones
					GROUP BY artist_name) AS sub)
					ORDER BY total_canciones DESC; 


-- ======================================================
/* 4. Matriz de Géneros por Artista

Reporte de perfilado que identifica el género principal de cada artista y determina si tiene canciones en más de un género musical.

Se utilizan subconsultas en el SELECT:
- Una para obtener el género más frecuente del artista.
- Otra para contar los géneros distintos y clasificarlo como multigénero.

Evaluamos la especialización o versatilidad de los artistas dentro del catálogo. */
-- ======================================================

SELECT a.nombre AS artista,
    (SELECT genre
        FROM canciones
        WHERE artist_name = a.nombre
        GROUP BY genre
        ORDER BY COUNT(*) DESC
        LIMIT 1) AS genero_principal,
    CASE
        WHEN (SELECT COUNT(DISTINCT genre)
            FROM canciones
            WHERE artist_name = a.nombre) > 1 THEN 'Sí'
        ELSE 'No'
    END AS multigenero
	FROM artistas AS a;


-- ======================================================
/* 5. Clasificación de popularidad de artistas

Unimos las tablas artistas y canciones a través de un INNER JOIN para obtener información del artista y género de sus canciones.

Evitamos duplicados con DISTINCT para que un mismo artista pueda tener varias canciones registradas en el catálogo.

Clasificamos a los artistas con CASE según su número de listeners en dos niveles de popularidad: 
'Mayor' si superan el valor de referencia y, 'Menor' en caso contrario. */
-- ======================================================

SELECT DISTINCT 
    a.nombre AS artista,
    c.genre AS genero,
    a.listeners AS popularidad,
    CASE
        WHEN a.listeners >= 439532.36 THEN 'Mayor'
        ELSE 'Menor'
    END AS nivel_popularidad
	FROM artistas AS a
	INNER JOIN canciones AS c
		ON a.nombre = c.artist_name;


-- ======================================================
/* 6. Clasificación de artistas según número de canciones

Agrupamos con GROUP BY canciones por artista y calculamos cuántas canciones tiene cada uno con COUNT(id). 
Clasificamos los resultados con CASE en tres rangos: entre 1 y 5 canciones, entre 6 y 10 canciones, o más de 10 canciones. */
-- ======================================================

SELECT artist_name AS artista,
	CASE 
		WHEN COUNT(id) BETWEEN 1 AND 5 THEN "1-5"
        WHEN COUNT(id) BETWEEN 6 AND 10 THEN "6-10"
        ELSE "+10"
        END AS total_canciones
	FROM canciones
    GROUP BY artist_name;


-- ======================================================
/* 7. Artista con más canciones en un mismo año

Queremos conocer qué artista tiene más canciones en un año concreto. 
Agrupamos los registros de la tabla canciones por artista y año, contando cuántas canciones aparecen en cada combinación a través de GROUP BY.

El resultado muestra el nombre del artista, el año y el número total de canciones en ese años. 
Los resultados se ordenan de mayor a menor para destacar los casos con mayor volumen de producción anual.
Utilizamos LIMIT para mostrar únicamente los artistas con más actividad. */
-- ======================================================

SELECT artist_name, year, COUNT(*) AS total_canciones
	FROM canciones
	GROUP BY artist_name, year
	ORDER BY total_canciones DESC;


-- ======================================================
/* 8. Canción más reciente de cada artista

Calculamos, mediante una subconsulta, el año más reciente de publicación para cada artista utilizando MAX(year). 
Unimos la subconsulta con la tabla canciones a través de un INNER JOIN para obtener toda la información de la canción correspondiente a ese año. 

Ordenamos los resultados alfabéticamente por artista.*/
-- ======================================================

SELECT c.artist_name AS artista,
	   c.track_name AS cancion,
       c.year AS año
	FROM canciones AS c
	INNER JOIN (SELECT artist_name, MAX(YEAR) AS mas_reciente 
			FROM canciones
			GROUP BY artist_name) AS m
	ON c.artist_name = m.artist_name AND c.year = m.mas_reciente
	ORDER BY c.artist_name;


-- ======================================================
/* 9. Canciones con mismo título interpretadas por distintos artistas y pertenecientes a otros géneros

Agrupamos los registros de la tabla canciones por track_name.
Con GROUP_CONCAT mostramos en una única fila los artistas y géneros relacionados con esa misma canción. 
Calculamos el total de artistas y géneros con COUNT(DISTINCT).

Filtramos con HAVING los casos en los que una canción tiene más de un artista y más de un género.

Ordenamos los resultados por el número de géneros distintos de forma descendente para destacar los títulos con mayor diversidad musical. */
-- ======================================================

SELECT 
    track_name AS cancion, 
    GROUP_CONCAT(DISTINCT artist_name ORDER BY artist_name SEPARATOR ', ') AS artistas,
    GROUP_CONCAT(DISTINCT genre ORDER BY genre SEPARATOR ' / ') AS generos,
    COUNT(DISTINCT artist_name) AS total_artistas,
    COUNT(DISTINCT genre) AS total_generos
	FROM canciones
	GROUP BY track_name
	HAVING COUNT(DISTINCT artist_name) > 1 
	   AND COUNT(DISTINCT genre) > 1
	ORDER BY COUNT(DISTINCT genre) DESC;


-- ======================================================
/* 10. Auditoría de Datos: Canciones Fantasma

Buscamos canciones cuyo artist_name no encuentra correspondencia en la tabla artistas. 
Este caso señalaría un posible fallo de integridad referencial o una carga inconsistente de datos.

Utilizamos LEFT JOIN de canciones hacia artistas y filtramos los registros que no tienen artista asociado. */
-- ======================================================

SELECT a.nombre AS nombre_artista
	FROM artistas AS a
    LEFT JOIN canciones AS c
		ON a.nombre = c.artist_name
	WHERE c.id IS NULL;