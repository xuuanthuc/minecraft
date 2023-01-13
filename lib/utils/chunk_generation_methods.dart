import 'dart:math';
import 'package:fast_noise/fast_noise.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/resources/biomes.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/resources/ores.dart';
import 'package:minecraft/resources/structures.dart';
import 'package:minecraft/utils/constants.dart';
import 'package:minecraft/utils/game_methods.dart';

import '../structure/tree.dart';

class ChunkGenerationMethods {
  static final ChunkGenerationMethods _instance =
      ChunkGenerationMethods._internal();

  factory ChunkGenerationMethods() {
    return _instance;
  }

  ChunkGenerationMethods._internal();

  List<List<Blocks?>> generateNullChunk() {
    return List.generate(
      chunkHeight,
      (index) => List.generate(chunkWidth, (index) => null),
    );
  }

  List<List<Blocks?>> generateChunk(int chunkIndex) {
    Biomes biome = Random().nextBool() ? Biomes.desert : Biomes.birchForest;

    List<List<Blocks?>> chunk = generateNullChunk();
    List<List<double>> rawNoise = noise2(
      chunkIndex >= 0
          ? chunkWidth * (chunkIndex + 1)
          : chunkWidth * (chunkIndex.abs()),
      1,
      noiseType: NoiseType.Perlin,
      frequency: 0.05,
      seed: chunkIndex >= 0
          ? GlobalGameReference().gameReference.worldData.seed
          : GlobalGameReference().gameReference.worldData.seed + 1,
    );

    final yValues = getYValueFromRawNoise(rawNoise);
    yValues.removeRange(
        0,
        chunkIndex >= 0
            ? chunkWidth * chunkIndex
            : chunkWidth * (chunkIndex.abs() - 1));
    chunk = generatePrimarySoil(chunk, yValues, biome);
    chunk = generateSecondarySoil(chunk, yValues, biome);
    chunk = generateStone(chunk);
    chunk = addStructureChunk(chunk, yValues, biome);
    chunk = addOreToChunk(chunk, Ores.coalOre);
    chunk = addOreToChunk(chunk, Ores.ironOre);
    chunk = addOreToChunk(chunk, Ores.goldOre);
    chunk = addOreToChunk(chunk, Ores.diamondOre);
    return chunk;
  }

  List<List<Blocks?>> generatePrimarySoil(
      List<List<Blocks?>> chunk, List<int> yValue, Biomes biome) {
    yValue.asMap().forEach((index, value) {
      chunk[value][index] = BiomeData.getBiomeDataFor(biome).primarySoil;
    });

    return chunk;
  }

  List<List<Blocks?>> generateSecondarySoil(
      List<List<Blocks?>> chunk, List<int> yValue, Biomes biome) {
    yValue.asMap().forEach((index, value) {
      for (var i = value + 1; i <= GameMethods().maxSecondarySoilExtent; i++) {
        chunk[i][index] = BiomeData.getBiomeDataFor(biome).secondarySoil;
      }
    });

    return chunk;
  }

  List<List<Blocks?>> generateStone(List<List<Blocks?>> chunk) {
    for (int index = 0; index < chunkWidth; index++) {
      for (int i = GameMethods().maxSecondarySoilExtent + 1;
          i < chunk.length;
          i++) {
        chunk[i][index] = Blocks.stone;
      }
    }

    int x1 = Random().nextInt((chunkWidth ~/ 2).toInt());
    int x2 = x1 + Random().nextInt((chunkWidth ~/ 2).toInt());
    chunk[GameMethods().maxSecondarySoilExtent].fillRange(x1, x2, Blocks.stone);

    return chunk;
  }

  List<List<Blocks?>> addStructureChunk(
    List<List<Blocks?>> chunk,
    List<int> yValues,
    Biomes biome,
  ) {
    BiomeData.getBiomeDataFor(biome)
        .generatingStructure
        .asMap()
        .forEach((key, Structure currentStructure) {
      for (var i = 0; i < currentStructure.maxOccurences; i++) {
        List<List<Blocks?>> structureList =
            List.from(currentStructure.structures.reversed);

        int xPositionOfStructure =
            Random().nextInt(chunkWidth - currentStructure.maxWidth);
        int yPositionOfStructure =
            (yValues[xPositionOfStructure + (currentStructure.maxWidth ~/ 2)]) -
                1;

        for (int indexOfRow = 0;
            indexOfRow < currentStructure.structures.length;
            indexOfRow++) {
          List<Blocks?> rowOfBlocksInStructure = structureList[indexOfRow];

          rowOfBlocksInStructure.asMap().forEach((index, blockInStructure) {
            if (chunk[yPositionOfStructure - indexOfRow]
                    [xPositionOfStructure + index] ==
                null) {
              chunk[yPositionOfStructure - indexOfRow]
                  [xPositionOfStructure + index] = blockInStructure;
            }
          });
        }
      }
    });
    return chunk;
  }

  List<int> getYValueFromRawNoise(List<List<double>> rawNoise) {
    List<int> yValues = [];
    rawNoise.asMap().forEach((int index, List<double> value) {
      yValues.add((value[0] * 10).toInt().abs() + GameMethods().freeArea);
    });
    return yValues;
  }

  List<List<Blocks?>> addOreToChunk(List<List<Blocks?>> chunk, Ores ores) {
    List<List<double>> rawNoise = noise2(
      chunkHeight,
      chunkWidth,
      noiseType: NoiseType.Perlin,
      frequency: 0.1,
      seed: Random().nextInt(11000000),
    );

    List<List<int>> processedNoise = GameMethods().processNoise(rawNoise);

    processedNoise
        .asMap()
        .forEach((rowOfProcessedNoiseIndex, rowOfProcessedNoise) {
      rowOfProcessedNoise.asMap().forEach((index, value) {
        if (value < ores.rarity &&
            chunk[rowOfProcessedNoiseIndex][index] == Blocks.stone) {
          chunk[rowOfProcessedNoiseIndex][index] = ores.block;
        }
      });
    });
    return chunk;
  }
}
