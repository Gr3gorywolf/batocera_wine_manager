import 'dart:io';

import 'package:batocera_wine_manager/constants/urls.dart';
import 'package:batocera_wine_manager/get_controllers/download_controller.dart';
import 'package:batocera_wine_manager/helpers/download_helper.dart';
import 'package:batocera_wine_manager/helpers/file_system_helper.dart';
import 'package:batocera_wine_manager/helpers/ui_helpers.dart';
import 'package:batocera_wine_manager/helpers/updates_helper.dart';
import 'package:batocera_wine_manager/models/download.dart';
import 'package:batocera_wine_manager/models/github_release.dart';
import 'package:batocera_wine_manager/pages/home/proton_list_item.dart';
import 'package:batocera_wine_manager/pages/home/update_banner.dart';
import 'package:batocera_wine_manager/widget/DownloadIconButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  var titleTextStyle = const TextStyle(fontSize: 20, color: Colors.red);
  DownloadController downloadController = Get.find();
  bool? redistInstallActive;
  GithubRelease? newUpdate;
  bool fastRedistInstallActive = false;
  String? activeProtonName;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FileSystemHelper.init();
    initializeNewUpdate();
    fetchReleases();
    initializeActiveProton();
    initializeRedist();
  }

  initializeNewUpdate() async {
    var update = await UpdatesHelper().fetchNewRelease();
    if (update != null) {
      setState(() {
        newUpdate = update;
      });
    }
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

  String? getRedistDownloadStatus() {
    var redistDownload = downloadController.downloads[REDIST_DOWNLOAD_LINK];
    if (redistDownload != null) {
      switch (redistDownload.status) {
        case DownloadStatus.downloading:
          return "Downloading: ${redistDownload.progress.round()}%";
        case DownloadStatus.downloaded:
          return "Installed";
        case DownloadStatus.uncompressing:
          return "Uncompressing";
        case DownloadStatus.none:
          break;
      }
    }
    return 'Not installed';
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

  handleUpdate() {
    UpdatesHelper().updateApp();
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

  handleShowInfoDialog() async {
    var currentRelease = await rootBundle.loadString(
      "assets/data/release-number.txt",
    );
    UiHelpers.showAlertDialog(context, "Batocera wine manager $currentRelease",
        "App created by gr3gorywolf with ❤️ to manage wine versions & redistributables on batocera for a optimal windows experience",
        buttons: [
          TextButton(
              onPressed: () => {Navigator.pop(context)}, child: const Text("Close")),
          TextButton(
              onPressed: () => {
                    launchUrl(Uri.parse(
                        "https://github.com/Gr3gorywolf/batocera_wine_manager"))
                  },
              child: const Text("View on github")),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Batocera wine manager"),
          actions: [
            IconButton(onPressed: handleShowInfoDialog, icon: const Icon(Icons.info)),
            IconButton(onPressed: () => {exit(0)}, icon: const Icon(Icons.close))
          ],
        ),
        body: SingleChildScrollView(
          child: Focus(
            child: Column(
              children: [
                ...newUpdate != null
                    ? [
                        UpdateBanner(
                            release: newUpdate, onUpdate: () => handleUpdate())
                      ]
                    : [],
                ListTile(
                    title: Text("Redistributables", style: titleTextStyle)),
                ListTile(
                  title: const Text(
                    "Download redistributables",
                  ),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        return Text(
                            "Those redistributables will allow you to install all the needed dependencies in the wine application's folder - ${getRedistDownloadStatus()}");
                      }),
                      ...redistInstallActive != null
                          ? ([
                              Row(
                                children: [
                                  Switch(
                                      value: redistInstallActive ?? false,
                                      onChanged: handleSetRedistActive),
                                  const Text(
                                      "Enable redistributables install on wine application launch")
                                ],
                              ),
                              Row(
                                children: [
                                  Switch(
                                      value: fastRedistInstallActive,
                                      onChanged: handleSetFastRedistInstall),
                                  const Text(
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
                  leading: const IconButton(
                    onPressed: null,
                    icon: Icon(Icons.download, color: Colors.green),
                  ),
                  title: const Text(
                    "Proton default",
                  ),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
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
                const Divider(),
                ...isFetchingReleases
                    ? [
                        const Center(
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
