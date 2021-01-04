# CryptPad pour YunoHost

[![Integration level](https://dash.yunohost.org/integration/cryptpad.svg)](https://dash.yunohost.org/appci/app/cryptpad) ![](https://ci-apps.yunohost.org/ci/badges/cryptpad.status.svg) ![](https://ci-apps.yunohost.org/ci/badges/cryptpad.maintain.svg)  
[![Installer CryptPad avec YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=cryptpad)

*[Read this readme in english.](./README.md)* 

> *Ce package vous permet d'installer CryptPad rapidement et simplement sur un serveur YunoHost.  
Si vous n'avez pas YunoHost, consultez [le guide](https://yunohost.org/#/install) pour apprendre comment l'installer.*

## Vue d'ensemble
CryptPad est un éditeur de documents chiffrés collaboratifs en temps réel. C'est une alternative respectant la vie privée aux outils office et aux services cloud populaires. Tout le contenu stocké dans CryptPad est chiffré avant d'être envoyé, ce qui signifie que personne ne peut accéder à vos données à moins que vous ne leur donniez les clés. Vous pouvez partager l'accès à un document simplement en partageant le lien.

**Version incluse :** 3.24.0

## Captures d'écran

![](https://github.com/xwiki-labs/cryptpad/raw/master/screenshot.png)

## Démo

* [Démo officielle](https://cryptpad.fr/)

## Configuration

Comment configurer cette application : via le panneau d'administration ainsi que le fichier de configuration `/var/www/cryptpad/config.js`.

## Documentation

* Official documentation : https://cryptpad.fr/what-is-cryptpad.html
* YunoHost documentation : If specific documentation is needed, feel free to contribute.

## Caractéristiques spécifiques YunoHost

#### Support multi-utilisateur

* L'authentification LDAP et HTTP est-elle prise en charge ? **Non**
* L'application peut-elle être utilisée par plusieurs utilisateurs ? **Oui**

#### Architectures supportées

* x86-64 - [![Build Status](https://ci-apps.yunohost.org/ci/logs/cryptpad%20%28Apps%29.svg)](https://ci-apps.yunohost.org/ci/apps/cryptpad/)
* ARMv8-A - [![Build Status](https://ci-apps-arm.yunohost.org/ci/logs/cryptpad%20%28Apps%29.svg)](https://ci-apps-arm.yunohost.org/ci/apps/cryptpad/)

## Limitations

* Nécessite un sous-domaine / domaine dédié. (limitation de CryptPad)
* Impossible de se connecter via SSO (cf [limitation de CryptPad](https://github.com/xwiki-labs/cryptpad/issues/116))

## Informations additionnelles

* Pour augmenter l'espace pour l'utilisateur dans le CryptPad, vous pouvez configurer le fichier `config.js` dans le dossier `/var/www/cryptpad/config.js`, puis redémarrez le service CryptPad `sudo service cryptpad restart`.

## Liens

* Signaler un bug : https://github.com/YunoHost-Apps/cryptpad_ynh/issues
* Site de l'application : https://cryptpad.fr/
* Dépôt de l'application principale : https://github.com/xwiki-labs/cryptpad
* Site web YunoHost : https://yunohost.org/

---

## Informations pour les développeurs

Merci de faire vos pull request sur la [branche testing](https://github.com/YunoHost-Apps/cryptpad_ynh/tree/testing).

Pour essayer la branche testing, procédez comme suit.
```
sudo yunohost app install https://github.com/YunoHost-Apps/cryptpad_ynh/tree/testing --debug
ou
sudo yunohost app upgrade cryptpad -u https://github.com/YunoHost-Apps/cryptpad_ynh/tree/testing --debug
```
