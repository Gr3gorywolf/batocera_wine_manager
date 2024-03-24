import 'package:batocera_wine_manager/pages/config/config.dart';
import 'package:batocera_wine_manager/pages/downloads/downloads.dart';
import 'package:flutter/material.dart';

class NavigatorPage extends StatefulWidget {
  NavigatorPage({Key? key}) : super(key: key);

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text("Batocera wine manager"),
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.download), text: "Downloads"),
                  Tab(icon: Icon(Icons.settings), text: "Wine Settings"),
                ],
              ),
            ),
            body: Container(
              child: TabBarView(
                children: [
                  DownloadsPage(),
                  ConfigPage(),
                ],
              ),
            )));
    ;
  }
}
