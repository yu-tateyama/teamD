#!/bin/bash

if [  "/tmp/dash-replace.war" -nt "/usr/local/tomcat/webapps/ROOT.war" ];then
    cp -a /tmp/dash-replace.war  /usr/local/tomcat/webapps/ROOT.war
fi
