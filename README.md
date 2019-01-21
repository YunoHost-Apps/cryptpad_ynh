Cryptad for Yunohost
------------------------

[![Integration level](https://dash.yunohost.org/integration/cryptpad.svg)](https://dash.yunohost.org/appci/app/cryptpad)  
[![Install Cryptad with YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=cryptpad)

**Shipped version:** 2.13.0

## Demo
https://cryptpad.fr/

## Known limitations / Limitations connues
- Installation possible only on a domain root (Cryptpad limitation)
- Can't login via SSO (due to this [Cryptpad limitation](https://github.com/xwiki-labs/cryptpad/issues/116))


## Links / Liens
- Package URL/URL du Paquet: https://github.com/YunoHost-Apps/cryptpad_ynh
- Official Website/Site Officiel: https://cryptpad.fr/
- Github: https://github.com/xwiki-labs/cryptpad
- Package status:  
  - [Last weekly report](https://forum.yunohost.org/t/rapport-hebdomadaire-dintegration-continue/2297)
  - [Last continuous integration test](https://ci-apps.yunohost.org/jenkins/job/cryptpad%20%28Community%29/lastBuild/consoleFull)


## Tricks :

- To increase space for user in cryptpad, you can set up it in the config.js file in the root folder (/var/www/cryptpad/config.js), and then restart the cryptpad service (`sudo service cryptpad restart`).
