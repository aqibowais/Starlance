import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:starlance/game/enemy.dart';
import 'package:starlance/game/knows_game_size.dart';
import 'package:starlance/game/starlance.dart';

class Player extends SpriteComponent
    with KnowsGameSize, CollisionCallbacks, HasGameRef<Starlance> {
  /// The direction of the player's movement.
  Vector2 _moveDirection = Vector2.zero();

  /// The speed of the player's movement.
  final double _speed = 300;
  final JoystickComponent joystick;

  /// Creates a new player.
  Player(
    this.joystick,
    Sprite? sprite,
    Vector2? size,
    Vector2? position,
  ) : super(
          sprite: sprite,
          size: size,
          position: position,
        );

  @override
  void onMount() {
    super.onMount();
    final shape = CircleHitbox();
    add(shape);
  }

  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Enemy) {
      print("player got hit");
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  @override
  void update(double dt) {
    if (joystick.direction != JoystickDirection.idle) {
      position.add(joystick.relativeDelta * _speed * dt);
      angle = joystick.delta.screenAngle();
    }
  }

  /// Updates the player's position based on the current [_moveDirection] and
  /// [_speed].

  /// Sets the [_moveDirection] to [newMoveDirection].
  void setMoveDirection(Vector2 newMoveDirection) {
    _moveDirection = newMoveDirection;
  }
}
