select * from PortfolioProject..CovidDeaths 
order by 3,4;

--select * from PortfolioProject..CovidVaccinations 
--order by 3,4;

--Selecting data ,we are going to use

select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
order by 1,2;

--Total Cases vs Total Deaths in India
--Shows the liklihood of sying from Covid

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_Percentage
from PortfolioProject..CovidDeaths
where location like '%India%'
order by 1,2;

--Total Cases vs Population in India
select location,date,total_cases,population,(total_cases/population)*100 as Infection_Percentage
from PortfolioProject..CovidDeaths
where location like '%India%'
order by 1,2;

--Looking at Countries with highest Infection_rate compared to Population
select location,population,max(total_cases) as HighestInfectionCount,max(total_cases/population)*100 as Infection_Percentage
from PortfolioProject..CovidDeaths
group by location,population
order by Infection_Percentage desc;

--Showing countries with highest death count per population

select location,max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by HighestDeathCount desc;

--Breaking things by continent
select location,max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject..CovidDeaths
where continent is  null
group by location
order by HighestDeathCount desc;

--Global Numbers
select nullif(sum(new_cases),0) as TotalCaseCount,nullif( sum(cast(new_deaths as int)),0) as TotalDeathCount
,nullif( sum(cast(new_deaths as int)),0)/nullif(sum(new_cases),0)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is  null
--group by date
order by 1,2;
--order by TotalDeathCount desc;

--Looking at Total Population vs Vaccination

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations from CovidDeaths dea join
 CovidVaccinations vac on dea.location=vac.location
 and dea.date=vac.date
 where dea.continent is not null
 order by 2,3;

 --Rolling Count

 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations 
 , sum(convert(int ,vac.new_vaccinations)) over (partition by dea.location order by dea.location
 ,dea.date)as RollingPeopleVaccinated from PortfolioProject..CovidDeaths dea join
 PortfolioProject..CovidVaccinations vac on dea.location=vac.location
 and dea.date=vac.date
 where dea.continent is not null
 order by 2,3;

 With PopvsVac(continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
 as
 (
   select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations 
 , sum(convert(int ,vac.new_vaccinations)) over (partition by dea.location order by dea.location
 ,dea.date)as RollingPeopleVaccinated 
 from PortfolioProject..CovidDeaths dea join
 PortfolioProject..CovidVaccinations vac on 
 dea.location=vac.location
 and dea.date=vac.date
 where dea.continent is not null
-- order by 2,3
 )
 select * ,(RollingPeopleVaccinated/population)*100 from PopvsVac;

