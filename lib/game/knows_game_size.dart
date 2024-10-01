import 'package:flame/components.dart';

mixin KnowsGameSize on Component {
  late Vector2 gamesize;
  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    gamesize = size;
  }
}
