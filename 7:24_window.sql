select * from employee;

select * from(
	select
	*,
	row_number() over(partition by dept_name order by emp_id) as rn
	-- max(salary) over(partition by dept_name) as max_salary
	from employee e) x 
where x.rn < 3

with whatever as (select
	*,
row_number() over(partition by dept_name order by emp_id) as rn
	-- max(salary) over(partition by dept_name) as max_salary
from employee
)

select * from whatever
where rn < 3


--rank
---fetch top 3 employees in each of the departments
select 
	e.*, 
	rank() over (partition by dept_name order by salary desc) as rnk,
	dense_rank() over (partition by dept_name order by salary desc) as d_rnk --dense rank does not skip values
from employee e;


-- LAG()/ LEAD()
select e.*,
lag(salary, 1, 0) over (partition by dept_name order by emp_id) as prev_emp_salary,
lead(salary, 1, 0) over (partition by dept_name order by emp_id) as next_emp_salary
from employee e;


--Question from video
select e.*,
lag(salary, 1, 0) over (partition by dept_name order by emp_id) as prev_emp_salary,
case when e.salary > lag(salary, 1, 0) over (partition by dept_name order by emp_id) then 'Higher'
	when e.salary < lag(salary, 1, 0) over (partition by dept_name order by emp_id) then 'Lower'
	when e.salary = lag(salary, 1, 0) over (partition by dept_name order by emp_id) then 'Same'
end as comparison
from employee e;
