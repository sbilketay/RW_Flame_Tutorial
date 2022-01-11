import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'helpers/direction.dart';

class Player extends SpriteAnimationComponent with HasGameRef {
  Player() : super(size: Vector2.all(50.0));

  Direction direction = Direction.none;
  final double _playerSpeed = 300.0;
  final double _animationSpeed = 0.15;
  late final SpriteAnimation _runDownAnimation;
  late final SpriteAnimation _runUpAnimation;
  late final SpriteAnimation _runLeftAnimation;
  late final SpriteAnimation _runRightAnimation;
  late final SpriteAnimation _standingAnimation;

  @override
  void update(double delta) {
    print(delta);
    super.update(delta);
    movePlayer(delta);
  }

  void movePlayer(double delta) {
    switch (direction) {
      case Direction.down:
        animation = _runDownAnimation;
        moveDown(delta);
        break;
      case Direction.right:
        animation = _runRightAnimation;
        moveRight(delta);
        break;
      case Direction.left:
        animation = _runLeftAnimation;
        moveLeft(delta);
        break;
      case Direction.up:
        animation = _runUpAnimation;
        moveUp(delta);
        break;
      case Direction.none:
        animation = _standingAnimation;
        break;
    }
  }

  void moveDown(double delta) {
    position.add(Vector2(0, delta * _playerSpeed));
  }

  void moveUp(double delta) {
    print(delta * _playerSpeed);
    position.add(Vector2(0, -delta * _playerSpeed));
  }

  void moveLeft(double delta) {
    position.add(Vector2(-delta * _playerSpeed, 0));
  }

  void moveRight(double delta) {
    position.add(Vector2(delta * _playerSpeed, 0));
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _loadAnimations().then((value) => animation = _standingAnimation);
    // sprite = await gameRef.loadSprite('player.png');
    position = gameRef.size / 2;
  }

  Future<void> _loadAnimations() async {
    final spriteSheet = SpriteSheet(
        image: await gameRef.images.load('player_spritesheet.png'),
        srcSize: Vector2(29.0, 32.0));

    _standingAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 1);
    _runDownAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 4);
    _runLeftAnimation =
        spriteSheet.createAnimation(row: 1, stepTime: _animationSpeed, to: 4);
    _runUpAnimation =
        spriteSheet.createAnimation(row: 2, stepTime: _animationSpeed, to: 4);
    _runRightAnimation =
        spriteSheet.createAnimation(row: 3, stepTime: _animationSpeed, to: 4);
  }
}
