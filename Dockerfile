
FROM tomcat:9.0-jdk8-temurin

# Remove the default Tomcat web application
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the generated OLTRS WAR file
COPY target/ticket-reservation.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]

