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

  Future<bool> _downloadAndUncompress(
      {required String url,
      required String fileUrl,
      required String logFileUrl,
      String? folderToUncompress,
      bool createOutputFolder = false}) async {
    DownloadController downloadController = Get.find();
    var outputFolder = folderToUncompress ?? fileUrl;
    downloadController.setDownload(Download(
        fileName: fileUrl, url: url, status: DownloadStatus.downloading));
    try {
      var res = await Dio().download(url, fileUrl,
          onReceiveProgress: (received, total) async {
        var progress = (received / total * 100);
        downloadController.setDownloadStatus(url, DownloadStatus.downloading,
            progress: progress);
      });
      downloadController.setDownloadStatus(url, DownloadStatus.uncompressing);
      if (createOutputFolder) {
        var outputFolderDir = Directory(outputFolder);
        if (!outputFolderDir.existsSync()) {
          outputFolderDir.createSync();
        }
      }
      ProcessResult result = await Process.run('tar', [
        '-xvf',
        fileUrl,
        '-C',
        outputFolder,
      ]);
      if (true) {
        File(fileUrl).deleteSync();
        var logFile = File(logFileUrl);
        logFile.writeAsStringSync(url);
        downloadController.setDownload(Download(
            fileName: path.dirname(logFileUrl),
            url: url,
            status: DownloadStatus.downloading));
      } else {
        print("Failed to uncompress");
        print(result.stdout);
        print(fileUrl);
        print(outputFolder);
        downloadController.setDownloadStatus(url, DownloadStatus.none);
        return false;
      }
      return true;
    } catch (err) {
      print(err);
      downloadController.setDownloadStatus(url, DownloadStatus.none);
      return false;
    }
  }

  downloadRedist() async {
    DownloadController downloadController = Get.find();
    var fileUrl = path.join(WINE_PATH, 'exe.bak.tar.gz');
    return await _downloadAndUncompress(
        fileUrl: fileUrl,
        url: REDIST_DOWNLOAD_LINK,
        createOutputFolder: true,
        folderToUncompress: REDIST_PATH_DISABLED,
        logFileUrl: '$REDIST_PATH_DISABLED/download-log.txt');
  }

  Future<bool> downloadProton(String protonDownloadUrl) async {
    DownloadController downloadController = Get.find();
    var fileName = CommonHelpers.getFileNameFromUrl(protonDownloadUrl);
    var fileUrl = "$PROTONS_PATH/$fileName";
    var uncompressFolder =
        PROTONS_PATH + "/" + fileName.replaceAll(".tar.gz", "");
    var logFile = '$uncompressFolder/download-log.txt';
    return await _downloadAndUncompress(
        url: protonDownloadUrl,
        fileUrl: fileUrl,
        logFileUrl: logFile,
        folderToUncompress: PROTONS_PATH);
  }
}
