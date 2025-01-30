import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:starlance/game/enemy.dart';

/// A bullet shot by the player.
class Bullet extends SpriteComponent with CollisionCallbacks {
  /// The speed at which the bullet moves.
  double speed = 450;

  /// Creates a new bullet.
  Bullet(
    /// The sprite for the bullet.
    Sprite? sprite,

    /// The size of the bullet.
    Vector2? size,

    /// The position of the bullet.
    Vector2? position,
  ) : super(
          sprite: sprite,
          size: size,
          position: position,
        );

  //implementing collision detection
  @override
  void onMount() {
    super.onMount();
    add(CircleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Enemy) {
      removeFromParent();
    }
    super.onCollision(intersectionPoints, other);
  }

  @override

  /// Updates the bullet's position based on the speed.
  void update(double dt) {
    super.update(dt);
    position += Vector2(0, -1) * speed * dt;
    if (position.y < 0) {
      /// If the bullet goes off the screen, remove it from the parent.
      removeFromParent();
    }
  }
}
