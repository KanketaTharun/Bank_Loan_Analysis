

Create table Load_Date(
Customer_id int Primary key,
Adress_State varchar(50),
Application_type varchar(50),
Emp_length varchar(50),
Emp_title varchar(50),
Grade varchar(20),
Home_ownership varchar(50),
Last_date date,
Last_credit_pull_date date,
Last_payment_date date,
Loan_status varchar(50),
Good_Loan_Bad_Loan varchar(50),
next_payment_date date,
member_id varchar(50),
Purpose varchar(50),
sub_grade varchar(50),
Term varchar(50),
verification_status varchar(50),
annual_income int,
dti int,
Installment int,
int_rate int,
Loan_amount int,
total_acc int,
total_payment int
);

--creating temporary table

Create table tmp_tabel(
Customer_id int,
Issue_date date
);

Select * from tmp_tabel;

--Updating the data in the main table

update Loan_data
set Issue_date = tmp_tabel.Issue_date
from tmp_tabel
where Loan_data.Customer_id = tmp_tabel.Customer_id;

--Droping the tmp table

Drop table tmp_tabel;

Alter table Load_date
Rename to Loan_data;

Alter table Loan_Data
Alter column dti type numeric(10,2),
Alter column Installment type numeric(10,2),
Alter column int_rate type numeric(10,2)

Alter table Loan_data
Alter Column Annual_income type numeric(10,2)

Alter table Loan_data
Alter column Emp_title type varchar(100)

Alter table Loan_data
add column Issue_date date

--Inserting data into single column

copy Loan_data(issue_date)
from 'C:\Users\tharun tharun\OneDrive\Desktop\K.Tharun\IT\Data analyst\Excel'
Delimiter ','
CSV;

Select * from Loan_data;

select Count(*) from Loan_data
where Grade = 'A';

--Total Loan Application

Select count(customer_id) as Total_Loan_application from Loan_Data;

--Month to Date Application

Select Count(customer_id) as Pmtd_Total_application from Loan_data
where Extract(Month from issue_date) = 12 and Extract(Year from issue_date) = 2021;

--Previous Month to date Applicaton

Select Count(customer_id) as Pmtd_Total_application from Loan_data
where Extract(Month from issue_date) = 11 and Extract(Year from issue_date) = 2021;

--or

Select Count(customer_id) as Pmtd_Total_application from Loan_data
where Issue_date >= '2021-11-01' and Issue_date < '2021-12-01';

--Total Funded Amount

Select Sum(Loan_amount) as Total_funded_amount from Loan_data;

--MTD

Select Sum(Loan_amount) as mtd_Total_funded_amount from Loan_data
where Issue_date >= '2021-12-01' and Issue_date < '2022-01-01';

--PMTD

Select Sum(Loan_amount) as Pmtd_Total_funded_amount from Loan_data
where Issue_date >= '2021-11-01' and Issue_date < '2021-12-01';


--Total Amount Received

Select Sum(total_payment) As Total_Received_amount from Loan_data;

--MTD

Select Sum(total_payment) as mtd_Total_Received_amount from Loan_data
where Issue_date >= '2021-12-01' and Issue_date < '2022-01-01';

--PMTD


Select Sum(total_payment) as Pmtd_Total_Received_amount from Loan_data
where Issue_date >= '2021-11-01' and Issue_date < '2021-12-01';

--Average Interset Rate

Select Round(Avg(int_rate) * 100,2) as Average_interest_rate from Loan_data;

--MTD

Select Round(Avg(int_rate) * 100,2) as mtd_Average_interest_rate from Loan_data
where Issue_date >= '2021-12-01' and Issue_date < '2022-01-01';

--PMTD


Select Round(Avg(int_rate) * 100,2) as Pmtd_Average_interest_rate from Loan_data
where Issue_date >= '2021-11-01' and Issue_date < '2021-12-01';

--Average Debt to interest Rate

Select Round(avg(dti)*100,2) as Debt_to_interest from Loan_data;

--MTD

Select Round(avg(dti)*100,2) as mtd_Debt_to_interest from Loan_data
where Issue_date >= '2021-12-01' and Issue_date < '2022-01-01';

--PMTD


Select Round(avg(dti)*100,2) as Pmtd_Debt_to_interest from Loan_data
where Issue_date >= '2021-11-01' and Issue_date < '2021-12-01';


--Good Loan Percentage

Select (Count(case when Loan_status = 'Fully Paid' or Loan_status = 'Current' Then Customer_id end) * 100 )/
count(Customer_id) as Good_Loan_percentage from Loan_data;

--Bad Loan Percentage

Select Count(customer_id) as Good_loan_application from Loan_data
where Loan_status = 'Fully Paid' or Loan_status = 'Current';

--Good Loan funded

Select Sum(Loan_amount) as Good_loan_application from Loan_data
where Loan_status = 'Fully Paid' or Loan_status = 'Current';

--Good Loan amount received


Select Sum(total_Payment) as Good_loan_application from Loan_data
where Loan_status = 'Fully Paid' or Loan_status = 'Current';

--Bad Loan Issued

--Bad Loan Percentage

SELECT 
    (COUNT(CASE WHEN Trim(lower(loan_status)) = 'charged off' THEN customer_id END) * 100.0) / 
    COUNT(customer_id) AS Bad_Loan_Percentage 
FROM Loan_data;

--or

SELECT 
    (COUNT(*) FILTER (WHERE TRIM(LOWER(loan_status)) = 'charged off') * 100.0) / 
    NULLIF(COUNT(*), 0) AS Bad_Loan_Percentage 
FROM Loan_data;

--Bad Loan amount Funded

Select sum(Loan_amount) as Bad_Loan_funded_amount from Loan_data
Where Loan_status = 'Charged Off';

--Bad Loan Amount received

Select sum(total_payment) as Bad_Loan_amount_received from Loan_data
Where Loan_status = 'Charged Off';

--Grid View

Select Loan_status, Count(Customer_id) as Loan_count, Sum(Loan_amount) as Total_amount_funded,
sum(total_payment) as Total_amount_received, Round(Avg(int_rate * 100),2) as Interest_rate,
Round(Avg(dti * 100),2) as DTI from Loan_data
Group by Loan_status;

--MTD

Select Loan_status,Sum(Loan_amount) as MTD_Total_amount_funded,
sum(total_payment) as MTD_Total_amount_received from Loan_Data
Where Issue_date >= '01-12-2021' and Issue_date < '31-12-2021'
Group by Loan_status;


--KPIs By month

Select To_char(issue_date,'Month') As Month_Name,
count(customer_id) As Total_Loan_application,
sum(Loan_amount) as Total_funded_amount,
Sum(total_Payment) as Total_amount_received
From Loan_data
Group by To_char(issue_date,'Month'), extract(Month from issue_date)
order by Extract(Month from issue_date);

--Reagional Analysis by state
Select * from loan_Data;

Select adress_state,
count(customer_id) As Total_Loan_application,
sum(Loan_amount) as Total_funded_amount,
Sum(total_Payment) as Total_amount_received
From Loan_data
Group by adress_state
order by Total_Loan_application desc;

--Term Analysis

Select term,
count(customer_id) As Total_Loan_application,
sum(Loan_amount) as Total_funded_amount,
Sum(total_Payment) as Total_amount_received
From Loan_data
Group by Term
order by Total_Loan_application desc;

--emp_length Analysis

Select Emp_length,
count(customer_id) As Total_Loan_application,
sum(Loan_amount) as Total_funded_amount,
Sum(total_Payment) as Total_amount_received
From Loan_data
Group by Emp_length
order by Emp_length Desc;

--Purpose


Select Purpose,
count(customer_id) As Total_Loan_application,
sum(Loan_amount) as Total_funded_amount,
Sum(total_Payment) as Total_amount_received
From Loan_data
Group by Purpose
order by Total_Loan_application Desc;


--Home Ownership

Select home_ownership,
count(customer_id) As Total_Loan_application,
sum(Loan_amount) as Total_funded_amount,
Sum(total_Payment) as Total_amount_received
From Loan_data
Group by home_ownership
order by Total_Loan_application Desc;


 
