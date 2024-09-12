
-- SOLUCIÓN EVALUACIÓN MÓDULO 2 --

USE sakila;

-- 1. Selecciona todos los nombres de las películas sin que aparezcan.

SELECT DISTINCT title
FROM film;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT DISTINCT title, rating
FROM film
WHERE rating = 'PG-13';

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT title, description
FROM film
WHERE description LIKE '%amazing%';

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT title, length
FROM film
WHERE length > 120;

-- 5. Recupera los nombres de todos los actores.

SELECT  CONCAT (first_name,' ', last_name) AS nombre_completo_cast
FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT  first_name, last_name
FROM actor
WHERE last_name LIKE '%Gibson%';

-- 7.Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT  actor_id, CONCAT (first_name,' ', last_name) AS nombre_completo_cast
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

-- 8.Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.

SELECT title, rating
FROM film
WHERE rating NOT IN ('R','PG-13');

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.

SELECT DISTINCT COUNT(*) AS cantidad_total_peliculas, rating
FROM film
GROUP BY rating;

-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT customer.customer_id, customer.first_name, customer.last_name, COUNT(*) AS cantidad_total_peliculas_alquiladas
FROM customer
INNER JOIN rental 
ON customer.customer_id = rental.customer_id
GROUP BY customer.customer_id;

-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT COUNT(rental.rental_id) AS cantidad_total_peliculas_alquiladas, category.name AS categoria
FROM rental
INNER JOIN inventory
ON inventory.inventory_id = rental.inventory_id
INNER JOIN film_category
ON film_category.film_id = inventory.film_id
INNER JOIN category
ON category.category_id = film_category.category_id
GROUP BY category.name;

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT AVG(length) AS promedio_duracion_peliculas, rating AS clasificacion
FROM film
GROUP BY rating;

-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT actor.first_name, actor.last_name
FROM actor
INNER JOIN film_actor
ON film_actor.actor_id = actor.actor_id
INNER JOIN film
ON film.film_id = film_actor.film_id
WHERE film.title = 'Indian Love';

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT film.title, film.description
FROM film
WHERE film.description REGEXP 'dog|cat';

-- 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.

SELECT actor.actor_id, CONCAT(actor.first_name,' ', actor.last_name) AS nombre_completo_cast
FROM actor
WHERE actor.actor_id NOT IN (SELECT film_actor.actor_id
							 FROM film_actor);

-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT film.title, film.release_year
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

-- 17.Encuentra el título de todas las películas que son de la misma categoría que "Family".

SELECT film.title, category.name
FROM film
INNER JOIN film_category
ON film_category.film_id = film.film_id
INNER JOIN category
ON category.category_id = film_category.category_id
WHERE category.name = 'Family';

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT actor.first_name, actor.last_name
FROM actor 
INNER JOIN film_actor
ON film_actor.actor_id = actor.actor_id
GROUP BY actor.first_name, actor.last_name
HAVING COUNT(film_actor.film_id) > 10;

-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

SELECT film.title, film.rating, film.length
FROM film
WHERE film.rating = 'R' AND film.length > 120;

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.

SELECT category.name, AVG(film.length) AS promedio_duracion
FROM category
INNER JOIN film_category
ON film_category.category_id = category.category_id
INNER JOIN film
ON film.film_id = film_category.film_id 
GROUP BY category.name
HAVING AVG(film.length) > 120;

-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

SELECT CONCAT(actor.first_name,' ', last_name) AS nombre_completo_cast, COUNT(film_actor.film_id) AS actua_en_mas_5_peliculas
FROM actor
INNER JOIN film_actor
ON film_actor.actor_id = actor.actor_id
GROUP BY actor.first_name, actor.last_name
HAVING COUNT(film_actor.film_id) >= 5;

-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.
-- Incorrecto 
SELECT film.title
FROM film
WHERE film.film_id IN (SELECT inventory.film_id
					   FROM inventory
                       INNER JOIN rental
					   ON rental.inventory_id = inventory.inventory_id
		               WHERE COUNT(rental.rental_id > 5));

-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.

SELECT actor.first_name, actor.last_name
FROM actor
WHERE actor.actor_id NOT IN (SELECT film_actor.actor_id
                             FROM film_actor
							 INNER JOIN film_category
                             ON film_category.film_id = film_actor.film_id 
                             INNER JOIN category
                             ON category.category_id = film_category.category_id
							 WHERE category.name = 'Horror'