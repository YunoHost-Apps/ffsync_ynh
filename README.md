Mozilla’s Sync Server for Yunohost
==================================

[![Integration level](https://dash.yunohost.org/integration/ffsync.svg)](https://ci-apps.yunohost.org/ci/apps/ffsync%20%28Community%29/lastBuild/consoleFull)  
[![Install ffsync with YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=ffsync)

> *This package allow you to install ffsync quickly and simply on a YunoHost server.  
If you don't have YunoHost, please see [here](https://yunohost.org/#/install) to know how to install and enjoy it.*

Overview
--------

The Sync Server provides a replacement for Firefox’s default server (hosted at Mozilla).

By default, a server set up will defer authentication to the Mozilla-hosted accounts server at [https://accounts.firefox.com](https://accounts.firefox.com). So you will still have to authenticate at Mozilla, but _the storage of your information will be done on your host_.

**Shipped version:** 1.8

Documentation
-------------

 * Official documentation:  https://docs.services.mozilla.com/howtos/run-sync-1.5.html
 * YunoHost documentation: There no other documentations, feel free to contribute.

YunoHost specific features
--------------------------

<!--Limitations
-----------

* Any known limitations.-->

Additional informations
-----------------------

### Configuring

Once installed, reaching `http://domain.tld/path` should show a page explaining how to configure it. Otherwise please refer to the [Yunohost page](https://yunohost.org/#/app_ffsync).

## Links

 * Report a bug about this package: https://github.com/YunoHost-Apps/ffsync_ynh/issues
 * Report a bug about firefox sync itself: https://github.com/mozilla-services/syncserver
 * YunoHost website: https://yunohost.org/

---

Install
-------

From command line:

`sudo yunohost app install -l ffsync https://github.com/YunoHost-Apps/ffsync_ynh`

Upgrade
-------

From command line:

`sudo yunohost app upgrade ffsync -u https://github.com/YunoHost-Apps/ffsync_ynh`

Developers infos
----------------

Please do your pull request to the [testing branch](https://github.com/YunoHost-Apps/ffsync_ynh/tree/testing).

To try the testing branch, please proceed like that.
```
sudo yunohost app install https://github.com/YunoHost-Apps/ffsync_ynh/tree/testing --debug
or
sudo yunohost app upgrade ffsync -u https://github.com/YunoHost-Apps/ffsync_ynh/tree/testing --debug
```

License
-------

ffsync is published under the Mozilla Public License Version 2.0

TODO
----
