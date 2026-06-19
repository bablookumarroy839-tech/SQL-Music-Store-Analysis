select * from  album;

1. Who is the Senoir most employee based on job title?

select first_name , last_name , levels , title from employee
order by title desc 
limit 1;

2. Which countries  have the  most Invoices?
select * from invoice;
select count(*) as total_invoice ,billing_country 
from invoice
group by billing_country 
order by  total_invoice desc;

3. What are the top 3 values of total invoices?

select  total from invoice
order by total desc
limit 3;

4.Which city has the best customers? we would like to throw a promotional music festival in the city we made the most money. Write a query that returns one city that has the highest  sum of invoice totals.
Return both the city name & sum of all invoice totals.

select sum(total) as total_invoice,billing_city from invoice
group by billing_city 
order by total_invoice desc;

5.Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money?

select customer.customer_id, customer.first_name, customer.last_name,  SUM(invoice.total) as total_sum from customer
join invoice  on
customer.customer_id=invoice.customer_id
group by customer.customer_id
order by total_sum desc
limit 1;

6.Write query to return the email,first name,last name & Genre of all Rock music listeners.Return your list ordered alphabetically by 
email satrting with A.

select distinct email, first_name, last_name from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id IN(
select track_id from track
join genre on track.genre_id = genre.genre_id
where genre.name like 'Rock')
order by email asc;

7.Let's invite the artists who have written the most  rock music in our dataset.Write a query that returns the Artist name and total 
track count of the top 10 rock bands.

select artist.artist_id, artist.name, count(artist.artist_id) as number_of_songs
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'Rock'
group by artist.artist_id
order by  number_of_songs desc
limit 10;

8. Return all the track names that have a song length longer than the average song length. Return the name and Milliseconds for each 
track. Order by the song length  with the longest song listed first.

select name,milliseconds from track
where milliseconds > (
select AVG(milliseconds) as Avg_length_track
from track)
order by milliseconds desc;

9.Find how much amount spent by each customer on artists? write a query to return customer name, artist name and total spent.

with best_selling_artist as (
   select artist.artist_id as artist_id, artist.name as artist_name,
   sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
   from invoice_line
   join track on track.track_id = invoice_line.track_id
   join album on album.album_id = track.album_id
   join artist on artist.artist_id = album.artist_id
   GROUP BY 1
   ORDER BY 3 desc
   LIMIT 1
)
select c.customer_id,c.first_name,c.last_name,bsa.artist_name,
sum(il.unit_price*il.quantity) as amount_spent 
from invoice i
join customer c on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id =i.invoice_id
join track t on t.track_id = il.track_id
join album alb on alb.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id = alb.artist_id
group by 1,2,3,4
order by 5 desc;

10. We want to find out the most popular music Genre  for each country. We determine the most popular genre as the genre with 
the  highest amount of purchases. Write a query  that returns each country along with the top Genre. For countries where 
the maximum number of purchasesis shared return all Genres.

with popular_genre AS
(    
     select count(invoice_line.quantity) as purchases,customer.country,genre.name, genre.genre_id,
	 ROW_NUMBER()OVER(PARTITION BY customer.country order by count(invoice_line.quantity)DESC) as Row_No 
	 from invoice_line
	 join invoice on invoice.invoice_id = invoice_line.invoice_id
	 join customer on customer.customer_id = invoice.customer_id
	 join track on track.track_id = invoice_line.track_id
	 join genre on genre.genre_id = track.genre_id
	 group by 2,3,4
	 order by 2 asc
)
select * from popular_genre where Row_No <=1

11.Write a query that determines the customer that has spent the most on music for each country .
Write a query  that returns the country along with the top customer and how much they spent. For countries where the top
amount spent is shared, provide all customers who spentthis amount.

WITH customer_with_country AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        i.billing_country,
        SUM(i.total) AS total_spending
    FROM invoice i
    JOIN customer c
        ON c.customer_id = i.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name,
        i.billing_country
),
country_max_spending AS (
    SELECT
        billing_country,
        MAX(total_spending) AS max_spending
    FROM customer_with_country
    GROUP BY billing_country
)

SELECT
    cc.billing_country,
    cc.total_spending,
    cc.first_name,
    cc.last_name,
    cc.customer_id
FROM customer_with_country cc
JOIN country_max_spending ms
    ON cc.billing_country = ms.billing_country
   AND cc.total_spending = ms.max_spending
ORDER BY cc.billing_country;


















		 
		  
     
