create view rcb_record_table as
(
With cte as (
select Venue_Id, Venue_Name, count(Match_Id) as No_of_Wins from (
select t1.Match_Id, t1.Team_1, t1.Team_2, t1.Season_Id, t1.Match_Winner, t1.Venue_Id, t2.Venue_Name
from matches t1
join venue t2
on t1.Venue_Id=t2.Venue_Id
where t1.Team_1=2 or t1.Team_2=2
) a
where Match_Winner=2
group by 1,2
),
cte2 as (
select Venue_Id, Venue_Name, count(Match_Id) as No_of_Losses from (
select t1.Match_Id, t1.Team_1, t1.Team_2, t1.Season_Id, t1.Match_Winner, t1.Venue_Id, t2.Venue_Name
from matches t1
join venue t2
on t1.Venue_Id=t2.Venue_Id
where t1.Team_1=2 or t1.Team_2=2
) a
where Match_Winner<>2
group by 1,2
)
select cte.*, cte2.No_of_Losses
from cte
join cte2
on cte.Venue_Id=cte2.Venue_Id
order by cte.Venue_Id
);
select * from rcb_record_table;