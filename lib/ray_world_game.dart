import 'package:flame/game.dart';
import 'player.dart';

class RayWorldGame extends FlameGame {
  final Player _player = Player();
  @override
  Future<void>? onLoad() {
    add(_player);
  }
}
