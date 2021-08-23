FROM ubuntu:focal-20210416 as builder

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        unzip curl wget

RUN mkdir /tmp/build

ARG KUBECTL_VERSION=v1.20.1
ARG KUBECTL_CHECKSUM=3f4b52a8072013e4cd34c9ea07e3c0c4e0350b227e00507fb1ae44a9adbf6785
RUN cd /tmp/build && \
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    echo -n "${KUBECTL_CHECKSUM}  kubectl" | sha256sum --check --status && \
    chmod +x ./kubectl

ARG OPA_VERSION=v0.25.2
ARG OPA_CHECKSUM=d6ca4103d6fa8f813ad0d68882a7a0988159ad1c69cdcc0b766c438a4c097936
RUN cd /tmp/build && \
    curl -LO "https://github.com/open-policy-agent/opa/releases/download/${OPA_VERSION}/opa_linux_amd64" &&  \
    mv opa_linux_amd64 opa && \
    echo -n "${OPA_CHECKSUM}  opa" | sha256sum --check --status && \
    chmod +x ./opa

ARG CONFTEST_VERSION=0.22.0
ARG CONFTEST_CHECKSUM=fb090053d8b00793997b4714c275ccbd987286b3001b511859c4264e2628b69e
RUN cd /tmp/build && \
    curl -LO "https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz" &&  \
    tar -xzvf "conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz" && \
    echo -n "${CONFTEST_CHECKSUM}  conftest" | sha256sum --check --status && \
    chmod +x ./conftest

ARG TERRAFORM_VERSION=1.0.0
ARG TERRAFORM_CHECKSUM=62bda872dbcf76387d00fefe337bb48617be414d746884a1b07ed0b3bd04706e
RUN cd /tmp/build && \
    wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    sha256sum terraform && \
    echo -n "${TERRAFORM_CHECKSUM}  terraform" | sha256sum --check --status && \
    chmod +x ./terraform

ARG TERRAGRUNT_VERSION=v0.29.0
ARG TERRAGRUNT_CHECKSUM=b46c0dae9469cb1633d0e3d71092bce43581b979dcbbb1c14aac96a4e3f39935
RUN cd /tmp/build && \
    wget "https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64" && \
    mv ./terragrunt_linux_amd64 ./terragrunt && \
    sha256sum terragrunt && \
    echo -n "${TERRAGRUNT_CHECKSUM}  terragrunt" | sha256sum --check --status && \
    chmod +x ./terragrunt

ARG HELM_VERSION=v3.5.2
ARG HELM_CHECKSUM=018736e597b2e986ff4af2dd51e893fe6af131e36a325ed9b777a478a1cbf17e
RUN cd /tmp/build && \
    wget "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" && \
    tar -xzvf "helm-${HELM_VERSION}-linux-amd64.tar.gz" && \
    cd linux-amd64/ && \
    sha256sum helm && \
    echo -n "${HELM_CHECKSUM}  helm" | sha256sum --check --status && \
    chmod +x ./helm

ARG CLOUD_NUKE_VERSION=v0.3.0
ARG CLOUD_NUKE_CHECKSUM=9c2e21c0dfd7528318db4bc03db595f74e4817868d68465068e24cafa3feca3d
RUN cd /tmp/build && \
    wget "https://github.com/gruntwork-io/cloud-nuke/releases/download/${CLOUD_NUKE_VERSION}/cloud-nuke_linux_amd64" && \
    sha256sum cloud-nuke_linux_amd64 && \
    echo -n "${CLOUD_NUKE_CHECKSUM}  cloud-nuke_linux_amd64" | sha256sum --check --status && \
    mv cloud-nuke_linux_amd64 cloud-nuke && \
    chmod +x ./cloud-nuke


# Download Iam authenticator
ARG AWS_IAM_AUTH_VERSION=1.17.9
ARG AWS_IAM_AUTH_CHECKSUM=fe958eff955bea1499015b45dc53392a33f737630efd841cd574559cc0f41800

RUN cd /tmp/build && \
    wget "https://amazon-eks.s3.us-west-2.amazonaws.com/${AWS_IAM_AUTH_VERSION}/2020-08-04/bin/linux/amd64/aws-iam-authenticator" && \
    sha256sum aws-iam-authenticator  && \
    echo "$AWS_IAM_AUTH_CHECKSUM  aws-iam-authenticator" | sha256sum --check --status

FROM ubuntu:focal-20210416

ARG USER_UID=1000
ARG USER_NAME="dev"
ARG USER_GID=1000
ARG USER_GROUP="dev"
ARG USER_HOME_DIR="/home/dev"

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
         bash \
         bash-completion \
         wget \
         curl \
         unzip \
         make \
         shellcheck \
         openssh-client \
         git \
         gpg \
         curl \
         xz-utils \
         python3 \
         python3-pip \
         vim \
         software-properties-common \
         jq \
         iproute2 &&\
    DEBIAN_FRONTEND=noninteractive apt-get clean

 
RUN  groupadd -g ${USER_GID} ${USER_GROUP} && \
     useradd \
        --create-home \
        --home-dir ${USER_HOME_DIR} \
        -u ${USER_UID} \
        -g ${USER_GROUP} \
        --shell /bin/bash \
        ${USER_NAME}

ARG DOCKER_GID=998
RUN  groupadd -g ${DOCKER_GID} docker && usermod -G docker ${USER_NAME}


# Install kubectl
COPY --from=builder /tmp/build/kubectl /usr/local/bin/kubectl

# Install opa
COPY --from=builder /tmp/build/opa /usr/local/bin/opa

# Install terraform
COPY --from=builder /tmp/build/terraform /usr/local/bin/terraform

# Install terragrunt
COPY --from=builder /tmp/build/terragrunt /usr/local/bin/terragrunt

# Install conftest
COPY --from=builder /tmp/build/conftest /usr/local/bin/conftest

# Install helm
COPY --from=builder /tmp/build/linux-amd64/helm /usr/local/bin/helm

# Install cloud-nuke
COPY --from=builder /tmp/build/cloud-nuke /usr/local/bin/cloud-nuke

ARG AWS_CLI_VERSION=2.0.30
ARG AWS_CLI_CHECKSUM=7ee475f22c1b35cc9e53affbf96a9ffce91706e154a9441d0d39cbf8366b718e
RUN mkdir /tmp/build && cd /tmp/build && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" -o "awscliv2.zip" && \
    echo -n "${AWS_CLI_CHECKSUM} awscliv2.zip" | sha256sum --check --status && \
    unzip awscliv2.zip && \
    ./aws/install

# Install aws sam
ARG AWS_SAM_VERSION="v1.18.1"
ARG AWS_SAM_CHECKSUM=742ea69de70100b132cd636612d5d256e628178f366284bf74defef656969968
RUN cd /tmp/build && \
    wget "https://github.com/aws/aws-sam-cli/releases/download/${AWS_SAM_VERSION}/aws-sam-cli-linux-x86_64.zip" && \
    sha256sum aws-sam-cli-linux-x86_64.zip && \
    echo -n "${AWS_SAM_CHECKSUM}  aws-sam-cli-linux-x86_64.zip" | sha256sum --check --status && \
    unzip aws-sam-cli-linux-x86_64.zip -d sam-installation && \
    ./sam-installation/install

# Install go
ARG GOLANG_CHECKSUM=3918e6cc85e7eaaa6f859f1bdbaac772e7a825b0eb423c63d3ae68b21f84b844
RUN cd /tmp/build && \
    wget https://golang.org/dl/go1.15.6.linux-amd64.tar.gz && \
    echo -n "${GOLANG_CHECKSUM}  go1.15.6.linux-amd64.tar.gz" | sha256sum --status --check && \
    tar -C /usr/local/ -xzvf go1.15.6.linux-amd64.tar.gz && \
    rm -rf /tmp/build

# Install aws-iam-authenticator
COPY --from=builder /tmp/build/aws-iam-authenticator /usr/local/sbin/aws-iam-authenticator
RUN chmod 0755 /usr/local/sbin/aws-iam-authenticator

# Install SSM plugin
RUN curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb" \
        && dpkg -i session-manager-plugin.deb

# Install node
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get -y install nodejs \
        &&  node --version \
   	    && npm --version \
   	    && echo "Sanity check:" \
   	    && node -e 'console.log(process.version)'

# Install Snyk
RUN npm install -g snyk

# Install gcloud
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt-get update && apt-get -y install google-cloud-sdk

# Install docker cli
RUN echo "deb [signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian buster stable" | tee -a /etc/apt/sources.list.d/docker.list
RUN curl https://download.docker.com/linux/debian/gpg | apt-key --keyring /usr/share/keyrings/docker.gpg add - 
RUN apt-get update && apt-get -y install docker-ce-cli

# Install boundary
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN echo "deb [arch=amd64] https://apt.releases.hashicorp.com buster main" | tee -a /etc/apt/sources.list.d/hashicorp.list
RUN apt-get update && apt-get install boundary

# Install ansible
RUN pip3 install -U pip && \
    pip3 install \
    setuptools \
    wheel && \
    pip3 install ansible

USER ${USER_NAME}

ENV GOPATH="/home/${USER_NAME}/.gocache"
ENV PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"

COPY bash_aliases "/home/${USER_NAME}/.bash_aliases"

WORKDIR "${USER_HOME_DIR}"
