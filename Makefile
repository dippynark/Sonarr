DOCKER_IMAGE = sonarr-build

all: build package

build:
	find . -name '*.csproj' -exec dotnet restore {} \;
	bash build.sh

package:
	cp -r ./_artifacts/linux-x64/net462/Sonarr Sonarr
	tar -zcvf Sonarr.linux.tar.gz ./Sonarr/*

docker_image:
	docker build \
		-t $(DOCKER_IMAGE) $(CURDIR)

docker_%: docker_image
	docker run -it \
		-v $(CURDIR):/workspace \
		$(DOCKER_IMAGE) \
		make $*
