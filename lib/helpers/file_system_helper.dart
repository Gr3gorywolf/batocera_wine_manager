import 'dart:io';

import '../constants/paths.dart';

class FileSystemHelper {
  static init() async {
    var requiredDirectories = [
      WINE_PATH,
      REDIST_PATHS,
      PROTON_OVERRIDE_PATH,
      PROTONS_PATH
    ];
    for (var path in requiredDirectories) {
      var currentDirectory = Directory(path);
      if (currentDirectory.existsSync()) {
        await currentDirectory.create(recursive: true);
      }
    }
  }
}
