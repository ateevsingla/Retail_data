

--Q1. Data preparation and understanding--

SELECT 'Customer' as Table_name , count(*) as Total_rows
FROM Customer
UNION
SELECT 'Transactions' as Transaction_table , COUNT(*)
FROM TRANSACTIONS
UNION
SELECT 'Prod cat info' as Prod_cat_table , COUNT(*) 
FROM PROD_CAT_INFO;

--Q2. Data preparation and understanding--

select count(distinct transaction_id) as total_return_transactions
from transactions
where Qty < 0;

--Q3. Data preparation and understanding--

select
convert(DATE,tran_date,105) as convert_date
from transactions;

--Q4. Data preparation and understanding--

select 
datediff(YEAR,min(tran_date),max(tran_date))as _years,
datediff(month,min(tran_date),max(tran_date))as _months,
datediff(day,min(tran_date),max(tran_date))as _days
from transactions;

--Q5. Data preparation and understanding--

select prod_cat, prod_subcat
from prod_cat_info
WHERE prod_subcat = 'DIY'


--Q1- Data Analysis--

select distinct Store_type,
count(store_type) as no_of_transactions
from Transactions
group by store_type
order by count(store_type) desc;
    -----e-shop channel is most frequently used for transactions--

--Q2- Data Analysis--

select distinct Gender,
count(gender) as no_of_customers
from Customer
where gender is not null
group by gender;

--Q3- Data Analysis--

select top 1 city_code,
count(city_code) as no_of_customers
from Customer
where city_code is not null
group by city_code
order by COUNT(city_code) desc;

--Q4- Data Analysis--

select prod_cat,
count(prod_sub_cat_code) as no_of_sub_categories
from prod_cat_info
where prod_cat = 'Books'
group by prod_cat;

--Q5- Data Analysis--

select
max(Qty) as max_order_quantity
from Transactions;

--Q6- Data Analysis--

select
sum(total_amt) as required_revenue
from Transactions
where prod_cat_code in (select distinct prod_cat_code as required_prod_cat
from prod_cat_info
where prod_cat in ('Electronics','Books'));

--Q7- Data Analysis--

select distinct cust_id,
count(cust_id) as no_of_transactions
from Transactions
where qty > 0
group by cust_id
having count(cust_id) > 10
order by count(cust_id) desc
;

--Q8- Data Analysis--

select
sum(total_amt) as required_revenue
from transactions
where prod_cat_code in (select distinct prod_cat_code
from prod_cat_info
where prod_cat in ('clothing','Electronics')
) and Store_type = 'Flagship store';

--Q9- Data Analysis--

select prod_subcat,
sum(total_amt) as total_revenue
from Transactions as T
left join prod_cat_info as P
on T.prod_cat_code = P.prod_cat_code and T.prod_subcat_code = P.prod_sub_cat_code
where cust_id in (select customer_Id
from Customer
where Gender = 'M')
And 
prod_cat in (select prod_cat
from prod_cat_info
where prod_cat = 'Electronics')
group by prod_subcat
;

--Q10- Data Analysis--

Select sales.prod_subcat , [%sales] , [%return] from
(select Top 5 prod_subcat, sum(total_amt)/(select sum(total_amt) as total_revenue  from transactions
where total_amt > 0)*100 as [%sales]
from Transactions as T
left join prod_cat_info as P
on T.prod_cat_code = P.prod_cat_code and T.prod_subcat_code = P.prod_sub_cat_code
where total_amt > 0
group by prod_subcat
order by 2 desc) as sales
left join
(select prod_subcat, sum(total_amt)/(select sum(total_amt) as total_revenue  from transactions
where total_amt < 0)*100 as [%return]
from Transactions as T
left join prod_cat_info as P
on T.prod_cat_code = P.prod_cat_code and T.prod_subcat_code = P.prod_sub_cat_code
where total_amt < 0
group by prod_subcat) as _return
on sales.prod_subcat = _return.prod_subcat

--Q11- Data Analysis--

select cust_id, total_revenue from (select cust_id, tran_date, sum(total_amt) as total_revenue,
max(tran_date) as _maxdate
from transactions
group by cust_id, tran_date) as T
left join Customer as R
on T.cust_id = R.customer_Id
where DATEDIFF(Day,DOB,_maxdate)/365 between 25 and 35
and tran_date >= (Select dateadd(day,-30,max(tran_date)) from Transactions)

--Q12- Data Analysis--

select top 1 prod_cat,sum(qty)as total_returns from Transactions a
join prod_cat_info b on a.prod_cat_code = b.prod_cat_code and a.prod_subcat_code = b.prod_sub_cat_code
where Qty<0 and tran_date >=  (Select dateadd(day,-90,max(tran_date)) from Transactions)
group by prod_cat
order by 2;

--Q13- Data Analysis--

select top 1 Store_type, sum(Qty)as total_quantity,
sum(total_amt) as total_sales
from transactions
where Qty > 0
group by Store_type
order by 3 desc , 2 desc;

--Q14- Data Analysis--

select prod_cat ,
avg(total_amt) as total_revenue
from Transactions as T
left join prod_cat_info as P
on T.prod_cat_code = P.prod_cat_code and T.prod_subcat_code = P.prod_sub_cat_code
group by prod_cat
having avg(total_amt) > (select avg(total_amt) from transactions);

--Q15- Data Analysis--

select prod_cat, prod_subcat, sum(total_amt) as Total_Revenue, avg(total_amt) as Average_Revenue
from transactions as T
left join prod_cat_info as P
on T.prod_cat_code = P.prod_cat_code and T.prod_subcat_code = P.prod_sub_cat_code
where prod_cat in (select top 5 prod_cat
from transactions as T
left join prod_cat_info as P
on T.prod_cat_code = P.prod_cat_code and T.prod_subcat_code = P.prod_sub_cat_code
where Qty > 0
group by prod_cat
order by  sum(Qty) desc) 
group by prod_cat, prod_subcat;






