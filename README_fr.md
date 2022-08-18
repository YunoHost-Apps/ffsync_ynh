> :warning: **Firefox Sync Server n'est plus maintenue par Mozilla. Le packaging de l'app est arrêté et l'installation déconseillée.**

# Serveur de synchronisation de Firefox pour YunoHost

[![Integration level](https://dash.yunohost.org/integration/ffsync.svg)](https://dash.yunohost.org/appci/app/ffsync) ![](https://ci-apps.yunohost.org/ci/badges/ffsync.status.svg) ![](https://ci-apps.yunohost.org/ci/badges/ffsync.maintain.svg)  
[![Install ffsync with YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=ffsync)

*[Read this readme in english.](./README.md)*
> *Ce package vous permet d'installer ffsync rapidement et simplement sur un serveur Yunohost.   
Si vous n'avez pas YunoHost, regardez [ici](https://yunohost.org/#/install) pour savoir comment l'installer et en profiter.*

## Vue d'ensemble

Le serveur de synchronisation permet un remplacement du serveur par défaut de Firefox (hébergé par Mozilla).

Par défaut, le serveur reporte l'authentification aux serveurs de comptes de Mozilla à https://accounts.firefox.com. vous vous authentifierez donc sur les serveurs de Mozilla, mais _le stockage de vos informations se fera sur votre serveur_.

**Version incluse :** 1.9.1

## Documentation

 * Documentation officialle : https://mozilla-services.readthedocs.io/en/latest/howtos/run-sync-1.5.html
 * Documentation YunoHost : https://yunohost.org/#/app_ffsync

## Configuration

Une fois installé, la page `http://domain.tld/path` vous explique comment l'utiliser.

#### Architectures supportées

* x86-64b - [![Build Status](https://ci-apps.yunohost.org/ci/logs/ffsync%20%28Apps%29.svg)](https://ci-apps.yunohost.org/ci/apps/ffsync/)
* ARMv8-A - [![Build Status](https://ci-apps-arm.yunohost.org/ci/logs/ffsync%20%28Apps%29.svg)](https://ci-apps-arm.yunohost.org/ci/apps/ffsync/)

## Liens

 * Rapporter un bug : https://github.com/YunoHost-Apps/ffsync_ynh/issues
 * Dépôt de Sync Server : https://github.com/mozilla-services/syncserver
 * Site de YunoHost : https://yunohost.org/

---

## Informations pour les développeurs

Merci de faire votre « pull request » sur la [branche testing](https://github.com/YunoHost-Apps/ffsync_ynh/tree/testing).
Pour tester la branche testing, faites comme ceci.
```
sudo yunohost app install https://github.com/YunoHost-Apps/ffsync_ynh/tree/testing --debug
ou
sudo yunohost app upgrade ffsync -u https://github.com/YunoHost-Apps/ffsync_ynh/tree/testing --debug
```
