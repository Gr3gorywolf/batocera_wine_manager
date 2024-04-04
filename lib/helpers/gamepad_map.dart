import 'dart:io';

import 'package:gamepads/gamepads.dart';

const _joystickAxisMaxValueLinux = 32767;
const _joystickAxisMaxValueWindows = 54741;

abstract class GamepadKey {
  const GamepadKey();

  bool matches(GamepadEvent event);
}

class GamepadAnalogAxis implements GamepadKey {
  final String linuxKeyName;
  final String macosKeyName;
  final String windowsKeyName;

  const GamepadAnalogAxis({
    required this.linuxKeyName,
    required this.macosKeyName,
    required this.windowsKeyName,
  });

  @override
  bool matches(GamepadEvent event) {
    final key = event.key;
    final isKey =
        key == linuxKeyName || key == macosKeyName || key == windowsKeyName;
    return isKey && event.type == KeyType.analog;
  }

  static double normalizedIntensity(GamepadEvent event) {
    double intensity = event.value;
    if (Platform.isWindows) {
      intensity = (event.value / _joystickAxisMaxValueWindows).clamp(-1.0, 1.0);
    }
    if (Platform.isLinux) {
      intensity = (event.value / _joystickAxisMaxValueLinux).clamp(-1.0, 1.0);
    }
    if (intensity.abs() < 0.2) {
      return 0;
    }
    return intensity;
  }
}

class GamepadButtonKey extends GamepadKey {
  final String linuxKeyName;
  final String macosKeyName;
  final String windowsKeyName;

  const GamepadButtonKey(
      {required this.linuxKeyName,
      required this.macosKeyName,
      required this.windowsKeyName});

  @override
  bool matches(GamepadEvent event) {
    final isKey = event.key == linuxKeyName ||
        event.key == macosKeyName ||
        event.key == windowsKeyName;
    return isKey && event.value == 1.0 && event.type == KeyType.button;
  }
}

class GamepadBumperKey extends GamepadKey {
  final String key;

  const GamepadBumperKey({required this.key});

  @override
  bool matches(GamepadEvent event) {
    return event.key == key &&
        event.value > 10000 &&
        event.type == KeyType.analog;
  }
}

const leftXAxis = GamepadAnalogAxis(
  linuxKeyName: '0',
  windowsKeyName: 'dwYpos',
  macosKeyName: 'l.joystick - xAxis',
);
const leftYAxis = GamepadAnalogAxis(
  linuxKeyName: '1',
  windowsKeyName: 'dwXpos',
  macosKeyName: 'l.joystick - yAxis',
);
const rightXAxis = GamepadAnalogAxis(
  linuxKeyName: '3',
  windowsKeyName: 'dwRpos',
  macosKeyName: 'r.joystick - xAxis',
);
const rightYAxis = GamepadAnalogAxis(
  linuxKeyName: '4',
  windowsKeyName: 'dwUpos',
  macosKeyName: 'r.joystick - yAxis',
);

const GamepadKey aButton = GamepadButtonKey(
  linuxKeyName: '0',
  windowsKeyName: 'button-0',
  macosKeyName: 'a.circle',
);
const GamepadKey bButton = GamepadButtonKey(
  linuxKeyName: '1',
  windowsKeyName: 'button-1',
  macosKeyName: 'b.circle',
);
const GamepadKey xButton = GamepadButtonKey(
  linuxKeyName: '2',
  windowsKeyName: 'button-2',
  macosKeyName: 'x.circle',
);
const GamepadKey yButton = GamepadButtonKey(
  linuxKeyName: '3',
  windowsKeyName: 'button-3',
  macosKeyName: 'y.circle',
);
const GamepadKey lButton = GamepadButtonKey(
  linuxKeyName: '4',
  windowsKeyName: 'button-4',
  macosKeyName: '4.circle',
);
const GamepadKey rButton = GamepadButtonKey(
  linuxKeyName: '5',
  windowsKeyName: 'button-5',
  macosKeyName: '5.circle',
);
const GamepadKey startButton = GamepadButtonKey(
  linuxKeyName: '7',
  windowsKeyName: 'button-7',
  macosKeyName: 'line.horizontal.3.circle',
);
const GamepadKey selectButton = GamepadButtonKey(
  linuxKeyName: '6',
  windowsKeyName: 'button-6',
  macosKeyName: '???',
);

const GamepadKey l1Bumper = GamepadBumperKey(key: '2');
const GamepadKey r1Bumper = GamepadBumperKey(key: '5');
