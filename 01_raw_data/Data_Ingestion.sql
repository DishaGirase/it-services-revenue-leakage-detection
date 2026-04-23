---------------Data Ingestion (ETL) Phase--------------
--step 1: Create the Timesheet Table
--first create the timesheet table
-- this stores all employee hours logged on projects 

create table if not exists fact_timesheet (
 timesheet_id varchar(20) primary key,
 project_id varchar(20) not null,
 project_name varchar(100),
 employee_id varchar(20),
 employee_name varchar(100),
 billing_month varchar(7) not null,
 logged_hours decimal(8,2) not null,
 hourly_rate_inr decimal(10,2),
 project_manager varchar(100),
 department varchar(100),
 created_at timestamp default current_timestamp
);

--step 2: Create the Invoice Table
-- create the invoice table
-- this stores all billing data sent to clients

create table if not exists fact_invoices (
 invoice_id varchar(30) primary key,
 project_id varchar(20) not null,
 client_name varchar(100),
 billing_month varchar(7) not null,
 billed_hours decimal(8,2) not null,
 invoice_amount_inr decimal(12,2),
 invoice_date date,
 payment_status varchar(30),
 contract_type varchar(30),
 created_at timestamp default current_timestamp
);

--step 3: Create the Projects Dimension Table
-- dimension table for project details
-- as a lookup table

create table if not exists dim_projects (
 project_id varchar(20) primary key,
 project_name varchar(100),
 client_name varchar(100),
 project_manager varchar(100),
 start_date date,
 end_date date,
 contract_type varchar(30),
 hourly_rate_inr decimal(10,2),
 project_status varchar(30)
);

alter table fact_invoices
alter column billed_hours drop not null;

--running this query to check whether data loaded correctly
select 'fact_timesheet' as table_name , count(*) as row_count from fact_timesheet
union all
select 'fact_invoces', count(*) from fact_invoices;

