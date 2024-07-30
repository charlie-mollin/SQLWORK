select * from product;

select *,
first_value(product_name) over (partition by product_category order by price desc) as most_exp_product,
last_value(product_name) over (partition by product_category order by price desc) as least_exp_product
from product;

--first_value
select *,
first_value(product_name) over (partition by product_category order by price asc) as most_exp_product
from product;

--frame clause
select *,
first_value(product_name) 
	over (partition by product_category order by price desc) 
	as most_exp_product,
last_value(product_name) 
	over (partition by product_category order by price desc
		 range between unbounded preceding and unbounded following) 
	--used to be current row
	--what is the range of records that the window function must consider. 
	--Says it must consider rows preceding unbounded so from the first value of the partition 
	--must modify to get everything, such that can fetch the last value
	-- can also change range to rows
	as least_exp_product
from product;

--alternate way of writing query
select *,
first_value(product_name) over w as most_exp_product,
last_value(product_name) over w as least_exp_product
from product
window w as (partition by product_category order by price desc
		 range between unbounded preceding and unbounded following);

--NTH VALUE
-- write query to display second most expensive product under each category. 
select *,
first_value(product_name) over w as most_exp_product,
last_value(product_name) over w as least_exp_product,
nth_value(product_name, 5) over w as second_exp_product
from product
window w as (partition by product_category order by price desc
		 range between unbounded preceding and unbounded following);

--NTILE 
-- query to segregate all expensive phones, mid range phones, and the cheaper phones 
--- think of it like "buckets"
select 
	product_name, 
	case
		when buckets = 1 then 'expensive'
		when buckets = 2 then 'mid range'
		when buckets = 3 then 'cheaper'
	end as phone_category
from (select *, ntile(3) over (order by price desc) buckets from product where product_category = 'Phone');


--CUME_DIST
-- fetch all products constituting the first 30% of the data in the products table based on price
with cum as (
	select *, 
	cume_dist() over (order by price desc) as cume_distribution, 
	round(cume_dist() over (order by price desc)::numeric * 100,2) as cume_dist_p-- no partition, run on entire result set
	from product
) 
select product_name, (cume_dist_p||'%') as percentage from cum where cume_dist_p < 30;

--PERCENT RANK
-- how expensive is galazy z fold 3 compared to all products
select *, 
round(percent_rank() over (order by price)::numeric * 100,2) as per_rank
from product;

