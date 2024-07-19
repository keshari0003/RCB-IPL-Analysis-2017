with cte as (
select t1.Bowler as Player_Id, t2.Player_Name, t1.Total_Runs_Conceded, t2.Total_Wickets, round((t1.Total_Runs_Conceded/t2.Total_Wickets),2) as Average,
t4.Bowling_Id, t4.Bowling_Skill
from runs_conceded t1
join highest_wickets_taken t2
on t1.Bowler=t2.Player_Id
join player t3
on t1.Bowler=t3.Player_Id
join bowling_style t4
on t3.Bowling_skill=t4.Bowling_Id
)
select Bowling_Skill, sum(Total_Runs_Conceded) as Total_Runs_Given, sum(Total_Wickets) as Total_Wickets_Taken, round(avg(Average),2) as Bowling_Average from cte
group by 1;