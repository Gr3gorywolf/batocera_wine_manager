import 'dart:io';

import 'package:batocera_wine_manager/constants/urls.dart';
import 'package:batocera_wine_manager/get_controllers/download_controller.dart';
import 'package:batocera_wine_manager/helpers/common_helpers.dart';
import 'package:batocera_wine_manager/models/download.dart';
import 'package:get/get.dart';

import '../constants/paths.dart';

class FileSystemHelper {
  static get wineOverrideFilePath {
    return '$WINE_PATH/_wine-override';
  }

  static String wineProtonFolderName = "ge-custom";
  static String get protonOverridePath {
    return "$WINE_PATH/$wineProtonFolderName";
  }

  static Directory? get redistDirectory {
    var redistDirectories = [
      Directory(REDIST_PATH),
      Directory(REDIST_PATH_DISABLED)
    ];

    for (var path in redistDirectories) {
      if (path.existsSync()) {
        return path;
      }
    }
    return null;
  }

  static init() async {
    DownloadController downloadController = Get.find();
    var requiredDirectories = [WINE_PATH, PROTONS_PATH];
    var oldProtonsDir = Directory(OLD_PROTONS_PATH);
    //Sets the old proton folder for batocera version < 39
    if (Directory('/usr/wine/proton').existsSync()) {
      wineProtonFolderName = 'proton';
    }
    //Uses new custom runner feature for batocera >= v40
    if (oldProtonsDir.existsSync()) {
      var overrunWine = await getWineOverrideName();
      await disableWineOverride();
      await oldProtonsDir.rename(PROTONS_PATH);
      List<FileSystemEntity> contents = Directory(PROTONS_PATH).listSync();
      for (FileSystemEntity entity in contents) {
        if (entity is Directory) {
          await FileSystemHelper.patchProtonDownload(entity.path);
        }
      }
      if (overrunWine != null) {
        overrunWine = overrunWine.replaceAll(OLD_PROTONS_PATH, PROTONS_PATH);
        await overrideWineVersion(overrunWine);
      }
    }
    for (var path in requiredDirectories) {
      var currentDirectory = Directory(path);
      if (!currentDirectory.existsSync()) {
        await currentDirectory.create(recursive: true);
      }
    }

    //sets the proper permissions
    try {
      var res = await Process.run("chmod", ["777", WINE_PATH]);
    } catch (err) {}

    //Check for the downloaded protons
    var protonsDirectory = Directory(PROTONS_PATH);
    var files = await protonsDirectory.list().toList();
    for (var fsEntity in files) {
      if (fsEntity is Directory) {
        File logFile = File('${fsEntity.path}/download-log.txt');
        if (logFile.existsSync()) {
          var downloadUrl = logFile.readAsStringSync();
          downloadController.setDownload(Download(
              filePath: fsEntity.path,
              progress: 0,
              url: downloadUrl,
              status: DownloadStatus.downloaded));
        }
      }
    }

    //Check for the downloaded redist
    var redistDir = FileSystemHelper.redistDirectory;
    if (redistDir != null) {
      File logFile = File('${redistDir.path}/download-log.txt');
      if (logFile.existsSync()) {
        downloadController.setDownload(Download(
            filePath: redistDir.path,
            progress: 0,
            url: REDIST_DOWNLOAD_LINK,
            status: DownloadStatus.downloaded));
      }
    }
  }

  static bool? getRedistInstallActive() {
    var activeRedistDir = Directory(REDIST_PATH);
    var unactiveRedistDir = Directory(REDIST_PATH_DISABLED);
    var isActive = activeRedistDir.existsSync();
    if (!isActive && !unactiveRedistDir.existsSync()) {
      return null;
    }
    return isActive;
  }

  static Future<String?> getWineOverrideName() async {
    var regFile = File(wineOverrideFilePath);
    if (regFile.existsSync()) {
      return await regFile.readAsString();
    }
    return null;
  }

  static Future<bool> toggleRedist(bool enable) async {
    var disabledDirectory = Directory(REDIST_PATH_DISABLED);
    var enabledDirectory = Directory(REDIST_PATH);
    if (enable && disabledDirectory.existsSync()) {
      await disabledDirectory.rename(REDIST_PATH);
    }
    if (!enable && enabledDirectory.existsSync()) {
      await enabledDirectory.rename(REDIST_PATH_DISABLED);
    }
    return enable;
  }

  static bool fastRedistInstallEnabled() {
    var redistDir = FileSystemHelper.redistDirectory;
    if (redistDir != null) {
      return File("${redistDir.path}/STEAMY-AiO.exe.bak").existsSync();
    }
    return false;
  }

  static Future<bool> toggleFastRedistInstall(bool enable) async {
    var redistDir = FileSystemHelper.redistDirectory;
    if (redistDir == null) {
      return false;
    }
    var fastRedistEnabled = FileSystemHelper.fastRedistInstallEnabled();
    if (enable && !fastRedistEnabled) {
      await File("${redistDir.path}/STEAMY-AiO.exe")
          .rename("${redistDir.path}/STEAMY-AiO.exe.bak");
    }
    if (!enable && fastRedistEnabled) {
      await File("${redistDir.path}/STEAMY-AiO.exe.bak")
          .rename("${redistDir.path}/STEAMY-AiO.exe");
    }
    return enable;
  }

  static disableWineOverride() async {
    var protonOverrideDir = Directory(protonOverridePath);
    var protonLink = Link(protonOverridePath);
    if (protonLink.existsSync()) {
      await protonLink.delete();
    } else if (protonOverrideDir.existsSync()) {
      await protonOverrideDir.delete(recursive: true);
    }
    var regFile = File(wineOverrideFilePath);
    if (regFile.existsSync()) {
      regFile.deleteSync();
    }
  }

  static Future<bool> deleteProton(String wineFile) async {
    try {
      var protonDir = Directory(wineFile);
      await protonDir.delete(recursive: true);
      var regFile = File(wineOverrideFilePath);
      if (regFile.existsSync()) {
        if (regFile.readAsStringSync() == wineFile) {
          await disableWineOverride();
        }
      }
      return true;
    } catch (err) {
      return false;
    }
  }

  static Future<bool> overrideWineVersion(String wineFile) async {
    try {
      await disableWineOverride();
      await Link(protonOverridePath).create("$wineFile");
      var regFile = File(wineOverrideFilePath);
      regFile.writeAsString(wineFile);
      return true;
    } catch (err) {
      return false;
    }
  }

  // Moves the proton files contents to the proton folder allowing it to be used by v40 runners
  static Future<void> patchProtonDownload(String protonFolder) async {
    String parentDirectoryPath = protonFolder;
    String fileDirectoryPath = "$protonFolder/files";
    Directory fileDirectory = Directory(fileDirectoryPath);
    if (fileDirectory.existsSync()) {
      List<FileSystemEntity> contents = fileDirectory.listSync();
      for (FileSystemEntity entity in contents) {
        if (entity is Directory) {
          String newDirectoryPath =
              '$parentDirectoryPath/${entity.path.split('/').last}';
          await entity.rename(newDirectoryPath);
        }
      }
    }
  }
}
