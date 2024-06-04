-- 1. Obtener el nombre, idioma original de la película, fecha de alquiler y fecha de devolución de todos los alquileres realizados por el cliente: Nombre: BARBARA Apellido: JONES (22 Filas)

select f.title, l.name, r.rental_date, r.return_date from film as f
inner join language as l on l.language_id = f.language_id
inner join inventory as i on i.film_id = f.film_id
inner join rental as r on r.inventory_id = i.inventory_id
inner join customer as c on c.customer_id = r.customer_id
where c.first_name like "BARBARA" and c.last_name like "JONES";

-- 2. Mostrar Apellido, Nombre de los actores que participan en todas las películas de la categoría Comedy con y sin repetición (286 filas c/repetición) (147 filas s/repetición) [DISTINCT]

-- SIN DISTINCT
SELECT a.last_name, a.first_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Comedy';

-- CON DISTINCT
SELECT DISTINCT a.last_name, a.first_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Comedy';

-- 3. Obtener todos los datos de película en las que participo el actor de nombre : RAY  (30 filas)

SELECT f.*
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE a.first_name = 'RAY';

-- 4. Obtener un listado de todas las películas cuya duración sea entre 61 y 99 minutos (ambos inclusive) y el lenguaje original sea French (9 rows)

SELECT f.*
FROM film f
JOIN language l ON f.original_language_id = l.language_id
WHERE f.length BETWEEN 61 AND 99
AND l.name = 'French';

-- 5. Mostrar nombre ciudad y nombre de país (en MAYÚSCULAS) de todas las ciudades de los países (Austria, Chile, France) ordenadas por país luego nombre localidad (10 filas) [UPPER]

SELECT UPPER(c.city) AS city_name, UPPER(co.country) AS country_name
FROM city c
JOIN country co ON c.country_id = co.country_id
WHERE co.country IN ('Austria', 'Chile', 'France')
ORDER BY co.country, c.city;


-- 6. Mostrar el apellido (minúsculas) concatenado al nombre (MAYÚSCULAS) cuyo apellido de los actores contenga SS. (7 Filas) [LIKE, UPPER, LOWER]

SELECT CONCAT(lower(last_name) ,' ',upper(first_name)) from actor
WHERE last_name LIKE '%SS%';

-- 7. Mostrar el nro de ejemplar y nombre película de todos los alquileres del día 26 (sin importar mes) que sean del almacén de la ciudad Woodridge (99 filas) [Utilizando extract o date_part]

SELECT r.inventory_id, f.title from rental r
    INNER JOIN inventory i ON r.inventory_id = i.inventory_id
    INNER JOIN  film f ON i.film_id = f.film_id
    INNER JOIN store s ON s.store_id = i.store_id
    INNER JOIN address a ON a.address_id = s.address_id
    INNER JOIN city c ON c.city_id = a.city_id
WHERE c.city LIKE '%Woodridge%' and extract(DAY FROM r.rental_date) = 26;

-- 8. Mostrar la segunda pagina (cada una tiene 10 películas) del listado nombre de la película , lenguaje original y valor de reposición de la películas ordenadas por su valor de reposición del mas caro al mas barato (10 filas) [LIMIT, OFFSET y ORDER]

SELECT f.title, f.original_language_id, f.replacement_cost from film f
ORDER BY replacement_cost DESC
OFFSET 10
LIMIT 10; 

-- 9. Mostrar el nombre de la película, el nombre del cliente, nro de ejemplar, fecha de alquiler, fecha de devolución de los ejemplares que demoraron mas de 7 días en ser devueltos (3557 filas) [AGE]

SELECT f.title AS film_title,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       i.inventory_id AS copy_number,
       DATE(r.rental_date) AS rental_date,
       DATE(r.return_date) AS return_date
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id
WHERE AGE(DATE(r.return_date), DATE(r.rental_date)) > INTERVAL '7 days'
ORDER BY DATE(r.rental_date);