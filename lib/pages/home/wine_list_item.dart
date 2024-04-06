import 'package:batocera_wine_manager/models/download.dart';
import 'package:batocera_wine_manager/models/github_release.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../get_controllers/download_controller.dart';
import '../../helpers/common_helpers.dart';
import '../../helpers/download_helper.dart';
import '../../widget/DownloadIconButton.dart';

class WineListItem extends StatelessWidget {
  bool isActive;
  Function(Download) toggleActive;
  Function(Download) onRemove;
  GithubRelease protonRelease;
  DownloadController downloadController = Get.find();
  WineListItem(
      {required this.isActive,
      required this.toggleActive,
      required this.onRemove,
      required this.protonRelease,
      super.key});
  GithubReleaseAsset? get releaseDownloadAsset {
    var releaseAssets = protonRelease.assets;
    if (releaseAssets != null && releaseAssets.isNotEmpty) {
      return protonRelease.assets?.last;
    }
    return null;
  }

  String? get fileSize {
    return CommonHelpers.formatBytes(releaseDownloadAsset?.size ?? 0, 1);
  }

  String? getfileStatus(Download? download) {
    if (download != null) {
      switch (download.status) {
        case DownloadStatus.downloading:
          return "Downloading: ${download.progress.round()}%";
        case DownloadStatus.downloaded:
          return "Installed";
        case DownloadStatus.uncompressing:
          return "Uncompressing";
        case DownloadStatus.none:
          break;
      }
    }
    return 'Not installed';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var currentDownload = downloadController
          .downloads[releaseDownloadAsset?.browserDownloadUrl ?? ''];
      var fileStatus = getfileStatus(currentDownload);
      return Column(
        children: [
          ListTile(
            enabled: true,
            focusColor: Colors.blue,
            leading: DownloadIconButton(
                downloadLink: releaseDownloadAsset?.browserDownloadUrl ?? '',
                onPress: () {
                  DownloadHelper().downloadWine(
                    releaseDownloadAsset?.browserDownloadUrl ?? '',
                  );
                }),
            title: Text(
              protonRelease.tagName ?? "",
            ),
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$fileSize - $fileStatus",
                ),
                ...currentDownload?.status == DownloadStatus.downloaded
                    ? [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: isActive || currentDownload == null
                                    ? null
                                    : () => toggleActive(currentDownload),
                                child:
                                    Text(isActive ? "On use" : "Use this wine"),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: ElevatedButton(
                                  onPressed: currentDownload == null
                                      ? null
                                      : () => onRemove(currentDownload),
                                  child: const Text("Delete this wine"),
                                ),
                              ),
                            ],
                          ),
                        )
                      ]
                    : []
              ],
            ),
          ),
          const Divider()
        ],
      );
    });
  }
}
