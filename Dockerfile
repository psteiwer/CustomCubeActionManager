ARG IMAGE=intersystemsdc/iris-community
FROM $IMAGE

USER root
WORKDIR /opt/irisapp
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp

USER ${ISC_PACKAGE_MGRUSER}

# copy files
COPY Installer.cls .
COPY CustomCubeActions CustomCubeActions
COPY Assets Assets
COPY module.xml .  
COPY iris.script /tmp/iris.script

# run iris and script
RUN iris start IRIS \
	&& iris session IRIS < /tmp/iris.script \
    && iris stop IRIS quietly

