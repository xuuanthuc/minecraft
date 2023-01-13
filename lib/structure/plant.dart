import 'package:minecraft/resources/blocks.dart';

import '../resources/structures.dart';

Structure cactus = Structure(structures: [
  [Blocks.cactus],
  [Blocks.cactus]
], maxOccurences: 5, maxWidth: 1);

Structure deadBush = Structure.getPlantStructureForBlock(Blocks.deadBush);
Structure grassPlant = Structure.getPlantStructureForBlock(Blocks.grassPlant);
Structure redFlower = Structure.getPlantStructureForBlock(Blocks.redFlower);
Structure purpleFlower =
    Structure.getPlantStructureForBlock(Blocks.purpleFlower);
Structure drippingWhiteFlower =
    Structure.getPlantStructureForBlock(Blocks.drippingWhiteFlower);
Structure yellowFlower =
    Structure.getPlantStructureForBlock(Blocks.yellowFlower);
Structure whiteFlower = Structure.getPlantStructureForBlock(Blocks.whiteFlower);
