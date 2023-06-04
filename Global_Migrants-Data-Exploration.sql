
select *
from [Portfolio-Project]..Global_Migration
order by 1

-- Child under age of 20 migrated to canada and USA
-- through the year 1990 to 2020
select Year, Country, [Child migrants (under-20s)]
from [Portfolio-Project]..Global_Migration
where [Child migrants (under-20s)] is not null
and Country like '%canada'

select Year, Country, [Child migrants (under-20s)]
from [Portfolio-Project]..Global_Migration
where [Child migrants (under-20s)] is not null
and Country like '%states'

--Countreis that have highest children migrants under age of 20s
select Country, max(convert(int, [Child migrants (under-20s)]))
as total_children_migrants
from [Portfolio-Project]..Global_Migration
where [Child migrants (under-20s)] is not null
group by Country
order by total_children_migrants desc

--total number of children migrants under age of 20s in the world
--use CTE
with total_numbr_of_children_migrants(Country, total_children_migrants)
as 
(
select Country, max(convert(int, [Child migrants (under-20s)]))
as total_children_migrants
from [Portfolio-Project]..Global_Migration
where [Child migrants (under-20s)] is not null
group by Country
--order by total_children_migrants desc
)
select SUM(total_children_migrants) as children_migrants_under20s
from total_numbr_of_children_migrants;

--Immigration rate per year from 1995 to 2020
select year, sum([Net migration rate]) as migration_rate
from [Portfolio-Project]..Global_Migration
where [Net migration rate] is not null
group by year
order by 1


select *
from [Portfolio-Project]..Global_Migration Global_migrants
join
[Portfolio-Project]..Migration_Flows Migration_Flows
on Global_migrants.Year = Migration_Flows.Year

--Total Emigrants per country from 1990 to 2020
select Country, sum(convert(bigint, Emigrants)) as Total_Emigrants
from [Portfolio-Project]..Global_Migration
where Emigrants is not null
and Country <> 'World'
group by Country
order by 2 desc

--Total Emirants migrated to Canada and Australia
select year, [Immigrants to Canada], [Immigrants to Australia]
from [Portfolio-Project]..Migration_Flows
where [Immigrants to Canada] is not null
and [Immigrants to Australia] is not null
order by 1

/*
Total number of Emigrants from Canada vs total number of Emigrants to Canada
and total number of Emigrants from Australia vs Total numne of Emigrants 
to Australia through the years of 1990 to 2020
*/
select year, sum(convert(bigint, [Emigrants from Canada])) as Immigration_from_canada,
sum(convert(bigint, [Immigrants to Canada])) as Immigration_to_canada,
sum(convert(bigint, [Emigrants from Australia])) as Immigration_from_Australia,
sum(convert(bigint, [Immigrants to Australia])) as Immigration_to_Australia
from [Portfolio-Project]..Migration_Flows
where [Immigrants to Canada] is not null
and [Emigrants from Canada] is not null
and [Emigrants from Australia] is not null
and [Immigrants to Australia] is not null
group by year
order by year

select year, sum(convert(bigint, [Emigrants from Germany])) as Emigrants_from_Germany,
sum(convert(bigint, [Immigrants to Germany])) as Emigrants_to_Germany
from [Portfolio-Project]..Migration_Flows
where [Immigrants to Canada] is not null
and [Emigrants from Canada] is not null
and [Emigrants from Australia] is not null
and [Immigrants to Australia] is not null
group by year
order by year

--total number of refugee from the USA
select Entity, SUM([refugee population by country]) as total_refugees
from [Portfolio-Project]..[Refugee-Population-by-Country]
where Entity like '%states'
group by Entity

--Total Refugees from the year of 1960 to 2020 in all around the world
select year, SUM([refugee population by country]) as total_refugees
from [Portfolio-Project]..[Refugee-Population-by-Country]
group by year
order by 1