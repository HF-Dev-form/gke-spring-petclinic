DOCKER_PREFIX=usinegk2023
# DOCKERIZE_VERSION=0.7.0

# all: admin-server api-gateway config-server customers discovery-server vets visits


# admin-server:
# 	$(MAKE) install-dockerize
# 	pack build $(DOCKER_PREFIX)/spring-petclinic-k8s-admin-server --publish -e BP_MAVEN_BUILT_MODULE=spring-petclinic-admin-server -e "BP_MAVEN_BUILD_ARGUMENTS=clean package -DskipTests"


# api-gateway:
# 	$(MAKE) install-dockerize
# 	pack build $(DOCKER_PREFIX)/spring-petclinic-k8s-api-gateway --publish -e BP_MAVEN_BUILT_MODULE=spring-petclinic-api-gateway -e "BP_MAVEN_BUILD_ARGUMENTS=clean package -DskipTests"


# config-server:
# 	$(MAKE) install-dockerize
# 	pack build $(DOCKER_PREFIX)/spring-petclinic-k8s-config-server --publish -e BP_MAVEN_BUILT_MODULE=spring-petclinic-config-server -e "BP_MAVEN_BUILD_ARGUMENTS=clean package -DskipTests"


# discovery-server:
# 	$(MAKE) install-dockerize
# 	pack build $(DOCKER_PREFIX)/spring-petclinic-k8s-discovery-server --publish -e BP_MAVEN_BUILT_MODULE=spring-petclinic-discovery-server -e "BP_MAVEN_BUILD_ARGUMENTS=clean package -DskipTests"


# customers:
# 	$(MAKE) install-dockerize
# 	pack build $(DOCKER_PREFIX)/spring-petclinic-k8s-customers --publish -e BP_MAVEN_BUILT_MODULE=spring-petclinic-customers-service -e "BP_MAVEN_BUILD_ARGUMENTS=clean package -DskipTests"

# vets:
# 	$(MAKE) install-dockerize
# 	pack build $(DOCKER_PREFIX)/spring-petclinic-k8s-vets --publish -e BP_MAVEN_BUILT_MODULE=spring-petclinic-vets-service -e "BP_MAVEN_BUILD_ARGUMENTS=clean package -DskipTests"

# visits:
# 	$(MAKE) install-dockerize
# 	pack build $(DOCKER_PREFIX)/spring-petclinic-k8s-visits --publish -e BP_MAVEN_BUILT_MODULE=spring-petclinic-visits-service -e "BP_MAVEN_BUILD_ARGUMENTS=clean package -DskipTests"


# install-dockerize:
# 	curl -sL -o dockerize.tar.gz https://github.com/jwilder/dockerize/releases/download/v$(DOCKERIZE_VERSION)/dockerize-linux-amd64-v$(DOCKERIZE_VERSION).tar.gz
# 	tar -C /usr/local/bin -xzvf dockerize.tar.gz
# 	rm dockerize.tar.gz



all: api-gateway customers-service vets-service visits-service discovery-server

api-gateway:
	cd spring-petclinic-api-gateway && mvn clean package -DskipTests
	docker build -t $(DOCKER_PREFIX)/spring-petclinic-k8s-api-gateway --build-arg ARTIFACT_NAME=$(shell basename spring-petclinic-api-gateway/target/*.jar .jar) .

customers-service:
	cd spring-petclinic-customers-service && mvn clean package -DskipTests
	docker build -t $(DOCKER_PREFIX)/spring-petclinic-k8s-customers-service --build-arg ARTIFACT_NAME=$(shell basename spring-petclinic-customers-service/target/*.jar .jar) .

vets-service:
	cd spring-petclinic-vets-service && mvn clean package -DskipTests
	docker build -t $(DOCKER_PREFIX)/spring-petclinic-k8s-vets-service --build-arg ARTIFACT_NAME=$(shell basename spring-petclinic-vets-service/target/*.jar .jar) .

visits-service:
	cd spring-petclinic-visits-service && mvn clean package -DskipTests
	docker build -t $(DOCKER_PREFIX)/spring-petclinic-k8s-visits-service --build-arg ARTIFACT_NAME=$(shell basename spring-petclinic-visits-service/target/*.jar .jar) .

discovery-server:
	cd spring-petclinic-discovery-server && mvn clean package -DskipTests
	docker build -t $(DOCKER_PREFIX)/spring-petclinic-k8s-discovery-server --build-arg ARTIFACT_NAME=$(shell basename spring-petclinic-discovery-server/target/*.jar .jar) .
