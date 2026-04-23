--- 04_views
DROP VIEW vw_revenue_leakage_summary;
CREATE OR REPLACE VIEW vw_revenue_leakage_summary AS
SELECT
    t.project_id,
    t.billing_month,
    t.project_manager,
    t.department,

    t.total_logged_hours,

    COALESCE(i.total_billed_hours,0) AS total_billed_hours,

    (t.total_logged_hours - COALESCE(i.total_billed_hours,0)) AS leakage_hours,

    ROUND(
        (t.total_logged_hours - COALESCE(i.total_billed_hours,0)) * t.avg_hourly_rate, 2
    ) AS leakage_inr,

    ROUND(
        CASE 
            WHEN t.total_logged_hours = 0 THEN 0
            ELSE (t.total_logged_hours - COALESCE(i.total_billed_hours,0)) 
                 / t.total_logged_hours * 100
        END, 2
    ) AS leakage_pct,

    CASE
        WHEN ((t.total_logged_hours - COALESCE(i.total_billed_hours,0))
             / NULLIF(t.total_logged_hours,0) * 100) > 8
        THEN 'High Risk'

        WHEN ((t.total_logged_hours - COALESCE(i.total_billed_hours,0))
             / NULLIF(t.total_logged_hours,0) * 100) > 4
        THEN 'Medium Risk'

        ELSE 'Low Risk'
    END AS risk_flag,

    COALESCE(i.client_name, 'No Invoice') AS client_name,
    COALESCE(i.invoice_amount_inr, 0) AS invoice_amount_inr

FROM (
    -- Timesheet aggregated ✅
    SELECT 
        project_id, 
        billing_month, 
        project_manager, 
        department,
        SUM(logged_hours) AS total_logged_hours,
        AVG(hourly_rate_inr) AS avg_hourly_rate
    FROM fact_timesheet
    GROUP BY project_id, billing_month, project_manager, department
) t

LEFT JOIN (
    -- 🔥 FIX: aggregate invoices FIRST
    SELECT 
        project_id,
        billing_month,
        SUM(billed_hours) AS total_billed_hours,
        MAX(client_name) AS client_name,
        SUM(invoice_amount_inr) AS invoice_amount_inr
    FROM fact_invoices
    GROUP BY project_id, billing_month
) i

ON t.project_id = i.project_id 
AND t.billing_month = i.billing_month;

-- Test your view
SELECT * FROM vw_revenue_leakage_summary
WHERE risk_flag = 'High Risk'
ORDER BY leakage_inr DESC;