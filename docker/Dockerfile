FROM azul/zulu-openjdk:8
############################################
## ARG for application (project)
#
ARG PENTAHO_USER
ARG PENTAHO_HOME
# Setting Time Zone
ARG TZ
ENV TZ=$TZ
## Project variables  ( docker-compose.yml file )
ARG APP_PATH
ARG CRONTAB_FILE_PATH


WORKDIR $APP_PATH

# Copy the entire project 
COPY . .

RUN apt-get update && apt-get install -y --no-install-recommends   unzip cron wget tzdata     && \
#
# Configuring time zone (all users)
#
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone     && \
    dpkg-reconfigure -f noninteractive tzdata      && \
#
# Create user defined into PENTAHO_USER variable 
#
    groupadd -r $PENTAHO_USER     && \
    useradd -s /bin/bash -d $PENTAHO_HOME -r -g $PENTAHO_USER $PENTAHO_USER     && \
    chown -R ${PENTAHO_USER}:${PENTAHO_USER} $PENTAHO_HOME     && \
    chmod -R +x $PENTAHO_HOME      && \
# Cleaning temporary files
#
    rm -rf /var/lib/apt/lists/*          && \
    rm -rf /tmp/* /var/tmp/* && apt-get clean  && \
#
## Project configurations (depends on the project)
#
# Cron ( schedule a project task )
    crontab -l -u $PENTAHO_USER | cat - ${CRONTAB_FILE_PATH} | crontab -u $PENTAHO_USER -
#
#############################################
# ARG for PDI
# 
##PDI variables ( pdi-compose.yml file )
ARG PDI_RELEASE
ARG PDI_VERSION
ARG MYSQL_CONN_VERSION
ARG JAVA_MAIL_VERSION_PATH 
ARG JAVA_MAIL_VERSION
ARG PDI_HOME
ARG PDI_WORKDIR
#
# Create PDI installation path as PDI_WORKDIR variable
#
RUN mkdir -p $PDI_WORKDIR      &&\
#
# PDI (download and unzip)
#
    /usr/bin/wget \
    --progress=dot:giga \
    https://razaoinfo.dl.sourceforge.net/project/pentaho/Pentaho%20${PDI_RELEASE}/client-tools/pdi-ce-${PDI_VERSION}.zip \
    -O /tmp/pdi-ce-${PDI_VERSION}.zip     && \
    /usr/bin/unzip -q /tmp/pdi-ce-${PDI_VERSION}.zip -d  $PDI_WORKDIR     && \
    rm -f /tmp/pdi-ce-${PDI_VERSION}.zip     && \
#
# MySQL Connector (.jar) (download , unzip and move into the /lib folder)
#
    /usr/bin/wget \
    --progress=dot:mega \
    https://downloads.mysql.com/archives/get/p/3/file/mysql-connector-java-${MYSQL_CONN_VERSION}.zip \
    -O /tmp/mysql-connector-java-${MYSQL_CONN_VERSION}.zip     && \
    /usr/bin/unzip -q /tmp/mysql-connector-java-${MYSQL_CONN_VERSION}.zip -d  /tmp     && \
    cp /tmp/mysql-connector-java-${MYSQL_CONN_VERSION}/mysql-connector-java-${MYSQL_CONN_VERSION}-bin.jar ${PDI_HOME}/lib     && \
    rm -f /tmp/mysql-connector-java-${MYSQL_CONN_VERSION}.zip     && \
    rm -rf /tmp/mysql-connector-java-${MYSQL_CONN_VERSION}     &&\
#
# javax.mail (New version : download , rename and move into the /lib folder)
#
    /usr/bin/wget \
    --progress=dot:mega \
    https://github.com/javaee/javamail/releases/download/JAVAMAIL-${JAVA_MAIL_VERSION_PATH}/javax.mail.jar \
    -O /tmp/javax.mail.jar      && \
    rm -f ${PDI_HOME}/lib/javax.mail*.jar      && \
    mv /tmp/javax.mail.jar ${PDI_HOME}/lib/javax.mail-${JAVA_MAIL_VERSION}.jar     &&\
#
# Adjust permissions for PDI instalation
    chown -R ${PENTAHO_USER}:${PENTAHO_USER} $PDI_WORKDIR     && \
    chmod -R +x $PDI_WORKDIR      && \
    rm -rf /tmp/* /var/tmp/* && apt-get clean
#
#
ENTRYPOINT [ "cron","-f" ]