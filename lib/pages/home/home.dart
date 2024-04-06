import 'dart:io';

import 'package:batocera_wine_manager/constants/enums.dart';
import 'package:batocera_wine_manager/constants/urls.dart';
import 'package:batocera_wine_manager/get_controllers/download_controller.dart';
import 'package:batocera_wine_manager/helpers/download_helper.dart';
import 'package:batocera_wine_manager/helpers/file_system_helper.dart';
import 'package:batocera_wine_manager/helpers/ui_helpers.dart';
import 'package:batocera_wine_manager/helpers/updates_helper.dart';
import 'package:batocera_wine_manager/models/download.dart';
import 'package:batocera_wine_manager/models/github_release.dart';
import 'package:batocera_wine_manager/pages/home/redist_install_modes.dart';
import 'package:batocera_wine_manager/pages/home/wine_list_item.dart';
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
  REDIST_MODES? redistInstallMode = null;
  GithubRelease? newUpdate;
  WINE_BUILDS wineBuild = WINE_BUILDS.protonGe;
  String? activeProtonName;
  int selectedIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FileSystemHelper.init();
    initializeNewUpdate();
    fetchReleases();
    initializeActiveProton();
    initializeRedist();
    HardwareKeyboard.instance.addHandler((key) {
      handleKeyEvent(key);
      return true;
    });
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
    REDIST_MODES? newMode = null;
    var installActive = FileSystemHelper.getRedistInstallActive();
    var fastRedistInstall = FileSystemHelper.fastRedistInstallEnabled();
    if (installActive != null) {
      if (installActive) {
        newMode = fastRedistInstall ? REDIST_MODES.fast : REDIST_MODES.full;
      } else {
        newMode = REDIST_MODES.disabled;
      }
    }
    setState(() {
      redistInstallMode = newMode;
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
    var releases =
        await DownloadHelper().fetchWineReleases(wineBuild: wineBuild);
    if (releases != null) {
      setState(() {
        protonReleases = releases;
      });
    }

    setState(() {
      isFetchingReleases = false;
    });
  }

  void handleKeyEvent(KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.keyA) {
      handleSetRedistInstallMode(REDIST_MODES.full);
    }
    if (event.logicalKey == LogicalKeyboardKey.keyS) {
      handleSetRedistInstallMode(REDIST_MODES.fast);
    }
    if (event.logicalKey == LogicalKeyboardKey.keyD) {
      handleSetRedistInstallMode(REDIST_MODES.disabled);
    }
  }

  handleSetRedistInstallMode(REDIST_MODES? mode) async {
    if (mode == null || redistInstallMode == null) {
      return;
    }
    try {
      switch (mode) {
        case REDIST_MODES.full:
          {
            await FileSystemHelper.toggleRedist(true);
            await FileSystemHelper.toggleFastRedistInstall(false);
            break;
          }
        case REDIST_MODES.fast:
          {
            await FileSystemHelper.toggleRedist(true);
            await FileSystemHelper.toggleFastRedistInstall(true);
            break;
          }
        case REDIST_MODES.disabled:
          {
            await FileSystemHelper.toggleRedist(false);
            break;
          }
      }
      setState(() {
        redistInstallMode = mode;
      });
    } catch (err) {}
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
    UiHelpers().showLoaderDialog(context, text: "Setting up wine version...");
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
    UiHelpers().showLoaderDialog(context, text: "Removing wine version...");
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
              onPressed: () => {Navigator.pop(context)},
              child: const Text("Close")),
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
            IconButton(
                onPressed: handleShowInfoDialog, icon: const Icon(Icons.info)),
            IconButton(
                onPressed: () => {exit(0)}, icon: const Icon(Icons.close))
          ],
        ),
        body: KeyboardListener(
          focusNode: FocusNode(),
          child: SingleChildScrollView(
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
                            "Those redistributables will allow you to install all the needed dependencies in the wine application's folder on application launch - ${getRedistDownloadStatus()}");
                      }),
                    ],
                  ),
                  leading: DownloadIconButton(
                      downloadLink: REDIST_DOWNLOAD_LINK,
                      onPress: handleDownloadRedist),
                ),
                redistInstallMode != null
                    ? ListTile(
                        title: Text("Redist Installation mode",
                            style: TextStyle(color: Colors.red)),
                        subtitle: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "If not disabled it will launch the installer every time that you launch a windows game",
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            RedistInstallationModes(
                                redistInstallMode: redistInstallMode,
                                onModeChange: handleSetRedistInstallMode),
                          ],
                        ),
                      )
                    : Container(),
                ListTile(title: Text("Wine versions", style: titleTextStyle)),
                ListTile(
                  leading: const IconButton(
                    onPressed: null,
                    icon: Icon(Icons.download, color: Colors.green),
                  ),
                  title: const Text(
                    "Wine default",
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
                              : "Use this wine"),
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
                        return WineListItem(
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
