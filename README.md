# xpand-it-challenge

This project consists of a Docker container that runs a Tomcat server with SSL/TLS support. It exposes the Tomcat sample application through a secure connection on port 4041. <br>

## Creation of private.pem and self-signed certificate
* Creation of the private key **(private.pem):** Here the ```openssl genpkey```, command was used to generate an RSA private key. RSA is an asymmetric encryption algorithm used to generate public and private keys.
* Creation of the self-signed certificate **(certificate.pem):** With the ```openssl req``` command, a self-signed certificate was created. This certificate is used for **demonstration or development purposes** as it is self-signed and not issued by a trusted certificate authority. It contains information such as the common name (CN) and is valid for 365 days.
* Encryption of the private key **(private_encrypted.pem):** Using the ```openssl rsa command```, the private key was encrypted with AES256(Advanced Encryption Standard) to ensure greater security. This step is important to protect the private key with a password, making it more difficult to compromise if the file is accessed by unauthorized third parties.

## Requirements
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
-t web-app:v1 .
```
## Start the Docker Container
* Let's start the container and it will expose the container's port 4041 to the host's port 4041.
```
docker run -d -p 4041:4041 web-app:v1
```
* Now we can access the Tomcat example application via SSL/TLS:<br>
> **Important Note:** As explained earlier regarding the self-signed certificate, security warnings will be displayed when accessing the URL. This is expected behavior since the certificate is self-signed and not issued by a trusted certificate authority. <br>

Open a web browser and go to: <https://localhost:4041/sample>