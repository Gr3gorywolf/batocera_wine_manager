import 'package:batocera_wine_manager/widget/ActionableListItem.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DefaultWineListItem extends StatefulWidget {
  bool isOnUse;
  Function onUsePressed;
  DefaultWineListItem(
      {super.key, required this.isOnUse, required this.onUsePressed});

  @override
  State<DefaultWineListItem> createState() => _DefaultWineListItemState();
}

class _DefaultWineListItemState extends State<DefaultWineListItem> {
  @override
  Widget build(BuildContext context) {
    return ActionableListItem(
      enterPressed: () {
        if (!widget.isOnUse) {
          widget.onUsePressed();
        }
      },
      builder: (focused) {
        return ListTile(
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
                  onPressed:
                      widget.isOnUse ? null : () => widget.onUsePressed(),
                  child: Text(widget.isOnUse
                      ? "On use"
                      : "Use this wine ${focused ? '(Start)' : ''}"),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
