#
# Development environment in Ubuntu 20.04 Focal
#----------------------------------------------------
# Build: docker build -t dockeragent:latest .
# Run: docker run -e AZP_URL=https://dev.azure.com/{$USERNAME}/ -e AZP_TOKEN=<PAT token> -e AZP_AGENT_NAME=mydockeragent dockeragent:latest
# Run: docker run -v /var/run/docker.sock:/var/run/docker.sock -e AZP_URL=https://dev.azure.com/{$USERNAME}/ -e AZP_TOKEN=<PAT token> -e AZP_AGENT_NAME=mydockeragent dockeragent:latest
FROM ubuntu:20.04

LABEL maintainer="Olivier Mbida <oliver.mbida@ai-uavsystems.com>"

# Logging
#-------------------------------------------------------------
#RUN touch /var/log/provision-docker-ubuntu-20-04.log

# Prerequisites
#-----------------------------------------------------

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt-get remove --auto-remove g++-*

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
    wget \
    git \
    iputils-ping \
    jq \
    zip \
    unzip \
    python3-pip \
    lsb-release \
    software-properties-common \
    && apt-get -y autoremove \
    && apt-get clean autoclean \
    && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

RUN curl -sSL https://get.docker.com/ | sh
# g++ v10.3.0 : released 8 April 2021
# With apt-get remove g++-* above, /usr/bin/g++ is unlinked 
# And all other versions were removed.
# Now it can be linked to the required version
# You can also have other versions installed and ensure the correct version is used
#--------------------------------------------------------

RUN apt -y install g++-10 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 1 \
    && update-alternatives --config g++ 

RUN  g++ --version | grep -oh "10.3.0" || echo "g++ v10.3.0 installation error." 


# Cmake v3.24.1: released 18 Nov 2021
#--------------------------------------------------------

RUN mkdir -p /opt/cmake && cd /opt/cmake \
    && wget -qc "https://github.com/Kitware/CMake/releases/download/v3.24.1/cmake-3.24.1-linux-x86_64.tar.gz" \
    && tar -xzf cmake-3.24.1-linux-x86_64.tar.gz --strip 1

ENV PATH="$PATH:/opt/cmake/bin"

RUN cmake --version | grep -oh "3.24.1" || echo "cmake v3.24.1 installation error." 


# Conan v1.51.3: released 10 Mar 2021
# Bug fixes: https://github.com/conan-io/conan/releases?expanded=true&page=5&q=1.34.1
# Please upgrade to Python>=3.6 to continue using Conan>=1.49
#---------------------------------------------------------

RUN pip install --upgrade pip \
    &&  pip uninstall conan \
    && pip install conan==1.51.3 

RUN conan --version | grep -oh "1.51.3" || echo "conan v1.51.3 installation error." 


# Ninja build tool v1.10.0
# Bug fixes: https://github.com/ninja-build/ninja/releases/tag/v1.10.0
#------------------------------------------------------------

RUN mkdir -p /opt/ninja && cd /opt/ninja \
    && wget -qc "https://github.com/ninja-build/ninja/releases/download/v1.11.0/ninja-linux.zip" \
    && unzip ninja-linux.zip \
    && chmod a+x ./ninja

ENV PATH="$PATH:/opt/ninja"

RUN ninja --version | grep -oh "1.11.0" || echo "ninja v1.11.0 installation error." 

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Can be 'linux-x64', 'linux-arm64', 'linux-arm', 'rhel.6-x64'.
ENV TARGETARCH=linux-x64

WORKDIR /azp

COPY ./start.sh .
RUN chmod +x start.sh

ENTRYPOINT [ "./start.sh" ]