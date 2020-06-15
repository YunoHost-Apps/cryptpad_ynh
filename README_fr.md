# CryptPad pour YunoHost

[![Integration level](https://dash.yunohost.org/integration/cryptpad.svg)](https://dash.yunohost.org/appci/app/cryptpad) ![](https://ci-apps.yunohost.org/ci/badges/cryptpad.status.svg) ![](https://ci-apps.yunohost.org/ci/badges/cryptpad.maintain.svg)  
[![Installer CryptPad avec YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=cryptpad)

*[Read this readme in english.](./README.md)* 

> *Ce package vous permet d'installer REPLACEBYYOURAPP rapidement et simplement sur un serveur Yunohost.  
Si vous n'avez pas YunoHost, consultez [le guide](https://yunohost.org/#/install) pour apprendre comment l'installer.*

## Vue d'ensemble
Quick description of this app.

**Version incluse :** 3.18.1

## Captures d'écran

![](https://github.com/xwiki-labs/cryptpad/raw/master/screenshot.png)

## Démo

* [Démo officielle](https://cryptpad.fr/)

## Configuration

How to configure this app: From an admin panel, a plain file with SSH, or any other way.

## Documentation

* Official documentation : Link to the official documentation of this app
* YunoHost documentation : If specific documentation is needed, feel free to contribute.

## YunoHost specific features

#### Support multi-utilisateur

* L'authentification LDAP et HTTP est-elle prise en charge ?
* L'application peut-elle être utilisée par plusieurs utilisateurs ?

#### Architectures supportées

* x86-64 - [![Build Status](https://ci-apps.yunohost.org/ci/logs/cryptpad%20%28Apps%29.svg)](https://ci-apps.yunohost.org/ci/apps/cryptpad/)
* ARMv8-A - [![Build Status](https://ci-apps-arm.yunohost.org/ci/logs/cryptpad%20%28Apps%29.svg)](https://ci-apps-arm.yunohost.org/ci/apps/cryptpad/)

## Limitations

* Installation possible only on a domain root (Cryptpad limitation)
* Can't login via SSO (due to this [Cryptpad limitation](https://github.com/xwiki-labs/cryptpad/issues/116))

## Informations additionnelles

* To increase space for user in cryptpad, you can set up it in the config.js file in the root folder (/var/www/cryptpad/config.js), and then restart the cryptpad service (`sudo service cryptpad restart`).

## Liens

* Signaler un bug : https://github.com/YunoHost-Apps/cryptpad_ynh/issues
* Site de l'application : https://cryptpad.fr/
* Dépôt de l'application principale : https://github.com/xwiki-labs/cryptpad
* Site web YunoHost: https://yunohost.org/

---

Informations pour les développeurs
----------------

Merci de faire vos pull request sur la [branche testing](https://github.com/YunoHost-Apps/cryptpad_ynh/tree/testing).

Pour essayer la branche testing, procédez comme suit.
```
sudo yunohost app install https://github.com/YunoHost-Apps/cryptpad_ynh/tree/testing --debug
ou
sudo yunohost app upgrade cryptpad -u https://github.com/YunoHost-Apps/cryptpad_ynh/tree/testing --debug
```
