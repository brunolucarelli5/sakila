select f.title titulo, LOWER(l.name) idioma from film f
inner join language l on l.language_id = f.language_id
where l.name like 'Mandarin'
order by f.title asc;