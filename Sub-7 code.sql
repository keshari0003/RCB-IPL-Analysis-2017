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
where t4.Season_Year between 2012 and 2016
),

cte2 as (
select Season_Year, sum(Runs_Scored) as Runs_in_PowerPlay_DeathOvers from cte
where (Over_Id between 1 and 6) or (Over_Id between 17 and 20)
group by 1
),

cte3 as (
select Season_Year, sum(Runs_Scored) as Runs_in_MiddleOvers from cte
where Over_Id between 7 and 16
group by 1
)

select t1.Season_Year, t1.Runs_in_PowerPlay_DeathOvers, t2.Runs_in_MiddleOvers
from cte2 t1 
join cte3 t2
on t1.Season_Year=t2.Season_Year;


-- ii) Comparison between Fall of Wickets during Power Play (1 to 6 overs) & Death Overs (17 to 20 overs) and Fall of Wickets during Middle Overs (7 to 16 Overs):

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
where t4.Season_Year between 2012 and 2016
),

cte2 as (
select Season_Year, count(Player_Out) as Wickets_Lost_In_PowerPlay_DeathOvers from cte
where (Over_Id between 1 and 6) or (Over_Id between 17 and 20)
group by 1
),

cte3 as (
select Season_Year, count(Player_Out) as Wickets_Lost_In_MiddleOvers from cte
where Over_Id between 7 and 16
group by 1
)

select t1.Season_Year, t1.Wickets_Lost_In_PowerPlay_DeathOvers, t2.Wickets_Lost_In_MiddleOvers
from cte2 t1 
join cte3 t2
on t1.Season_Year=t2.Season_Year;

