with cte as (
select t3.Season_Id, t4.Season_Year, t1.Match_Id, t1.Over_Id, t1.Ball_Id, t1.Innings_No, t1.Striker, t2.Runs_Scored, t5.Player_Out
from ball_by_ball t1 
join batsman_scored t2
on t1.Match_Id=t2.Match_Id and t1.Over_Id=t2.Over_Id and t1.Ball_Id=t2.Ball_Id and t1.Innings_No=t2.Innings_No
join matches t3
on t1.Match_Id=t3.Match_Id
join season t4
on t3.Season_Id=t4.Season_Id
left join wicket_taken t5
on t1.Match_Id=t5.Match_Id and t1.Over_Id=t5.Over_Id and t1.Ball_Id=t5.Ball_Id and t1.Innings_No=t5.Innings_No
where t4.Season_Year in (2015,2016)
),

cte2 as (
select Season_Year, Striker as Player_Id, sum(Runs_Scored) as Total_Runs from cte
group by 1,2
),

cte3 as (
select Season_Year, Player_Out as Player_Id, count(*) as Total_Dismissals from cte
where Player_Out is not null
group by 1,2
),

cte4 as (
select c1.*, c2.Total_Dismissals
from cte2 c1
join cte3 c2
on c1.Season_Year=c2.Season_Year and c1.Player_Id=c2.Player_Id
),

cte5 as (
select Player_Id, sum(Total_Runs) as Total_Runs, sum(Total_Dismissals) as Total_Dismissals from cte4
group by 1
),

cte6 as (
select Player_Id, Total_Runs, Total_Dismissals, round((Total_Runs/Total_Dismissals),2) as Average_Performance from cte5
order by Player_Id
)
select t2.Player_Name, t1.Total_Runs, t1.Total_Dismissals, t1.Average_Performance
from cte6 t1 
join player t2 
on t1.Player_Id=t2.Player_Id
where t1.Total_Runs>=500 and t1.Average_Performance>=30
order by t1.Average_Performance desc;

