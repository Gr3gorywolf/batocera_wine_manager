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
  static List<GithubRelease> _catchedReleases = [];
  Future<List<GithubRelease>?> fetchProtonReleases(
      {int maxPages = 4,
      int page = 1,
      List<GithubRelease>? initialReleases}) async {
    if (DownloadHelper._catchedReleases.isNotEmpty) {
      return DownloadHelper._catchedReleases;
    }
    try {
      var res = await Dio().get(
          "https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases?page=$page");
      List<dynamic> resData = res.data;
      var releases =
          resData.map((release) => GithubRelease.fromJson(release)).toList();
      if (initialReleases != null) {
        releases = [
          ...initialReleases,
          ...releases,
        ];
      }
      if (page < maxPages) {
        return await fetchProtonReleases(
            maxPages: maxPages, initialReleases: releases, page: page + 1);
      }
      DownloadHelper._catchedReleases = releases;
      return releases;
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
        filePath: fileUrl, url: url, status: DownloadStatus.downloading));
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
            filePath: path.dirname(logFileUrl),
            url: url,
            status: DownloadStatus.downloaded));
      }
      return true;
    } catch (err) {
      print(err);
      downloadController.setDownloadStatus(url, DownloadStatus.none);
      return false;
    }
  }

  Future<bool> downloadRedist() async {
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
