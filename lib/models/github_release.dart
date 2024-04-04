class GithubRelease {
  String? url;
  String? htmlUrl;
  String? assetsUrl;
  String? uploadUrl;
  String? tarballUrl;
  String? zipballUrl;
  int? id;
  String? nodeId;
  String? tagName;
  String? targetCommitish;
  String? name;
  String? body;
  bool? draft;
  bool? prerelease;
  String? createdAt;
  String? publishedAt;
  _Author? author;
  List<GithubReleaseAsset>? assets;

  GithubRelease(
      {this.url,
      this.htmlUrl,
      this.assetsUrl,
      this.uploadUrl,
      this.tarballUrl,
      this.zipballUrl,
      this.id,
      this.nodeId,
      this.tagName,
      this.targetCommitish,
      this.name,
      this.body,
      this.draft,
      this.prerelease,
      this.createdAt,
      this.publishedAt,
      this.author,
      this.assets});

  GithubRelease.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    htmlUrl = json['html_url'];
    assetsUrl = json['assets_url'];
    uploadUrl = json['upload_url'];
    tarballUrl = json['tarball_url'];
    zipballUrl = json['zipball_url'];
    id = json['id'];
    nodeId = json['node_id'];
    tagName = json['tag_name'];
    targetCommitish = json['target_commitish'];
    name = json['name'];
    body = json['body'];
    draft = json['draft'];
    prerelease = json['prerelease'];
    createdAt = json['created_at'];
    publishedAt = json['published_at'];
    author =
        json['author'] != null ? new _Author.fromJson(json['author']) : null;
    if (json['assets'] != null) {
      assets = <GithubReleaseAsset>[];
      json['assets'].forEach((v) {
        assets!.add(new GithubReleaseAsset.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['html_url'] = this.htmlUrl;
    data['assets_url'] = this.assetsUrl;
    data['upload_url'] = this.uploadUrl;
    data['tarball_url'] = this.tarballUrl;
    data['zipball_url'] = this.zipballUrl;
    data['id'] = this.id;
    data['node_id'] = this.nodeId;
    data['tag_name'] = this.tagName;
    data['target_commitish'] = this.targetCommitish;
    data['name'] = this.name;
    data['body'] = this.body;
    data['draft'] = this.draft;
    data['prerelease'] = this.prerelease;
    data['created_at'] = this.createdAt;
    data['published_at'] = this.publishedAt;
    if (this.author != null) {
      data['author'] = this.author!.toJson();
    }
    if (this.assets != null) {
      data['assets'] = this.assets!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class _Author {
  String? login;
  int? id;
  String? nodeId;
  String? avatarUrl;
  String? gravatarId;
  String? url;
  String? htmlUrl;
  String? followersUrl;
  String? followingUrl;
  String? gistsUrl;
  String? starredUrl;
  String? subscriptionsUrl;
  String? organizationsUrl;
  String? reposUrl;
  String? eventsUrl;
  String? receivedEventsUrl;
  String? type;
  bool? siteAdmin;

  _Author(
      {this.login,
      this.id,
      this.nodeId,
      this.avatarUrl,
      this.gravatarId,
      this.url,
      this.htmlUrl,
      this.followersUrl,
      this.followingUrl,
      this.gistsUrl,
      this.starredUrl,
      this.subscriptionsUrl,
      this.organizationsUrl,
      this.reposUrl,
      this.eventsUrl,
      this.receivedEventsUrl,
      this.type,
      this.siteAdmin});

  _Author.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    id = json['id'];
    nodeId = json['node_id'];
    avatarUrl = json['avatar_url'];
    gravatarId = json['gravatar_id'];
    url = json['url'];
    htmlUrl = json['html_url'];
    followersUrl = json['followers_url'];
    followingUrl = json['following_url'];
    gistsUrl = json['gists_url'];
    starredUrl = json['starred_url'];
    subscriptionsUrl = json['subscriptions_url'];
    organizationsUrl = json['organizations_url'];
    reposUrl = json['repos_url'];
    eventsUrl = json['events_url'];
    receivedEventsUrl = json['received_events_url'];
    type = json['type'];
    siteAdmin = json['site_admin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login'] = this.login;
    data['id'] = this.id;
    data['node_id'] = this.nodeId;
    data['avatar_url'] = this.avatarUrl;
    data['gravatar_id'] = this.gravatarId;
    data['url'] = this.url;
    data['html_url'] = this.htmlUrl;
    data['followers_url'] = this.followersUrl;
    data['following_url'] = this.followingUrl;
    data['gists_url'] = this.gistsUrl;
    data['starred_url'] = this.starredUrl;
    data['subscriptions_url'] = this.subscriptionsUrl;
    data['organizations_url'] = this.organizationsUrl;
    data['repos_url'] = this.reposUrl;
    data['events_url'] = this.eventsUrl;
    data['received_events_url'] = this.receivedEventsUrl;
    data['type'] = this.type;
    data['site_admin'] = this.siteAdmin;
    return data;
  }
}

class GithubReleaseAsset {
  String? url;
  String? browserDownloadUrl;
  int? id;
  String? nodeId;
  String? name;
  String? label;
  String? state;
  String? contentType;
  int? size;
  int? downloadCount;
  String? createdAt;
  String? updatedAt;
  _Author? uploader;

  GithubReleaseAsset(
      {this.url,
      this.browserDownloadUrl,
      this.id,
      this.nodeId,
      this.name,
      this.label,
      this.state,
      this.contentType,
      this.size,
      this.downloadCount,
      this.createdAt,
      this.updatedAt,
      this.uploader});

  GithubReleaseAsset.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    browserDownloadUrl = json['browser_download_url'];
    id = json['id'];
    nodeId = json['node_id'];
    name = json['name'];
    label = json['label'];
    state = json['state'];
    contentType = json['content_type'];
    size = json['size'];
    downloadCount = json['download_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    uploader = json['uploader'] != null
        ? new _Author.fromJson(json['uploader'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['browser_download_url'] = this.browserDownloadUrl;
    data['id'] = this.id;
    data['node_id'] = this.nodeId;
    data['name'] = this.name;
    data['label'] = this.label;
    data['state'] = this.state;
    data['content_type'] = this.contentType;
    data['size'] = this.size;
    data['download_count'] = this.downloadCount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.uploader != null) {
      data['uploader'] = this.uploader!.toJson();
    }
    return data;
  }
}
