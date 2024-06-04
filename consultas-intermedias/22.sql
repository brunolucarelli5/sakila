SELECT 
    ci.city, 
    COUNT(c.customer_id) AS cantidad_clientes
FROM 
    customer c
JOIN 
    address a ON c.address_id = a.address_id
JOIN 
    city ci ON a.city_id = ci.city_id
GROUP BY 
    ci.city
ORDER BY 
    cantidad_clientes DESC;
