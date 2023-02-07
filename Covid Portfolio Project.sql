select * from projectportfolio.coviddeaths where continent is not null order by 3,4;

select location, date,total_cases,new_cases,total_deaths,population from projectportfolio.coviddeaths 
where continent is not null 
order by 1,2;

#Looking at Total Cases vs Total Deaths
#Shows likelihood of dying if you contract covid in your country

select location, date,total_cases,total_deaths,(total_deaths/total_cases)*100 deathpercentage
from projectportfolio.coviddeaths  where location like '%Bahamas%' and continent is not null order by 1,2;

#Looking at the total cases vs population
#Shows what percentage of population got covid

select location, date,total_cases,population,(total_cases/population)*100 percentageofpopulationinfected
from projectportfolio.coviddeaths  
where continent is not null
#where location like '%Bahamas%' 
order by 1,2;

#Looking at countries with highest infection Rate compared to population

select location, max(total_cases) highestinfectioncount, population, max((total_cases/population))*100 percentageofpopulationinfected
from projectportfolio.coviddeaths 
where continent is not null 
group by location, population  
#where location like '%Bahamas%' 
order by percentageofpopulationinfected desc;

# Showing countries with highest deathcount per population

select location, max(total_deaths) totaldeathcount from projectportfolio.coviddeaths where continent is not null
group by location  
#where location like '%Bahamas%' 
order by totaldeathcount desc;

#LET'S BREAK THINGS DOWN BY CONTINENT
#Showing the Continents with highest death count per population

select continent, max(total_deaths) totaldeathcount from projectportfolio.coviddeaths where continent is not null
group by continent  
#where location like '%Bahamas%' 
order by totaldeathcount desc;

# GLOBAL Numbers

select date,sum(new_cases) total_cases,sum(new_deaths) total_deaths, sum(new_deaths)/sum(new_cases)*100 as deathpercentage
from projectportfolio.coviddeaths
where continent is not null
#where location like '%Bahamas%' 
Group by date 
order by 1,2;

#Looking at Total Population vs Vaccination

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) peoplevaccinated
from projectportfolio.coviddeaths dea join projectportfolio.covidvaccinations vac 
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3;

#USE CTE

with popvsvac (Continent, location,date,population,new_vaccinations,peoplevaccinated) as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) peoplevaccinated
from projectportfolio.coviddeaths dea join projectportfolio.covidvaccinations vac 
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3)
Select *,(peoplevaccinated/population)*100 from popvsvac;

#Creating view to store data for later visualizations

Create view PercentPopulationVaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) peoplevaccinated
from projectportfolio.coviddeaths dea join projectportfolio.covidvaccinations vac 
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
#order by 2,3;

SELECT * FROM projectportfolio.percentpopulationvaccinated;