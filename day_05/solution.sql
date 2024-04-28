-- Solution first part

insert into emp_transaction
select s.emp_id, s.emp_name, x.trns_type
, case when x.trns_type = 'Basic' then round(base_salary * (cast(x.percentage as decimal)/100),2)
	   when x.trns_type = 'Allowance' then round(base_salary * (cast(x.percentage as decimal)/100),2)
	   when x.trns_type = 'Others' then round(base_salary * (cast(x.percentage as decimal)/100),2)
	   when x.trns_type = 'Insurance' then round(base_salary * (cast(x.percentage as decimal)/100),2)
	   when x.trns_type = 'Health' then round(base_salary * (cast(x.percentage as decimal)/100),2)
	   when x.trns_type = 'House' then round(base_salary * (cast(x.percentage as decimal)/100),2) end as amount	   
from salary s
cross join (select income as trns_type, percentage from income
			union
			select deduction as trns_type, percentage from deduction) x;


-- Solution second part (crosstab - [pivot in mysql])

-- Crosstab syntax
-- select * from crosstab('base_query | order by', 'list of columns') as result ('final columns with data type')

-- add extension on postgres db to run crosstab
CREATE EXTENSION IF NOT EXISTS tablefunc;


select employee, basic, allowance, others, (basic + allowance + others) , insurance, health, house, (insurance + health + house)  from crosstab ('select emp_name, trns_type, amount from emp_transaction order by emp_name, trns_type', 'select distinct trns_type from emp_transaction order by trns_type') AS result(employee varchar, allowance numeric, basic numeric, health numeric, house numeric, insurance numeric, others numeric);

