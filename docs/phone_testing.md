# Run Munchies Fall on your Android phone

## Which app should I use?

Use **Godot** to open the project, check for GDScript errors, export the Android APK, and send it to your phone. VS Code is optional and is only for editing files; it does not export or install the game by itself.

Open this project in Godot by opening:

```text
C:\Users\Administrator\Documents\munchiesfall\project.godot
```

Use the Godot 4.7 editor for this project. Wait for the project scan/import to finish, then check the Output panel for script or missing-file errors before exporting.

## Recommended: deploy from Godot

1. On the phone, enable **Developer options** and **USB debugging**. Connect it to the computer with a data-capable USB cable and accept the phone's USB debugging prompt.
2. In Godot, open **Project > Export** and choose the existing **munchiesfall (Android)** preset. Its Runnable preset is already selected in this project.
3. If Godot reports Android setup is missing, install the Android export templates from **Editor > Manage Export Templates**. In **Editor > Editor Settings > Export > Android**, set the Android SDK path and Java SDK path. Godot's Android export instructions recommend JDK 17 and an Android SDK folder containing `platform-tools/adb`.
4. Close the Export window. With the phone connected, use Godot's **one-click deploy** button beside Play. Godot will export a debug build, install it, and launch it on the phone.

If Godot does not show the device, check the device connection with the manual steps below. The Godot editor and the terminal should use the same Android SDK installation.

## Manual install and launch with ADB

The project's Android export preset writes the APK to `./munchiesfall.apk`, relative to the project folder. The correct full path is:

```text
C:\Users\Administrator\Documents\munchiesfall\munchiesfall.apk
```

It is **not** `C:\Users\Administrator\Documents\munchiesfall.apk` (that file does not exist).

First export a fresh APK from Godot: this folder's existing APK may be from an earlier build. Then open PowerShell and run:

```powershell
$adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
$apk = "C:\Users\Administrator\Documents\munchiesfall\munchiesfall.apk"
Test-Path $apk
& $adb devices -l
& $adb install -r $apk
& $adb shell monkey -p com.example.munchiesfall 1
```

`Test-Path` should print `True`. In the device list, the phone should end with the state `device` (not `unauthorized` or `offline`). The `-r` option reinstalls the app while retaining its app data when Android accepts the update signature.

The launch command is `monkey`, spelled M-O-N-K-E-Y. `money` is not an ADB command. You can also tap the installed **Munchies Fall** icon on your phone after installing.

## Details already checked for this project

- Android package ID: `com.example.munchiesfall`
- Export preset: Android, marked Runnable
- Export path: `munchiesfall.apk` in the project root
- Phone detected by ADB: yes
- Phone CPU ABI: `arm64-v8a`, supported by the current Android preset
- The package is already installed on the connected phone.

## If something still fails

- **`adb: failed to stat ...` / “No such file or directory”:** export first and check `Test-Path $apk`. Confirm the path includes `\munchiesfall\munchiesfall.apk`.
- **No device listed:** unlock the phone, reconnect the cable, accept the USB debugging prompt, then run `& $adb devices -l` again. If it says `unauthorized`, revoke USB debugging authorizations in Android Developer options, reconnect, and accept the prompt again.
- **`INSTALL_FAILED_UPDATE_INCOMPATIBLE`:** Android has an app with this package ID signed by a different key. Uninstalling it will delete its local saved data. Only if that is okay, run `& $adb uninstall com.example.munchiesfall`, then retry `& $adb install $apk`.
- **App installs but closes immediately:** launch it from PowerShell and read the device log:

  ```powershell
  & $adb shell monkey -p com.example.munchiesfall 1
  & $adb logcat -d -s godot Godot AndroidRuntime
  ```

  Copy the error output from the Godot editor or logcat when asking for help.

Official references: [Godot Android export](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_android.html), [Godot one-click deploy](https://docs.godotengine.org/en/4.7/tutorials/export/one-click_deploy.html), and [Android Debug Bridge](https://developer.android.com/tools/adb).
