import 'package:batocera_wine_manager/models/github_release.dart';
import 'package:flutter/material.dart';

class UpdateBanner extends StatelessWidget {
  late GithubRelease? release;
  Function onUpdate;
  UpdateBanner({super.key, required this.release, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Icon(
            Icons.update,
            color: Colors.red,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            "There's a new update available: ${release?.name}",
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(
            width: 10,
          ),
          TextButton(
            onPressed: () => onUpdate(),
            child: const Text("Update now"),
          )
        ],
      ),
    );
  }
}
