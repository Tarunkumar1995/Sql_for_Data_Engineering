select * from departments;
select * from employees;
select * from projects;
select * from salaries;


-- Q5. Find the top 3 highest salaries in each department.
with duplicates as (
select
        d.department_id,
        d.department_name,
        e.emp_id,
        e.full_name,
        s.salary,
        s.effective_from,
      -- Max(s.salary) over (partition by e.emp_id order by s.salary desc) as max_sal,
       Row_number()  over (partition by e.emp_id order by s.salary desc) as row_ranking
     --  Row_number() over(partition by d.department_id order by s.salary desc) as row_ranking
      --   Dense_rank() over(partition by d.department_id order by s.salary desc) as rnk
from departments d
        inner join employees e 
				on d.department_id = e.department_id
		inner join salaries s
				on s.emp_id = e.emp_id
	),
    
Top_salaries as (
select 
       * 
from duplicates where row_ranking =1
),

Ranks_assigned as (
select 
	  department_name,
      full_name,
      salary,
      dense_rank() over (partition by department_id order by salary desc) as rnk
from Top_salaries t )

select 
       * 
from Ranks_assigned where rnk <=3;

-- Q6. For each employee, show the salary change compared to previous year.

with Previous_salaries as (
select
     s.emp_id,
     s.salary,
     s.effective_from,
    coalesce (lag(s.salary) over(partition by emp_id order by  s.effective_from), 0) as previous_sal
from 
     salaries s
   )
   
select
     emp_id,
     salary,
     previous_sal,
     case
         when previous_sal =0 then 'No change'
         when previous_sal !=0 then(salary - previous_sal)
         end as sal_changes
from Previous_salaries;

-- Q7. Rank employees by hours worked in projects (per department).

select
      e.emp_id,
      p.hours_worked,
      d.department_name,
      
      dense_rank() over(partition by d.department_id order by p.hours_worked desc) rnk
from employees e
        inner join departments d on e.department_id = d.department_id
        inner join projects p on  p.emp_id = e.emp_id;

-- Q8. Calculate running total of salaries by hire date.

select 
       e.hire_date,
      
       sum(s.salary) over(partition by e.hire_date ) as running_totals
from employees e
   inner join salaries s
      on e.emp_id = s.emp_id;
      
select
      * from employees where hire_date = '2017-6-22';
      
