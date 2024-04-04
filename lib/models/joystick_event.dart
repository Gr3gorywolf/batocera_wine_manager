class JoystickEvent {
  late int type;
  late int time;
  late int number;
  late double value;

  JoystickEvent(
      {required this.type,
      required this.time,
      required this.number,
      required this.value});

  factory JoystickEvent.fromString(String eventString) {
    if (!eventString.contains("Event: ")) {
      return JoystickEvent(type: 0, time: 0, number: 0, value: 0);
    }
    List<String> parts = eventString.split(', ');
    if (parts.length != 4) {
      return JoystickEvent(type: 0, time: 0, number: 0, value: 0);
    }

    int type = int.parse(parts[0].split(' ')[1]);
    int time = int.parse(parts[1].split(' ')[1]);
    int number = int.parse(parts[2].split(' ')[1]);
    double value = double.parse(parts[3].split(' ')[1]);

    return JoystickEvent(type: type, time: time, number: number, value: value);
  }

  String getTypeName() {
    if (type == 1) {
      return 'Button';
    } else if (type == 2) {
      return 'Stick';
    } else {
      return 'Unknown';
    }
  }

  String getStickDirection() {
    if (type == 2) {
      if (number == 0 && value < 0) {
        return 'Up';
      } else if (number == 0 && value > 0) {
        return 'Down';
      } else if (number == 1 && value > 0) {
        return 'Right';
      } else if (number == 1 && value < 0) {
        return 'Left';
      }
    }
    return '';
  }

  bool isButton() {
    return type == 1;
  }

  bool isStick() {
    return type == 2;
  }

  bool isStickUp() {
    return isStick() && number == 0 && value < 0;
  }

  bool isStickDown() {
    return isStick() && number == 0 && value > 0;
  }

  bool isStickRight() {
    return isStick() && number == 1 && value > 0;
  }

  bool isStickLeft() {
    return isStick() && number == 1 && value < 0;
  }
}
