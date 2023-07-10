
# CI/CD spring-petclinic

## 10/07/2023:

- [ ] Cloner le repo de l'application afin de tester si l'application est correctement packagée avec Maven, en particulier au niveau de la compatibilité des dépendances. Exécuter les fichiers .jar de chaque service pour vérifier le bon fonctionnement de l'application.

- [ ] Créer les Dockerfiles (ou utiliser buildpacks.io) pour chaque service, afin de les construire en tant qu'images Docker. Configurer une action GitHub pour pousser les images vers un registre.

- [ ] Mettre en place une infrastructure adéquate pour le déploiement de l'environnement de staging à l'aide de Terraform. Ensuite, créer une infrastructure plus légère pour l'environnement de développement, par exemple en utilisant Cloud Run avec un fichier docker-compose.yml ou un cluster Kubernetes à un seul nœud. Pour le moment, le déploiement de l'infrastructure se fera manuellement pour faciliter les tests.

- [ ] Créer les différents modules Kubernetes pour les services et configurer une action GitHub pour effectuer un premier déploiement des services sur l'infrastructure.

## 11/07/2023:

...

## 12/07/2023:

...
