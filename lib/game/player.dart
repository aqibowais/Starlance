import 'package:flame/components.dart';
import 'package:starlance/game/knows_game_size.dart';

class Player extends SpriteComponent with KnowsGameSize {
  /// The direction of the player's movement.
  Vector2 _moveDirection = Vector2.zero();

  /// The speed of the player's movement.
  final double _speed = 300;

  /// Creates a new player.
  Player(
    Sprite? sprite,
    Vector2? size,
    Vector2? position,
  ) : super(
          sprite: sprite,
          size: size,
          position: position,
        );

  @override

  /// Updates the player's position based on the current [_moveDirection] and
  /// [_speed].
  void update(double dt) {
    super.update(dt);
    position += _moveDirection.normalized() * _speed * dt;
    position.clamp(Vector2.zero() + size / 2, gamesize - size / 2);
  }

  /// Sets the [_moveDirection] to [newMoveDirection].
  void setMoveDirection(Vector2 newMoveDirection) {
    _moveDirection = newMoveDirection;
  }
}
