create view teams_score_each_season as (
With cte1 as (
select t1.Match_Id, t1.Team_1, t1.Team_2, t2.Team_Name, t1.Season_ID, t1.Toss_Winner, t1.Toss_Decide, t3.Toss_Name
from matches t1
join team t2
on t1.Team_1=t2.Team_Id or t1.Team_2=t2.Team_Id
join toss_decision t3
on t1.Toss_Decide=t3.Toss_Id
order by t1.Match_Id
),
cte2 as (
select distinct Match_Id, Team_1, Team_2, Season_ID, Toss_Winner, Toss_Decide, Toss_Name,
case when Toss_Winner=Team_1 and Toss_Name="bat" then Team_1
when Toss_Winner=Team_1 and Toss_Name="field" then Team_2
when Toss_Winner=Team_2 and Toss_Name="bat" then Team_2
when Toss_Winner=Team_2 and Toss_Name="field" then Team_1
end as First_Innings
from cte1
),
cte3 as (
select *,
case when First_Innings=Team_1 then Team_2 else Team_1 end as Second_Innings
from cte2
),
cte4 as (
select Match_Id, Innings_No, sum(Extra_Runs) as Extras from extra_runs
group by 1,2
),
cte5 as (
select Match_Id, Innings_No, sum(Runs_Scored) as Runs from batsman_scored
group by 1,2
),
cte6 as (
select cte4.Match_Id, cte4.Innings_No, cte5.Runs, cte4.Extras, cte5.Runs+cte4.Extras as Score
from cte4 join cte5
on cte4.Match_Id=cte5.Match_Id and cte4.Innings_No=cte5.Innings_No
),
cte7 as (
select t1.Season_ID, t1.Match_Id, t1.Team_1, t1.Team_2, t1.First_Innings, t1.Second_Innings, t2.Innings_No,
case when t2.Innings_No=1 then t2.Score end as First_Innings_Score,
case when t2.Innings_No=2 then t2.Score end as Second_Innings_Score
from cte3 t1 join cte6 t2
on t1.Match_Id=t2.Match_Id
),
cte8 as (
select Season_ID, First_Innings, sum(First_Innings_Score) as Score_First_Batting from cte7
group by 1,2
),
cte9 as (
select Season_ID, Second_Innings, sum(Second_Innings_Score) as Score_Second_Batting from cte7
group by 1,2
)
select c1.Season_ID, c4.Season_Year, c1.First_Innings as Team_ID, c3.Team_Name, c1.Score_First_Batting, c2.Score_Second_Batting,
c1.Score_First_Batting+c2.Score_Second_Batting as Total_Score
from cte8 c1 join cte9 c2
on c1.Season_ID=c2.Season_ID and c1.First_Innings=c2.Second_Innings
join team c3
on c1.First_Innings=c3.Team_Id
join season c4
on c1.Season_ID=c4.Season_Id
);
create view team_wickets_each_season as (
With cte1 as (
select t1.Match_Id, t1.Team_1, t1.Team_2, t2.Team_Name, t1.Season_ID, t1.Toss_Winner, t1.Toss_Decide, t3.Toss_Name
from matches t1
join team t2
on t1.Team_1=t2.Team_Id or t1.Team_2=t2.Team_Id
join toss_decision t3
on t1.Toss_Decide=t3.Toss_Id
order by t1.Match_Id
),
cte2 as (
select distinct Match_Id, Team_1, Team_2, Season_ID, Toss_Winner, Toss_Decide, Toss_Name,
case when Toss_Winner=Team_1 and Toss_Name="bat" then Team_1
when Toss_Winner=Team_1 and Toss_Name="field" then Team_2
when Toss_Winner=Team_2 and Toss_Name="bat" then Team_2
when Toss_Winner=Team_2 and Toss_Name="field" then Team_1
end as First_Innings
from cte1
),
cte3 as (
select *,
case when First_Innings=Team_1 then Team_2 else Team_1 end as Second_Innings
from cte2
),
cte4 as (
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
),
cte5 as (
select Season_Year, Match_Id, Innings_No, count(*) as Wickets from cte4
group by 1,2,3
),
cte6 as (
select t1.Season_ID, t2.Season_Year, t1.Match_Id, t1.Team_1, t1.Team_2, t1.First_Innings, t1.Second_Innings, t2.Innings_No,
case when t2.Innings_No=1 then t2.Wickets end as First_Innings_Wickets,
case when t2.Innings_No=2 then t2.Wickets end as Second_Innings_Wickets
from cte3 t1 join cte5 t2
on t1.Match_Id=t2.Match_Id
),
cte7 as (
select Season_ID, Season_Year, First_Innings, sum(Second_Innings_Wickets) as Wickets_1 from cte6
group by 1,2,3
),
cte8 as (
select Season_ID, Season_Year, Second_Innings, sum(First_Innings_Wickets) as Wickets_2 from cte6
group by 1,2,3
)
select c1.Season_ID, c1.Season_Year, c1.First_Innings as Team_ID, c3.Team_Name, c1.Wickets_1, c2.Wickets_2, c1.Wickets_1+c2.Wickets_2 as Total_Wickets
from cte7 c1
join cte8 c2
on c1.Season_ID=c2.Season_ID and c1.First_Innings=c2.Second_Innings
join team c3
on c1.First_Innings=c3.Team_Id
);
With cte as (
select t1.Season_ID, t1.Season_Year, t1.Team_ID, t1.Team_Name,
t1.Total_Score, lag(t1.Total_Score,1,"-") over(partition by t1.Team_Name order by t1.Season_Year) as Prev_Total_Score,
t2.Total_Wickets, lag(t2.Total_Wickets,1,"-") over(partition by t1.Team_Name order by t1.Season_Year) as Prev_Total_Wickets,
min(t1.Season_Year) over(partition by t1.Team_Name) as First_Season_Year
from teams_score_each_season t1
join team_wickets_each_season t2
on t1.Season_ID=t2.Season_ID and t1.Team_ID=t2.Team_ID
order by Team_Name, Season_Year
)
select Season_Year, Team_Name, Total_Score, Prev_Total_Score, Total_Wickets, Prev_Total_Wickets,
case when Season_Year=First_Season_Year then "First Season"
when Total_Score>Prev_Total_Score and Total_Wickets>Prev_Total_Wickets then "Better" else "Decline" end as Performance_Status
from cte;