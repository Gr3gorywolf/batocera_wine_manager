import 'package:batocera_wine_manager/models/download.dart';
import 'package:get/get.dart';

class DownloadController extends GetxController {
  RxMap<String, Download> downloads = RxMap<String, Download>();
  setDownload(Download download) {
    downloads[download.key] = download;
  }
}
