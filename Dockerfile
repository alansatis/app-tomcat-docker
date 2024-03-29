FROM centos:7

# Import GPG Keys and install necessary packages
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7  \
  && yum install -y java-1.8.0-openjdk wget ca-certificates openssl

# Install Tomcat 8.5
RUN wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.100/bin/apache-tomcat-8.5.100.tar.gz \
    && tar -xzvf apache-tomcat-8.5.100.tar.gz -C /opt \
    && mv /opt/apache-tomcat-8.5.100 /opt/tomcat \
    && rm -rf apache-tomcat-8.5.100.tar.gz

# Download sample app
RUN wget https://tomcat.apache.org/tomcat-8.5-doc/appdev/sample/sample.war -P /opt/tomcat/webapps/

# Copy private encrypted key and certificate
COPY private_encrypted.pem certificate.pem /tmp/

# Decrypt private key
RUN openssl rsa -in /tmp/private_encrypted.pem -out /tmp/private.pem -passin pass:1234

# Create keystore
RUN openssl pkcs12 -export -in /tmp/certificate.pem -inkey /tmp/private.pem -out /opt/tomcat/conf/keystore.p12 -name tomcat -passout pass:1234

# Configure server.xml to enable SSL/TLS
RUN sed -i '/<Connector port="8443"/a \
               keystoreFile="/opt/tomcat/conf/keystore.p12" \
               keystoreType="PKCS12" \
               keystorePass="1234" \
               keyAlias="tomcat" \
               keyPass="1234" \
               SSLEnabled="true" \
               scheme="https" \
               secure="true" \
               SSLProtocol="TLS"' /opt/tomcat/conf/server.xml

# Remove temporary files
RUN rm /tmp/private_encrypted.pem /tmp/private.pem /tmp/certificate.pem

# Expose port 4041
EXPOSE 4041

# Start Tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
