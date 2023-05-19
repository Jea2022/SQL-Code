select *
from [Portfolio-Project]..['Covid-Deaths]
select * 
from [Portfolio-Project]..['Covid-Vaccination]


select location, date, total_cases, new_cases, total_deaths, population, continent
from [Portfolio-Project]..['Covid-Deaths]
where continent is not null
order by 1,2

--looking for percentage of TotalDeath in canada
SELECT location, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [Portfolio-Project]..['Covid-Deaths]
where location like '%canada%'
order by 1,2

--looking at total case vs Population
--shows the percentage that have been infected by Covid-19 in Canada
SELECT location, population, total_cases,  (total_cases/population)*100 as InfectedPercentage
from [Portfolio-Project]..['Covid-Deaths]
where location like '%canada%'
order by 1,2

--Looking at the countries with hightest Covid Infection Rate
SELECT location, population, MAX(total_cases) AS HisghestRate, 
MAX(total_cases/population)*100 as PercentagePopulationInfected
from [Portfolio-Project]..['Covid-Deaths]
GROUP BY location, population
order by PercentagePopulationInfected desc

--Looking for Countries with Highest Death Rate per Population
--Showing the highest deat in percentage per population
select location, MAX(cast(total_deaths as int)) as HisghestDeathRate
from [Portfolio-Project]..['Covid-Deaths]
where continent is not null
group by location
order by HisghestDeathRate desc

--Looking for Highest Death Rate in each continent
select continent, MAX(cast(total_deaths as int)) as HisghestDeathRate
from [Portfolio-Project]..['Covid-Deaths]
where continent is not null
group by continent
order by HisghestDeathRate desc

--Looking for Total Number of CovidCase and Total number of
--CovidDeath in the world
select date, SUM(total_cases) as WorldTotalCases, 
SUM(cast(new_deaths as int)) as WorldTotalDeaths,
SUM(cast(new_deaths as int))/SUM(total_cases)*100 as WorldDeathPercentage
from [Portfolio-Project]..['Covid-Deaths]
where continent is not null
group by date
order by WorldTotalDeaths desc

--Looking for Total_Case, Total_Death, and Percentage_Of_Total_Death
select SUM(total_cases) as WorldTotalCases, 
SUM(cast(new_deaths as int)) as WorldTotalDeaths,
SUM(cast(new_deaths as int))/SUM(total_cases)*100 as WorldDeathPercentage
from [Portfolio-Project]..['Covid-Deaths]
where continent is not null
--order by WorldTotalDeaths desc


--Looking the total populations that have been vaccinated 
select death.continent, death.location, death.date, death.population, 
vaccine.new_vaccinations, vaccine.total_vaccinations,
SUM(cast(vaccine.new_vaccinations as float)) OVER (partition by death.location)
as Total_New_Vaccination
from [Portfolio-Project]..['Covid-Deaths] death
join [Portfolio-Project]..['Covid-Vaccination] vaccine
on death.location = vaccine.location
and death.date = vaccine.date
where death.continent is not null
order by 2,3

--calculating the percentage of people vaccinated
--USE CTE

with Percentage_of_Vaccination(continent, location, date, population, new_vaccinations,
total_amount_of_vaccination)
as
(
select deaths.continent, deaths.location, deaths.date ,deaths.population, vaccine.new_vaccinations,
SUM(convert(float, vaccine.new_vaccinations)) over 
(partition by deaths.location order by deaths.location, deaths.date)
as total_amount_of_vaccination
from [Portfolio-Project]..['Covid-Deaths'] deaths
join
[Portfolio-Project]..['Covid-Vaccination'] vaccine
on deaths.location = vaccine.location
and deaths.date = vaccine.date
where deaths.continent is not null
--order by 2,3
)
select *, (total_amount_of_vaccination/population)*100 as Percentage_of_Vaccination
from Percentage_of_Vaccination


--TEMP TABLE

Drop table if exists #Population_Vaccination_Percentage
create table #Population_Vaccination_Percentage
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations nvarchar(255),
total_amount_of_vaccination numeric
)

insert into #Population_Vaccination_Percentage
select deaths.continent, deaths.location, deaths.date ,deaths.population, vaccine.new_vaccinations,
SUM(convert(float, vaccine.new_vaccinations)) over 
(partition by deaths.location order by deaths.location, deaths.date)
as total_amount_of_vaccination
from [Portfolio-Project]..['Covid-Deaths'] deaths
join
[Portfolio-Project]..['Covid-Vaccination'] vaccine
on deaths.location = vaccine.location
and deaths.date = vaccine.date
where deaths.continent is not null
order by 2,3

select *, (total_amount_of_vaccination/population)*100 as Percentage_of_Vaccination
from #Population_Vaccination_Percentage

--Creating View to store data for later visualizations

create view Population_Vaccination_Percentage as
select deaths.continent, deaths.location, deaths.date ,deaths.population, vaccine.new_vaccinations,
SUM(convert(float, vaccine.new_vaccinations)) over 
(partition by deaths.location order by deaths.location, deaths.date)
as total_amount_of_vaccination
from [Portfolio-Project]..['Covid-Deaths'] deaths
join
[Portfolio-Project]..['Covid-Vaccination'] vaccine
on deaths.location = vaccine.location
and deaths.date = vaccine.date
where deaths.continent is not null
--order by 2,3

--selecting view
select *
from Population_Vaccination_Percentage
