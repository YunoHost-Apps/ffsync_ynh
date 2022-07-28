## Configuration

Once installed, reaching `http://domain.tld/path` should show a page explaining how to configure it.

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
