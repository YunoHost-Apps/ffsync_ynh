# Mozilla’s Sync Server for Yunohost

[![Integration level](https://dash.yunohost.org/integration/ffsync.svg)](https://dash.yunohost.org/appci/app/ffsync)  
[![Install ffsync with YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=ffsync)

> *This package allow you to install ffsync quickly and simply on a YunoHost server.  
If you don't have YunoHost, please see [here](https://yunohost.org/#/install) to know how to install and enjoy it.*

## Overview

The Sync Server provides a replacement for Firefox’s default server (hosted at Mozilla).

By default, a server set up will defer authentication to the Mozilla-hosted accounts server at [https://accounts.firefox.com](https://accounts.firefox.com). So you will still have to authenticate at Mozilla, but _the storage of your information will be done on your host_.

**Shipped version:** 1.8

## Configuration

Once installed, reaching `http://domain.tld/path` should show a page explaining how to configure it. Otherwise please refer to the [Yunohost page](https://yunohost.org/#/app_ffsync).

## Documentation

 * Official documentation:  https://docs.services.mozilla.com/howtos/run-sync-1.5.html
 * YunoHost documentation: There no other documentations, feel free to contribute.

## YunoHost specific features

#### Supported architectures

* x86-64b - [![Build Status](https://ci-apps.yunohost.org/ci/logs/ffsync%20%28Apps%29.svg)](https://ci-apps.yunohost.org/ci/apps/ffsync/)
* ARMv8-A - [![Build Status](https://ci-apps-arm.yunohost.org/ci/logs/ffsync%20%28Apps%29.svg)](https://ci-apps-arm.yunohost.org/ci/apps/ffsync/)

## Links

 * Report a bug about this package: https://github.com/YunoHost-Apps/ffsync_ynh/issues
 * Upstream app repository: https://github.com/mozilla-services/syncserver
 * YunoHost website: https://yunohost.org/

---

Developers info
----------------

Please do your pull request to the [testing branch](https://github.com/YunoHost-Apps/ffsync_ynh/tree/testing).

To try the testing branch, please proceed like that.
```
sudo yunohost app install https://github.com/YunoHost-Apps/ffsync_ynh/tree/testing --debug
or
sudo yunohost app upgrade ffsync -u https://github.com/YunoHost-Apps/ffsync_ynh/tree/testing --debug
```
