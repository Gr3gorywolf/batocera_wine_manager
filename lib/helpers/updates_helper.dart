import 'dart:io';

import 'package:batocera_wine_manager/models/github_release.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class UpdatesHelper {
  /// Fetches a new release, if its the current built release it will return null
  Future<GithubRelease?> fetchNewRelease() async {
    try {
      var res = await Dio().get(
          "https://api.github.com/repos/Gr3gorywolf/batocera_wine_manager/releases");
      var data = GithubRelease.fromJson(res.data.first);
      var currentRelease = await rootBundle.loadString(
        "assets/data/release-number.txt",
      );
      print(currentRelease);
      print(data.name);
      if (!currentRelease.toString().contains(data.name ?? '')) {
        return data;
      }
      return null;
    } catch (err) {
      print(err);
    }
    return null;
  }

  updateApp() {
    Directory("/userdata/system/temp").createSync(recursive: true);
    File("/userdata/system/wine_manager/update.sh")
        .copySync("/userdata/system/temp/update.sh");
    Process.start('xterm', ['-e', "bash /userdata/system/temp/update.sh"])
        .then((val) {
      exit(0);
    });
  }
}
