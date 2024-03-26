<!--
Nota bene : ce README est automatiquement généré par <https://github.com/YunoHost/apps/tree/master/tools/readme_generator>
Il NE doit PAS être modifié à la main.
-->

# Firefox Sync Server pour YunoHost

[![Niveau d’intégration](https://dash.yunohost.org/integration/ffsync.svg)](https://dash.yunohost.org/appci/app/ffsync) ![Statut du fonctionnement](https://ci-apps.yunohost.org/ci/badges/ffsync.status.svg) ![Statut de maintenance](https://ci-apps.yunohost.org/ci/badges/ffsync.maintain.svg)

[![Installer Firefox Sync Server avec YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=ffsync)

*[Lire le README dans d'autres langues.](./ALL_README.md)*

> *Ce package vous permet d’installer Firefox Sync Server rapidement et simplement sur un serveur YunoHost.*  
> *Si vous n’avez pas YunoHost, consultez [ce guide](https://yunohost.org/install) pour savoir comment l’installer et en profiter.*

## Vue d’ensemble

Le serveur de synchronisation permet un remplacement du serveur par défaut de Firefox (hébergé par Mozilla).

Par défaut, le serveur reporte l'authentification aux serveurs de comptes de Mozilla à https://accounts.firefox.com. vous vous authentifierez donc sur les serveurs de Mozilla, mais _le stockage de vos informations se fera sur votre serveur_.

⚠️ Cette app est **obsolète et remplacée** par [syncstorage-rs](https://apps.yunohost.org/app/syncserver-rs).


**Version incluse :** 1.9.1~ynh6
## Avertissements / informations importantes

## Configuration

Une fois installé, la page `http://domain.tld/path` vous explique comment l'utiliser.
## :red_circle: Anti-fonctionnalités

- **Application non maintenue**: Ce logiciel n'est plus maintenu. Attendez-vous à ce qu'il ne fonctionne plus avec le temps, et que l'on découvre des failles de sécurité qui ne seront pas corrigées, etc.

## Documentations et ressources

- Documentation officielle de l’admin : <https://mozilla-services.readthedocs.io/en/latest/howtos/run-sync-1.5.html>
- Dépôt de code officiel de l’app : <https://github.com/mozilla-services/syncserver>
- YunoHost Store : <https://apps.yunohost.org/app/ffsync>
- Signaler un bug : <https://github.com/YunoHost-Apps/ffsync_ynh/issues>

## Informations pour les développeurs

Merci de faire vos pull request sur la [branche `testing`](https://github.com/YunoHost-Apps/ffsync_ynh/tree/testing).

Pour essayer la branche `testing`, procédez comme suit :

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/ffsync_ynh/tree/testing --debug
ou
sudo yunohost app upgrade ffsync -u https://github.com/YunoHost-Apps/ffsync_ynh/tree/testing --debug
```

**Plus d’infos sur le packaging d’applications :** <https://yunohost.org/packaging_apps>
