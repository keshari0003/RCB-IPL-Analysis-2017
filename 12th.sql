With cte as (
select t3.Season_Id, t4.Season_Year, t1.Match_Id, t1.Over_Id, t1.Ball_Id, t1.Innings_No, t1.Striker, t2.Runs_Scored
from ball_by_ball t1
join batsman_scored t2
on t1.Match_Id=t2.Match_Id and t1.Over_Id=t2.Over_Id and t1.Ball_Id=t2.Ball_Id and t1.Innings_No=t2.Innings_No
join matches t3
on t1.Match_Id=t3.Match_Id
join season t4
on t3.Season_Id=t4.Season_Id
),
cte2 as (
select *, dense_rank() over(order by Season_Year desc) as rnk from cte
),
cte3 as (
select * from cte2
where rnk<=2
order by Season_Year desc
),
cte4 as (
select Striker, sum(Runs_Scored) as Total_Runs, count(Striker) as Total_Balls from cte3
group by 1
)
select c1.Striker as Player_Id, c2.Player_Name, c1.Total_Runs, c1.Total_Balls, round((c1.Total_Runs/c1.Total_Balls)*100,2) as Strike_Rate
from cte4 c1
left join player c2
on c1.Striker=c2.Player_Id
where Total_Balls>=200
order by Strike_Rate desc
limit 20;