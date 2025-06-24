FROM intersystemsdc/iris-community:latest

COPY cls /irisdev/app/cls
COPY iris.script /irisdev/app/iris.script

RUN iris start IRIS \
 && iris session IRIS < /irisdev/app/iris.script \
 && iris stop IRIS quietly