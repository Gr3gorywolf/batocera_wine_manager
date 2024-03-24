import 'package:batocera_wine_manager/models/download.dart';
import 'package:get/get.dart';

class DownloadController extends GetxController {
  RxMap<String, Download> downloads = RxMap<String, Download>();
  setDownload(Download download) {
    downloads[download.url] = download;
  }

  setDownloadStatus(String url, DownloadStatus status, {double? progress}) {
    var foundDownload = downloads[url];
    if (foundDownload != null) {
      foundDownload.status = status;
      foundDownload.progress = progress ?? 0;
      downloads[url] = foundDownload;
    }
  }
}
