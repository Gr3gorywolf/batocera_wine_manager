import 'dart:io';
import 'package:batocera_wine_manager/constants/urls.dart';
import 'package:batocera_wine_manager/get_controllers/download_controller.dart';
import 'package:batocera_wine_manager/models/download.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:batocera_wine_manager/constants/paths.dart';
import 'package:batocera_wine_manager/helpers/common_helpers.dart';
import 'package:batocera_wine_manager/models/github_release.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DownloadHelper {
  Future<List<GithubRelease>?> fetchProtonReleases() async {
    try {
      var res = await Dio().get(
          "https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases?page=2");
      List<dynamic> resData = res.data;
      return resData.map((release) => GithubRelease.fromJson(release)).toList();
    } catch (err) {
      return null;
    }
  }

  downloadRedist() async {
    DownloadController downloadController = Get.find();
    var downloadUrl = path.join(WINE_PATH, 'exe.bak.tar.gz');
    try {
      var res = await Dio().download(REDIST_DOWNLOAD_LINK, downloadUrl,
          onReceiveProgress: (received, total) async {
        var progress = (received / total * 100);
        downloadController.setDownload(Download(
            fileName: downloadUrl,
            progress: progress,
            key: REDIST_DOWNLOAD_LINK));
      });
      var redistPathDir = Directory(REDIST_PATH_DISABLED);
      if (!redistPathDir.existsSync()) {
        redistPathDir.createSync();
      }
      ProcessResult result = await Process.run('tar', [
        '-xvf',
        downloadUrl,
        '-C',
        REDIST_PATH_DISABLED,
      ]);
      if (result.exitCode == 0) {
        File(downloadUrl).deleteSync();
        var logFile = File('$REDIST_PATH_DISABLED/download-log.txt');
        logFile.writeAsStringSync(REDIST_DOWNLOAD_LINK);
      } else {
        return false;
      }
      return true;
    } catch (err) {
      downloadController.setDownload(Download(
          fileName: downloadUrl, progress: -1, key: REDIST_DOWNLOAD_LINK));
      return false;
    }
  }

  Future<bool> downloadProton(String protonDownloadUrl) async {
    DownloadController downloadController = Get.find();
    var fileName = CommonHelpers.getFileNameFromUrl(protonDownloadUrl);
    var downloadUrl = "$PROTONS_PATH/$fileName";
    try {
      var res = await Dio().download(protonDownloadUrl, downloadUrl,
          onReceiveProgress: (received, total) async {
        var progress = (received / total * 100);
        downloadController.setDownload(Download(
            fileName: downloadUrl, progress: progress, key: protonDownloadUrl));
      });

      ProcessResult result =
          await Process.run('tar', ['-xvf', downloadUrl, '-C', PROTONS_PATH]);
      if (result.exitCode == 0) {
        File(downloadUrl).deleteSync();
        var logFile = File(PROTONS_PATH +
            "/" +
            fileName.replaceAll(".tar.gz", "") +
            '/download-log.txt');
        logFile.writeAsStringSync(protonDownloadUrl);
      } else {
        return false;
      }

      return true;
    } catch (err) {
      downloadController.setDownload(Download(
          fileName: downloadUrl, progress: -1, key: protonDownloadUrl));
      return false;
    }
  }
}
