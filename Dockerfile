FROM caarlos0/alpine-oraclejdk7-mvn:latest

WORKDIR /usr/local/src

ADD https://github.com/alfredr/saiku/archive/master.zip saiku-server.zip
RUN unzip saiku-server.zip
RUN mv saiku-master saiku-server

WORKDIR /usr/local/src/saiku-server
RUN mvn clean install -Dmaven.test.skip=true
RUN cp saiku-ui/target/saiku-ui/saiku.min.js \
       saiku-server/target/dist/saiku-server/tomcat/webapps/ROOT/

WORKDIR /usr/local/src/saiku-server/saiku-server/target/dist/
RUN chmod +x saiku-server/*.sh \
    && chmod +x saiku-server/tomcat/bin/*.sh

EXPOSE 8080
CMD saiku-server/start-saiku.sh \
    && tail -f saiku-server/tomcat/logs/catalina.out
