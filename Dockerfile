FROM centos:6.6

ENV GOPATH="/root/go"
ENV PATH $GOPATH/bin:/usr/local/go/bin:/usr/local/node/bin:$PATH

# yum plugin for overlay file system
RUN yum install -y yum-plugin-ovl

# install basic tools
RUN yum install -y tar curl wget git

# install go
ARG GO_PKG
COPY vendors/$GO_PKG /tmp
RUN tar -C /usr/local -xzf /tmp/$GO_PKG
RUN rm /tmp/$GO_PKG

# install node
ARG NODE_PKG
ARG NODE_DIR
COPY vendors/$NODE_PKG /tmp
RUN tar -C /usr/local -xzf /tmp/$NODE_PKG
RUN mv /usr/local/$NODE_DIR /usr/local/node
RUN rm /tmp/$NODE_PKG

# install yarn
RUN npm install -g yarn

# install FPM needs
RUN yum install -y ruby-devel gcc make rpm-build

# install ruby for gem
ARG RUBY_PKG
ARG RUBY_DIR
COPY vendors/$RUBY_PKG /tmp/$RUBY_PKG
RUN tar -xvf /tmp/$RUBY_PKG
RUN rm /tmp/$RUBY_PKG
WORKDIR /$RUBY_DIR
RUN yum install -y zlib-devel openssl-devel
RUN ./configure --with-zlib-dir=/usr --with-openssl-dir=/usr
RUN make -j`nproc`
RUN make install
WORKDIR /
RUN rm -rf /$RUBY_DIR

# install fpm from gem
RUN gem install --no-ri --no-rdoc fpm

# install gcc-c++/bzip2 for yarn install
RUN yum install -y gcc-c++ bzip2

# upgrade ssl(go get with github occurs code 128)
RUN yum update -y nss curl libcurl openssh

COPY scripts/start.sh /

CMD [ "bash", "/start.sh" ]
