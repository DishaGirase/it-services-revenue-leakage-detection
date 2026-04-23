SELECT
    timesheet_id,
    project_id,
    employee_id,
    project_manager,
    billing_month,
    logged_hours,
    hourly_rate_inr
FROM fact_timesheet
WHERE project_id IS NOT NULL
  AND billing_month IS NOT NULL
  AND logged_hours IS NOT NULL;

SELECT
    project_id,
    billing_month,
    billed_hours
FROM fact_invoices
WHERE project_id IS NOT NULL
  AND billing_month IS NOT NULL;