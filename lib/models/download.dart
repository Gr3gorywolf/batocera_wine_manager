class Download {
  late String fileName;
  late String key;
  late double progress;

  get isCompleted {
    return this.progress == 100;
  }

  get canDownload {
    return this.progress <= 0;
  }

  Download({required this.fileName, required this.progress, required this.key});

  Download.fromJson(Map<String, dynamic> json) {
    fileName = json['fileName'];
    progress = json['progress'];
    key = json[key];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fileName'] = this.fileName;
    data['progress'] = this.progress;
    data['key'] = this.key;
    return data;
  }
}
