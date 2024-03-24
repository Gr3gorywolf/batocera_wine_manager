import 'package:batocera_wine_manager/get_controllers/download_controller.dart';
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
      var canDownload = download == null || download?.canDownload;
      var isDownloading =
          (download?.progress ?? -1) > 0 && (download?.progress ?? -1) < 100;
      return IconButton(
        onPressed: canDownload ? () => onPress() : null,
        icon: !isDownloading
            ? Icon(
                Icons.download,
                color: canDownload ? null : Colors.green,
              )
            : CircularProgressIndicator(
                semanticsLabel: "100",
                strokeWidth: 4,
                value: (download?.progress ?? 0) / 100,
              ),
      );
    });
  }
}
