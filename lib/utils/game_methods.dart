import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/utils/constants.dart';
import 'package:flame/sprite.dart';

class GameMethods {
  static final GameMethods _instance = GameMethods._internal();

  factory GameMethods() {
    return _instance;
  }

  GameMethods._internal();

  Vector2 get blockSize {
    // return Vector2.all(30);
    return Vector2.all(getScreenSize().width / chunkWidth);
  }

  int get freeArea {
    return (chunkHeight * 0.6).toInt();
  }

  int get maxSecondarySoilExtent {
    return freeArea + 6;
  }

  int get gravity => blockSize.x.toInt();

  int get currentChunkIndex {
    return playerXIndexPosition >= 0
        ? playerXIndexPosition ~/ chunkWidth
        : (playerXIndexPosition ~/ chunkWidth) - 1;
  }

  double get playerXIndexPosition {
    return GlobalGameReference().gameReference.playerComponent.position.x /
        blockSize.x;
  }

  Size getScreenSize() {
    return MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;
  }

  Future<SpriteSheet> getBlockSpriteSheet() async {
    return SpriteSheet(
        image: await Flame.images
            .load('sprite_sheets/blocks/block_sprite_sheet.png'),
        srcSize: Vector2.all(60));
  }

  Future<Sprite> getSpriteFromBlock(Blocks block) async {
    SpriteSheet sprite = await getBlockSpriteSheet();
    return sprite.getSprite(0, block.index);
  }

  void addChunkToWorldChunks(List<List<Blocks?>> chunk,
      {bool isRightWorldChunk = true}) {
    if (isRightWorldChunk) {
      chunk.asMap().forEach((yIndex, List<Blocks?> value) {
        GlobalGameReference()
            .gameReference
            .worldData
            .rightWorldChunk[yIndex]
            .addAll(value);
      });
    } else {
      chunk.asMap().forEach((yIndex, List<Blocks?> value) {
        GlobalGameReference()
            .gameReference
            .worldData
            .leftWorldChunk[yIndex]
            .addAll(value);
      });
    }
  }

  List<List<Blocks?>> getChunk(int chunkIndex) {
    List<List<Blocks?>> chunk = [];
    if (chunkIndex >= 0) {
      GlobalGameReference()
          .gameReference
          .worldData
          .rightWorldChunk
          .asMap()
          .forEach((int index, List<Blocks?> rowOfCombineBLocks) {
        chunk.add(rowOfCombineBLocks.sublist(
            chunkIndex * chunkWidth, chunkWidth * (chunkIndex + 1)));
      });
    } else {
      GlobalGameReference()
          .gameReference
          .worldData
          .leftWorldChunk
          .asMap()
          .forEach((int index, List<Blocks?> rowOfCombineBLocks) {
        chunk.add(rowOfCombineBLocks
            .sublist((chunkIndex.abs() - 1) * chunkWidth,
                chunkWidth * (chunkIndex.abs()))
            .reversed
            .toList());
      });
    }
    return chunk;
  }

  List<List<int>> processNoise(List<List<double>> rawNoise) {
    List<List<int>> proccessedNoise = List.generate(rawNoise.length,
        (index) => List.generate(rawNoise[0].length, (index) => 255));
    for (var x = 0; x < rawNoise.length; x++) {
      for (var y = 0; y < rawNoise[0].length; y++) {
        var value = (0x80 + 0x80 * rawNoise[x][y]).floor();
        proccessedNoise[x][y] = value;
      }
    }
    return proccessedNoise;
  }
}
