
# CI/CD spring-petclinic ## Evolutif

## 10/07/2023:

- [ ] Cloner le repo de l'application afin de tester si l'application est correctement packagée avec Maven, en particulier au niveau de la compatibilité des dépendances. Exécuter les fichiers .jar de chaque service pour vérifier le bon fonctionnement de l'application.

- [ ] Créer les Dockerfiles (ou utiliser buildpacks.io) pour chaque service, afin de les construire en tant qu'images Docker. Configurer une action GitHub pour pousser les images vers un registre.

- [ ] Mettre en place une infrastructure adéquate pour le déploiement de l'environnement de staging à l'aide de Terraform. Ensuite, créer une infrastructure plus légère pour l'environnement de développement, par exemple en utilisant Cloud Run avec un fichier docker-compose.yml ou un cluster Kubernetes à un seul nœud. Pour le moment, le déploiement de l'infrastructure se fera manuellement pour faciliter les tests.

- [ ] Créer les différents services de l'application pour Kubernetes via les images stcokées et configurer une action GitHub pour effectuer un premier déploiement des services sur l'infrastructure.

## 11/07/2023:

...

## 12/07/2023:

...

# Tâche prioritaire:
Je vais créer un environnement de pré-production similaire à l'environnement de production. Les données de production seront réinjectées quotidiennement dans cet environnement pour simuler au mieux les conditions réelles. J'utiliserai des tâches cycliques pour éteindre cet environnement pendant les périodes de non-activité afin d'économiser les ressources.

Une fois que l'environnement de pré-production est testé et validé, je passerai à la mise en place de l'environnement de production. Cet environnement sera conçu pour garantir une haute disponibilité et inclura des mécanismes de sauvegarde automatique régulière de la base de données pour minimiser les pertes de données en cas d'incident. Je mettrai également en place une surveillance et des alertes pour suivre les performances et détecter les problèmes potentiels.
 
