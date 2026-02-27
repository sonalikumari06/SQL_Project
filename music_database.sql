-- Q1: senior emolyee on job title?
/*SELECT * FROM employee
ORDER BY levels desc
limit 1 */

/*Q2: which countries have most invoice?
select COUNT(*) as c, billing_country 
from invoice
group by billing_country
order by c desc*/

/*  Q3: What are top 3 values of total invoice
select total from invoice
order by total desc
limit 3   */

/*    Q4:Which city best customers? we would like to throw promotional music in city we made most money. 
returns one city that has has the highest sum of invoice. return both city name and sum all invoice totals.

select SUM(total) as invoice_total, billing_city
from invoice
group by billing_city
order by invoice_total desc    */


/*  Q5: Who is best customers? The customers who has spet the most money will be decleard best customers. 
Write a quesry that return the person the person who has spent the most money.

select customer.customer_id, customer.first_name, customer.last_name, SUM(invoice.total) as total
from customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_ID
ORDER BY total DESC
limit 1 */


/* Q6: write query to return the email, first name, last name & Genre of all Rock Music
Reture your list ordered alphabetically by email starting with A.

SELECT DISTINCT email,first_name, last_name
FROM customer
JOIN invoice ON invoice.invoice_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN(
     SELECT track_id FROM track
	 JOIN genre ON track.genre_id = genre.genre_id
	 WHERE genre.name LIKE 'Rock'
)
ORDER BY email;  */

/* Q7: Let's invite the artists who have written the most rock music in our dataset. Write 
a query that returns the Atrist name and total track count of the top 10 rock bands. 

SELECT artist.artist_id, artist.name,COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;  */

/* Q8: Return all the track names that have a song length longer then the average song length.
Return the Name and Millisecond for each track. Order by the song length wiith the longest song listed first.

SELECT name,milliseconds
FROM track
WHERE milliseconds > (
   SELECT AVG(milliseconds) AS avg_track_length
   FROM track)
ORDER BY milliseconds DESC;	*/

/* Q9: Find how much spent by each customer on artists? write a query a return customer name 
artist name and total spent. 

WITH best_selling_artist AS (
    SELECT artist.artist_id AS artist_id, artist.name AS artist_name,
	SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = artist.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name,
SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC; */
/* Q10: we want to find out the most popular music Genre for each country, 
we determine the most popular genre as the genre with the highest amount. 

WITH popular_genre AS
(
     SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id,
	 ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity)DESC) AS ROWNo
	 FROM invoice_line
	 JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	 JOIN customer ON customer.customer_id = invoice.customer_id
	 JOIN track ON track.track_id = invoice_line.track_id
	 JOIN genre ON genre.genre_id = track.genre_id
	 GROUP BY 2,3,4
     ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1
*/

/* Q11: Write a query that dertmine the customer that has spent the most on music for each country,
write a query that return the country along with the top customer and how much they spent,
for countries where the top amount spent is provide all customer who spent this amount.


WITH customer_with_country AS (
        SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
		ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total)DESC) AS ROWNo
	    FROM invoice
	    JOIN customer ON customer.customer_id = invoice.customer_id
	    GROUP BY 1,2,3,4
        ORDER BY 4 ASC, 5 DESC
)
SELECT * FROM customer_with_country WHERE RowNo <= 1

*/














