DOCKER_IMAGE = sonarr-build

all: build package

build:
	yarn global add node-gyp
	yarn install
	yarn build
	bash build.sh

package:
	rm -rf Sonarr.linux.tar.gz Sonarr
	cp -r ./_output_linux Sonarr
	tar -zcvf Sonarr.linux.tar.gz ./Sonarr/*

docker_image:
	docker build \
		-t $(DOCKER_IMAGE) $(CURDIR)

docker_%: docker_image
	docker run -it \
		-v $(CURDIR):/workspace \
		$(DOCKER_IMAGE) \
		make $*
