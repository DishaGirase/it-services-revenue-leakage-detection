-------Data Cleaning Phase-------

-- step 1:Check for NULL Values
-- check null values in timesheet table
-- each column should show 0 if there are no missing values 

select
    count(*) as total_rows,
	count(*) - count(project_id) as missing_project_id,
	count(*) - count(billing_month) as missing_billing_month,
	count(*) - count(logged_hours) as missing_logged_hours,
	count(*) - count(hourly_rate_inr) as missing_hourly_rate,
	count(*) - count(project_manager) as missing_pm
from fact_timesheet;

-- check null values in invoice table

select 
    count(*) as total_rows,
	count(*) - count(project_id) as missing_project_id,
	count(*) - count(billed_hours) as missing_billed_hours,
	count(*) - count(billing_month) as missing_billing_month
from fact_invoices;

-- step 2: Handle Missing Billed Hours
-- replace null billed hours with 0
-- if we dont know the billed hours, assume 0
-- this will show up as 100% leakage 

update fact_invoices
set billed_hours = 0
where billed_hours is null;

-- replace null hourly rate with avg rate for that project

update fact_timesheet t
set hourly_rate_inr = (
    select avg(hourly_rate_inr)
	from fact_timesheet
	where project_id = t.project_id
	and hourly_rate_inr is not null
)
where hourly_rate_inr is null;

-- step 3: Standardize Date Formats
-- check what formats exist in your billing_month column

select distinct billing_month from fact_timesheet order by billing_month;

-- this is for different formats of date but in my data date format is same 

select distinct billing_month from fact_timesheet order by 1;

-- step 4: Remove Duplicates
-- find duplicate timesheet entries for same employee , project , month

select timesheet_id, project_id, employee_id, billing_month,
    count(*) as duplicate_count
from fact_timesheet
group by timesheet_id, project_id, employee_id, billing_month
having count(*) > 1;

-- no duplicates found
