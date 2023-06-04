

select *
from [Portfolio-Project]..World_Population$
order by 1,2


--countries that have the highest population in 2020
select country, max(year_2020) as highest_population
from [Portfolio-Project]..World_Population$
group by country
order by highest_population desc

--comparing world population in 1960 and 2020 and Growth_Rate_Percentage
select SUM(year_1960) as World_Population_in_1960,
SUM(year_2020) as World_Population_in_2020,
(SUM(year_1960) / SUM(year_2020))*100 as Growth_Rate_percentage
from [Portfolio-Project]..World_Population$

--Growth_rate world population from 1960 throught 2020
select country, max(year_1960) as highest_population_in_1960,
max(year_2020) as highest_population_in_2020,
(max(year_1960)/max(year_2020)) * 100 as Growth_Rate_Percentage
from [Portfolio-Project]..World_Population$
group by country
order by highest_population_in_1960 desc

--United state population growth rate through the year 1960 to 2020
select year_1960, year_2020, (year_2020 - year_1960) as difference,
(year_1960 / year_2020) * 100 as Growth_Rate_Percentage
from [Portfolio-Project]..World_Population$
where country ='United States'

--countries with highest growth rate population
select country, max(year_1960) as highest_population_in_1960,
max(year_2020) as highest_population_in_2020,
(max(year_2020) - max(year_1960)) as difference,
(max(year_1960)/max(year_2020)) * 100 as Growth_Rate_Percentage
from [Portfolio-Project]..World_Population$
group by country
order by highest_population_in_2020 desc

--United States Populatino growth from 1960 to 2020
select year_1960, year_2020, year_2020-year_1960 as difference,
(year_1960 / year_2020)*100 as Growth_Percentage
from [Portfolio-Project]..World_Population$
where country = 'United States'

--world Populatin from 2000 to 2020
select country, SUM(convert(float, year_2000+year_2001+year_2002+year_2003+
year_2004+year_2005+year_2006+year_2007+year_2008+year_2009+year_2010+
year_2011+year_2012+year_2013+year_2014+year_2015+year_2016+year_2017+
year_2018+year_2019+year_2020)) as total_population
from [Portfolio-Project]..World_Population$
group by country
order by total_population desc

--CTE
with Total_Population(country, total_population)
as
(
select country, SUM(convert(float, year_2000+year_2001+year_2002+year_2003+
year_2004+year_2005+year_2006+year_2007+year_2008+year_2009+year_2010+
year_2011+year_2012+year_2013+year_2014+year_2015+year_2016+year_2017+
year_2018+year_2019+year_2020)) as total_population
from [Portfolio-Project]..World_Population$
group by country
)
select SUM(total_population) as total_Population_2000_2020
from Total_Population


