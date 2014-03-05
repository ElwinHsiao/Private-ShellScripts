#!/bin/bash

export JAVA_HOME=/opt/jdk1.6.0_33
export JRE_HOME=\$JAVA_HOME/jre 
export PATH=$JAVA_HOME/bin:\$PATH
export CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar
"