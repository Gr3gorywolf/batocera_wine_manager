import 'package:batocera_wine_manager/get_controllers/download_controller.dart';
import 'package:batocera_wine_manager/models/download.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownloadIconButton extends StatelessWidget {
  late String downloadLink;
  late Function onPress;
  DownloadIconButton(
      {Key? key, required this.downloadLink, required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DownloadController downloadController = Get.find();
    return Obx(() {
      var download = downloadController.downloads[downloadLink];
      var hasNoneStatus =
          download == null || download.status == DownloadStatus.none;
      return IconButton(
        onPressed: hasNoneStatus ? () => onPress() : null,
        icon: [DownloadStatus.none, DownloadStatus.downloaded, null]
                .contains(download?.status)
            ? Icon(
                Icons.download,
                color: hasNoneStatus ? null : Colors.green,
              )
            : CircularProgressIndicator(
                strokeWidth: 4,
                value: download?.status == DownloadStatus.uncompressing
                    ? null
                    : (download?.progress ?? 0) / 100,
              ),
      );
    });
  }
}
