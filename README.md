# IT Services Revenue Leakage Detection System

Detecting unbilled work and revenue loss in IT services using **PostgreSQL, Google Sheets, and Power BI**.

---

## Problem Statement

In IT services companies, developers log hours in internal systems, but not all of those hours get billed to clients.

This mismatch between **timesheet data** and **invoice data** leads to **revenue leakage**, directly impacting company profitability.

---

## Tech Stack

-  PostgreSQL  
-  Power BI Desktop  
-  Google Sheets  
 
---

##  Architecture
```
Raw CSV Data (Timesheet + Invoice)
            ↓
PostgreSQL Database
            ↓
SQL View (vw_revenue_leakage_summary)
            ↓
┌───────────────────────────┐
↓                           ↓
Google Sheets               Power BI
(Pivot + Pareto)            (Dashboard)
```

---

##  Solution Approach

- Designed a **star schema**:
  - `fact_timesheet`
  - `fact_invoices`
  - `dim_projects`

- Built a **LEFT JOIN reconciliation logic** to detect:
  - Missing invoices  
  - Under-billing  

- Created reusable SQL view:
  - `vw_revenue_leakage_summary`

- Performed analysis using:
  - Pivot heatmaps  
  - Pareto (80/20) analysis  

- Developed a **Power BI dashboard**

---

##  Key Metrics

- Total Logged Hours  
- Total Billed Hours  
- Total Leakage Hours  
- Revenue Leakage (₹)  
- Leakage %  
- Billing Efficiency %  
- High Risk Projects  
- Missing Invoice Cases  

---

##  Key Insights

- Multiple projects showed **100% leakage (no invoice generated)**  
- ~20% of projects contributed to ~80% of total leakage (**Pareto principle**)  
- Certain departments consistently showed higher leakage  
- Monthly spikes indicate billing delays or process inefficiencies  

---

##  Dashboard Preview

<img width="1452" height="835" alt="image" src="https://github.com/user-attachments/assets/310d7bc5-0300-431b-a168-2b5906fe8c93" />

---

##  Google Sheets Analysis

Includes:
- Project Manager vs Month Heatmap  
- Monthly Trend Chart  
- Pareto Analysis (Top leakage contributors)  

---

##  Project Structure
```
IT-Revenue-Leakage-Detection-System/
│
├── 01_raw_data/
├── 02_cleaned_data/
├── 03_sql_scripts/
├── 04_excel_analysis/
├── 05_powerbi/
├── 06_documentation/
└── README.md
```

---

##  Business Impact

- Identifies unbilled work instantly  
- Improves billing efficiency (~94% observed)  
- Flags high-risk projects using threshold alerts (>8%)  
- Enables finance teams to recover **₹ lakhs of lost revenue**  

---

##  30-Second Pitch

> I built a revenue leakage detection system for an IT services company where logged hours were not always matching billed hours. Using PostgreSQL, I wrote a LEFT JOIN reconciliation query to identify leakage at project-month level, created a SQL view for reuse, performed Pareto analysis in Google Sheets, and built a 4-page Power BI dashboard. The system identified that a small number of projects contributed to the majority of leakage, enabling targeted financial action.

---

##  Why Google Sheets Instead of Excel?

Google Sheets was chosen deliberately for its **browser-based accessibility and easy sharing**.

- Heavy processing → PostgreSQL  
- Analysis → Google Sheets  
- Dashboard → Power BI  

Each tool was used for what it does best.

---

##  SQL Scripts

Check `/03_sql_scripts/` for: 

- Table creation  
- Data cleaning  
- Reconciliation logic  
- View creation  

---

##  Setup Instructions

1. Install PostgreSQL  
2. Create database: `revenue_leakage_db`  
3. Import CSV files into tables  
4. Run SQL scripts  
5. Create view:
```
vw_revenue_leakage_summary
```
6. Connect Power BI to PostgreSQL  
7. Build dashboard  

---

##  Resume Highlights

- Built end-to-end revenue leakage detection system  
- Implemented SQL reconciliation using LEFT JOIN  
- Identified high-risk projects using Pareto analysis  
- Developed interactive Power BI dashboard with DAX  

---

##  Quick Access

All project components are organized for easy navigation:

-  SQL logic → `/03_sql_scripts`
-  Dashboard → `/05_powerbi`
-  Documentation → `/06_documentation`
  
##  Conclusion

This project demonstrates how data analytics can uncover hidden financial inefficiencies and drive business decisions using a modern, cost-effective tool stack.

---

##  Project Status: COMPLETE

**PostgreSQL • Google Sheets • Power BI • 100% Free Stack**

---

##  Acknowledgement

This project was built as part of a self-driven data analytics portfolio to simulate real-world IT services revenue scenarios.

---

##  Connect With Me

If you found this project interesting or have feedback, feel free to connect:

-  LinkedIn: https://www.linkedin.com/in/your-link
-  Email: dishagirase2806@gmail.com
-  GitHub: https://github.com/DishaGirase

---

⭐ If you found this useful, consider giving it a star!
