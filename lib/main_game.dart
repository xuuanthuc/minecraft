import 'package:flame/game.dart';
import 'package:minecraft/components/block_component.dart';
import 'package:minecraft/components/player_component.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/world_data.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/utils/chunk_generation_methods.dart';
import 'package:minecraft/utils/constants.dart';
import 'package:minecraft/utils/game_methods.dart';

class MainGame extends FlameGame with HasCollisionDetection {
  final WorldData worldData;

  MainGame({required this.worldData}) {
    globalGameReference.gameReference = this;
  }

  GlobalGameReference globalGameReference = GlobalGameReference();

  late PlayerComponent playerComponent;

  @override
  Future<void>? onLoad() {
    playerComponent = PlayerComponent();
    camera.followComponent(playerComponent);
    add(playerComponent);

    GameMethods().addChunkToWorldChunks(
        ChunkGenerationMethods().generateChunk(-1),
        isRightWorldChunk: false);
    GameMethods()
        .addChunkToWorldChunks(ChunkGenerationMethods().generateChunk(0));
    GameMethods()
        .addChunkToWorldChunks(ChunkGenerationMethods().generateChunk(1));
    renderChunk(-1);
    renderChunk(0);
    renderChunk(1);
    return super.onLoad();
  }

  void renderChunk(int chunkIndex) {
    List<List<Blocks?>> chunk = GameMethods().getChunk(chunkIndex);
    chunk.asMap().forEach((yIndex, rowOfBlocks) {
      rowOfBlocks.asMap().forEach((xIndex, block) async {
        if (block != null) {
          add(BlockComponent(
            block: block,
            blockIndex: Vector2((chunkIndex * chunkWidth) + xIndex.toDouble(),
                yIndex.toDouble()),
            chunkIndex: chunkIndex,
          ));
        }
      });
    });
  }

  @override
  void update(double dt) {
    super.update(dt);
    worldData.chunksThatShouldBeRender.asMap().forEach((index, chunkIndex) {
      if (!worldData.currentlyRenderedChunks.contains(chunkIndex)) {
        if (chunkIndex >= 0) {
          if (worldData.rightWorldChunk[0].length ~/ chunkWidth <
              chunkIndex + 1) {
            GameMethods().addChunkToWorldChunks(
                ChunkGenerationMethods().generateChunk(chunkIndex));
          }
        } else {
          if (worldData.leftWorldChunk[0].length ~/ chunkWidth <
              chunkIndex.abs()) {
            GameMethods().addChunkToWorldChunks(
                ChunkGenerationMethods().generateChunk(chunkIndex),
                isRightWorldChunk: false);
          }
        }
        renderChunk(chunkIndex);
        worldData.currentlyRenderedChunks.add(chunkIndex);
      }
    });
  }
}
