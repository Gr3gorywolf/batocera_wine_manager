import 'dart:io';

import 'package:batocera_wine_manager/constants/paths.dart';
import 'package:batocera_wine_manager/constants/urls.dart';
import 'package:batocera_wine_manager/get_controllers/download_controller.dart';
import 'package:batocera_wine_manager/helpers/common_helpers.dart';
import 'package:batocera_wine_manager/helpers/download_helper.dart';
import 'package:batocera_wine_manager/helpers/file_system_helper.dart';
import 'package:batocera_wine_manager/helpers/ui_helpers.dart';
import 'package:batocera_wine_manager/models/download.dart';
import 'package:batocera_wine_manager/models/github_release.dart';
import 'package:batocera_wine_manager/pages/home/proton_list_item.dart';
import 'package:batocera_wine_manager/widget/DownloadIconButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GithubRelease> protonReleases = [];
  var isFetchingReleases = false;
  var titleTextStyle = TextStyle(fontSize: 20, color: Colors.red);
  DownloadController downloadController = Get.find();
  bool? redistInstallActive = null;
  bool fastRedistInstallActive = false;
  String? activeProtonName = null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FileSystemHelper.init();
    fetchReleases();
    initializeActiveProton();
    initializeRedist();
  }

  initializeRedist() async {
    setState(() {
      redistInstallActive = FileSystemHelper.getRedistInstallActive();
      fastRedistInstallActive = FileSystemHelper.fastRedistInstallEnabled();
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

  handleSetFastRedistInstall(bool active) async {
    var toggleResult = await FileSystemHelper.toggleFastRedistInstall(active);
    setState(() {
      fastRedistInstallActive = toggleResult;
    });
  }

  handleDownloadRedist() async {
    var downloadSucceed = await DownloadHelper().downloadRedist();
    if (downloadSucceed) {
      initializeRedist();
    }
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
        await FileSystemHelper.overrideWineVersion(protonDownload.filePath);
    if (overrideSucced) {
      setState(() {
        activeProtonName = protonDownload.fileName;
      });
    }
    Navigator.pop(context);
  }

  handleRemoveProton(Download protonDownload) async {
    UiHelpers().showLoaderDialog(context, text: "Removing proton...");
    var deleteSucceed =
        await FileSystemHelper.deleteProton(protonDownload.filePath);

    if (deleteSucceed) {
      downloadController.downloads.remove(protonDownload.url);
      if (activeProtonName == protonDownload.fileName) {
        setState(() {
          activeProtonName = null;
        });
      }
    }
    Navigator.pop(context);
  }

  handleShowInfoDialog() {
    UiHelpers.showAlertDialog(context, "About batocera wine manager",
        "App created by gr3gorywolf with love to manage wine versions & redistributables on batocera for a optimal windows experience",
        buttons: [
          TextButton(
              onPressed: () => {Navigator.pop(context)}, child: Text("Close")),
          TextButton(
              onPressed: () => {
                    launchUrl(Uri.parse(
                        "https://github.com/Gr3gorywolf/batocera_wine_manager"))
                  },
              child: Text("View on github")),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Batocera wine manager"),
          actions: [
            IconButton(onPressed: handleShowInfoDialog, icon: Icon(Icons.info)),
            IconButton(onPressed: () => {exit(0)}, icon: Icon(Icons.close))
          ],
        ),
        body: SingleChildScrollView(
          child: Focus(
            child: Column(
              children: [
                ListTile(
                    title: Text("Redistributables", style: titleTextStyle)),
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
                              ),
                              Row(
                                children: [
                                  Switch(
                                      value: fastRedistInstallActive,
                                      onChanged: handleSetFastRedistInstall),
                                  Text(
                                      "Enable fast & automatic distributables install (Some games will need the full installation)")
                                ],
                              )
                            ])
                          : []
                    ],
                  ),
                  leading: DownloadIconButton(
                      downloadLink: REDIST_DOWNLOAD_LINK,
                      onPress: handleDownloadRedist),
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
                        var releaseDownloadAsset =
                            getReleaseDownloadAsset(release);
                        return ProtonListItem(
                            onRemove: handleRemoveProton,
                            isActive: activeProtonName == null
                                ? false
                                : releaseDownloadAsset?.browserDownloadUrl!
                                        .contains(activeProtonName ?? '') ??
                                    false,
                            toggleActive: handleOverrideProton,
                            protonRelease: release);
                      })
              ],
            ),
          ),
        ));
  }
}
