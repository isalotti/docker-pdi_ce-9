#!/bin/bash

# Set JAVA environmental variable:
if [ -z "$JAVA_HOME" ]; then
   echo "export JAVA_HOME="$(dirname $(dirname $(readlink -f $(which java))))""
fi

# PATH_REPO : absotule path to the application.

PATH_REPO=/home/pentaho/docker-pdi_ce-9

# PATH_SCRIPT : scripts .sh that call transformations and jobs.

PATH_SCRIPT=$PATH_REPO/pdi_scripts

# PATH_APP : path to the transformations and jobs.
PATH_APP=$PATH_REPO/pdi_app

# PENTAHO_HOME : PDI installation path.

PENTAHO_HOME=/opt/pentaho/client-tools/data-integration

# PATH_KETTLE_HOME : PATH to kettle.properties .

PATH_KETTLE_HOME=$PATH_REPO/pdi_app/kettle_home

export KETTLE_HOME=$PATH_KETTLE_HOME

if [ "$?" = "0" ]; then
	sh $PENTAHO_HOME/kitchen.sh -file=$PATH_APP/test_job.kjb -DKETTLE_HOME=$PATH_KETTLE_HOME
fi

