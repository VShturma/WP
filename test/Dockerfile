FROM centos:centos7.6.1810

ENV GOPATH=/go
ENV PATH $PATH:/usr/local/go/bin
ARG aws_key=default_key
ARG aws_secret=default_secret
ENV AWS_ACCESS_KEY_ID=$aws_key
ENV AWS_SECRET_ACCESS_KEY=$aws_secret

WORKDIR /go 

RUN yum -y install unzip wget gcc git \
    && wget https://releases.hashicorp.com/terraform/0.12.3/terraform_0.12.3_linux_amd64.zip -O terraform.zip \
    && unzip terraform.zip \
    && rm -rf terraform.zip \
    && mv terraform /usr/local/sbin/ \
    && wget https://dl.google.com/go/go1.12.7.linux-amd64.tar.gz -O go.tar.gz \
    && tar -C /usr/local -xzf go.tar.gz \
    && rm -rf go.tar.gz \
    && mkdir /go/bin \
    && wget https://raw.githubusercontent.com/golang/dep/master/install.sh && sh install.sh \
    && rm -rf install.sh \
    && yum -y remove unzip wget \
    && yum -y clean all

RUN git clone --branch master https://github.com/VShturma/WP.git /go/src/wordpress
RUN ssh-keygen -f /go/src/wordpress/examples/ec2_key -t rsa -b 4096

WORKDIR /go/src/wordpress/test
