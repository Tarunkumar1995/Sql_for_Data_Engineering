select * from departments;
select * from employees;
select * from salaries;
select * from projects;

-- Q9. Find department with the highest total salary.

with ranked as (
select
      d.department_id,
      d.department_name,
      e.emp_id,
      s.effective_from,
      s.salary,
      row_number() over(partition by e.emp_id order by s.effective_from desc) rn
from employees e
   inner join departments d on e.department_id = d.department_id
   inner join salaries s on e.emp_id = s.emp_id
   ),

filtering as (
   select
          emp_id,
          department_name,
          salary
from ranked where rn =1
)

select 
     department_name,
    sum(salary) as Highest_tot_sal
from filtering
group by department_name
order by Highest_tot_sal desc;

-- Q10. Which project has the maximum total hours worked?

select
    project_name,
    max(hours_worked) as Max_hours
from projects;

-- Q11. Count male vs female employees per city.
select
         city,
         gender,
         count(*) as tot_count
from employees
group by city , gender
order by city;

-- 2nd method (PIVOT Table)
select
     city,
	sum(case when gender = 'M' then 1 else 0 end) as male_count,
    sum(case when gender = 'F' then 1 else 0 end) as female_count
from employees
group by city
order by city;

-- Q12. Find average salary of employees hired in each year.

select
       e.hire_date,
       year(e.hire_date) as years,
       avg(s.salary) as avg_sal
from employees e
   inner join salaries s
        on e.emp_id = s.emp_id        
group by year(e.hire_date)
order by avg_sal;

-- 2nd method

select distinct
     hiring_year,
     avg_salary
  from   (
select
     year(e.hire_date) as hiring_year,
      avg(s.salary) over(partition by year(e.hire_date)) as avg_salary
from employees e
   inner join salaries s
        on e.emp_id = s.emp_id ) t
order by avg_salary;


-- CATEGORY 4 SUBQUERIES



-- Q14. Retrieve employees who have the second highest salary.
with duplicates_removed as (
select
        e.emp_id,
        e.full_name,
        s.salary,
        row_number() over (partition by e.emp_id order by s.effective_from desc) as rnk
from employees e 
   inner join salaries s on e.emp_id = s.emp_id
   ),

final_sal as (
select
      *
from duplicates_removed 
where rnk = 1

 ),
 ranked as(
 select
       *,
       dense_rank() over(order by salary desc) as rnking
from final_sal
  )
  
  select * from ranked where rnking  =2;
  
-- Q15. Find departments where more than 5 employees work.

select
        d.department_id,
        d.department_name,
     --   count(e.emp_id) over(partition by d.department_id) as counting
     count(e.emp_id) as counting
from employees e 
 inner join departments d 
   on e.department_id = d.department_id
group by d.department_id
having count(e.emp_id) > 5;

-- CATEGORY 5 — STRING FUNCTIONS

-- Q16. Extract FIRST NAME from full_name for all employees.

select
       full_name,
       substring_index(full_name, ' ', 1) as first_name
from employees;


-- Q17. Standardize city names: Remove extra spaces + lowercase.

select
concat(
        upper(left(trim(city), 1)),
        lower(substring(trim(city), 2)) 
        ) as city_name
from employees;

-- CATEGORY 6 — DATE FUNCTIONS

-- Q18. Calculate employee experience in years.

select
        e.emp_id,
        e.full_name,
       round(datediff(current_date(), e.hire_date)/365, 1) as exp_years
from employees e
order by exp_years desc;

-- Q19. Find employees hired on weekends.

select 
 hire_date,
  
  case dayofweek(hire_date)
      when 1 then 'Weekend' 
      when 7 then 'Weekend'
      else 'Weekday'
      end as is_weekend_status
from employees;
      
  
-- Q20. Find the next salary increment date (add 12 months to last increment).

with last_increment as (
select 
    e.emp_id,
    e.full_name,
    s.effective_from,
    row_number() over(partition by e.emp_id order by s.effective_from desc) as rn
from employees e
	inner join salaries s
        on e.emp_id =  s.emp_id
	)

select
     emp_id,
     full_name,
     effective_from,
     date_add(effective_from, interval 12 month) as increment_year
from last_increment where rn =1;
