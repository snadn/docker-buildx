FROM docker:latest

ENV DOCKER_CLI_EXPERIMENTAL=enabled

RUN mkdir -p ~/.docker/cli-plugins \
  && wget -qO- https://api.github.com/repos/docker/buildx/releases/latest | grep "browser_download_url.*linux-amd64" | cut -d : -f 2,3 | tr -d '"' | xargs wget -O ~/.docker/cli-plugins/docker-buildx \
  && chmod a+x ~/.docker/cli-plugins/docker-buildx
RUN docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
RUN docker buildx ls | grep mybuilder \
  || docker context create buildx \
    && docker buildx create buildx --name mybuilder \
    && docker buildx use mybuilder \
    && docker buildx inspect --bootstrap
