


Drop view if exists rcb_table;

Drop view if exists rcb_table2;

Drop view if exists rcb_table3;

create view rcb_table as
(
With cte1 as (
select t1.Match_Id, t1.Team_1, t1.Team_2, t2.Team_Name, t1.Season_ID, t1.Toss_Winner, t1.Toss_Decide, t3.Toss_Name
from matches t1
join team t2
on t1.Team_1=t2.Team_Id or t1.Team_2=t2.Team_Id
join toss_decision t3
on t1.Toss_Decide=t3.Toss_Id
where t1.Season_Id=1 and t2.Team_Name="Royal Challengers Bangalore"
order by t1.Match_Id
),
cte2 as (
select *,
case when Toss_Winner=2 then Toss_Name
when Toss_Winner<>2 and Toss_Name="bat" then "field"
when Toss_Winner<>2 and Toss_Name="field" then "bat" end as rcb_first_innings
from cte1
)
select *,
case when rcb_first_innings="field" then "bat" else "field" end as rcb_second_innings,
case when rcb_first_innings="field" then 2 else 1 end as rcb_innings
from cte2
);
create view rcb_table2 as
(
with cte3 as (
select Match_Id, Innings_No, sum(Extra_Runs) as Extras from extra_runs
where Match_Id in
(
select distinct Match_Id from rcb_table
)
group by 1,2
)
select r1.*, r2.Innings_No, r2.Extras
from rcb_table r1
join cte3 r2
on r1.Match_Id=r2.Match_Id and r1.rcb_innings=r2.Innings_No
);
create view rcb_table3 as
(
with cte4 as (
select Match_Id, Innings_No, sum(Runs_Scored) as Runs from batsman_scored
where Match_Id in
(
select distinct Match_Id from rcb_table2
)
group by 1,2
)
select c1.*, c2.Runs
from rcb_table2 c1
join cte4 c2
on c1.Match_Id=c2.Match_Id and c1.rcb_innings=c2.Innings_No
);
select sum(Score) as Total_Runs_Scored_By_RCB from
(
select row_number() over(order by Match_Id) as Rn, Match_Id, (Runs+Extras) as Score from rcb_table3
) a;