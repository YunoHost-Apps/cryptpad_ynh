<!--
注意：此 README 由 <https://github.com/YunoHost/apps/tree/master/tools/readme_generator> 自动生成
请勿手动编辑。
-->

# YunoHost 上的 CryptPad

[![集成程度](https://dash.yunohost.org/integration/cryptpad.svg)](https://ci-apps.yunohost.org/ci/apps/cryptpad/) ![工作状态](https://ci-apps.yunohost.org/ci/badges/cryptpad.status.svg) ![维护状态](https://ci-apps.yunohost.org/ci/badges/cryptpad.maintain.svg)

[![使用 YunoHost 安装 CryptPad](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=cryptpad)

*[阅读此 README 的其它语言版本。](./ALL_README.md)*

> *通过此软件包，您可以在 YunoHost 服务器上快速、简单地安装 CryptPad。*  
> *如果您还没有 YunoHost，请参阅[指南](https://yunohost.org/install)了解如何安装它。*

## 概况

CryptPad is a collaboration suite that is end-to-end-encrypted and open-source. It is built to enable collaboration, synchronizing changes to documents in real time. Because all data is encrypted, the service and its administrators have no way of seeing the content being edited and stored.

**分发版本：** 2024.9.1~ynh1

**演示：** <https://cryptpad.fr/>

## 截图

![CryptPad 的截图](./doc/screenshots/screenshot.png)

## 文档与资源

- 官方应用网站： <https://cryptpad.fr/>
- 官方管理文档： <https://docs.cryptpad.fr/en/>
- 上游应用代码库： <https://github.com/xwiki-labs/cryptpad>
- YunoHost 商店： <https://apps.yunohost.org/app/cryptpad>
- 报告 bug： <https://github.com/YunoHost-Apps/cryptpad_ynh/issues>

## 开发者信息

请向 [`testing` 分支](https://github.com/YunoHost-Apps/cryptpad_ynh/tree/testing) 发送拉取请求。

如要尝试 `testing` 分支，请这样操作：

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/cryptpad_ynh/tree/testing --debug
或
sudo yunohost app upgrade cryptpad -u https://github.com/YunoHost-Apps/cryptpad_ynh/tree/testing --debug
```

**有关应用打包的更多信息：** <https://yunohost.org/packaging_apps>
