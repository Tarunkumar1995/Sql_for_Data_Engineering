select * from departments;
select * from employees;
select * from salaries;
select * from projects;


-- Q1. Find employees who have NEVER worked on any project.
select 
      e.full_name, e.gender, e.emp_id 
from employees e
      left join projects p 
            on e.emp_id = p.emp_id
where p.emp_id is null;

-- 2nd method
with emp_not_in_project as (
        select 
               full_name,
               gender,
               emp_id
	     from employees
		)
select 
      e.full_name,
      e.gender,
      e.emp_id
from emp_not_in_project e
where not exists(
            select 1 
			from projects p 
            where p.emp_id = e.emp_id);
            
-- Q2. List employees who worked on more than 1 project.
select
          e.emp_id,
          e.full_name,
          e.gender,
          count(*) as more_than_1_project
from employees e
	inner join projects p 
           on e.emp_id = p.emp_id
group by e.emp_id, e.full_name, e.gender
having count(*) > 1;

-- 2nd method
with ProjectCounts As (
       select 
             e.emp_id,
             e.full_name,
             e.gender,
             count(p.emp_id) over (partition by e.emp_id order by emp_id) as count
		from employees e
        inner join projects p
            on e.emp_id = p.emp_id
            )
select 
   distinct
    e.emp_id,
	e.full_name,
	e.gender,
    e.count
from ProjectCounts e
 where e.count > 1;

-- Q3. Show each department with number of employees and average salary.

select
        d.department_name,
        count(e.emp_id) as tot_emp,
        avg(s.salary) as tot_sal
from departments d
     inner join employees e on d.department_id = e.department_id
     inner join salaries s on s.emp_id = e.emp_id	
group by d.department_name;

-- 2nd method
with DepartmentCount as (
       select
             d.department_name,
             count(e.emp_id) over(partition by d.department_id) as tot_emp,
             avg(s.salary) over(partition by d.department_id) as avg_salary
		from departments d
            inner join employees e on d.department_id = e.department_id
            inner join salaries s on s.emp_id = e.emp_id
)
select 
       distinct
       department_name,
       tot_emp,
       avg_salary
from DepartmentCount;

-- Q4. Find employees whose salary is higher than their department’s average salary.

with latest_salary as (
       select 
              e.emp_id,
              e.full_name,
              e.department_id,
              s.salary,
              s.effective_from,
          
              dense_rank() over(partition by s.emp_id order by s.salary desc) ranking
		from employees e
            inner join salaries s on e.emp_id = s.emp_id
		
		),
Employees_Highest_Salary  as (
    select 
         * 
	from latest_salary where ranking = 1
),

DepartmentsAverage_salary as (
 select
        *,
        avg(salary) over(partition by department_id) as DepartmentsAverage_salary
from 
      Employees_Highest_Salary
      )
      
select 
          *
          
from DepartmentsAverage_salary
where salary > DepartmentsAverage_salary;






 

