# Image Docker pour utiliser PluXml sous Apache

Elle permet d'utiliser la dernière version de [PluXml](http://www.pluxml.org) sur un serveur Apache dans un environnement [Alpine-Linux](https://www.alpinelinux.org/).

La distribution Alpine Linux est une distribution "_poids plume_" par rapport aux autres distributions.

L'image est créée à partir de l'image [nimmis/alpine-micro:latest](https://hub.docker.com/r/nimmis/alpine-micro/). Certains éléments de l'image [nimmis/alpine-apache](https://hub.docker.com/r/nimmis/alpine-apache/) ont également été utilisés.

Le plugin __[kzUploader](http://kazimentou.fr/pluxml-plugins2/)__ est automatiquement ajouté après le téléchargement de PluXml.

Une fois PluXml installé, il est nécessaire d'activer kzUploader pour ajouter d'autres plugins via le navigateur Internet.

Afin de profiter des dernières versions de PluXml et kzUploader, ceux-ci ne sont pas inclus dans l'image mais installés à la première utilisation dans un volume.

### Utilisation

Les données entre les lancements successifs de l'image peuvent être conservés dans un dossier local. Il suffit de le monter sur le volume __/web__, en utilisant l'option -v, comme ceci.

`docker run -v /chemin-complet-du/dossier/mon-site:/web alpine-pluxml`

PluXml sera entièrement stocké dans ce dossier avec les logs du serveur Apache.

Il est ainsi possible de modifier localement l'installation de PluXml en devenant superutilisateur (sudo) et de consulter les logs de Apache.

### Construction de l'image

En se plaçant dans le dossier qui contient le fichier Dockerfile, l'image se construit simplement par la commande :

`docker build -t alpine-pluxml .`

Notez que le point final représente le dossier actuel et non la fin de la phrase.

Par défaut, la version 7 de PHP sera utilisé. Si on souhaite utiliser la version précèdente, utiliser la commande suivante :

`docker build --build-arg PHP_VERSION=php5 -t alpine-pluxml .`

## Utilisation avancée

Pour accèder à la ligne de commande sous Alpine Linux en utilisant l'image pour Docker, lancer l'image comme ceci :

`docker run -itv /chemin-complet-du/dossier/mon-site:/web alpine-pluxml /bin/sh`

Noter les points suivants :

* Il faut rafraichir la liste des paquets par la commande `apk update`

* L'installation de PluXml, du plugin kzUploader et le lancement d'Apache ne se sont pas automatiquement

* Pour cela rentrer successivement les commandes suivantes :

`$ /etc/run_always/50-config-webdir`  /* _Configuration du serveur Apache_ */

`$ /etc/run_always/55-fix-html-dir`  /* _Téléchargement de PluXml et du plugin kzUploader_ */

`$ /etc/sv/apache2/run`  /* _Lancement du serveur Apache_ */

### Installation de Docker

L'installation de Docker sous [Ubuntu](http://www.ubuntu-fr.com/) est relativement facile et clairement expliquée en anglais sur [docker.com](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository) :

https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository

* Installer d'abord les différents paquets nécessaires à Apt pour accèder à un dépôt en utilisant le protocole HTTPS

`$ sudo apt-get install apt-transport-https ca-certificates curl software-properties-common`

* Ajouter la clé de certification pour le dépôt docker.com

`$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -`

* Vérifier que  l'empreinte ( _fingerprint_ )de la clé de certification correspond bien à _9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88_ :

`$ sudo apt-key fingerprint 0EBFCD88`

* Ajouter le dépôt de Docker dans la liste des dépôts de Apt :

`$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"`

Pour les processeurs basés sur sur la famille Armou S390, remplacer _amd64_ par _armhf_ ou _s390x_.

* Mettre à jour la liste des paquets pour tous les dépôts comme d'habitude :

`$ sudo apt update`

* Installer Docker :

`$ sudo apt install docker-ce`

On peut également utiliser un script qui enchaine automatiquement toutes les opérations ci-dessus :

`$ curl -fsSL get.docker.com -o get-docker.sh && sudo sh get-docker.sh`

Par sécurité, il vaut mieux exécuter les instructions une à une.

Les procédures pour installer Docker sur d'autres distributions Linux ou Mac ou Windows sont accessibles ici :
https://store.docker.com/search?type=edition&offering=community
