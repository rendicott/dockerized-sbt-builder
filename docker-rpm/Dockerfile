FROM centos:7
RUN yum install wget -y
RUN yum remove git -y

RUN wget http://opensource.wandisco.com/centos/6/git/x86_64/git-2.10.0-1.WANdisco.313.x86_64.rpm
RUN wget http://opensource.wandisco.com/centos/6/git/x86_64/perl-Git-2.10.0-1.WANdisco.313.noarch.rpm
RUN yum install gettext-devel openssl-devel perl-CPAN perl-devel zlib-devel -y
WORKDIR /tmp
RUN wget https://github.com/git/git/archive/v2.8.0.tar.gz
RUN tar -xzf v2.8.0.tar.gz
RUN ls -al
WORKDIR /tmp/git-2.8.0/
RUN pwd
RUN ls -al
RUN yum groupinstall 'Development Tools' -y
RUN make configure
RUN ./configure --prefix=/usr/local
RUN make install
RUN git --version
RUN ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N ""
ADD ssh/ /root/.ssh/
RUN chmod 600 /root/.ssh/*
RUN touch /root/.ssh/known_hosts
RUN cat /dev/null > /root/.ssh/known_hosts
RUN ssh-keyscan -T 10 stash.company.com >> /root/.ssh/known_hosts

RUN mkdir /tmp/source
WORKDIR /tmp/source
ADD git.sh .
RUN ./git.sh -i /root/.ssh/id_rsa clone ssh://git@stash.company.com:7999/had/merchant_cleaning.git
RUN yum install rpmdevtools -y
RUN yum install tree -y
ADD package.sh .
RUN chmod +x package.sh
