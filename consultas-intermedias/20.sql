SELECT concat(c.last_name, ', ',c.first_name) cliente, p.amount pago_maximo FROM payment p
inner join rental r on r.rental_id = p.rental_id
inner join customer c on c.customer_id = p.customer_id
where extract(YEAR from payment_date) = 2005
order by amount desc
limit 1;