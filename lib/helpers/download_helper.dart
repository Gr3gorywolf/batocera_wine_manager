import 'dart:io';
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

  downloadRedist() {}

  Future<bool> downloadProton(String protonDownloadUrl) async {
    try {
      var downloadUrl = path.join(PROTONS_PATH, protonDownloadUrl);
      var res = await Dio().download(protonDownloadUrl, downloadUrl);
      await Process.run('gunzip', [downloadUrl]);
      return true;
    } catch (err) {
      return false;
    }
  }
}
