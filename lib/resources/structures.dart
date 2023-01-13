import 'blocks.dart';

class Structure {
  final List<List<Blocks?>> structures;
  final int maxOccurences;
  final int maxWidth;

  Structure({
    required this.structures,
    required this.maxOccurences,
    required this.maxWidth,
  });

  factory Structure.getPlantStructureForBlock(Blocks block) => Structure(structures: [[block]], maxOccurences: 2, maxWidth: 1);
}
