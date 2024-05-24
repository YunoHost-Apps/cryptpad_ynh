<!--
Nota bene : ce README est automatiquement généré par <https://github.com/YunoHost/apps/tree/master/tools/readme_generator>
Il NE doit PAS être modifié à la main.
-->

# CryptPad pour YunoHost

[![Niveau d’intégration](https://dash.yunohost.org/integration/cryptpad.svg)](https://dash.yunohost.org/appci/app/cryptpad) ![Statut du fonctionnement](https://ci-apps.yunohost.org/ci/badges/cryptpad.status.svg) ![Statut de maintenance](https://ci-apps.yunohost.org/ci/badges/cryptpad.maintain.svg)

[![Installer CryptPad avec YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=cryptpad)

*[Lire le README dans d'autres langues.](./ALL_README.md)*

> *Ce package vous permet d’installer CryptPad rapidement et simplement sur un serveur YunoHost.*  
> *Si vous n’avez pas YunoHost, consultez [ce guide](https://yunohost.org/install) pour savoir comment l’installer et en profiter.*

## Vue d’ensemble

CryptPad est une suite de collaboration chiffrée de bout en bout et open source. Il est conçu pour permettre la collaboration, en synchronisant les modifications apportées aux documents en temps réel. Étant donné que toutes les données sont chiffrées, le service et ses administrateurs n'ont aucun moyen de voir le contenu modifié et stocké. 

**Version incluse :** 2024.3.1~ynh1

**Démo :** <https://cryptpad.fr/>

## Captures d’écran

![Capture d’écran de CryptPad](./doc/screenshots/screenshot.png)

## Documentations et ressources

- Site officiel de l’app : <https://cryptpad.fr/>
- Documentation officielle de l’admin : <https://docs.cryptpad.fr/en/>
- Dépôt de code officiel de l’app : <https://github.com/cryptpad/cryptpad>
- YunoHost Store : <https://apps.yunohost.org/app/cryptpad>
- Signaler un bug : <https://github.com/YunoHost-Apps/cryptpad_ynh/issues>

## Informations pour les développeurs

Merci de faire vos pull request sur la [branche `testing`](https://github.com/YunoHost-Apps/cryptpad_ynh/tree/testing).

Pour essayer la branche `testing`, procédez comme suit :

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/cryptpad_ynh/tree/testing --debug
ou
sudo yunohost app upgrade cryptpad -u https://github.com/YunoHost-Apps/cryptpad_ynh/tree/testing --debug
```

**Plus d’infos sur le packaging d’applications :** <https://yunohost.org/packaging_apps>
