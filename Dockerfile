FROM debian:10.6

RUN apt-get update && apt-get install -y \
  gcc \
  python \
  unzip \
  curl \
  git \
  wget \
  gpg \
  make \
  nodejs \
  apt-transport-https

# https://classic.yarnpkg.com/en/docs/install
RUN cd /opt && \
  wget https://github.com/yarnpkg/yarn/releases/download/v1.22.10/yarn-v1.22.10.tar.gz && \
  tar zvxf yarn-v1.22.10.tar.gz
ENV PATH=/opt/yarn-v1.22.10/bin:$PATH

# https://www.mono-project.com/download/stable/#download-lin-debian
RUN apt install apt-transport-https dirmngr gnupg ca-certificates
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb https://download.mono-project.com/repo/debian stable-buster main" | tee /etc/apt/sources.list.d/mono-official-stable.list
RUN apt update && apt install -y mono-complete msbuild

WORKDIR /workspace
