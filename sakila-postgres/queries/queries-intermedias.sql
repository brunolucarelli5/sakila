--10. Mostrar todas las películas que están alquiladas y que todavía no fueron devueltas. Mostrando el nombre de la película, el número de ejemplar, quien la alquilo y la fecha. Mostrar el nombre del cliente de la manera Apellido, Nombre y renombre el campo como 'nombre_cliente'

select f.title titulo, i.inventory_id ejemplar_pelicula, concat(c.last_name, ', ', c.first_name) cliente, r.rental_date fecha_de_renta from film f
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
inner join customer c on c.customer_id = r.customer_id
where r.return_date is null;

--11. Mostrar cuales fueron las 10 películas mas alquiladas 

select f.title, count(f.film_id) cantidad from film f
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
group by f.film_id order by cantidad desc limit 10;

--12. Realizar un listado de las películas que fueron alquiladas por el cliente "OWENS, CARMEN" 

select f.title, r.rental_date from film f
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
inner join customer c on c.customer_id = r.customer_id
where first_name like 'CARMEN' and last_name like 'OWENS'
order by f.title asc;

-- 13. Buscar los pagos que no han sido asignados a ningún alquiler 

SELECT p.*
FROM payment p
LEFT JOIN rental r ON p.rental_id = r.rental_id
WHERE r.rental_id IS NULL;

--14. Seleccionar todas las películas que son en "Mandarin" y listar las por orden alfabético. Mostrando el titulo de la película y el idioma ingresando el idioma en minúsculas.

select f.title titulo, LOWER(l.name) idioma from film f
inner join language l on l.language_id = f.language_id
where l.name like 'Mandarin'
order by f.title asc;

-- 15. Mostrar los clientes que hayan alquilado mas de 1 vez la misma película

SELECT c.customer_id, c.first_name, c.last_name, f.film_id, f.title, COUNT(*) as rental_count
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id
GROUP BY c.customer_id, f.film_id
HAVING COUNT(*) > 1;

-- 16. Mostrar los totales de alquileres por mes del año 2005 

SELECT EXTRACT(MONTH FROM rental_date) AS month, COUNT(*) as rental_count
FROM rental
WHERE EXTRACT(YEAR FROM rental_date) = 2005
GROUP BY month
ORDER BY month;

-- 17. Mostrar los totales históricos de alquileres discriminados por categoría. Ordene los resultados por el campo monto en orden descendente al campo calculado llamarlo monto. 

SELECT ca.name AS category, SUM(p.amount) AS monto
FROM rental r
JOIN payment p ON r.rental_id = p.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category ca ON fc.category_id = ca.category_id
GROUP BY ca.name
ORDER BY monto DESC;

-- 18. Listar todos los actores de las películas alquiladas en el periodo 7 del año 2005. Ordenados alfabéticamente representados "APELLIDO, nombre" renombrar el campo como Actor 

SELECT CONCAT(a.last_name, ', ', a.first_name) AS Actor
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE EXTRACT(YEAR FROM r.rental_date) = 2005 AND EXTRACT(MONTH FROM r.rental_date) = 7
GROUP BY a.actor_id
ORDER BY Actor;

-- 19. Listar el monto gastado por el customer last_name=SHAW; first_name=CLARA; 

SELECT CONCAT(a.last_name, ', ', a.first_name) AS Actor
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE EXTRACT(YEAR FROM r.rental_date) = 2005 AND EXTRACT(MONTH FROM r.rental_date) = 7
GROUP BY a.actor_id
ORDER BY Actor;

--20.

SELECT concat(c.last_name, ', ',c.first_name) cliente, p.amount pago_maximo FROM payment p
inner join rental r on r.rental_id = p.rental_id
inner join customer c on c.customer_id = p.customer_id
where extract(YEAR from payment_date) = 2005
order by amount desc
limit 1;

--21. Listar el monto gastado por los customer que hayan gastado mas de 40 en el mes 6 de 2005.

SELECT p.customer_id, SUM(p.amount) AS total_amount FROM payment p 
WHERE EXTRACT(YEAR FROM p.payment_date) = 2005 AND EXTRACT(MONTH FROM p.payment_date) = 6 
GROUP BY p.customer_id 
HAVING SUM(p.amount) > 40 
ORDER BY total_amount DESC;

--22. Mostrar la cantidad del clientes hay por ciudad 

SELECT ci.city, COUNT(c.customer_id) AS cantidad_clientes FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
GROUP BY ci.city
ORDER BY cantidad_clientes DESC;

--23. Mostrar las 5 películas con mayor cantidad de actores. 

SELECT f.title, COUNT(fa.actor_id) AS actor_count FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
GROUP BY f.film_id, f.title
ORDER BY actor_count DESC
LIMIT 5;

--24. Mostrar los días donde se hayan alquilado mas de 10 de películas de "Drama" 

SELECT DATE(r.rental_date) AS fecha_renta, COUNT(r.rental_id) AS contador_renta FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Drama'
GROUP BY fecha_renta
HAVING COUNT(r.rental_id) > 10
ORDER BY fecha_renta;

--25. Mostrar los actores que no están en ninguna película 

SELECT a.actor_id, a.first_name, a.last_name FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.actor_id IS NULL;