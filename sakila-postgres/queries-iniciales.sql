-- 1. Obtener el nombre, idioma original de la película, fecha de alquiler y fecha de devolución de todos los alquileres realizados por el cliente: Nombre: BARBARA Apellido: JONES (22 Filas)













-- 2. Mostrar Apellido, Nombre de los actores que participan en todas las películas de la categoría Comedy con y sin repetición (286 filas c/repetición) (147 filas s/repetición) [DISTINCT]
-- 3. Obtener todos los datos de película en las que participo el actor de nombre : RAY  (30 filas)
-- 4. Obtener un listado de todas las películas cuya duración sea entre 61 y 99 minutos (ambos inclusive) y el lenguaje original sea French (9 rows)
-- 5. Mostrar nombre ciudad y nombre de país (en MAYÚSCULAS) de todas las ciudades de los países (Austria, Chile, France) ordenadas por país luego nombre localidad (10 filas) [UPPER]
-- 6. Mostrar el apellido (minúsculas) concatenado al nombre (MAYÚSCULAS) cuyo apellido de los actores contenga SS. (7 Filas) [LIKE, UPPER, LOWER]
-- 7. Mostrar el nro de ejemplar y nombre película de todos los alquileres del día 26 (sin importar mes) que sean del almacén de la ciudad Woodridge (99 filas) [Utilizando extract o date_part]
-- 8. Mostrar la segunda pagina (cada una tiene 10 películas) del listado nombre de la película , lenguaje original y valor de reposición de la películas ordenadas por su valor de reposición del mas caro al mas barato (10 filas) [LIMIT, OFFSET y ORDER]
-- 9. Mostrar el nombre de la película, el nombre del cliente, nro de ejemplar, fecha de alquiler, fecha de devolución de los ejemplares que demoraron mas de 7 días en ser devueltos (3557 filas) [AGE]