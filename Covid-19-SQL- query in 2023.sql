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

--use CTE
with PopvsVac (continent, location, date, population, new_vaccination,
Total_New_Vaccination)
as
(select death.continent, death.location, death.date, death.population, 
vaccine.new_vaccinations,
SUM(convert(float, vaccine.new_vaccinations)) OVER (partition by death.location order by 
death.location)
as Total_New_Vaccination
from [Portfolio-Project]..['Covid-Deaths] death
join [Portfolio-Project]..['Covid-Vaccination] vaccine
on death.location = vaccine.location
and death.date = vaccine.date
where death.continent is not null
)
select *, (Total_New_Vaccination/population)*100 as PopulationPercentageVaccinated
from PopvsVac


--temp table

drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
Total_New_Vaccination numeric
)

insert into #PercentPopulationVaccinated
select death.continent, death.location, death.date, death.population, 
vaccine.new_vaccinations as float, SUM(cast(vaccine.new_vaccinations as float))
OVER (partition by death.location order by death.location) as Total_New_Vaccination
from [Portfolio-Project]..['Covid-Deaths] death
join [Portfolio-Project]..['Covid-Vaccination] vaccine
on death.location = vaccine.location
and death.date = vaccine.date
--where death.continent is not null

select *, (Total_New_Vaccination/population)*100 as PopulationPercentVaccinated
from #PercentPopulationVaccinated


--Creating View to store data for later visualization
drop view if exists PercentPopulationVaccinated

create view PercentPopulationVaccinated as
select death.continent, death.location, death.date, death.population, 
vaccine.new_vaccinations as float, SUM(cast(vaccine.new_vaccinations as float))
OVER (partition by death.location order by death.location) as Total_New_Vaccination
from [Portfolio-Project]..['Covid-Deaths] death
join [Portfolio-Project]..['Covid-Vaccination] vaccine
on death.location = vaccine.location
and death.date = vaccine.date
where death.continent is not null

select *
from #PercentPopulationVaccinated