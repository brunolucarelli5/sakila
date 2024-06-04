select f.title titulo, i.inventory_id ejemplar_pelicula, 
concat(c.last_name, ', ', c.first_name) cliente, 
r.rental_date fecha_de_renta from film f
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
inner join customer c on c.customer_id = r.customer_id
where r.return_date is null;