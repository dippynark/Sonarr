FROM debian:10.3

RUN apt-get update && apt-get install -y \
  build-essential \
  gcc \
  python \
  git \
  wget \
  gpg \
  make \
  nodejs \
  apt-transport-https

# https://code.visualstudio.com/docs/setup/linux#_debian-and-ubuntu-based-distributions
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
RUN install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
RUN sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
RUN apt-get update && apt-get install -y code

# https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu#install-the-sdk
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update && apt-get install -y dotnet-sdk-3.1

# https://classic.yarnpkg.com/en/docs/install/#mac-stable
RUN cd /opt && \
  wget https://github.com/yarnpkg/yarn/releases/download/v1.22.10/yarn-v1.22.10.tar.gz && \
  tar zvxf yarn-v1.22.10.tar.gz
ENV PATH=/opt/yarn-v1.22.10/bin:$PATH

WORKDIR /workspace

RUN git clone https://github.com/Sonarr/Sonarr && \
  cd Sonarr && \
  yarn install
