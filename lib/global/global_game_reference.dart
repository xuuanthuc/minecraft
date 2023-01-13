import 'package:minecraft/main_game.dart';

class GlobalGameReference {

  static final GlobalGameReference _singleton = GlobalGameReference._internal();

  factory GlobalGameReference() {
    return _singleton;
  }

  GlobalGameReference._internal();

  late MainGame gameReference;
}