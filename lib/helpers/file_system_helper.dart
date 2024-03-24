import 'dart:io';

import 'package:batocera_wine_manager/get_controllers/download_controller.dart';
import 'package:batocera_wine_manager/models/download.dart';
import 'package:get/get.dart';

import '../constants/paths.dart';

class FileSystemHelper {
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
    var requiredDirectories = [WINE_PATH, REDIST_PATH_DISABLED, PROTONS_PATH];
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
              fileName: fsEntity.path, progress: 100, key: downloadUrl));
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
            fileName: redistDir.path, progress: 100, key: downloadUrl));
      }
    }
  }
}
