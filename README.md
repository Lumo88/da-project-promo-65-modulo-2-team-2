# 🎵 LOLAVAN MUSIC: Data Engineering & Analytics
### Proyecto Final de SQL y Python | Equipo LOLAVAN

![Logo de LOLAVAN MUSIC](https://via.placeholder.com/800x200?text=LOLAVAN+MUSIC+PROYECTO+SQL) 
*(Sugerencia: Sube tu logo a la carpeta del repo y cambia este enlace por el nombre del archivo)*

## 👥 Nuestro Equipo
**LOLAVAN** nace de la sinergia de nuestras integrantes:
* **LO** - Lorena Serra - Lourdes Moya 
* **LA** - Laura Mulero
* **VA** - Valeria Mora
* **AN** - Ana María García


---

## 🚀 Descripción del Proyecto
Este ecosistema de datos ha sido diseñado para integrar, procesar y analizar la industria musical comprendida desde 2020 y 2026. Combinamos datos de **Spotify** y **Last.fm** para construir una base de datos relacional robusta que permite realizar análisis de KPIs, popularidad y versatilidad de artistas en 5 géneros musicales.

## 🛠️ Pipeline de Datos (ETL)
El proyecto cubre el ciclo de vida completo del dato:

1.  **Extracción e Ingesta:** * Procesamiento de ficheros JSON extraídos de la API de **Spotify**.
    * Enriquecimiento de perfiles de artistas mediante la API de **Last.fm**.
2.  **Modelado de Datos:** * Diseño de un diagrama Entidad-Relación (ER) normalizado.
    * Definición de esquemas, claves primarias y foráneas para garantizar la integridad.
3.  **Carga Automatizada:** * Implementación de scripts en **Python** para la limpieza e inserción masiva de datos en el servidor SQL.

---

## 📊 Consultas Analíticas (Business Intelligence)
Hemos desarrollado una serie de consultas avanzadas que resuelven retos de negocio:

### 🚦 El Semáforo de Popularidad
Un sistema de reporting de KPIs que clasifica el éxito de las canciones para la toma de decisiones comerciales.

### 🧩 El "Club de los Géneros Exclusivos"
Identificación de artistas "puristas" mediante subconsultas que comparan su rendimiento individual frente a la media global de reproducciones.

### 🕵️ Auditoría de Datos: "Huérfanos y Fantasmas"
Implementación de controles de calidad mediante `LEFT JOIN` e `IS NULL` para detectar inconsistencias en la base de datos y asegurar un entorno de datos "limpio".

### 🏆 El "Top Hit" por Artista
Resolución técnica compleja: extracción del éxito principal de cada artista sin utilizar funciones de ventana, optimizando mediante subconsultas correlacionadas.

---

## 💻 Ejemplo de Lógica SQL Destacada

Para encontrar artistas con más canciones que la media global, implementamos la siguiente lógica de subconsultas:

```sql
SELECT a.name AS "Artista", COUNT(s.id) AS "Total Canciones"
FROM artists a
JOIN songs s ON a.id = s.artist_id
GROUP BY a.name
HAVING COUNT(s.id) > (
    SELECT AVG(song_count) 
    FROM (SELECT COUNT(id) AS song_count FROM songs GROUP BY artist_id) AS sub
);
