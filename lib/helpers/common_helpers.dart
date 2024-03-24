import 'dart:math';

class CommonHelpers {
  static String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  static String getFileNameFromUrl(String url) {
    Uri uri = Uri.parse(url);
    String path = uri.path;
    List<String> pathSegments = path.split('/');
    String filenameWithExtension = pathSegments.last;
    List<String> filenameSegments = filenameWithExtension.split(r'\');
    String filename = filenameSegments.last;

    return filename;
  }
}
