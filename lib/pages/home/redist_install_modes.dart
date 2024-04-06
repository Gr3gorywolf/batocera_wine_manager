import 'package:flutter/material.dart';

import '../../constants/enums.dart';

class RedistInstallationModes extends StatelessWidget {
  REDIST_MODES? redistInstallMode;
  Function(REDIST_MODES?) onModeChange;
  RedistInstallationModes(
      {super.key, required this.redistInstallMode, required this.onModeChange});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Radio(
                value: REDIST_MODES.full,
                groupValue: redistInstallMode,
                onChanged: onModeChange),
            const Text("Full installation (Start)")
          ],
        ),
        Row(
          children: [
            Radio(
                value: REDIST_MODES.fast,
                groupValue: redistInstallMode,
                onChanged: onModeChange),
            const Text("Fast installation (Select)")
          ],
        ),
        Row(
          children: [
            Radio(
                value: REDIST_MODES.disabled,
                groupValue: redistInstallMode,
                onChanged: onModeChange),
            const Text("Disable installation (X or Y)")
          ],
        )
      ],
    );
  }
}
