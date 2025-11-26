FROM tomcat:10.1-jdk17-temurin

# Clean default ROOT webapp (optional)
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy your custom webapp (NOTE: webapps, not webapp)
COPY webapps/demo /usr/local/tomcat/webapps/demo

EXPOSE 8080

CMD ["catalina.sh", "run"]
