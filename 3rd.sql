use ipl;

with cte as (
select t1.Match_Id, t2.Team_Id, t2.Player_Id, t3.Player_Name, t3.DOB, t1.Season_Id, t5.Season_Year, t5.Season_Year-(year(t3.DOB)) as Age
from matches t1
join player_match t2
on t1.Match_Id=t2.Match_Id
join player t3
on t2.Player_Id=t3.Player_Id
join team t4
on t1.Team_1=t4.Team_Id or t1.Team_2=t4.Team_Id
join season t5
on t1.Season_Id=t5.Season_Id
where t1.Season_Id=2 -- and t2.Team_Id=2 and t4.Team_Name="Royal Challengers Bangalore"
)
select count(Player_Name) as AgeMoreThan_25_Season2 from
(
select distinct Player_Id, Player_Name, Age from cte
where Age>25
) a
