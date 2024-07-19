with cte as (
select t3.Season_Id, t4.Season_Year, t1.Match_Id, t1.Over_Id, t1.Ball_Id, t1.Innings_No, t1.Striker, t2.Runs_Scored
from ball_by_ball t1 
join batsman_scored t2
on t1.Match_Id=t2.Match_Id and t1.Over_Id=t2.Over_Id and t1.Ball_Id=t2.Ball_Id and t1.Innings_No=t2.Innings_No
join matches t3
on t1.Match_Id=t3.Match_Id
join season t4
on t3.Season_Id=t4.Season_Id
where t4.Season_Year in (2015,2016)
),

cte2 as (
select Striker, sum(Runs_Scored) as Total_Runs from cte 
group by 1
),

cte3 as (
select Striker, sum(Runs_Scored) as Runs_In_Boundaries from cte
where Runs_Scored in (4,6)
group by 1
)

select t1.Striker as Player_Id, t3.Player_Name, t1.Total_Runs, t2.Runs_In_Boundaries, round((t2.Runs_In_Boundaries*100/t1.Total_Runs),2) as Boundary_Percentage 
from cte2 t1 
join cte3 t2 
on t1.Striker=t2.Striker
join player t3 
on t1.Striker=t3.Player_Id
where t1.Total_Runs>=100
order by Boundary_Percentage desc;
