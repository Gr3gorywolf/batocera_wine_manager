import 'dart:io';

import 'package:batocera_wine_manager/get_controllers/download_controller.dart';
import 'package:batocera_wine_manager/helpers/common_helpers.dart';
import 'package:batocera_wine_manager/models/download.dart';
import 'package:get/get.dart';

import '../constants/paths.dart';

class FileSystemHelper {
  static get wineOverrideFilePath {
    return '$WINE_PATH/_wine-override';
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
    for (var path in requiredDirectories) {
      var currentDirectory = Directory(path);
      if (!currentDirectory.existsSync()) {
        await currentDirectory.create(recursive: true);
      }
    }

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
      var files = await redistDir.list().toList();
      File logFile = File('${redistDir.path}/download-log.txt');
      if (logFile.existsSync()) {
        var downloadUrl = logFile.readAsStringSync();
        downloadController.setDownload(Download(
            filePath: redistDir.path,
            progress: 0,
            url: downloadUrl,
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
    try {
      if (enable && disabledDirectory.existsSync()) {
        await disabledDirectory.rename(REDIST_PATH);
      }
      if (!enable && enabledDirectory.existsSync()) {
        await enabledDirectory.rename(REDIST_PATH_DISABLED);
      }
      return enable;
    } catch (err) {
      return false;
    }
  }

  static disableWineOverride() async {
    var protonOverridePath = Directory(PROTON_OVERRIDE_PATH);
    if (protonOverridePath.existsSync()) {
      await protonOverridePath.delete(recursive: true);
      var regFile = File(wineOverrideFilePath);
      if (regFile.existsSync()) {
        regFile.deleteSync();
      }
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
      await CommonHelpers.copyDirectory(
          "$wineFile/files", PROTON_OVERRIDE_PATH);
      var regFile = File(wineOverrideFilePath);
      regFile.writeAsString(wineFile);
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }
}
