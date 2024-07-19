with cte as (
select *, round((Total_Runs/Total_Dismissals),2) as Average from Total_Players_Avg
),
cte2 as (
select Player_Id, sum(case when Average>30 then 1 else 0 end) as Total_Count
from cte
group by 1
having Total_Count>=4
order by Player_Id
),
cte3 as (
select t1.Player_Id, t2.Player_Name
from cte2 t1
join player t2
on t1.Player_Id=t2.Player_Id
),
cte4 as (
select Player_Id, Season_Year, round((Total_Runs/Total_Dismissals),2) as Average from Total_Players_Avg
where Player_Id in
(
select Player_Id from cte3
)
)
select t1.Player_Id, t2.Player_Name, t1.Season_Year, t1.Average
from cte4 t1
join player t2
on t1.Player_Id=t2.Player_Id
order by t1.Player_Id, t1.Season_Year;
