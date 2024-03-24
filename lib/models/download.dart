enum DownloadStatus { downloading, downloaded, uncompressing, none }

class Download {
  late String fileName;
  late String url;
  late double progress;
  late DownloadStatus status;

  get isCompleted {
    return status == DownloadStatus.downloaded;
  }

  get canDownload {
    return status == DownloadStatus.none;
  }

  Download(
      {required this.fileName,
      this.progress = 0,
      required this.url,
      this.status = DownloadStatus.none});
}
