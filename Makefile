# DOCKER_PREFIX=usinegk2023
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

DOCKER_PREFIX = usinegk2023
DOCKERIZE_VERSION = 0.7.0

all: admin-server api-gateway config-server customers discovery-server vets visits

admin-server:
	$(MAKE) build-with-dockerize SERVICE=admin-server MODULE=spring-petclinic-admin-server

api-gateway:
	$(MAKE) build-with-dockerize SERVICE=api-gateway MODULE=spring-petclinic-api-gateway

config-server:
	$(MAKE) build-with-dockerize SERVICE=config-server MODULE=spring-petclinic-config-server

discovery-server:
	$(MAKE) build-with-dockerize SERVICE=discovery-server MODULE=spring-petclinic-discovery-server

customers:
	$(MAKE) build-with-dockerize SERVICE=customers MODULE=spring-petclinic-customers-service

vets:
	$(MAKE) build-with-dockerize SERVICE=vets MODULE=spring-petclinic-vets-service

visits:
	$(MAKE) build-with-dockerize SERVICE=visits MODULE=spring-petclinic-visits-service

build-with-dockerize:
	@echo "FROM openjdk:11-jre as builder" > Dockerfile
	@echo "WORKDIR application" >> Dockerfile
	@echo "ARG ARTIFACT_NAME" >> Dockerfile
	@echo "COPY ${ARTIFACT_NAME}.jar application.jar" >> Dockerfile
	@echo "RUN java -Djarmode=layertools -jar application.jar extract" >> Dockerfile
	@echo "ARG DOCKERIZE_VERSION" >> Dockerfile
	@echo "RUN wget -O dockerize.tar.gz https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz" >> Dockerfile
	@echo "RUN tar xzf dockerize.tar.gz" >> Dockerfile
	@echo "RUN chmod +x dockerize" >> Dockerfile
	@echo "FROM adoptopenjdk:11-jre-hotspot" >> Dockerfile
	@echo "WORKDIR application" >> Dockerfile
	@echo "COPY --from=builder application/dockerize ./" >> Dockerfile
	@echo "ARG EXPOSED_PORT" >> Dockerfile
	@echo "EXPOSE ${EXPOSED_PORT}" >> Dockerfile
	@echo "ENV SPRING_PROFILES_ACTIVE docker" >> Dockerfile
	@echo "COPY --from=builder application/dependencies/ ./" >> Dockerfile
	@echo "COPY --from=builder application/spring-boot-loader/ ./" >> Dockerfile
	@echo "COPY --from=builder application/snapshot-dependencies/ ./" >> Dockerfile
	@echo "COPY --from=builder application/application/ ./" >> Dockerfile
	@echo "ENTRYPOINT [\"java\", \"org.springframework.boot.loader.JarLauncher\"]" >> Dockerfile
	docker build -t $(DOCKER_PREFIX)/spring-petclinic-k8s-$(SERVICE) --build-arg ARTIFACT_NAME=$(MODULE) --build-arg DOCKERIZE_VERSION=$(DOCKERIZE_VERSION) --build-arg EXPOSED_PORT=8080 .
