select count(Match_Id) as RCB_season1_won from
(
select * from matches
where Season_ID=1 and Match_Winner=(select Team_Id from team where Team_Name="Royal Challengers Bangalore")
) a




