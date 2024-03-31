# expand-it-challenges

This project consists of a Docker container that runs a Tomcat server with SSL/TLS support. It exposes the Tomcat sample application through a secure connection on port 4041. <br>

## Prerequisites
* Docker installed on your machine. You can get it [here](https://docs.docker.com/get-docker/).
* To run this project you will need to have the passwords to decrypt private.pem and the password for keystore. They will be sent by email.

## Build Image
* The Docker image build process involves setting up dependencies like Java and OpenSSL, installing Apache Tomcat 8.5, downloading a sample application, configuring SSL/TLS encryption for secure communication, building the Docker image with Tomcat and SSL/TLS support, exposing port 4041 for external access. 
* After cloning the project, navigate to:
``` cd <project-directory> ```
```
docker build \
--build-arg PRIVATE_KEY_PASSWORD=<your-private-key-password> \
--build-arg KEYSTORE_PASSWORD=<your-keystore-password> \
-t image-name .
```
### Start the Docker Container
* Let's start the container and it will expose the container's port 4041 to the host's port 4041.
```
docker run -d -p 4041:4041 image-name
```
* Now we can access the Tomcat example application via SSL/TLS:
Open a web browser and go to: ```https://localhost:4041/sample```