FROM centos:7

MAINTAINER Marcos Entenza <mak@redhat.com>

LABEL io.k8s.description="AWS EBS snaphot manager for OCP" \
      io.k8s.display-name="AWS EBS snaphot manager for OCP"

ENV PATH=$PATH:/root/.local/bin
ENV AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
ENV AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
ENV AWS_REGION=${AWS_REGION}


RUN rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
rm -fr /var/cache/yum/* && \
yum clean all && \
INSTALL_PKGS="python2-pip" && \ 
yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
rpm -V $INSTALL_PKGS && \
yum clean all && \
pip install awscli --upgrade --user

CMD [ "/usr/bin/sleep", "10000000" ]