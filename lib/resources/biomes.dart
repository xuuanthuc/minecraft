import 'package:flame/components.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/resources/structures.dart';
import 'package:minecraft/structure/tree.dart';

import '../structure/plant.dart';

enum Biomes { desert, birchForest }

class BiomeData {
  final Blocks primarySoil;
  final Blocks secondarySoil;
  final List<Structure> generatingStructure;

  BiomeData({
    required this.primarySoil,
    required this.secondarySoil,
    required this.generatingStructure,
  });

  factory BiomeData.getBiomeDataFor(Biomes biomes) {
    switch (biomes) {
      case Biomes.desert:
        return BiomeData(
            primarySoil: Blocks.sand,
            secondarySoil: Blocks.sand,
            generatingStructure: [
              deadBush,
              cactus,
            ]);
      case Biomes.birchForest:
        return BiomeData(
            primarySoil: Blocks.grass,
            secondarySoil: Blocks.dirt,
            generatingStructure: [
              birchTree,
              grassPlant,
              redFlower,
              purpleFlower,
              drippingWhiteFlower,
              yellowFlower,
              whiteFlower
            ]);
    }
  }
}
