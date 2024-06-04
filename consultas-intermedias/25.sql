SELECT 
    a.actor_id, 
    a.first_name, 
    a.last_name
FROM 
    actor a
LEFT JOIN 
    film_actor fa ON a.actor_id = fa.actor_id
WHERE 
    fa.actor_id IS NULL;