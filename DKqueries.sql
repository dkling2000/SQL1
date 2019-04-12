use sakila;

-- 1a
SELECT first_name, last_name from actor;

-- 1b
SELECT concat(first_name, " ", last_name) as Actor_Name from actor;

-- 2a
SELECT actor_id, first_name from actor where first_name = "Joe";

-- 2b 
SELECT last_name from actor where last_name like '%GEN%';

-- 2c
SELECT first_name, last_name from actor where last_name like'%LI%'
ORDER BY first_name, last_name;

-- 2d
SELECT country_id, country from country where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a
ALTER TABLE actor
ADD description BLOB;

-- 3b
ALTER TABLE actor DROP description;

-- 4a
SELECT COUNT(last_name),last_name from actor
GROUP BY last_name;

-- 4b
SELECT last_name, COUNT(last_name) from actor
GROUP BY  last_name Having Count(last_name) >1;

-- 4c
UPDATE actor
SET first_name = "Harpo"
WHERE actor_id = 172;

-- 4D
SET SQL_SAFE_UPDATES=0;
UPDATE actor
SET first_name = "Groucho"
WHERE first_name = 'Harpo';

-- 5a
SHOW CREATE TABLE address (
	address_id INT AUTO_INCREMENT,
    address varchar(50),
    address2 varchar(50),
    district varchar(20),
    city_id int,
    post_code varchar(10),
    location geometry,
    last_update timestamp,
    Primary Key (address_id)
    );
-- 6a
SELECT staff.first_name, staff.last_name, address.address, address.address2
FROM staff
INNER JOIN  address
ON staff.address_id = address.address_id;

-- 6b
SELECT staff.first_name, staff.last_name, SUM(payment.amount)
FROM staff
JOIN payment
on staff.staff_id = payment.staff_id
where payment.payment_date like '2005-08%'
GROUP BY staff.staff_id;

-- 6c
SELECT film.title, COUNT(film_actor.actor_id)
FROM film
INNER JOIN film_actor ON film_actor.film_id = film.film_id
GROUP BY film.film_id;

-- 6d
SELECT film.title, COUNT(inventory.film_id)
FROM film
JOIN inventory ON film.film_id = inventory.film_id
WHERE film.title = 'Hunchback Impossible'

-- 6e
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS "Total Amount Paid"
FROM customer
JOIN payment
on customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name;

-- 7a 
SELECT title from film WHERE(title LIKE 'K%' or title LIKE 'Q%') AND
language_id IN 
(SELECT 
language_id 
FROM 
language 
WHERE name = 'English');


-- 7b
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
  SELECT actor_id
  FROM film_actor
  WHERE film_id IN
  (
   SELECT film_id
   FROM film
   WHERE title = 'Alone Trip'
  )
);

-- 7c
SELECT email
FROM customer
WHERE address_id IN
(
  SELECT address_id
  FROM address
  WHERE city_id IN
  (
   SELECT city_id
   FROM city
   WHERE country_id IN
   (
   SELECT country_id
   FROM country
   WHERE country = 'Canada'
  )
  )
);
-- 7d
SELECT title
FROM film
WHERE film_id IN
(
  SELECT film_id
  FROM film_category
  WHERE category_id IN
  (
   SELECT category_id
   FROM category
   WHERE name = 'Family'
  )
);

-- 7e 
SELECT film.title,	COUNT(rental.inventory_id) as TimesRented, rental.customer_id from film	
JOIN inventory
on film.film_id = inventory.film_id
JOIN rental
on inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY TimesRented desc;



-- 7f
SELECT SUM(amount), staff.store_id from payment
JOIN staff
ON staff.staff_id = payment.staff_id
GROUP BY payment.staff_id;

-- 7g
SELECT store_id
FROM store
WHERE address_id IN
(SELECT address_id 
FROM address 
WHERE city_id in
(SELECT city_id, city
FROM city
WHERE country_id in
(SELECT country_id, country
FROM country
)
)
);
-- 7h 
SELECT category.name,   SUM(payment.amount) as Gross FROM category	
JOIN film_category
on category.category_id = film_category.category_id
JOIN film
on film_category.film_id = film.film_id
JOIN inventory
on film.film_id = inventory.film_id
JOIN rental
ON inventory.inventory_id = rental.inventory_id
JOIN payment
ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY Gross desc
LIMIT 5;

-- 8a
CREATE VIEW `Top_Five`  AS
SELECT category.name,   SUM(payment.amount) as Gross FROM category	
JOIN film_category
on category.category_id = film_category.category_id
JOIN film
on film_category.film_id = film.film_id
JOIN inventory
on film.film_id = inventory.film_id
JOIN rental
ON inventory.inventory_id = rental.inventory_id
JOIN payment
ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY Gross desc
LIMIT 5;

-- 8b
SELECT * FROM top_five;

-- 8c
DROP VIEW top_five