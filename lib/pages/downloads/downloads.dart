import 'package:batocera_wine_manager/constants/paths.dart';
import 'package:batocera_wine_manager/constants/urls.dart';
import 'package:batocera_wine_manager/helpers/common_helpers.dart';
import 'package:batocera_wine_manager/helpers/download_helper.dart';
import 'package:batocera_wine_manager/helpers/file_system_helper.dart';
import 'package:batocera_wine_manager/helpers/ui_helpers.dart';
import 'package:batocera_wine_manager/models/download.dart';
import 'package:batocera_wine_manager/models/github_release.dart';
import 'package:batocera_wine_manager/pages/downloads/proton_list_item.dart';
import 'package:batocera_wine_manager/widget/DownloadIconButton.dart';
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
  bool? redistInstallActive = null;
  var activeProtonName = null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchReleases();
    initializeActiveProton();
    initializeRedistActivation();
  }

  initializeRedistActivation() async {
    setState(() {
      redistInstallActive = FileSystemHelper.getRedistInstallActive();
    });
  }

  initializeActiveProton() async {
    var protonPath = await FileSystemHelper.getWineOverrideName();
    setState(() {
      if (protonPath != null) {
        activeProtonName = Uri.parse(protonPath).pathSegments.last;
      } else {
        activeProtonName = null;
      }
    });
  }

  GithubReleaseAsset? getReleaseDownloadAsset(GithubRelease release) {
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

  handleSetRedistActive(bool isActive) async {
    var toggleResult = await FileSystemHelper.toggleRedist(isActive);
    setState(() {
      redistInstallActive = toggleResult;
    });
  }

  handleDisableProtonOverride() async {
    await FileSystemHelper.disableWineOverride();
    setState(() {
      activeProtonName = null;
    });
  }

  handleOverrideProton(Download protonDownload) async {
    UiHelpers().showLoaderDialog(context, text: "Setting up proton...");
    var overrideSucced =
        await FileSystemHelper.overrideWineVersion(protonDownload.fileName);
    if (overrideSucced) {
      setState(() {
        activeProtonName = Uri.parse(protonDownload.fileName).pathSegments.last;
      });
    }
    Navigator.pop(context);
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
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Those redistributables will allow you to install all the needed dependencies in the wine application's folder"),
                ...redistInstallActive != null
                    ? ([
                        Row(
                          children: [
                            Switch(
                                value: redistInstallActive ?? false,
                                onChanged: handleSetRedistActive),
                            Text(
                                "Enable redistributables install on wine application launch")
                          ],
                        )
                      ])
                    : []
              ],
            ),
            leading: DownloadIconButton(
                downloadLink: REDIST_DOWNLOAD_LINK,
                onPress: () {
                  DownloadHelper().downloadRedist();
                }),
          ),
          ListTile(title: Text("Proton versions", style: titleTextStyle)),
          ListTile(
            leading: IconButton(
              onPressed: null,
              icon: Icon(Icons.download, color: Colors.green),
            ),
            title: Text(
              "Proton default",
            ),
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "The batocera's default wine version",
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: ElevatedButton(
                    onPressed: activeProtonName == null
                        ? null
                        : () => handleDisableProtonOverride(),
                    child: Text(activeProtonName == null
                        ? "On use"
                        : "Use this proton"),
                  ),
                )
              ],
            ),
          ),
          Divider(),
          ...isFetchingReleases
              ? [
                  Center(
                    child: CircularProgressIndicator(),
                  )
                ]
              : protonReleases.map((release) {
                  var releaseDownloadAsset = getReleaseDownloadAsset(release);
                  return ProtonListItem(
                      isActive: activeProtonName == null
                          ? false
                          : releaseDownloadAsset?.browserDownloadUrl!
                                  .contains(activeProtonName) ??
                              false,
                      toggleActive: handleOverrideProton,
                      protonRelease: release);
                })
        ],
      ),
    ));
  }
}
