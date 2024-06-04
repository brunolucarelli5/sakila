select f.title, r.rental_date from film f
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
inner join customer c on c.customer_id = r.customer_id
where first_name like 'CARMEN' and last_name like 'OWENS'
order by f.title asc;