-- QUERIES INICIALES

-- 1. Obtener el nombre, idioma original de la película, fecha de alquiler y fecha de devolución de todos los alquileres realizados por el cliente: Nombre: BARBARA Apellido: JONES (22 Filas)
select
    f.title,
    l.name,
    r.rental_date,
    r.return_date
from
    film as f
    inner join language as l on l.language_id = f.language_id
    inner join inventory as i on i.film_id = f.film_id
    inner join rental as r on r.inventory_id = i.inventory_id
    inner join customer as c on c.customer_id = r.customer_id
where
    c.first_name like "BARBARA"
    and c.last_name like "JONES";

-- 2. Mostrar Apellido, Nombre de los actores que participan en todas las películas de la categoría Comedy con y sin repetición (286 filas c/repetición) (147 filas s/repetición) [DISTINCT]
-- SIN DISTINCT
SELECT
    a.last_name,
    a.first_name
FROM
    actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    JOIN film f ON fa.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
WHERE
    c.name = 'Comedy';

-- CON DISTINCT
SELECT
    DISTINCT a.last_name,
    a.first_name
FROM
    actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    JOIN film f ON fa.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
WHERE
    c.name = 'Comedy';

-- 3. Obtener todos los datos de película en las que participo el actor de nombre : RAY  (30 filas)
SELECT
    f.*
FROM
    actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    JOIN film f ON fa.film_id = f.film_id
WHERE
    a.first_name = 'RAY';

-- 4. Obtener un listado de todas las películas cuya duración sea entre 61 y 99 minutos (ambos inclusive) y el lenguaje original sea French (9 rows)
SELECT
    f.*
FROM
    film f
    JOIN language l ON f.original_language_id = l.language_id
WHERE
    f.length BETWEEN 61
    AND 99
    AND l.name = 'French';

-- 5. Mostrar nombre ciudad y nombre de país (en MAYÚSCULAS) de todas las ciudades de los países (Austria, Chile, France) ordenadas por país luego nombre localidad (10 filas) [UPPER]
SELECT
    UPPER(c.city) AS city_name,
    UPPER(co.country) AS country_name
FROM
    city c
    JOIN country co ON c.country_id = co.country_id
WHERE
    co.country IN ('Austria', 'Chile', 'France')
ORDER BY
    co.country,
    c.city;

-- 6. Mostrar el apellido (minúsculas) concatenado al nombre (MAYÚSCULAS) cuyo apellido de los actores contenga SS. (7 Filas) [LIKE, UPPER, LOWER]
SELECT
    CONCAT(lower(last_name), ' ', upper(first_name))
from
    actor
WHERE
    last_name LIKE '%SS%';

-- 7. Mostrar el nro de ejemplar y nombre película de todos los alquileres del día 26 (sin importar mes) que sean del almacén de la ciudad Woodridge (99 filas) [Utilizando extract o date_part]
SELECT
    r.inventory_id,
    f.title
from
    rental r
    INNER JOIN inventory i ON r.inventory_id = i.inventory_id
    INNER JOIN film f ON i.film_id = f.film_id
    INNER JOIN store s ON s.store_id = i.store_id
    INNER JOIN address a ON a.address_id = s.address_id
    INNER JOIN city c ON c.city_id = a.city_id
WHERE
    c.city LIKE '%Woodridge%'
    and extract(
        DAY
        FROM
            r.rental_date
    ) = 26;

-- 8. Mostrar la segunda pagina (cada una tiene 10 películas) del listado nombre de la película , lenguaje original y valor de reposición de la películas ordenadas por su valor de reposición del mas caro al mas barato (10 filas) [LIMIT, OFFSET y ORDER]
SELECT
    f.title,
    f.original_language_id,
    f.replacement_cost
from
    film f
ORDER BY
    replacement_cost DESC OFFSET 10
LIMIT
    10;

-- 9. Mostrar el nombre de la película, el nombre del cliente, nro de ejemplar, fecha de alquiler, fecha de devolución de los ejemplares que demoraron mas de 7 días en ser devueltos (3557 filas) [AGE]
SELECT
    f.title AS film_title,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    i.inventory_id AS copy_number,
    DATE(r.rental_date) AS rental_date,
    DATE(r.return_date) AS return_date
FROM
    rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN customer c ON r.customer_id = c.customer_id
WHERE
    AGE(DATE(r.return_date), DATE(r.rental_date)) > INTERVAL '7 days'
ORDER BY
    DATE(r.rental_date);

-- QUERIES INTERMEDIAS

--10. Mostrar todas las películas que están alquiladas y que todavía no fueron devueltas. Mostrando el nombre de la película, el número de ejemplar, quien la alquilo y la fecha. Mostrar el nombre del cliente de la manera Apellido, Nombre y renombre el campo como 'nombre_cliente'
select
    f.title titulo,
    i.inventory_id ejemplar_pelicula,
    concat(c.last_name, ', ', c.first_name) cliente,
    r.rental_date fecha_de_renta
from
    film f
    inner join inventory i on i.film_id = f.film_id
    inner join rental r on r.inventory_id = i.inventory_id
    inner join customer c on c.customer_id = r.customer_id
where
    r.return_date is null;

--11. Mostrar cuales fueron las 10 películas mas alquiladas 
select
    f.title,
    count(f.film_id) cantidad
from
    film f
    inner join inventory i on i.film_id = f.film_id
    inner join rental r on r.inventory_id = i.inventory_id
group by
    f.film_id
order by
    cantidad desc
limit
    10;

--12. Realizar un listado de las películas que fueron alquiladas por el cliente "OWENS, CARMEN" 
select
    f.title,
    r.rental_date
from
    film f
    inner join inventory i on i.film_id = f.film_id
    inner join rental r on r.inventory_id = i.inventory_id
    inner join customer c on c.customer_id = r.customer_id
where
    first_name like 'CARMEN'
    and last_name like 'OWENS'
order by
    f.title asc;

-- 13. Buscar los pagos que no han sido asignados a ningún alquiler 
SELECT
    p.*
FROM
    payment p
    LEFT JOIN rental r ON p.rental_id = r.rental_id
WHERE
    r.rental_id IS NULL;

--14. Seleccionar todas las películas que son en "Mandarin" y listar las por orden alfabético. Mostrando el titulo de la película y el idioma ingresando el idioma en minúsculas.
select
    f.title titulo,
    LOWER(l.name) idioma
from
    film f
    inner join language l on l.language_id = f.language_id
where
    l.name like 'Mandarin'
order by
    f.title asc;

-- 15. Mostrar los clientes que hayan alquilado mas de 1 vez la misma película
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    f.film_id,
    f.title,
    COUNT(*) as rental_count
FROM
    rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN customer c ON r.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    f.film_id
HAVING
    COUNT(*) > 1;

-- 16. Mostrar los totales de alquileres por mes del año 2005 
SELECT
    EXTRACT(
        MONTH
        FROM
            rental_date
    ) AS month,
    COUNT(*) as rental_count
FROM
    rental
WHERE
    EXTRACT(
        YEAR
        FROM
            rental_date
    ) = 2005
GROUP BY
    month
ORDER BY
    month;

-- 17. Mostrar los totales históricos de alquileres discriminados por categoría. Ordene los resultados por el campo monto en orden descendente al campo calculado llamarlo monto. 
SELECT
    ca.name AS category,
    SUM(p.amount) AS monto
FROM
    rental r
    JOIN payment p ON r.rental_id = p.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category ca ON fc.category_id = ca.category_id
GROUP BY
    ca.name
ORDER BY
    monto DESC;

-- 18. Listar todos los actores de las películas alquiladas en el periodo 7 del año 2005. Ordenados alfabéticamente representados "APELLIDO, nombre" renombrar el campo como Actor 
SELECT
    CONCAT(a.last_name, ', ', a.first_name) AS Actor
FROM
    rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_actor fa ON f.film_id = fa.film_id
    JOIN actor a ON fa.actor_id = a.actor_id
WHERE
    EXTRACT(
        YEAR
        FROM
            r.rental_date
    ) = 2005
    AND EXTRACT(
        MONTH
        FROM
            r.rental_date
    ) = 7
GROUP BY
    a.actor_id
ORDER BY
    Actor;

-- 19. Listar el monto gastado por el customer last_name=SHAW; first_name=CLARA; 
SELECT
    CONCAT(a.last_name, ', ', a.first_name) AS Actor
FROM
    rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_actor fa ON f.film_id = fa.film_id
    JOIN actor a ON fa.actor_id = a.actor_id
WHERE
    EXTRACT(
        YEAR
        FROM
            r.rental_date
    ) = 2005
    AND EXTRACT(
        MONTH
        FROM
            r.rental_date
    ) = 7
GROUP BY
    a.actor_id
ORDER BY
    Actor;

--20.
SELECT
    concat(c.last_name, ', ', c.first_name) cliente,
    p.amount pago_maximo
FROM
    payment p
    inner join rental r on r.rental_id = p.rental_id
    inner join customer c on c.customer_id = p.customer_id
where
    extract(
        YEAR
        from
            payment_date
    ) = 2005
order by
    amount desc
limit
    1;

--21. Listar el monto gastado por los customer que hayan gastado mas de 40 en el mes 6 de 2005.
SELECT
    p.customer_id,
    SUM(p.amount) AS total_amount
FROM
    payment p
WHERE
    EXTRACT(
        YEAR
        FROM
            p.payment_date
    ) = 2005
    AND EXTRACT(
        MONTH
        FROM
            p.payment_date
    ) = 6
GROUP BY
    p.customer_id
HAVING
    SUM(p.amount) > 40
ORDER BY
    total_amount DESC;

--22. Mostrar la cantidad del clientes hay por ciudad 
SELECT
    ci.city,
    COUNT(c.customer_id) AS cantidad_clientes
FROM
    customer c
    JOIN address a ON c.address_id = a.address_id
    JOIN city ci ON a.city_id = ci.city_id
GROUP BY
    ci.city
ORDER BY
    cantidad_clientes DESC;

--23. Mostrar las 5 películas con mayor cantidad de actores. 
SELECT
    f.title,
    COUNT(fa.actor_id) AS actor_count
FROM
    film f
    JOIN film_actor fa ON f.film_id = fa.film_id
GROUP BY
    f.film_id,
    f.title
ORDER BY
    actor_count DESC
LIMIT
    5;

--24. Mostrar los días donde se hayan alquilado mas de 10 de películas de "Drama" 
SELECT
    DATE(r.rental_date) AS fecha_renta,
    COUNT(r.rental_id) AS contador_renta
FROM
    rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
WHERE
    c.name = 'Drama'
GROUP BY
    fecha_renta
HAVING
    COUNT(r.rental_id) > 10
ORDER BY
    fecha_renta;

--25. Mostrar los actores que no están en ninguna película 
SELECT
    a.actor_id,
    a.first_name,
    a.last_name
FROM
    actor a
    LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE
    fa.actor_id IS NULL;

-- QUERIES AVANZADAS

-- Pelicula mas alquilada
SELECT
    f.film_id,
    f.title,
    COUNT(r.rental_id) AS rental_count
FROM
    film f
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY
    f.film_id,
    f.title
ORDER BY
    rental_count DESC
LIMIT
    1;

-- Pelicula menos alquilada
SELECT
    f.film_id,
    f.title,
    COUNT(r.rental_id) AS rental_count
FROM
    film f
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY
    f.film_id,
    f.title
ORDER BY
    rental_count ASC
LIMIT
    1;

-- 26. Mostrar los clientes que hayan alquilado la película mas alquilada conjuntamente con los 
-- clientes que hayan alquilado la menos alquilada con repeticiones, ordenados alfabéticamente 
SELECT
    c.first_name,
    c.last_name,
    f.title
FROM
    customer c
    JOIN rental r ON c.customer_id = r.customer_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
WHERE
    f.title IN (
        SELECT
            film.title
        FROM
            film
            JOIN inventory ON film.film_id = inventory.film_id
            JOIN rental ON inventory.inventory_id = rental.inventory_id
        GROUP BY
            film.title
        ORDER BY
            COUNT(rental_id) DESC
        LIMIT
            1
    )
    OR f.title IN (
        SELECT
            film.title
        FROM
            film
            JOIN inventory ON film.film_id = inventory.film_id
            JOIN rental ON inventory.inventory_id = rental.inventory_id
        GROUP BY
            film.title
        ORDER BY
            COUNT(rental_id) ASC
        LIMIT
            1
    )
ORDER BY
    c.first_name,
    c.last_name;

-- 27. Mostrar los clientes que hayan alquilado la película mas alquilada conjuntamente con los clientes 
-- que hayan alquilado la menos alquilada sin repeticiones, ordenados alfabéticamente. El unico cliente 
-- que se repite del listado anterior es ANA BRADLEY. Le agregamos nomas el DISTINCT para que solamente 
-- traiga las filas que no se repitan
SELECT
    DISTINCT (
        SELECT
            first_name
        FROM
            customer
        WHERE
            customer_id = c.customer_id
    ),
    (
        SELECT
            last_name
        FROM
            customer
        WHERE
            customer_id = c.customer_id
    ),
    f.title
FROM
    customer c
    JOIN rental r ON c.customer_id = r.customer_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
WHERE
    f.title IN (
        SELECT
            film.title
        FROM
            film
            JOIN inventory ON film.film_id = inventory.film_id
            JOIN rental ON inventory.inventory_id = rental.inventory_id
        GROUP BY
            film.title
        ORDER BY
            COUNT(rental_id) DESC
        LIMIT
            1
    )
    OR f.title IN (
        SELECT
            film.title
        FROM
            film
            JOIN inventory ON film.film_id = inventory.film_id
            JOIN rental ON inventory.inventory_id = rental.inventory_id
        GROUP BY
            film.title
        ORDER BY
            COUNT(rental_id) ASC
        LIMIT
            1
    )
ORDER BY
    (
        SELECT
            first_name
        FROM
            customer
        WHERE
            customer_id = c.customer_id
    ),
    (
        SELECT
            last_name
        FROM
            customer
        WHERE
            customer_id = c.customer_id
    );

-- 28. Mostrar el/los clientes que hayan alquilado tanto la película mas alquilada como la menos alquilada.
SELECT
    DISTINCT c.first_name,
    c.last_name
FROM
    customer c
    JOIN rental r ON c.customer_id = r.customer_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
WHERE
    i.film_id IN (
        (
            SELECT
                film_id
            FROM
                film
            ORDER BY
                (
                    SELECT
                        COUNT(*)
                    FROM
                        rental
                    WHERE
                        inventory_id = i.inventory_id
                ) DESC
            LIMIT
                1
        ), (
            SELECT
                film_id
            FROM
                film
            ORDER BY
                (
                    SELECT
                        COUNT(*)
                    FROM
                        rental
                    WHERE
                        inventory_id = i.inventory_id
                ) ASC
            LIMIT
                1
        )
    )
ORDER BY
    c.first_name,
    c.last_name;

-- 29. Mostrar los clientes que alquilaron películas de la categoría 'New' los días en que se hayan alquilado 
-- más de 40 ejemplares de dicha categoría 
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    DATE(r.rental_date) as rental_date
FROM
    rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category ca ON fc.category_id = ca.category_id
    JOIN customer c ON r.customer_id = c.customer_id
WHERE
    ca.name = 'New'
    AND DATE(r.rental_date) IN (
        SELECT
            DATE(rental_date)
        FROM
            rental r
            JOIN inventory i ON r.inventory_id = i.inventory_id
            JOIN film f ON i.film_id = f.film_id
            JOIN film_category fc ON f.film_id = fc.film_id
            JOIN category ca ON fc.category_id = ca.category_id
        WHERE
            ca.name = 'New'
        GROUP BY
            DATE(rental_date)
        HAVING
            COUNT(*) > 40
    )
ORDER BY
    rental_date;

-- 30. Mostrar los días que se hayan alquilado películas (cantidad) por encima de la media de alquileres diaria 
-- ordenado por la cantidad de alquileres.
SELECT
    r.rental_date,
    COUNT(r.rental_id) AS rental_count
FROM
    rental r
GROUP BY
    r.rental_date
HAVING
    COUNT(r.rental_id) > (
        SELECT
            AVG(rental_count)
        FROM
            (
                SELECT
                    r.rental_date,
                    COUNT(r.rental_id) AS rental_count
                FROM
                    rental r
                GROUP BY
                    r.rental_date
            ) AS daily_rentals
    )
ORDER BY
    rental_count DESC;