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
COPY PEM-files/private_encrypted.pem PEM-files/certificate.pem /tmp/

# Definindo variáveis de ambiente para as senhas
ARG PRIVATE_KEY_PASSWORD
ENV PRIVATE_KEY_PASSWORD=${PRIVATE_KEY_PASSWORD}
ARG KEYSTORE_PASSWORD
ENV KEYSTORE_PASSWORD=${KEYSTORE_PASSWORD}

# Decrypt private key
RUN openssl rsa -in /tmp/private_encrypted.pem -out /tmp/private.pem -passin pass:$PRIVATE_KEY_PASSWORD

# Create keystore
RUN openssl pkcs12 -export -in /tmp/certificate.pem -inkey /tmp/private.pem -out /opt/tomcat/conf/keystore.p12 -name tomcat -passout pass:$KEYSTORE_PASSWORD

# Use sed to add SSL/TLS configuration for port 4041 in server.xml
RUN sed -i "/<Service name=\"Catalina\">/a \
               <Connector port=\"4041\" protocol=\"org.apache.coyote.http11.Http11NioProtocol\" \
                          maxThreads=\"150\" SSLEnabled=\"true\" scheme=\"https\" secure=\"true\" clientAuth=\"false\" sslProtocol=\"TLS\" \
                          keystoreFile=\"\/opt\/tomcat\/conf\/keystore.p12\" \
                          keystoreType=\"PKCS12\" \
                          keystorePass=\"${KEYSTORE_PASSWORD}\" \/>" /opt/tomcat/conf/server.xml


# Remove temporary files
RUN rm /tmp/private_encrypted.pem /tmp/private.pem /tmp/certificate.pem

# Expose port 4041
EXPOSE 4041

# Start Tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
