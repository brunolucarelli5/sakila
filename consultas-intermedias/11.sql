select f.title, count(f.film_id) cantidad from film f
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
group by f.film_id order by cantidad desc limit 10;