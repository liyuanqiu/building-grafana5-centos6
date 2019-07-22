FROM centos:6.6

ENV GOPATH="/root/go"
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN yum update -y

# yum plugin for overlay file system
RUN yum install -y yum-plugin-ovl

# install basic tools
RUN yum install -y tar curl wget git

# install go
COPY vendors/go1.12.7.linux-amd64.tar.gz /tmp
RUN tar -C /usr/local -xzf /tmp/go1.12.7.linux-amd64.tar.gz
RUN rm /tmp/go1.12.7.linux-amd64.tar.gz

# install node
RUN curl -sL https://rpm.nodesource.com/setup_8.x | bash -
RUN yum install -y nodejs

# install yarn
RUN npm install -g yarn

# install FPM needs
RUN yum install -y ruby-devel gcc make rpm-build

# install ruby for gem
COPY vendors/ruby-2.4.6.tar.gz /tmp/ruby-2.4.6.tar.gz
RUN tar -xvf /tmp/ruby-2.4.6.tar.gz
RUN rm /tmp/ruby-2.4.6.tar.gz
WORKDIR /ruby-2.4.6
RUN yum install -y zlib-devel openssl-devel
RUN ./configure --with-zlib-dir=/usr --with-openssl-dir=/usr
RUN make -j`nproc`
RUN make install
WORKDIR /
RUN rm -rf /ruby-2.4.6

# install fpm from gem
RUN gem install --no-ri --no-rdoc fpm

# install gcc-c++/bzip2 for yarn install
RUN yum install -y gcc-c++ bzip2

COPY scripts/start.sh /

CMD [ "bash", "/start.sh" ]
