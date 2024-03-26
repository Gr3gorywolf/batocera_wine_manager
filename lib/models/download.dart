enum DownloadStatus { downloading, downloaded, uncompressing, none }

class Download {
  late String filePath;
  late String url;
  late double progress;
  late DownloadStatus status;

  get fileName {
    return Uri.parse(filePath).pathSegments.last;
  }

  get isCompleted {
    return status == DownloadStatus.downloaded;
  }

  get canDownload {
    return status == DownloadStatus.none;
  }

  Download(
      {required this.filePath,
      this.progress = 0,
      required this.url,
      this.status = DownloadStatus.none});
}
