<!--
N.B.: README ini dibuat secara otomatis oleh <https://github.com/YunoHost/apps/tree/master/tools/readme_generator>
Ini TIDAK boleh diedit dengan tangan.
-->

# CryptPad untuk YunoHost

[![Tingkat integrasi](https://apps.yunohost.org/badge/integration/cryptpad)](https://ci-apps.yunohost.org/ci/apps/cryptpad/)
![Status kerja](https://apps.yunohost.org/badge/state/cryptpad)
![Status pemeliharaan](https://apps.yunohost.org/badge/maintained/cryptpad)

[![Pasang CryptPad dengan YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=cryptpad)

*[Baca README ini dengan bahasa yang lain.](./ALL_README.md)*

> *Paket ini memperbolehkan Anda untuk memasang CryptPad secara cepat dan mudah pada server YunoHost.*  
> *Bila Anda tidak mempunyai YunoHost, silakan berkonsultasi dengan [panduan](https://yunohost.org/install) untuk mempelajari bagaimana untuk memasangnya.*

## Ringkasan

CryptPad is a collaboration suite that is end-to-end-encrypted and open-source. It is built to enable collaboration, synchronizing changes to documents in real time. Because all data is encrypted, the service and its administrators have no way of seeing the content being edited and stored.

**Versi terkirim:** 2024.12.0~ynh4

**Demo:** <https://cryptpad.fr/>

## Tangkapan Layar

![Tangkapan Layar pada CryptPad](./doc/screenshots/screenshot.png)

## Dokumentasi dan sumber daya

- Website aplikasi resmi: <https://cryptpad.fr/>
- Dokumentasi admin resmi: <https://docs.cryptpad.fr/en/>
- Depot kode aplikasi hulu: <https://github.com/cryptpad/cryptpad>
- Gudang YunoHost: <https://apps.yunohost.org/app/cryptpad>
- Laporkan bug: <https://github.com/YunoHost-Apps/cryptpad_ynh/issues>

## Info developer

Silakan kirim pull request ke [`testing` branch](https://github.com/YunoHost-Apps/cryptpad_ynh/tree/testing).

Untuk mencoba branch `testing`, silakan dilanjutkan seperti:

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/cryptpad_ynh/tree/testing --debug
atau
sudo yunohost app upgrade cryptpad -u https://github.com/YunoHost-Apps/cryptpad_ynh/tree/testing --debug
```

**Info lebih lanjut mengenai pemaketan aplikasi:** <https://yunohost.org/packaging_apps>
