select 
	class_name
from subjects sub
inner join classes cls
on sub.subject_id = cls.subject_id
where subject_name = 'Music';

select * from classes;

select distinct 
	*
from subjects sub
inner join classes cls on cls.subject_id = sub.subject_id
inner join staff stf on cls.teacher_id = stf.staff_id;
-- where sub.subject_name = 'Mathematics';


-- Fetch all staff who teach grades 8,9,10 and fetch all of the non teaching staff
--- first 8 9 and 10
select * from classes;
select * from staff;


--union work
select distinct
	stf.staff_type,
	(stf.first_name||' '||stf.last_name) as full_name,
	stf.age, 
	CASE
		WHEN stf.gender = 'M' THEN 'Male'
		WHEN stf.gender = 'F' THEN 'Female'
	END AS gender, 
	stf.join_date
from classes cls
inner join staff stf
on cls.teacher_id = stf.staff_id
where cls.class_name in ('Grade 8', 'Grade 9', 'Grade 10')
and stf.staff_type = 'Teaching'

UNION

select distinct
	staff_type,
	(first_name||' '||last_name) as full_name,
	age, 
	(CASE
		WHEN gender = 'M' THEN 'Male'
		WHEN gender = 'F' THEN 'Female'
	END) AS gender,
	join_date
from staff
where staff_type = 'Non-Teaching'
order by 2;

select 
	class_id, 
	COUNT(student_id)
from student_classes
GROUP BY 1;

select
	class_id,
	COUNT(student_id) as "students"
from student_classes
group by 1
having COUNT(student_id)> 100
order by class_id desc;

select * from parents;

select 
	(pa.first_name||' '||pa.last_name) as parent_name, 
	count(sp.student_id) as no_student
from student_parent sp
inner join parents pa
on sp.parent_id = pa.id
group by 1
having count(sp.student_id) > 1
order by 2 desc; 

--details of parents having more than one kid at the school, subqueries
select 
	(P.FIRST_NAME||' '||P.LAST_NAME) AS PARENT_NAME, 
	(S.FIRST_NAME||' '||S.LAST_NAME) AS STUDENT_NAME,
	S.AGE AS STUDENT_AGE,
	S.GENDER AS STUDENT_GENDER, 
	(ADR.STREET||', '||ADR.CITY||', '||ADR.COUNTRY) AS ADDRESS
FROM PARENTS P
INNER JOIN STUDENT_PARENT SP ON P.ID = SP.PARENT_ID
INNER JOIN STUDENTS S ON S.ID = SP.STUDENT_ID
INNER JOIN ADDRESS ADR ON P.ADDRESS_ID = ADR.ADDRESS_ID
WHERE P.ID IN( 
	SELECT 
		PARENT_ID
	FROM STUDENT_PARENT 
	GROUP BY PARENT_ID
	HAVING COUNT(STUDENT_ID) > 1)
ORDER BY 1;

--aggregate functions
---avg
select * from staff_salary;
select * from staff;

select
	s.staff_type,
	avg(ss.salary) as avg_s --can include any aggregate here, really
from staff_salary ss
inner join staff s
on ss.staff_id = s.staff_id
group by 1;
-- where s.staff_type = 'Non-Teaching';


