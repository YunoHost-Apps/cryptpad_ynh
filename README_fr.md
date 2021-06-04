# CryptPad pour YunoHost

[![Niveau d'intégration](https://dash.yunohost.org/integration/cryptpad.svg)](https://dash.yunohost.org/appci/app/cryptpad) ![](https://ci-apps.yunohost.org/ci/badges/cryptpad.status.svg) ![](https://ci-apps.yunohost.org/ci/badges/cryptpad.maintain.svg)  
[![Installer CryptPad avec YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=cryptpad)

*[Read this readme in english.](./README.md)*
*[Lire ce readme en français.](./README_fr.md)*

> *Ce package vous permet d'installer CryptPad rapidement et simplement sur un serveur YunoHost.
Si vous n'avez pas YunoHost, regardez [ici](https://yunohost.org/#/install) pour savoir comment l'installer et en profiter.*

## Vue d'ensemble

Éditeur chiffré collaboratif en temps réel.

**Version incluse :** 4.6.0~ynh1

**Démo :** https://cryptpad.fr/

## Captures d'écran

![](./doc/screenshots/screenshot.png)

## Avertissements / informations importantes

## Configuration

Comment configurer cette application : via le panneau d'administration ainsi que le fichier de configuration `/var/www/cryptpad/config/config.js`.

## Documentations et ressources

* Site officiel de l'app : https://cryptpad.fr/
* Documentation officielle utilisateur : https://yunohost.org/apps
* Documentation officielle de l'admin : https://docs.cryptpad.fr/en/
* Dépôt de code officiel de l'app : https://github.com/xwiki-labs/cryptpad
* Documentation YunoHost pour cette app : https://yunohost.org/app_cryptpad
* Signaler un bug : https://github.com/YunoHost-Apps/cryptpad_ynh/issues

## Informations pour les développeurs

Merci de faire vos pull request sur la [branche testing](https://github.com/YunoHost-Apps/cryptpad_ynh/tree/testing).

Pour essayer la branche testing, procédez comme suit.
```
sudo yunohost app install https://github.com/YunoHost-Apps/cryptpad_ynh/tree/testing --debug
ou
sudo yunohost app upgrade cryptpad -u https://github.com/YunoHost-Apps/cryptpad_ynh/tree/testing --debug
```

**Plus d'infos sur le packaging d'applications :** https://yunohost.org/packaging_apps