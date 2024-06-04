-- Pelicula mas alquilada
SELECT f.film_id, f.title, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
ORDER BY rental_count DESC
LIMIT 1;

-- Pelicula menos alquilada
SELECT f.film_id, f.title, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
ORDER BY rental_count ASC
LIMIT 1;

-- 26. Mostrar los clientes que hayan alquilado la película mas alquilada conjuntamente con los 
-- clientes que hayan alquilado la menos alquilada con repeticiones, ordenados alfabéticamente 

SELECT c.first_name, c.last_name, f.title
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE f.title IN (
  SELECT film.title
  FROM film
  JOIN inventory ON film.film_id = inventory.film_id
  JOIN rental ON inventory.inventory_id = rental.inventory_id
  GROUP BY film.title
  ORDER BY COUNT(rental_id) DESC
  LIMIT 1
)
OR f.title IN (
  SELECT film.title
  FROM film
  JOIN inventory ON film.film_id = inventory.film_id
  JOIN rental ON inventory.inventory_id = rental.inventory_id
  GROUP BY film.title
  ORDER BY COUNT(rental_id) ASC
  LIMIT 1
)
ORDER BY c.first_name, c.last_name;

-- 27. Mostrar los clientes que hayan alquilado la película mas alquilada conjuntamente con los clientes 
-- que hayan alquilado la menos alquilada sin repeticiones, ordenados alfabéticamente. El unico cliente 
-- que se repite del listado anterior es ANA BRADLEY. Le agregamos nomas el DISTINCT para que solamente 
-- traiga las filas que no se repitan

SELECT DISTINCT
    (SELECT first_name FROM customer WHERE customer_id = c.customer_id),
    (SELECT last_name FROM customer WHERE customer_id = c.customer_id),
    f.title
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE f.title IN (
  SELECT film.title
  FROM film
  JOIN inventory ON film.film_id = inventory.film_id
  JOIN rental ON inventory.inventory_id = rental.inventory_id
  GROUP BY film.title
  ORDER BY COUNT(rental_id) DESC
  LIMIT 1
)
OR f.title IN (
  SELECT film.title
  FROM film
  JOIN inventory ON film.film_id = inventory.film_id
  JOIN rental ON inventory.inventory_id = rental.inventory_id
  GROUP BY film.title
  ORDER BY COUNT(rental_id) ASC
  LIMIT 1
)
ORDER BY (SELECT first_name FROM customer WHERE customer_id = c.customer_id),
         (SELECT last_name FROM customer WHERE customer_id = c.customer_id);

-- 28. Mostrar el/los clientes que hayan alquilado tanto la película mas alquilada como la menos alquilada.
 
SELECT DISTINCT
    c.first_name,
    c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
WHERE i.film_id IN (
    (
        SELECT film_id
        FROM film
        ORDER BY (
            SELECT COUNT(*) 
            FROM rental 
            WHERE inventory_id = i.inventory_id
        ) DESC
        LIMIT 1
    ),
    (
        SELECT film_id
        FROM film
        ORDER BY (
            SELECT COUNT(*)
            FROM rental
            WHERE inventory_id = i.inventory_id  
        ) ASC
        LIMIT 1
    )
)
ORDER BY c.first_name, c.last_name;

-- 29. Mostrar los clientes que alquilaron películas de la categoría 'New' los días en que se hayan alquilado 
-- más de 40 ejemplares de dicha categoría 

SELECT c.customer_id, c.first_name, c.last_name, DATE(r.rental_date) as rental_date
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category ca ON fc.category_id = ca.category_id
JOIN customer c ON r.customer_id = c.customer_id
WHERE ca.name = 'New' AND DATE(r.rental_date) IN (
    SELECT DATE(rental_date)
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category ca ON fc.category_id = ca.category_id
    WHERE ca.name = 'New'
    GROUP BY DATE(rental_date)
    HAVING COUNT(*) > 40
)
ORDER BY rental_date;


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
        FROM (
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
