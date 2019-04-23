#
# Create a docker image suitable for day to day use when on client
# sites rather than pollute the Base OS on my laptop.
# Yes this is pretty heavy for a container....
#
FROM centos:7
MAINTAINER Joel Heenan "joelh@planetjoel.com"
RUN yum -y update
RUN yum -y install epel-release
RUN yum -y install which git vim mlocate curl sudo unzip file python-devel python-pip python34 python34-devel wget bind-utils
 
# Create a user for use in the image that aligns with the UID on my mac.
# Ensure it has sudo root access
#
RUN useradd -m -u 501 joelh
RUN chown joelh:joelh /home/joelh/
RUN echo '%wheel    ALL=(ALL)    NOPASSWD:ALL' > /etc/sudoers.d/wheel
RUN chmod 0440 /etc/sudoers.d/wheel
 
# Install RVM and a copy of Ruby 2.3
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN usermod -G rvm,wheel joelh
RUN usermod -G rvm root
RUN su - root -c "rvm install 2.3"
 
# Install the AWS CLI Tools
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "/var/tmp/awscli-bundle.zip"
WORKDIR /var/tmp/
RUN unzip awscli-bundle.zip
WORKDIR /var/tmp/awscli-bundle/
RUN /var/tmp/awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
RUN rm -f /var/tmp/awscli-bundle.zip
RUN rm -rf /var/tmp/awscli-bundle
 
WORKDIR /
 
CMD ["/bin/bash"]
