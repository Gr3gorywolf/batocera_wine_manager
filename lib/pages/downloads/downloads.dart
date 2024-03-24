import 'package:batocera_wine_manager/helpers/common_helpers.dart';
import 'package:batocera_wine_manager/helpers/download_helper.dart';
import 'package:batocera_wine_manager/models/github_release.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  List<GithubRelease> protonReleases = [];
  var isFetchingReleases = false;
  var titleTextStyle = TextStyle(fontSize: 20, color: Colors.red);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchReleases();
  }

  getReleaseDownloadAsset(GithubRelease release) {
    var releaseAssets = release.assets;
    if (releaseAssets != null && releaseAssets.isNotEmpty) {
      return release.assets?.last;
    }
    return null;
  }

  fetchReleases() async {
    setState(() {
      isFetchingReleases = true;
    });
    var releases = await DownloadHelper().fetchProtonReleases();
    if (releases != null) {
      setState(() {
        protonReleases = releases;
      });
    }

    setState(() {
      isFetchingReleases = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          ListTile(title: Text("Redistributables", style: titleTextStyle)),
          ListTile(
              title: Text(
                "Download redistributables",
              ),
              subtitle: Text(
                  "Those redistributables will allow you to install all the needed dependencies in the wine application's folder"),
              trailing: IconButton(
                onPressed: () => {},
                icon: Icon(Icons.download),
              )),
          ListTile(title: Text("Proton versions", style: titleTextStyle)),
          ...isFetchingReleases
              ? [
                  Center(
                    child: CircularProgressIndicator(),
                  )
                ]
              : protonReleases.map(
                  (release) => Column(
                    children: [
                      ListTile(
                          title: Text(
                            release.tagName ?? "",
                          ),
                          subtitle: Text(
                            CommonHelpers.formatBytes(
                                    getReleaseDownloadAsset(release)?.size ?? 0,
                                    1) +
                                " - Not installed",
                          ),
                          trailing: IconButton(
                            onPressed: () => {},
                            icon: Icon(Icons.download),
                          )),
                      Divider()
                    ],
                  ),
                )
        ],
      ),
    ));
  }
}
