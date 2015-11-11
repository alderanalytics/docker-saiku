FROM caarlos0/alpine-oraclejdk7-mvn:latest

ENV LANG C.UTF-8
ENV JAVA_TOOL_OPTIONS -Dfile.encoding=UTF8

ADD https://github.com/OSBI/saiku/archive/saiku-3.5.zip saiku-server.zip
RUN unzip saiku-server.zip \
    && mv saiku-saiku-3.5/saiku-server saiku \
    && rmdir saiku-saiku-3.5

WORKDIR /saiku
RUN sed -i 's/failonerror="true"/failonerror="false"/g' saiku-ui/pom.xml
RUN mvn clean -pl '!saiku-bi-platform-plugin-p5' install -Dmaven.test.skip=true
RUN cp saiku-ui/target/saiku-ui/saiku.min.js \
       saiku-server/target/dist/saiku-server/tomcat/webapps/ROOT/

WORKDIR /saiku/saiku-server/target/dist/
ADD start-saiku.sh saiku-server/start-saiku.sh
ADD http://central.maven.org/maven2/org/apache/commons/commons-math/2.2/commons-math-2.2.jar \
        ./saiku-server/tomcat/webapps/saiku/WEB-INF/lib/commons-math-2.2.jar

RUN chmod +x saiku-server/*.sh \
    && chmod +x saiku-server/tomcat/bin/*.sh

EXPOSE 8080
VOLUMES ["/saiku/saiku-server/target/dist/saiku-server/data", \
          "/saiku/saiku-server/target/dist/saiku-server/repository/data"]
ENTRYPOINT saiku-server/start-saiku.sh
