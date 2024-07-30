--find employee who's salary is more than average salary earcned by all employees
select * from employee;

--scalar subquery
select
	emp_name
from employee
where salary > (select AVG(salary) from employee)
order by emp_name;

--multiple row subquery
-- find employees who earn the highest salary in each department
select
	dept_name, 
	MAX(salary)
from employee 
GROUP BY 1

select 
	*
from employee
where (dept_name, salary) in (select
									dept_name, 
									MAX(salary)
								from employee 
								GROUP BY 1)

--single column, multiple row
---find department without any employees
select * 
from department
where (dept_name) not in (select distinct dept_name from employee);

--correlated sub query
--- find employees in each department that earn more than average salary in that dpt
select 
	avg(salary)
from employee
where dept_name = "Finance";

select
	*
from employee e1
where salary > (select 
					avg(salary)
				from employee e2
				where e2.dept_name = e1.dept_name) --referencing a column that comes from the outer query

--another example
--- correlated: find the dpt that does not have any employees 
select *
from department d1
where not exists (select 
						1 
					from employee e1
					where d1.dept_name = e1.dept_name);

--subquery 
select * from sales;

--find stores who sales were better than average sales across all stores; 
select *
from (select store_name, SUM(price) as total_sales
	  from sales
	  group by 1) sales
join (select AVG(total_sales) as sales
	from (select store_name,  SUM(price) as total_sales
	  from sales
	  group by 1) x) avg_sales
	on sales.total_sales > avg_sales.sales
	
--can make this more efficient using CTEs
with sales as(
	select store_name, SUM(price) as total_sales
	from sales
	group by 1
)

select *
from sales
join (select AVG(total_sales) as sales
	from sales ) avg_sales
	on sales.total_sales > avg_sales.sales

--subqury in select clause
-- fetch employee details and add remarks to those that earn more than average pay
select 
	*
	,(case 
		when salary > avg_sal.sal then 'Yay!'
		else 'You suck'
		end)  as remarks
from employee
cross join (select avg(salary) sal from employee) avg_sal;

--HAVING
---Find stores that have sold more units than average units sold by all stores
select * from sales;

select 
	store_name,
	SUM(quantity) as units_sold
from sales
group by 1
having SUM(quantity)> (select avg(quantity) from sales)


--INSERT: 
--- Insert data to employee history table. Make sure not to insert duplicate records
select * from employee_history;

insert into employee_history
select e.emp_id, e.emp_name, d.dept_name, e.salary, d.location
from employee e
join department d
on d.dept_name = e.dept_name
where not exists (select 1 
					from employee_history eh
					where eh.emp_id = e.emp_id)