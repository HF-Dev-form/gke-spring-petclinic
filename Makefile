DOCKER_PREFIX = usinegk2023

all: admin-server api-gateway config-server customers discovery-server vets visits


admin-server:
	pack build $(DOCKER_PREFIX)/spring-petclinic-k8s-admin-server --publish -e BP_MAVEN_BUILT_MODULE=spring-petclinic-admin-server -e "BP_MAVEN_BUILD_ARGUMENTS=clean package -DskipTests"


api-gateway:
	pack build $(DOCKER_PREFIX)/spring-petclinic-k8s-api-gateway --publish -e BP_MAVEN_BUILT_MODULE=spring-petclinic-api-gateway -e "BP_MAVEN_BUILD_ARGUMENTS=clean package -DskipTests"


config-server:
	pack build $(DOCKER_PREFIX)/spring-petclinic-k8s-config-server --publish -e BP_MAVEN_BUILT_MODULE=spring-petclinic-config-server -e "BP_MAVEN_BUILD_ARGUMENTS=clean package -DskipTests"


discovery-server:
	pack build $(DOCKER_PREFIX)/spring-petclinic-k8s-discovery-server --publish -e BP_MAVEN_BUILT_MODULE=spring-petclinic-discovery-server -e "BP_MAVEN_BUILD_ARGUMENTS=clean package -DskipTests"


customers:
	pack build $(DOCKER_PREFIX)/spring-petclinic-k8s-customers --publish -e BP_MAVEN_BUILT_MODULE=spring-petclinic-customers-service -e "BP_MAVEN_BUILD_ARGUMENTS=clean package -DskipTests"

vets:
	pack build $(DOCKER_PREFIX)/spring-petclinic-k8s-vets --publish -e BP_MAVEN_BUILT_MODULE=spring-petclinic-vets-service -e "BP_MAVEN_BUILD_ARGUMENTS=clean package -DskipTests"

visits:
	pack build $(DOCKER_PREFIX)/spring-petclinic-k8s-visits --publish -e BP_MAVEN_BUILT_MODULE=spring-petclinic-visits-service -e "BP_MAVEN_BUILD_ARGUMENTS=clean package -DskipTests"