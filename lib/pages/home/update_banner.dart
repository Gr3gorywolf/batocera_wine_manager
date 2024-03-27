import 'package:batocera_wine_manager/models/github_release.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class UpdateBanner extends StatelessWidget {
  late GithubRelease? release;
  Function onUpdate;
  UpdateBanner({super.key, required this.release, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            Icons.update,
            color: Colors.red,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "There's a new update available: ${release?.name}",
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(
            width: 10,
          ),
          TextButton(
            onPressed: () => onUpdate(),
            child: Text("Update now"),
          )
        ],
      ),
    );
  }
}
