--------SQL Reconciliation Logic--------
-- step 1: aggregate timesheet hours per project per month

-- total hrs logged per proj per billing month
-- we use sum -- as multiple employees can log hrs on the same proj

select
    project_id,
	billing_month,
	sum(logged_hours) as total_logged_hours,
	sum(logged_hours * hourly_rate_inr) as potential_revenue_inr,
	project_manager,
	department
from fact_timesheet
group by project_id, billing_month, project_manager, department
order by project_id, billing_month;

-- proj runs for multiple months, thats why we use group by project_id n billing_month

-- step 2: left join reconciliation query
-- we use a left join to find all timesheet entries, including those with no matching invoice

select
    t.project_id,
	t.billing_month,
	t.project_manager,
	t.department,
	
	t.total_logged_hours,
	coalesce(i.billed_hours, 0) as total_billing_hours,

	(t.total_logged_hours - coalesce(i.billed_hours, 0)) as leakage_hours,

	(t.total_logged_hours - coalesce(i.billed_hours, 0))
	* t.avg_hourly_rate as leakage_inr,

	case
	    when t.total_logged_hours = 0 then 0
		else round(
                    ((t.total_logged_hours - coalesce(i.billed_hours, 0))
					/ t.total_logged_hours * 100), 2
		)
	end as leakage_pct,

	case
	    when ((t.total_logged_hours - coalesce(i.billed_hours, 0))
		/ nullif(t.total_logged_hours, 0) * 100) > 8
		then 'High Risk'

		when ((t.total_logged_hours - coalesce(i.billed_hours, 0))
		/ nullif(t.total_logged_hours, 0) * 100) > 4
		then 'Medium Risk'

		else 'Low Risk'
	end as risk_flag,

	i.invoice_id,
	i.client_name,
	coalesce(i.invoice_amount_inr, 0) as invoice_amount_inr

from (
    select
	    project_id, billing_month, project_manager, department,
		sum(logged_hours) as total_logged_hours,
		avg(hourly_rate_inr) as avg_hourly_rate
	from fact_timesheet
	group by project_id, billing_month, project_manager, department
) t

left join fact_invoices i
    on t.project_id = i.project_id
	and t.billing_month = i.billing_month

order by leakage_inr desc;

-- step 3: create a sql view
-- view is like saving a query as a virtual table 

-- create a view so power bi can connect to it directly

create or replace view vw_revenue_leakage_summary as 
select
    t.project_id,
	t.billing_month,
	t.project_manager,
	t.department,
	t.total_logged_hours,
	coalesce(i.billed_hours,0) as total_billed_hours,
	(t.total_logged_hours - coalesce(i.billed_hours,0)) as leakage_hours,
	round(
(t.total_logged_hours - coalesce(i.billed_hours,0))
* t.avg_hourly_rate, 2
	) as leakage_inr,

	round(
case when t.total_logged_hours = 0 then 0
else (t.total_logged_hours - coalesce(i.billed_hours, 0))
/ t.total_logged_hours * 100
	end , 2) as leakage_pct,

case
	    when ((t.total_logged_hours - coalesce(i.billed_hours, 0))
		/ nullif(t.total_logged_hours, 0) * 100) > 8
		then 'High Risk'

		when ((t.total_logged_hours - coalesce(i.billed_hours, 0))
		/ nullif(t.total_logged_hours, 0) * 100) > 4
		then 'Medium Risk'

		else 'Low Risk'
	end as risk_flag,

	coalesce(i.client_name, 'No Invoice') as client_name,
	coalesce(i.invoice_amount_inr, 0) as invoice_amount_inr

from (
select project_id, billing_month, project_manager, department,
sum(logged_hours) as total_logged_hours,
avg(hourly_rate_inr) as avg_hourly_rate
from fact_timesheet
group by project_id, billing_month, project_manager, department
) t

left join fact_invoices i
    on t.project_id = i.project_id and t.billing_month = i.billing_month;

select * from vw_revenue_leakage_summary
where risk_flag = 'High Risk'
order by leakage_inr desc;
