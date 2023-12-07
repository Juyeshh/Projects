Select * 
From Portfolio_Project..CovidDeaths
where continent is not null 
order by 3,4

--Select * 
--From Portffolio_Project..CovidVaccinations
--order by 3,4

Select Location, date, total_cases, new_cases,
total_deaths, population
From Portfolio_Project..CovidDeaths
order by 1,2

--Looking at the Total Cases vs Total Deaths

Select Location, date, total_cases, total_deaths,
(Total_deaths/total_cases)*100 as DeathPercentage
From Portfolio_Project..CovidDeaths
where location like'%India%'
order by 1,2


--Looking at Total Cases vs Population
--Shows what percentage of population got covid

Select Location, date, total_cases, population,
(total_cases/population)*100 as Percent_Infec
From Portfolio_Project..CovidDeaths
--where location like'%states%'
order by 1,2

--Countries with highest infection rate compared to population

Select Location,MAX(total_cases) as Highest_Infec, 
population, Max((total_cases/population))*100 as
Percent_Infec
From Portfolio_Project..CovidDeaths
--where location like'%States%'
Group by location, population
order by Percent_Infec desc


-- Showing countries with highest death count per population

Select location, Sum(cast(new_deaths as int)) as TotalDeathCount
From Portfolio_Project..CovidDeaths
--where location like'%States%'
where continent is not null 
and location not in ('World', 'Eupropean Union', 'International')
Group by location
order by TotalDeathCount desc

--Lets break things down by continent

Select continent, Max(cast(Total_deaths as int)) as TotalDeathCount
From Portfolio_Project..CovidDeaths
--where location like'%States%'
where continent is not null 
Group by continent
order by TotalDeathCount desc


--Showing the continents with the highest death count per population

Select continent, Max(cast(Total_deaths as int)) as TotalDeathCount
From Portfolio_Project..CovidDeaths
--where location like'%States%'
where continent is not null 
Group by continent
order by TotalDeathCount desc


--Global Numbers

Select Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, 
Sum(cast(new_deaths as int))/Sum(New_cases)*100 as DeathPercentage
From Portfolio_Project..CovidDeaths
--where location like'%states%'
where continent is not null 
--Group by date
order by 1,2



--Looking at Total Population vs Vaccinations



--Use CTE

With PopvsVac(Continent, Location, Date, Population,
New_Vaccinations, RollingPeopleVaccinated)
as(
Select dea.continent, dea.location, dea.date, 
dea.population, vac.new_vaccinations,
Sum(Convert(int,vac.new_vaccinations))
Over(Partition by dea.location 
Order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From Portfolio_Project..CovidDeaths dea
Join Portfolio_Project..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

 
 --Temp table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, 
dea.population, vac.new_vaccinations,
Sum(Convert(int,vac.new_vaccinations))
Over(Partition by dea.location 
Order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From Portfolio_Project..CovidDeaths dea
Join Portfolio_Project..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 1,2,3
 
 Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated
 
 
 
  
 --Creating view to store data for later visualization


Create View PercentPopulationVaccinated1 as
Select dea.continent, dea.location, dea.date, 
dea.population, vac.new_vaccinations,
Sum(Convert(int,vac.new_vaccinations))
Over(Partition by dea.location 
Order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From Portfolio_Project..CovidDeaths dea
Join Portfolio_Project..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3



/*

Queries used for Tableau Project

*/



-- 1. 

Select Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, 
Sum(cast(new_deaths as int))/Sum(New_cases)*100 as DeathPercentage
From Portfolio_Project..CovidDeaths
--where location like'%states%'
where continent is not null 
--Group by date
order by 1,2

--2.

Select continent, Sum(cast(new_deaths as int)) as TotalDeathCount
From Portfolio_Project..CovidDeaths
--where location like'%States%'
where continent is not null 
and location not in ('World', 'Eupropean Union', 'International')
Group by continent
order by TotalDeathCount desc

--3.
Select Location,Population, MAX(total_cases) as Highest_Infec, 
Max((total_cases/population))*100 as Percent_Infec
From Portfolio_Project..CovidDeaths
--where location like'%States%'
Group by location, population
order by Percent_Infec desc

--4.
Select Location,Population,Date, MAX(total_cases) as Highest_Infec, 
Max((total_cases/population))*100 as Percent_Infec
From Portfolio_Project..CovidDeaths
--where location like'%States%'
Group by location, population, date
order by Percent_Infec desc