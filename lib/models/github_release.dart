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
        json['author'] != null ? _Author.fromJson(json['author']) : null;
    if (json['assets'] != null) {
      assets = <GithubReleaseAsset>[];
      json['assets'].forEach((v) {
        assets!.add(GithubReleaseAsset.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['html_url'] = htmlUrl;
    data['assets_url'] = assetsUrl;
    data['upload_url'] = uploadUrl;
    data['tarball_url'] = tarballUrl;
    data['zipball_url'] = zipballUrl;
    data['id'] = id;
    data['node_id'] = nodeId;
    data['tag_name'] = tagName;
    data['target_commitish'] = targetCommitish;
    data['name'] = name;
    data['body'] = body;
    data['draft'] = draft;
    data['prerelease'] = prerelease;
    data['created_at'] = createdAt;
    data['published_at'] = publishedAt;
    if (author != null) {
      data['author'] = author!.toJson();
    }
    if (assets != null) {
      data['assets'] = assets!.map((v) => v.toJson()).toList();
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

  _Author();

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['login'] = login;
    data['id'] = id;
    data['node_id'] = nodeId;
    data['avatar_url'] = avatarUrl;
    data['gravatar_id'] = gravatarId;
    data['url'] = url;
    data['html_url'] = htmlUrl;
    data['followers_url'] = followersUrl;
    data['following_url'] = followingUrl;
    data['gists_url'] = gistsUrl;
    data['starred_url'] = starredUrl;
    data['subscriptions_url'] = subscriptionsUrl;
    data['organizations_url'] = organizationsUrl;
    data['repos_url'] = reposUrl;
    data['events_url'] = eventsUrl;
    data['received_events_url'] = receivedEventsUrl;
    data['type'] = type;
    data['site_admin'] = siteAdmin;
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
        ? _Author.fromJson(json['uploader'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['browser_download_url'] = browserDownloadUrl;
    data['id'] = id;
    data['node_id'] = nodeId;
    data['name'] = name;
    data['label'] = label;
    data['state'] = state;
    data['content_type'] = contentType;
    data['size'] = size;
    data['download_count'] = downloadCount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (uploader != null) {
      data['uploader'] = uploader!.toJson();
    }
    return data;
  }
}
