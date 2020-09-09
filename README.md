# docker-pdi_ce-9
Get Pentaho Data Integration (PDI) 9.0.0.0-423 Community Edition inside a docker container with MySQL database connection.
## Getting Started
These instructions will help you to get a docker image ready to use.
For further instructions about customizing the code, fell free to dive into the files!
### Prerequisites
* Docker engine release : 1.12.0+
* Compose file format : v2.0
### Building a docker image
```
cd docker
docker-compose build app
```
### Running the docker image
```
cd docker
docker-compose up -d
```
**OR**
```
docker run -t -i -d docker-pdi_ce-9:v1.0.0
# Save the hash string returned.
```
### Checking the PDI transformation execution
A **.txt** file will be generated after each five minutes, as scheduled by **cron**, and you can check this by the following commands:
```
cd docker
docker-compose exec app /bin/bash
```
Once inside docker console:
```
cd /home/pentaho/docker-pdi_ce-9/pdi_app
cat test_file.txt
```
**OR**
```
docker exec -i -t <HASH_STRING_HERE> /bin/bash
```
Once inside docker console:
```
cd /home/pentaho/docker-pdi_ce-9/pdi_app
cat test_file.txt
```

## What does this docker image do?
This docker **PDI** image comes with **cron** installed that is started as a service into **ENTRYPOINT** inside the **Dockerfile**. A shell script scheduled to run each five minutes is given as an example. This script calls a **PDI** transformation that produces a **.txt** file as output.
This example does not use a database connection : explore the files to know how to make it.
* **IMPORTANT**: This docker image allows external database connections. No database is installed on this one.

## Project Structure
### **/pdi_app**
* PDI transformations and jobs;
* **/kettle_home/.kettle** : 
  * **kettle.properties** : Kettle variables customized by user. Database properties , like database host and port, are inside this file. They can be used inside transformations and jobs.
  * **shared.xml** : Stores database properties configuration. This file is necessary to **PDI** shares database property information between transformations. 

### **/pdi_scripts**
* Shell scripts that call **PDI** transformations or jobs. Inside the scripts some parameters and environment variables, like JAVA_HOME, are setted.
### **/crontab**
* **crontab_pentaho**: Instruction to schedule a shell script into cron.
### **/docker**
* **Dockerfile** : First, is installed **cron** and other necessary services and is copied the local path. A **cron** schedule is created for "pentaho" user. Then **PDI, MySQL and javax.mail** are installed. 
* **pdi-compose.yml** : Partial **docker-compose** file where some variables to install PDI are stored in.
* **.env** : Key-value pair variables that are consumed by the **pdi-compose.yml** file. They store PDI version, time zone and so on.
* **docker-compose.yml** : Embodies **pdi-compose.yml** file and set some file path configurations.