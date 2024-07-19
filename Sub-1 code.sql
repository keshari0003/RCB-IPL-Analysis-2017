use ipl;
with cte as (
select t1.Match_Id, t1.Team_1, t1.Team_2, t1.Season_ID, t1.Toss_Winner, t1.Toss_Decide, t2.Toss_Name, t1.Match_Winner,
case when Toss_Winner=Match_Winner then 1 else 0 end as Toss_Win_Results, 
case when Toss_Winner<>Match_Winner then 1 else 0 end as Toss_Loss_Results 
from matches t1 
join toss_decision t2
on t1.Toss_Decide=t2.Toss_Id
order by t1.Match_Id
),

cte2 as (
select count(Match_Id) as Total_Matches, sum(Toss_Win_Results) as Toss_Winnner_Match_Winner, sum(Toss_Loss_Results) as Toss_Loser_Match_Winner from cte 
where Match_Winner is not null
)

select *, round(Toss_Winnner_Match_Winner*100/Total_Matches,2) as "Toss_Winnner_Match_Winner_Percentage (%)", 
round(Toss_Loser_Match_Winner*100/Total_Matches,2) as "Toss_Loser_Match_Winner_Percentage (%)" from cte2; 


-- Toss Impact on Different Venues:

with cte as (
select t1.Match_Id, t1.Team_1, t1.Team_2, t1.Season_ID, t1.Venue_Id, t1.Toss_Winner, t1.Toss_Decide, t2.Toss_Name, t1.Match_Winner,
case when Toss_Winner=Match_Winner then 1 else 0 end as Toss_Win_Results, 
case when Toss_Winner<>Match_Winner then 1 else 0 end as Toss_Loss_Results 
from matches t1 
join toss_decision t2
on t1.Toss_Decide=t2.Toss_Id
order by t1.Match_Id
),

cte2 as (
select Venue_Id, count(Match_Id) as Total_Matches, sum(Toss_Win_Results) as Toss_Winnner_Match_Winner, sum(Toss_Loss_Results) as Toss_Loser_Match_Winner from cte 
where Match_Winner is not null
group by 1
),

cte3 as (
select *, round(Toss_Winnner_Match_Winner*100/Total_Matches,2) as Toss_Winnner_Match_Winner_Percentage, 
round(Toss_Loser_Match_Winner*100/Total_Matches,2) as Toss_Loser_Match_Winner_Percentage from cte2
)

select  t2.Venue_Name, t1.Total_Matches, t1.Toss_Winnner_Match_Winner, t1.Toss_Loser_Match_Winner, 
t1.Toss_Winnner_Match_Winner_Percentage as "Toss_Winnner_Match_Winner_Percentage (%)", 
t1.Toss_Loser_Match_Winner_Percentage as "Toss_Loser_Match_Winner_Percentage (%)"
from cte3 t1 
join venue t2 
on t1.Venue_Id=t2.Venue_Id
order by Venue_name;      
