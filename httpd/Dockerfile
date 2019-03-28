FROM openshift/rhel7:latest

RUN yum -y install \
  --enablerepo=rhel-7-server-optional-rpms \
  --enablerepo=rhel-7-server-extras-rpms \
  httpd

# Set up permissions
RUN chmod a+rwX -R /var/log/httpd /run/httpd
RUN sed -i -e 's/^Listen .*/Listen 8080/' /etc/httpd/conf/httpd.conf

RUN echo "Sample Web Server" > /var/www/html/index.html

EXPOSE 8080

# Start the service
CMD ["-D", "FOREGROUND"]
ENTRYPOINT ["/usr/sbin/httpd"]
