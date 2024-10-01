import 'package:flame/components.dart';

/// A bullet shot by the player.
class Bullet extends SpriteComponent {
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
