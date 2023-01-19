PORT ?= 3000

build:
	docker build  -t app_image .
	
run:
	docker images | grep app_image
	docker rm -f react_app_container
	docker run -d -p $(PORT):3000 --name react_app_container -i app_image

start:
	docker start react_app_container

stop:
	docker stop react_app_container