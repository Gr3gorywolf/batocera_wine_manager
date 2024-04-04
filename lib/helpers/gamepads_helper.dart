import 'dart:convert';
import 'dart:io';
import 'package:batocera_wine_manager/models/joystick_event.dart';
import 'package:flutter/material.dart';

class GamepadsHelper {
  static init(BuildContext context) async {
    var proc = await Process.start('jstest', ['--nonblock', '/dev/input/js0']);
    proc.stdout.transform(utf8.decoder).listen((String data) {
      // Handle stdout data here
      _handleGamepadEvent(JoystickEvent.fromString(data), context);
    });
  }

  static void _handleGamepadEvent(JoystickEvent event, BuildContext context) {
    print("${event.getTypeName()} ${event.number} ${event.value}");
    // Extract the necessary information from the event to manage focus
    if (event.isButton()) {
      print("button pressed");
      // if (event.key == GamepadButton.a && event.event == ButtonEvent.down) {
      //   // Perform action when A button is pressed
      //   // For example, you can simulate a tap event to trigger the focused element
      //   // or navigate to a new screen
      // }
    } else if (event.isStick()) {
      // Interpret the axis event to determine focus changes

      var sensibility = 0.7;
      if (event.isStickRight()) {
        print("right stick");
      }
      if (event.isStickLeft()) {
        print("left stick");
      }
      if (event.isStickUp()) {
        print("up stick");
      }
      if (event.isStickDown()) {
        print("down stick");
      }
    }
  }
}
