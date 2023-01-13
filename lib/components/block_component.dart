import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/utils/game_methods.dart';

class BlockComponent extends SpriteComponent {
  final Blocks block;
  final Vector2 blockIndex;
  final int chunkIndex;

  BlockComponent({
    required this.block,
    required this.blockIndex,
    required this.chunkIndex,
  });

  final List<Blocks> _blocksHasHitBox = [
    Blocks.grass,
    Blocks.dirt,
    Blocks.sand,
    Blocks.ironOre,
    Blocks.coalOre,
    Blocks.goldOre,
    Blocks.diamondOre,
  ];

  @override
  Future<void> onLoad() async {
    super.onLoad();
    if(_blocksHasHitBox.contains(block)){
      await add(RectangleHitbox());
    }

    size = GameMethods().blockSize;
    position = Vector2(GameMethods().blockSize.x * blockIndex.x,
        GameMethods().blockSize.y * blockIndex.y);
    sprite = await GameMethods().getSpriteFromBlock(block);
  }

  @override
  void onGameResize(Vector2 size) {
    size = GameMethods().blockSize;
    position = Vector2(GameMethods().blockSize.x * blockIndex.x,
        GameMethods().blockSize.y * blockIndex.y);
    super.onGameResize(size);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!GlobalGameReference()
        .gameReference
        .worldData
        .chunksThatShouldBeRender
        .contains(chunkIndex)) {
      removeFromParent();
      GlobalGameReference()
          .gameReference
          .worldData
          .currentlyRenderedChunks
          .remove(chunkIndex);
    }
  }
}
