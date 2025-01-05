<!--
Ohart ongi: README hau automatikoki sortu da <https://github.com/YunoHost/apps/tree/master/tools/readme_generator>ri esker
EZ editatu eskuz.
-->

# CryptPad YunoHost-erako

[![Integrazio maila](https://apps.yunohost.org/badge/integration/cryptpad)](https://ci-apps.yunohost.org/ci/apps/cryptpad/)
![Funtzionamendu egoera](https://apps.yunohost.org/badge/state/cryptpad)
![Mantentze egoera](https://apps.yunohost.org/badge/maintained/cryptpad)

[![Instalatu CryptPad YunoHost-ekin](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=cryptpad)

*[Irakurri README hau beste hizkuntzatan.](./ALL_README.md)*

> *Pakete honek CryptPad YunoHost zerbitzari batean azkar eta zailtasunik gabe instalatzea ahalbidetzen dizu.*  
> *YunoHost ez baduzu, kontsultatu [gida](https://yunohost.org/install) nola instalatu ikasteko.*

## Aurreikuspena

CryptPad is a collaboration suite that is end-to-end-encrypted and open-source. It is built to enable collaboration, synchronizing changes to documents in real time. Because all data is encrypted, the service and its administrators have no way of seeing the content being edited and stored.

**Paketatutako bertsioa:** 2024.12.0~ynh2

**Demoa:** <https://cryptpad.fr/>

## Pantaila-argazkiak

![CryptPad(r)en pantaila-argazkia](./doc/screenshots/screenshot.png)

## Dokumentazioa eta baliabideak

- Aplikazioaren webgune ofiziala: <https://cryptpad.fr/>
- Administratzaileen dokumentazio ofiziala: <https://docs.cryptpad.fr/en/>
- Jatorrizko aplikazioaren kode-gordailua: <https://github.com/cryptpad/cryptpad>
- YunoHost Denda: <https://apps.yunohost.org/app/cryptpad>
- Eman errore baten berri: <https://github.com/YunoHost-Apps/cryptpad_ynh/issues>

## Garatzaileentzako informazioa

Bidali `pull request`a [`testing` abarrera](https://github.com/YunoHost-Apps/cryptpad_ynh/tree/testing).

`testing` abarra probatzeko, ondorengoa egin:

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/cryptpad_ynh/tree/testing --debug
edo
sudo yunohost app upgrade cryptpad -u https://github.com/YunoHost-Apps/cryptpad_ynh/tree/testing --debug
```

**Informazio gehiago aplikazioaren paketatzeari buruz:** <https://yunohost.org/packaging_apps>
