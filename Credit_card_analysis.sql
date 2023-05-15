
/*
1. write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends 
*/
with cte as
(select City,sum(Amount) as total_amount_spent from credit_card
group by City
),cte1 as
(
select sum(cast(Amount as bigint)) as total_credit from credit_card
)
select  top 5 a.City,a.total_amount_spent,round((100.0*cast(total_amount_spent as Bigint)/total_credit),2)as percent_contribution from cte a
join cte1 b
on 1=1
order by 3 desc;

/*
2. write a query to print highest spend month and amount spent in that month for each card type*/

with cte as
(
select DATEPART(year,Transaction_date) as yr,DATEPART(month,Transaction_date) as mt,Card_Type,sum(Amount) as Amount_spent  from Credit_card
group by DATEPART(year,Transaction_date),DATEPART(month,Transaction_date),Card_Type
),cte1 as
(
select *,DENSE_RANK() over(partition by Card_Type order by Amount_spent desc) as rn from cte
)
select yr,mt,Card_Type,Amount_spent from cte1
where rn=1;

/*
3. write a query to print the transaction details(all columns from the table) for each card type when
it reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type)
*/
with cte as
(select *,sum(Amount) over(partition by Card_Type order by Transaction_date  rows between unbounded preceding and current row ) as cum_sum from Credit_card
),cte1 as
(
select *,DENSE_RANK() over(partition by Card_Type order by cum_sum) as rn from cte
where cum_sum>=1000000
)
select * from cte1
where rn=1;

/*
4. write a query to find city which had lowest percentage spend for gold card type
*/
with cte as
(
select City,Card_Type,sum(Amount) as citywise_amount_spent from credit_card
where Card_Type='Gold'
group by City,Card_Type
),cte1 as
(
select City,sum(cast (Amount as bigint)) as all_city_amount_spent from credit_card
group by City
)
select Top 1 a.City,a.Card_Type,a.citywise_amount_spent,b.all_city_amount_spent,100.0*a.citywise_amount_spent/b.all_city_amount_spent as per_contribution from cte as a
join cte1 b
on a.City=b.City
order by 3;

/*
5. write a query to print 3 columns: city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)
*/
with cte as
(
select City,Exp_Type,sum(Amount) as Cate_by_exp from Credit_card
group by City, Exp_Type
),cte1  as
(
select City,max(Cate_by_exp) as max_ex,min(Cate_by_exp) as min_ex from cte
group by City
)
select a.City,max(case when Cate_by_exp=max_ex then Exp_Type else null end) as Higehest_exp_type, max(case when Cate_by_exp=min_ex then Exp_Type else null end) as Lowest_exp_type from cte a
join cte1 b
on a.City=b.
City
group by a.City;

/*
6. write a query to find percentage contribution of spends by females for each expense type
*/

with cte as
(
select Exp_Type,sum(Amount) as Total_exp from Credit_card
group by Exp_Type
),cte1 as
(
select Exp_Type,sum(Amount) as Total_Female_exp from Credit_card
where Gender='F'
group by Exp_Type
)
select a.Exp_Type,a.Total_exp as total_amount_spent,b.Total_Female_exp as total_amount_spent_female,
1.0*b.Total_Female_exp/a.Total_exp as per_contribution
from cte a
join cte1  b
on a.Exp_Type=b.Exp_Type;
















