with cte as (
select t3.Season_Id, t4.Season_Year, t3.Venue_Id, t5.Venue_Name, t1.Match_Id, t1.Over_Id, t1.Ball_Id, t1.Innings_No, t1.Striker, t2.Runs_Scored
from ball_by_ball t1
join batsman_scored t2
on t1.Match_Id=t2.Match_Id and t1.Over_Id=t2.Over_Id and t1.Ball_Id=t2.Ball_Id and t1.Innings_No=t2.Innings_No
join matches t3
on t1.Match_Id=t3.Match_Id
join season t4
on t3.Season_Id=t4.Season_Id
join venue t5
on t3.Venue_Id=t5.Venue_Id
),
cte2 as (
select Venue_Id, Venue_Name, Striker, sum(Runs_Scored) as Total_Runs from cte
group by 1,2,3
),
cte3 as (
select *, dense_rank() over(partition by Venue_Name order by Total_Runs desc) as Ranking
from cte2
order by Venue_Id
),
cte4 as (
select * from cte3
where Ranking=1
order by Venue_Id, Ranking
)
select t1.Venue_Id, t1.Venue_Name, t2.Player_Id, t2.Player_Name, t1.Total_Runs, t1.Ranking
from cte4 t1
join player t2
on t1.Striker=t2.Player_Id;