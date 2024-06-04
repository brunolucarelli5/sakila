SELECT 
    f.title, 
    COUNT(fa.actor_id) AS actor_count
FROM 
    film f
JOIN 
    film_actor fa ON f.film_id = fa.film_id
GROUP BY 
    f.film_id, f.title
ORDER BY 
    actor_count DESC
LIMIT 5;