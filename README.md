# CryptPad for YunoHost

[![Integration level](https://dash.yunohost.org/integration/cryptpad.svg)](https://dash.yunohost.org/appci/app/cryptpad) ![](https://ci-apps.yunohost.org/ci/badges/cryptpad.status.svg) ![](https://ci-apps.yunohost.org/ci/badges/cryptpad.maintain.svg)  
[![Install CryptPad with YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=cryptpad)

*[Lire ce readme en français.](./README_fr.md)*

> *This package allows you to install CryptPad quickly and simply on a YunoHost server.  
If you don't have YunoHost, please consult [the guide](https://yunohost.org/#/install) to learn how to install it.*

## Overview
CryptPad is a collaborative encrypted document editor in real time. It is a privacy-friendly alternative to popular office tools and cloud services. All content stored in CryptPad is encrypted before being sent, which means that no one can access your data unless you give them the keys. You can share access to a document simply by sharing the link.

**Shipped version:** 3.24.0

## Screenshots

![](https://github.com/xwiki-labs/cryptpad/raw/master/screenshot.png)

## Demo

* [Official demo](https://cryptpad.fr/)

## Configuration

* How to configure this app: From an admin panel, a plain file with SSH.

## Documentation

* Official documentation: https://cryptpad.fr/what-is-cryptpad.html
* YunoHost documentation: If specific documentation is needed, feel free to contribute.

## YunoHost specific features

#### Multi-user support

* Are LDAP and HTTP auth supported? **No**
* Can the app be used by multiple users? **Yes**

#### Supported architectures

* x86-64 - [![Build Status](https://ci-apps.yunohost.org/ci/logs/cryptpad%20%28Apps%29.svg)](https://ci-apps.yunohost.org/ci/apps/cryptpad/)
* ARMv8-A - [![Build Status](https://ci-apps-arm.yunohost.org/ci/logs/cryptpad%20%28Apps%29.svg)](https://ci-apps-arm.yunohost.org/ci/apps/cryptpad/)

## Limitations

* Installation possible only on a root domain (CryptPad limitation)
* Can't login via SSO (due to this [CryptPad limitation](https://github.com/xwiki-labs/cryptpad/issues/116))

## Additional information

* To increase space for CryptPad users, you can modify `/var/www/cryptpad/config.js`, and restart the CryptPad service with `sudo service cryptpad restart`.

## Links

 * Report a bug: https://github.com/YunoHost-Apps/cryptpad_ynh/issues
 * App website: https://cryptpad.fr/
 * Upstream app repository: https://github.com/xwiki-labs/cryptpad
 * YunoHost website: https://yunohost.org/

---

## Developer info

Please send your pull request to the [testing branch](https://github.com/YunoHost-Apps/cryptpad_ynh/tree/testing).

To try the testing branch, please proceed like that.
```
sudo yunohost app install https://github.com/YunoHost-Apps/cryptpad_ynh/tree/testing --debug
or
sudo yunohost app upgrade cryptpad -u https://github.com/YunoHost-Apps/cryptpad_ynh/tree/testing --debug
```
