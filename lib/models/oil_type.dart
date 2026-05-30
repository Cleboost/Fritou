class OilType {
  final String name;
  final String description;
  final int defaultMaxBaths;
  final String icon;

  const OilType({
    required this.name,
    required this.description,
    required this.defaultMaxBaths,
    required this.icon,
  });
}

const List<OilType> availableOils = [
  OilType(
    name: 'Blanc de bœuf',
    description: 'Traditionnel belge. Très stable à haute température.',
    defaultMaxBaths: 10,
    icon: '🐄',
  ),
  OilType(
    name: 'Huile d\'Arachide',
    description: 'Très résistante, idéale pour les frites dorées.',
    defaultMaxBaths: 8,
    icon: '🥜',
  ),
  OilType(
    name: 'Huile de Tournesol',
    description: 'Classique et légère, mais se dégrade plus rapidement.',
    defaultMaxBaths: 5,
    icon: '🌻',
  ),
];
