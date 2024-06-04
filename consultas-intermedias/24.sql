SELECT 
    DATE(r.rental_date) AS fecha_renta, 
    COUNT(r.rental_id) AS contador_renta
FROM 
    rental r
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film f ON i.film_id = f.film_id
JOIN 
    film_category fc ON f.film_id = fc.film_id
JOIN 
    category c ON fc.category_id = c.category_id
WHERE 
    c.name = 'Drama'
GROUP BY 
    fecha_renta
HAVING 
    COUNT(r.rental_id) > 10
ORDER BY 
    fecha_renta;