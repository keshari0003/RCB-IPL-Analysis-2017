create view avg_runs_greater_than_batting_avg as (
with cte as (
select Player_Id, sum(Total_Runs) as Total_Runs, sum(Total_Dismissals) as Total_Dismissals from Total_Players_Avg
group by 1
),
cte2 as (
select Player_Id, Total_Runs, Total_Dismissals, round((Total_Runs/Total_Dismissals),2) as Average from cte
order by Player_Id
),
cte3 as (
select t1.Player_Id, t2.Player_Name, t1.Total_Runs, t1.Total_Dismissals, t1.Average
from cte2 t1
join player t2
on t1.Player_Id=t2.Player_Id
order by t1.Player_Id
),
cte4 as (
select round(avg(Average),2) as Overall_Batting_Average from cte3
)
select * from cte3 cross join cte4
where Average>Overall_Batting_Average
);
create view wickets_greater_than_bowling_avg as (
With cte as (
select t2.*, t1.Total_Runs_Conceded, round((t1.Total_Runs_Conceded/t2.Total_Wickets),2) as Bowling_Average
from runs_conceded t1
join highest_wickets_taken t2
on t1.Bowler=t2.Player_Id
),
cte2 as (
select round(avg(Bowling_Average),0) as Overall_Bowling_Average from cte
)
select * from cte cross join cte2
where Total_Wickets>Overall_Bowling_Average
);
select t1.Player_Id, t1.Player_Name, t1.Total_Runs, t1.Average as Batting_Average, t1.Overall_Batting_Average, t2.Total_Wickets, t2.Bowling_Average, t2.Overall_Bowling_Average
from avg_runs_greater_than_batting_avg t1
join wickets_greater_than_bowling_avg t2
on t1.Player_Id=t2.Player_Id;