import 'package:batocera_wine_manager/models/download.dart';
import 'package:batocera_wine_manager/models/github_release.dart';
import 'package:batocera_wine_manager/widget/ActionableListItem.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../../get_controllers/download_controller.dart';
import '../../helpers/common_helpers.dart';
import '../../helpers/download_helper.dart';
import '../../widget/DownloadIconButton.dart';

class WineListItem extends StatefulWidget {
  bool isActive;
  Function(Download) toggleActive;
  Function(Download) onRemove;
  GithubRelease protonRelease;

  WineListItem(
      {required this.isActive,
      required this.toggleActive,
      required this.onRemove,
      required this.protonRelease,
      super.key});

  @override
  State<WineListItem> createState() => _WineListItemState();
}

class _WineListItemState extends State<WineListItem> {
  DownloadController downloadController = Get.find();

  GithubReleaseAsset? get releaseDownloadAsset {
    var releaseAssets = widget.protonRelease.assets;
    if (releaseAssets != null && releaseAssets.isNotEmpty) {
      return widget.protonRelease.assets?.last;
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

  Download? get currentDownload {
    return downloadController
        .downloads[releaseDownloadAsset?.browserDownloadUrl ?? ''];
  }

  handleDownload() {
    DownloadHelper().downloadWine(
      releaseDownloadAsset?.browserDownloadUrl ?? '',
    );
  }

  handleOnDelete() {
    if (currentDownload != null) {
      widget.onRemove(currentDownload!);
    }
  }

  handleOnEnter() {
    if (currentDownload == null) {
      handleDownload();
    } else {
      if (!widget.isActive) {
        widget.toggleActive(currentDownload!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var fileStatus = getfileStatus(currentDownload);
      return Column(
        children: [
          ActionableListItem(
              enterPressed: handleOnEnter,
              deletePressed: handleOnDelete,
              builder: (focus) {
                return ListTile(
                  leading: DownloadIconButton(
                      downloadLink:
                          releaseDownloadAsset?.browserDownloadUrl ?? '',
                      onPress: handleDownload),
                  title: Text(
                    widget.protonRelease.tagName ?? "",
                  ),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$fileSize - $fileStatus",
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            currentDownload == null
                                ? ElevatedButton(
                                    onPressed: handleDownload,
                                    child: Text(
                                        "Download this wine ${focus ? '(Start)' : ''}"),
                                  )
                                : Container(),
                            ...currentDownload?.status ==
                                    DownloadStatus.downloaded
                                ? [
                                    ElevatedButton(
                                      onPressed: widget.isActive ||
                                              currentDownload == null
                                          ? null
                                          : () => widget
                                              .toggleActive(currentDownload!),
                                      child: Text(widget.isActive
                                          ? "On use"
                                          : "Set as system default ${focus ? '(Start)' : ''}"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: ElevatedButton(
                                        onPressed: currentDownload == null
                                            ? null
                                            : () => widget
                                                .onRemove(currentDownload!),
                                        child: Text(
                                            "Delete this wine ${focus ? '(Select)' : ''}"),
                                      ),
                                    )
                                  ]
                                : []
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }),
          const Divider()
        ],
      );
    });
  }
}
