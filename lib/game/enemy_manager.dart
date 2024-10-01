import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:starlance/game/enemy.dart';
import 'package:starlance/game/knows_game_size.dart';
import 'package:starlance/game/starlance.dart';

class EnemyManager extends Component with KnowsGameSize, HasGameRef<Starlance> {
  // Timer that triggers the spawn of a new enemy
  late Timer timer;
  // Random number generator
  Random random = Random();
  // Sprite sheet to use for the enemies
  SpriteSheet spriteSheet;
  EnemyManager({required this.spriteSheet}) : super() {
    // Set up the timer to spawn a new enemy every second
    timer = Timer(1, onTick: _spawnEnemy, repeat: true);
  }

  // Function called when the timer triggers
  void _spawnEnemy() {
    // Size of the enemy
    Vector2 initialSize = Vector2(64, 64);
    // Position of the enemy
    Vector2 position = Vector2(random.nextDouble() * gamesize.x, 0);

    // Make sure the enemy is within the screen
    position.clamp(
        Vector2.zero() + initialSize / 2, gamesize - initialSize / 2);
    // Create the enemy
    Enemy enemy = Enemy(
      spriteSheet.getSpriteById(3),
      initialSize,
      position,
    );
    // Center the enemy
    enemy.anchor = Anchor.center;
    // Add the enemy to the game
    add(enemy);
  }

  // When the component is mounted (added to the game tree)
  @override
  void onMount() {
    super.onMount();
    // Start the timer
    timer.start();
  }

  // When the component is removed from the game tree
  @override
  void onRemove() {
    super.onRemove();
    // Stop the timer
    timer.stop();
  }

  // Called every frame
  @override
  void update(double dt) {
    super.update(dt);
    // Update the timer
    timer.update(dt);
  }
}
