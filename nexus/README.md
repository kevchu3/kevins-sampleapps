# Docker Repository with Nexus and Httpd

### 1. Installing Sonatype Nexus

Provision a virtual machine with 4 cores and 8 GB RAM according to minimum [system requirements].  Follow the instructions to [install Nexus], [install Java] and [run Nexus as a service].

### 2. Configure Private Docker Repository

From the Nexus UI, configure a [private Docker repository] on Sonatype Nexus

### 3. Set up httpd as reverse proxy

Download and set up Apache httpd as a reverse proxy.  This will allow a repository connector to be used on a separate port, reasoning below provided by [this article]:

What is a Repository Connector?
When you make a request using the Docker client, you provide a hostname and port followed by the Docker image. Docker does not support the use of a context to specify the path to the repository. 

Does not work:
`docker pull centos7:8081/repository/docker-group/postgres:9.4`

Does work:
`docker pull centos7:18080/postgres:9.4`

Since we cannot include the repository name in the Docker client request, we use a Repository Connector to assign a port to the Docker repository which can be used in Docker client commands. The Repository Connector is found in the settings for each docker repository.

#### 3a. Install and configure httpd

Follow the steps to [configure httpd as a reverse proxy].

Install needed packages: `yum install httpd mod_ssl mod_headers -y`

Edit the main configuration file: `vi /etc/httpd/conf/httpd.conf`
```
Listen 5002

# Docker
ProxyRequests Off
ProxyPreserveHost On

<VirtualHost *:5002>
  SSLEngine on
  SSLCertificateFile /etc/httpd/nexus.crt
  SSLCertificateKeyFile /etc/httpd/nexus.key

  ServerName nexus.example.com
  ServerAdmin admin@example.com

  AllowEncodedSlashes NoDecode

  ProxyPass / http://nexus.example.com:8081/repository/docker-private/ nocanon
  ProxyPassReverse / http://nexus.example.com:8081/repository/docker-private/
  RequestHeader set X-Forwarded-Proto "https"

  ErrorLog logs/nexus.example.com/nexus/error.log
  CustomLog logs/nexus.example.com/nexus/access.log common
</VirtualHost>
```

Create logs directory: `mkdir -p /var/log/httpd/nexus.example.com/nexus`

#### 3b. Generate and configure SSL certificates

Follow the steps to [generate SSL certificates].
```
cd /etc/httpd
keytool -genkeypair -keystore keystore.jks -storepass password -alias nexus \
 -keyalg RSA -keysize 2048 -validity 5000 -keypass password \
 -dname 'CN=nexus.example.com, OU=Red Hat, O=Red Hat, L=New York, ST=NY, C=US' \
 -ext 'SAN=DNS:nexus.example.com'
keytool -exportcert -keystore keystore.jks -alias nexus -rfc > nexus.crt
keytool -importkeystore -srckeystore keystore.jks -destkeystore nexus.p12 -deststoretype PKCS12
openssl pkcs12 -nokeys -in nexus.p12 -out nexus.pem
openssl pkcs12 -nocerts -nodes -in nexus.p12 -out nexus.key

Edit the SSL configuration file to point to your custom certificates: `vi /etc/httpd/conf.d/ssl.conf'
```
SSLCertificateFile /etc/httpd/nexus.crt
SSLCertificateKeyFile /etc/httpd/nexus.key
```
#### 3c. Set up whitelisting

```
# set SELinux permissions for non-standard port 5002
yum -y install policycoreutils-python
semanage port -a -t http_port_t -p tcp 5002

# https://access.redhat.com/solutions/2980121
setsebool -P httpd_can_network_connect 1

# whitelist port 5002 in firewalld
firewall-cmd --permanent --add-port=5002/tcp
firewall-cmd --reload

# start httpd
systemctl restart httpd
```

Configure docker client to [trust self-signed certificate]. Copy nexus certificate to every host and OS certificate trust.  You do not need to restart Docker.

```
cp nexus.crt /etc/docker/certs.d/nexus.example.com:5002/ca.crt
cp certs/nexus.crt /etc/pki/ca-trust/source/anchors/nexus.example.com/nexus.crt
update-ca-trust
```

### 4. Log into Nexus repository

`podman login nexus.example.com:5002`

[system requirements]: https://help.sonatype.com/repomanager3/system-requirements
[install Nexus]: https://help.sonatype.com/repomanager3/installation
[install Java]: https://help.sonatype.com/repomanager3/installation/java-runtime-environment
[run Nexus as a service]: https://help.sonatype.com/repomanager3/installation/run-as-a-service
[private Docker repository]: https://blog.sonatype.com/using-nexus-3-as-your-repository-part-3-docker-images
[this article]: https://support.sonatype.com/hc/en-us/articles/115013153887-Docker-Repository-Configuration-and-Client-Connection
[configure httpd as a reverse proxy]: https://help.sonatype.com/repomanager3/installation/run-behind-a-reverse-proxy
[generate ssl certificates]: https://support.sonatype.com/hc/en-us/articles/213465768-SSL-Certificate-Guide
[trust self-signed certificate]: https://docs.docker.com/registry/insecure/#use-self-signed-certificates
