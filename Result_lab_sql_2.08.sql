USE Sakila;

/* 
1. Write a query to display for each store its store ID, city, and country.
*/

SELECT * FROM store; -- to check how many stores  might expect as a result, andits 2 stores

SELECT store_id, cy.city, ct.country FROM store s
JOIN address a USING (address_id)
JOIN city cy USING (city_id)
JOIN country ct USING (country_id);

/*
2. Write a query to display how much business, in dollars, each store brought in.
*/
SELECT s.store_id, SUM(p.amount) As Total_Profit
FROM payment p
JOIN staff s USING (staff_id)
GROUP BY store_id;

/*
3. Which film categories are longest?
*/

/*
-- Avergae lenght

SELECT category.name, AVG(length)
FROM film JOIN film_category USING (film_id) JOIN category USING (category_id)
GROUP BY category.name
HAVING AVG(length) > (
	SELECT AVG(length) FROM film)
ORDER BY AVG(length) DESC;*/

SELECT c.name, MAX(f.length) AS MAX_LENGTH 
FROM film f
JOIN film_category fc USING (film_id) 
JOIN category c USING (category_id)
GROUP BY c.name 
HAVING MAX(f.length)=(SELECT MAX(f.length) FROM film f); -- 7  category has the same max lenght


/*
4. Display the most frequently rented movies in descending order.
*/
SELECT f.title, COUNT(f.title) AS rentals 
FROM film f 
JOIN 
	(SELECT r.rental_id, i.film_id FROM rental r 
    JOIN 
    inventory i ON i.inventory_id = r.inventory_id) a
    ON a.film_id = f.film_id 
    GROUP BY f.title 
    ORDER BY rentals DESC;

/*
5. List the top five genres in gross revenue in descending order.
*/
SELECT cat.name AS category, SUM(d.revenue) AS Revenue FROM category cat 
JOIN
    (SELECT catf.category_id, c.revenue FROM film_category catf 
	JOIN 
		(SELECT i.film_id, b.revenue FROM inventory i 
		JOIN 
			(SELECT r.inventory_id, a.revenue from rental r 
			JOIN 
				(SELECT p.rental_id, p.amount AS revenue FROM payment p) a 
				ON a.rental_id = r.rental_id) b
			ON b.inventory_id = i.inventory_id) c
		ON c.film_id = catf.film_id) d 
	ON d.category_id = cat.category_id GROUP BY cat.name
  ORDER BY revenue DESC
  LIMIT 5;
  
/*
6. Is "Academy Dinosaur" available for rent from Store 1?
*/
-- to check, which copies are in store 1
SELECT f.film_id, f.title, s.store_id, i.inventory_id
FROM inventory i
JOIN store s ON s.store_id = i.store_id
JOIN film f ON  f.film_id = i.film_id
WHERE f.title = 'Academy Dinosaur' AND s.store_id = 1; -- there are 4 copies available in store 1

-- INVENTORY ID for rent

SELECT i.inventory_id
FROM inventory i
JOIN store s USING (store_id)
JOIN film f USING (film_id)
JOIN rental r USING (inventory_id)
WHERE f.title = 'Academy Dinosaur'
      AND s.store_id = 1
      AND r.return_date is not null
GROUP BY i.inventory_id;

/*
7. Get all pairs of actors that worked together.
*/
SELECT DISTINCT a1.actor_id, a1.first_name, a1.last_name, a2.actor_id, a2.first_name, a2.last_name 
FROM film_actor fa 
JOIN actor AS a1
USING (actor_id)
JOIN actor AS a2 
ON (fa.actor_id <> a2.actor_id)
WHERE fa.film_id in (
	SELECT DISTINCT film_id FROM film_actor);

/*
Bonus:
These questions are tricky, you can wait until after Monday's lesson to use new techniques to answer them!

8. Get all pairs of customers that have rented the same film more than 3 times.
*/

/*
9. For each film, list actor that has acted in more films.
*/