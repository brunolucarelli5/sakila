SELECT p.customer_id, SUM(p.amount) AS total_amount FROM payment p 
WHERE EXTRACT(YEAR FROM p.payment_date) = 2005 AND EXTRACT(MONTH FROM p.payment_date) = 6 
GROUP BY p.customer_id 
HAVING SUM(p.amount) > 40 
ORDER BY total_amount DESC;