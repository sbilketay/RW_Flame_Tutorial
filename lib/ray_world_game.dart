import 'package:flame/game.dart';
import 'helpers/direction.dart';
import 'player.dart';

class RayWorldGame extends FlameGame {
  final Player _player = Player();
  @override
  // ignore: must_call_super
  Future<void>? onLoad() {
    add(_player);
  }

  void onJoypadDirectionChanged(Direction direction) {
    _player.direction = direction;
  }
}
