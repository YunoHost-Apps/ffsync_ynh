# Mozilla’s Sync Server for YunoHost

[![Integration level](https://dash.yunohost.org/integration/ffsync.svg)](https://dash.yunohost.org/appci/app/ffsync) ![](https://ci-apps.yunohost.org/ci/badges/ffsync.status.svg) ![](https://ci-apps.yunohost.org/ci/badges/ffsync.maintain.svg)
[![Install ffsync with YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=ffsync)

*[Lire ce readme en français.](./README_fr.md)*
> *This package allow you to install ffsync quickly and simply on a YunoHost server.
If you don't have YunoHost, please see [here](https://yunohost.org/#/install) to know how to install and enjoy it.*

## Overview

The Sync Server provides a replacement for Firefox’s default server (hosted at Mozilla).

By default, a server set up will defer authentication to the Mozilla-hosted accounts server at [https://accounts.firefox.com](https://accounts.firefox.com). So you will still have to authenticate at Mozilla, but _the storage of your information will be done on your host_.

**Shipped version:** 1.9.1

## Documentation

 * Official documentation: https://mozilla-services.readthedocs.io/en/latest/howtos/run-sync-1.5.html
 * YunoHost documentation: https://yunohost.org/#/app_ffsync

## Configuration

Once installed, reaching `http://domain.tld/path` should show a page explaining how to configure it.

## Links

 * Report a bug about this package: https://github.com/YunoHost-Apps/ffsync_ynh/issues
 * Upstream app repository: https://github.com/mozilla-services/syncserver
 * YunoHost website: https://yunohost.org/

---

## Developers info

Please do your pull request to the [testing branch](https://github.com/YunoHost-Apps/ffsync_ynh/tree/testing).
To try the testing branch, please proceed like that.
```
sudo yunohost app install https://github.com/YunoHost-Apps/ffsync_ynh/tree/testing --debug
or
sudo yunohost app upgrade ffsync -u https://github.com/YunoHost-Apps/ffsync_ynh/tree/testing --debug
```

### Solving problems with Android

The sure-fire way to know what Sync on Android is really doing is to observe the Android device log using adb logcat. You’ll want to bump your log-level:
```
adb shell setprop log.tag.FxAccounts VERBOSE
```

Then, you can observe the log using:
```
adb logcat | grep FxAccounts
```

It’s best to observe the log while you force a sync from the Android Settings App. You should see output like:

```
D FxAccounts(...) fennec :: BaseResource :: HTTP GET https://token.stage.mozaws.net/1.0/sync/1.5
...
D FxAccounts(...) fennec :: BaseResource :: HTTP GET https://sync-4-us-east-1.stage.mozaws.net/
```
