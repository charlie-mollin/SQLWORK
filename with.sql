--find employees who earn more than average salary of all employees
with e (avg_salary) as(
	select
		cast(AVG(salary) as int) 
	from emp
)
select 
	a.emp_name,
	a.salary,
	e.avg_salary
from emp a, e
where a.salary > e.avg_salary;


--next example
select * from sales;

--find stores whose sales are better than the average sales across all stores
with average (average_sale) as(
	select
		cast(AVG(price) as int) 
	from sales
	),

stores_sales as (
	select
		store_name, 
		SUM(price)
	from sales
	group by 1
)
select 
	* 
from stores_sales ss
cross join average a
where ss.sum > a.average_sale


--redo
with stores_sales (store_name, total_sale) as (
	select
		store_name, 
		SUM(price)
	from sales
	group by 1),

avg_sales (average_guy) as (
	select
		cast(AVG(total_sale) as int)
	from stores_sales
)
select 
	*
	-- ss.store_name,
	-- ss.total_sale,
	-- aa.average_guy
from stores_sales ss
join avg_sales aa
on ss.total_sale > aa.average_guy;