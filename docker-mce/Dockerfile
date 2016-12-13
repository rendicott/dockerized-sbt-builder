FROM centos:7
MAINTAINER "Russell Endicott" <rendicott@gmail.com>

RUN yum install wget -y
# install scala and sbt, should source these from artifactory
RUN wget https://dl.bintray.com/sbt/rpm/sbt-0.13.12.rpm
RUN yum install sbt-0.13.12.rpm -y
RUN yum groupinstall 'Development Tools' -y
RUN yum remove git -y # remove old version

# Install newer version of git 
RUN yum install gettext-devel openssl-devel perl-CPAN perl-devel zlib-devel -y
WORKDIR /tmp
RUN wget https://github.com/git/git/archive/v2.8.0.tar.gz
RUN tar -xzf v2.8.0.tar.gz
RUN ls -al
WORKDIR /tmp/git-2.8.0/
RUN pwd
RUN ls -al
RUN make configure
RUN ./configure --prefix=/usr/local
RUN make install
RUN git --version # validate version

RUN ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N ""
ADD ssh/ /root/.ssh/
RUN chmod 600 /root/.ssh/*
RUN touch /root/.ssh/known_hosts
RUN cat /dev/null > /root/.ssh/known_hosts
RUN ssh-keyscan -T 10 clstash.company.com >> /root/.ssh/known_hosts

RUN mkdir /tmp/source
WORKDIR /tmp/source
ADD git.sh .
ADD build.sh .
RUN chmod +x *.sh
#RUN sbt
ADD repositories /root/.sbt/repositories
RUN sbt -Dsbt.override.build.repos=true
RUN ./git.sh -i /root/.ssh/id_rsa clone ssh://git@clstash.company.com:7999/had/merchant_cleaning.git
#CMD ./build.sh

