import 'dart:io';

import 'package:batocera_wine_manager/helpers/gamepad_map.dart';
import 'package:flutter/material.dart';
import 'package:gamepads/gamepads.dart';

const _joystickAxisMaxValueLinux = 32767;

class GamepadsHelper {
  static late GamepadController _gamepadController;
  static init(BuildContext context) async {
    Gamepads.events.listen((ev) => _handleGamepadEvent(ev, context));
  }

  static void _handleGamepadEvent(GamepadEvent event, BuildContext context) {
    print(event.key);
    // Extract the necessary information from the event to manage focus
    if (event.type == KeyType.button && event.value > 0) {
      if (aButton.matches(event)) {
        print("a button pressed");
      }

      if (bButton.matches(event)) {
        print("b button pressed");
      }
      // if (event.key == GamepadButton.a && event.event == ButtonEvent.down) {
      //   // Perform action when A button is pressed
      //   // For example, you can simulate a tap event to trigger the focused element
      //   // or navigate to a new screen
      // }
    } else if (event.type == KeyType.analog) {
      // Interpret the axis event to determine focus changes

      var sensibility = 0.7;
      var intensity = GamepadAnalogAxis.normalizedIntensity(event);
      if (intensity > sensibility) {
        if (leftXAxis.matches(event)) {
          print("left x axis  ${intensity}");
        }

        if (leftYAxis.matches(event)) {
          print("left y axis ${intensity}");
        }
      }
    }
  }
}
