import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class ActionableListItem extends StatefulWidget {
  Widget Function(bool focus) builder;
  Function? enterPressed;
  Function? deletePressed;
  ActionableListItem(
      {super.key,
      required this.builder,
      this.enterPressed,
      this.deletePressed});

  @override
  State<ActionableListItem> createState() => _ActionableListItemState();
}

class _ActionableListItemState extends State<ActionableListItem> {
  var isFocused = false;
  final FocusNode keyboardNode = FocusNode(canRequestFocus: false);

  final FocusNode inkWellNode = FocusNode(
      descendantsAreFocusable: false, descendantsAreTraversable: false);

  handleKeyPress(KeyEvent key) {
    if (key.logicalKey == LogicalKeyboardKey.enter &&
        widget.enterPressed != null) {
      widget.enterPressed!();
    }
    if (key.logicalKey == LogicalKeyboardKey.delete &&
        widget.deletePressed != null) {
      widget.deletePressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: keyboardNode,
      onKeyEvent: handleKeyPress,
      child: InkWell(
        focusNode: inkWellNode,
        focusColor: Colors.purple[50],
        onFocusChange: (val) {
          setState(() {
            isFocused = val;
          });
        },
        onTap: () => {},
        child: widget.builder(isFocused),
      ),
    );
  }
}
