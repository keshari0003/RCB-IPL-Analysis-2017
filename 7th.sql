create view highest_wickets_taken as
(
with cte as (
select t5.Season_Year, t1.Match_Id, t1.Innings_No, t1.Over_Id, t1.Ball_Id, t1.Bowler, t2.Kind_Out, t3.Out_Name
from ball_by_ball t1
join wicket_taken t2
on t1.Match_Id=t2.Match_Id and t1.Over_Id=t2.Over_Id and t1.Ball_Id=t2.Ball_Id and t1.Innings_No=t2.Innings_No
join out_type t3
on t2.Kind_Out=t3.Out_Id
join matches t4
on t1.Match_Id=t4.Match_Id
join season t5
on t4.Season_Id=t5.Season_Id
where t3.Out_Name not in ("run out","retired hurt","obstructing the field")
),
cte2 as (
select Bowler, count(Out_Name) as Total_Wickets from cte
group by Bowler
)
select c2.Player_Id, c2.Player_Name, c1.Total_Wickets
from cte2 c1
join player c2
on c1.Bowler=c2.Player_Id
order by c1.Total_Wickets desc
);
create view runs_conceded as
(
with cte as (
select t4.Season_Year, t1.Match_Id, t1.Innings_No, t1.Over_Id, t1.Ball_Id, t1.Bowler, t2.Runs_Scored
from ball_by_ball t1
join batsman_scored t2
on t1.Match_Id=t2.Match_Id and t1.Over_Id=t2.Over_Id and t1.Ball_Id=t2.Ball_Id and t1.Innings_No=t2.Innings_No
join matches t3
on t1.Match_Id=t3.Match_Id
join season t4
on t3.Season_Id=t4.Season_Id
),
cte2 as (
select t1.Match_Id, t1.Innings_No, t1.Over_Id, t1.Ball_Id, t1.Bowler, t2.Extra_Type_Id, t2.Extra_Runs, t3.Extra_Name
from ball_by_ball t1
left join extra_runs t2
on t1.Match_Id=t2.Match_Id and t1.Over_Id=t2.Over_Id and t1.Ball_Id=t2.Ball_Id and t1.Innings_No=t2.Innings_No
left join extra_type t3
on t2.Extra_Type_Id=t3.Extra_Id
),
cte3 as (
select Bowler, sum(Runs_Scored) as Runs_Concede from cte
group by 1
),
cte4 as (
select Bowler, sum(Extra_Runs) as Extras_Concede from cte2
where Extra_Type_Id is not null and Extra_Name in ("wides","noballs")
group by 1
)
select c1.Bowler, c1.Runs_Concede, c2.Extras_Concede, (c1.Runs_Concede+coalesce(c2.Extras_Concede,0)) as Total_Runs_Conceded
from cte3 c1
left join cte4 c2
on c1.Bowler=c2.Bowler
);
select t1.*, t2.Total_Runs_Conceded, round((t2.Total_Runs_Conceded/t1.Total_Wickets),2) as Bowling_Average
from highest_wickets_taken t1
join runs_conceded t2
on t1.Player_Id=t2.Bowler
where t1.Total_Wickets >= 25
order by Bowling_Average asc;