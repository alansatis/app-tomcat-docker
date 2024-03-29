FROM centos:7

# Import GPG Keys and install necessary packages
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7  \
  && yum install -y java-1.8.0-openjdk wget ca-certificates

# Install Tomcat 8.5
RUN wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.100/bin/apache-tomcat-8.5.100.tar.gz \
    && tar -xzvf apache-tomcat-8.5.100.tar.gz -C /opt \
    && mv /opt/apache-tomcat-8.5.100 /opt/tomcat \
    && rm -rf apache-tomcat-8.5.100.tar.gz

# Download sample app
RUN wget https://tomcat.apache.org/tomcat-8.5-doc/appdev/sample/sample.war -P /opt/tomcat/webapps/

# Expose port 4041
EXPOSE 4041

# Start Tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
