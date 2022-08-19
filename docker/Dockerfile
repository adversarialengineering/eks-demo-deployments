FROM ubuntu:jammy-20220531 as builder

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        unzip curl wget

RUN mkdir /tmp/build

# https://github.com/plexsystems/konstraint
ARG KONSTRAINT_VERSION=v0.23.0
ARG KONSTRAINT_CHECKSUM=76eaa86f2a8fdeed4d039b3d149d3024f48c5d3487565fdfcecb843ed536b2b6
RUN cd /tmp/build && \
    curl -L "https://github.com/plexsystems/konstraint/releases/download/${KONSTRAINT_VERSION}/konstraint-linux-amd64" -o konstraint && \
    echo -n "${KONSTRAINT_CHECKSUM}  konstraint" | sha256sum --check --status && \
    chmod +x ./konstraint

# https://github.com/fugue/fregot
ARG FREGOT_VERSION=v0.14.2
ARG FREGOT_CHECKSUM=cd97f7e699f6ea5b17fc64461a16a0018fe8321b30cad6d0c42181d7ee7518a0
RUN cd /tmp/build && \
    curl -L "https://github.com/fugue/fregot/releases/download/${FREGOT_VERSION}/fregot-${FREGOT_VERSION}-linux.tar.gz" -o fregot.tar.gz && \
    echo -n "${FREGOT_CHECKSUM}  fregot.tar.gz" | sha256sum --check --status && \
    tar -xf fregot.tar.gz -O "fregot" >./fregot && \
    chmod +x ./fregot

# https://github.com/kubernetes-sigs/kustomize
ARG KUSTOMIZE_VERSION=v4.5.7
ARG KUSTOMIZE_CHECKSUM=701e3c4bfa14e4c520d481fdf7131f902531bfc002cb5062dcf31263a09c70c9
RUN cd /tmp/build && \
    curl -L "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz" -o kustomize.tar.gz && \
    echo -n "${KUSTOMIZE_CHECKSUM}  kustomize.tar.gz" | sha256sum --check --status && \
    tar -xf kustomize.tar.gz && \
    chmod +x ./kustomize

# https://github.com/kubernetes/kubectl
ARG KUBECTL_VERSION=v1.24.3
ARG KUBECTL_CHECKSUM=8a45348bdaf81d46caf1706c8bf95b3f431150554f47d444ffde89e8cdd712c1
RUN cd /tmp/build && \
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    echo -n "${KUBECTL_CHECKSUM}  kubectl" | sha256sum --check --status && \
    chmod +x ./kubectl

# https://github.com/open-policy-agent/opa
ARG OPA_VERSION=v0.43.0
ARG OPA_CHECKSUM=d5337139a7ccb04149bd9f96ab7a1641a3e3c39f6e1fffa610c7a5c054b0881f
RUN cd /tmp/build && \
    curl -LO "https://github.com/open-policy-agent/opa/releases/download/${OPA_VERSION}/opa_linux_amd64" &&  \
    mv opa_linux_amd64 opa && \
    echo -n "${OPA_CHECKSUM}  opa" | sha256sum --check --status && \
    chmod +x ./opa

# https://github.com/open-policy-agent/conftest
ARG CONFTEST_VERSION=0.34.0
ARG CONFTEST_CHECKSUM=7392e2ca85c52fc176bec10f07972f8668b0ecc217456085f16a3e571d942f44
RUN cd /tmp/build && \
    curl -LO "https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz" &&  \
    tar -xzvf "conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz" && \
    echo -n "${CONFTEST_CHECKSUM}  conftest" | sha256sum --check --status && \
    chmod +x ./conftest

# https://github.com/hashicorp/terraform
ARG TERRAFORM_VERSION=1.2.7
ARG TERRAFORM_CHECKSUM=93b01d8cb0496202db36be249fdab4ba0c0f5a84de9a603c486765aa5419da5f
RUN cd /tmp/build && \
    wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    echo -n "${TERRAFORM_CHECKSUM}  terraform" | sha256sum --check --status && \
    chmod +x ./terraform

# https://github.com/gruntwork-io/terragrunt
ARG TERRAGRUNT_VERSION=v0.38.7
ARG TERRAGRUNT_CHECKSUM=c3dd39836d968c9299647d9b950ba9110922c6a910c60d8dcc30e8549333aac1  
RUN cd /tmp/build && \
    wget "https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64" && \
    mv ./terragrunt_linux_amd64 ./terragrunt && \
    echo -n "${TERRAGRUNT_CHECKSUM}  terragrunt" | sha256sum --check --status && \
    chmod +x ./terragrunt

# https://github.com/helm/helm
ARG HELM_VERSION=v3.9.3
ARG HELM_CHECKSUM=ebfac82c2c7e8425fff1bbfa2b1867502c5703e1e8fe30ee6ec6e52355d51fc1
RUN cd /tmp/build && \
    wget "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" && \
    tar -xzvf "helm-${HELM_VERSION}-linux-amd64.tar.gz" && \
    cd linux-amd64/ && \
    echo -n "${HELM_CHECKSUM}  helm" | sha256sum --check --status && \
    chmod +x ./helm

# https://github.com/gruntwork-io/cloud-nuke
ARG CLOUD_NUKE_VERSION=v0.17.0
ARG CLOUD_NUKE_CHECKSUM=03106ad46d6177368659a29176bdead22cb20391a00bc0442b246c8e1d53aa9e
RUN cd /tmp/build && \
    wget "https://github.com/gruntwork-io/cloud-nuke/releases/download/${CLOUD_NUKE_VERSION}/cloud-nuke_linux_amd64" && \
    echo -n "${CLOUD_NUKE_CHECKSUM}  cloud-nuke_linux_amd64" | sha256sum --check --status && \
    mv cloud-nuke_linux_amd64 cloud-nuke && \
    chmod +x ./cloud-nuke

# Download Iam authenticator
ARG AWS_IAM_AUTH_VERSION=1.21.2/2021-07-05
ARG AWS_IAM_AUTH_CHECKSUM=fe958eff955bea1499015b45dc53392a33f737630efd841cd574559cc0f41800
RUN cd /tmp/build && \
    wget "https://amazon-eks.s3.us-west-2.amazonaws.com/${AWS_IAM_AUTH_VERSION}/bin/linux/amd64/aws-iam-authenticator" && \
    sha256sum aws-iam-authenticator  && \
    echo "$AWS_IAM_AUTH_CHECKSUM  aws-iam-authenticator" | sha256sum --check --status

FROM ubuntu:jammy-20220531

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
         dnsutils \
         iproute2 \
         python3-venv  \
         mysql-client \
         openjdk-8-jdk && \
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

# Install konstraint
COPY --from=builder /tmp/build/konstraint /usr/local/bin/kubectl

# Install fregot
COPY --from=builder /tmp/build/fregot /usr/local/bin/fregot

# Install kustomize
COPY --from=builder /tmp/build/kustomize /usr/local/bin/kustomize

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

ARG AWS_CLI_VERSION=2.7.4
ARG AWS_CLI_CHECKSUM=2b73e4be409197ffb19c169e3577ec217e0d90c0db23668255d844482aa2aa3d
RUN mkdir /tmp/build && cd /tmp/build && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" -o "awscliv2.zip" && \
    echo -n "${AWS_CLI_CHECKSUM} awscliv2.zip" | sha256sum --check --status && \
    unzip awscliv2.zip && \
    ./aws/install

# Install aws sam
ARG AWS_SAM_VERSION="v1.55.0"
ARG AWS_SAM_CHECKSUM=5e3e2fe551b8a1ce1615100695772ac24de09946f326939a06b8483e63d25962
RUN cd /tmp/build && \
    wget "https://github.com/aws/aws-sam-cli/releases/download/${AWS_SAM_VERSION}/aws-sam-cli-linux-x86_64.zip" && \
    echo -n "${AWS_SAM_CHECKSUM}  aws-sam-cli-linux-x86_64.zip" | sha256sum --check --status && \
    unzip aws-sam-cli-linux-x86_64.zip -d sam-installation && \
    ./sam-installation/install

# Install go v18
ARG GOLANG_CHECKSUM=956f8507b302ab0bb747613695cdae10af99bbd39a90cae522b7c0302cc27245
RUN cd /tmp/build && \
    wget https://go.dev/dl/go1.18.3.linux-amd64.tar.gz && \
    echo -n "${GOLANG_CHECKSUM}  go1.18.3.linux-amd64.tar.gz" | sha256sum --status --check && \
    tar -C /usr/local/ -xzvf go1.18.3.linux-amd64.tar.gz && \
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

# Install github cli
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null
RUN apt update
RUN apt install gh

# Install AWS CDK
RUN npm install -g aws-cdk 

USER ${USER_NAME}

# Install serverless
RUN curl -o- -L https://slss.io/install | bash

ENV GOPATH="/home/${USER_NAME}/.gocache"
ENV PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"

COPY bash_aliases "/home/${USER_NAME}/.bash_aliases"

WORKDIR "${USER_HOME_DIR}"
