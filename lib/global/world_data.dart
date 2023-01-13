import 'package:minecraft/global/player_data.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/utils/game_methods.dart';

import '../utils/constants.dart';

class WorldData {
  final int seed;

  WorldData({required this.seed});

  PlayerData playerData = PlayerData();

  List<List<Blocks?>> rightWorldChunk = List.generate(chunkHeight, (index) => []);
  List<List<Blocks?>> leftWorldChunk = List.generate(chunkHeight, (index) => []);

  List<int> get chunksThatShouldBeRender{
    return [
      GameMethods().currentChunkIndex - 1,
      GameMethods().currentChunkIndex,
      GameMethods().currentChunkIndex + 1,
    ];
  }

  List<int> currentlyRenderedChunks = [];
}
