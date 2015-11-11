#!/bin/sh

DIR_REL=$1
#echo $DIR_REL

TEMP="${DIR_REL%\"}"
TEMP="${TEMP#\"}"

DIR_REL=$TEMP

if [ -z "$DIR_REL" ]
then
DIR_REL=`dirname $0`
fi

echo $DIR_REL

cd $DIR_REL
DIR=`pwd`
cd -

. "$DIR/set-java.sh"

 setJava

 cd "$DIR/tomcat/bin"
 JAVA_HEAP_MAX=${JAVA_HEAP_MAX:-768m}
 JAVA_HEAP_MIN=${JAVA_HEAP_MIN:-256m}
 DEFAULT_CATALINA_OPTS="-Xms${JAVA_HEAP_MIN} -Xmx${JAVA_HEAP_MAX} -XX:MaxPermSize=256m -Dfile.encoding=UTF-8 -Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true -Djava.awt.headless=true"
 export CATALINA_OPTS=${CATALINA_OPTS:-${DEFAULT_CATALINA_OPTS}}
 echo "Catalina Options: ${CATALINA_OPTS}"
 JAVA_HOME=$_JAVA_HOME
 exec sh catalina.sh run
