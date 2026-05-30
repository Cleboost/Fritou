import 'package:flutter/material.dart';

class Recipe {
  final String title;
  final String subtitle;
  final String duration;
  final String difficulty;
  final String temp;
  final String oil;
  final IconData icon;
  final List<String> ingredients;
  final List<String> steps;
  final String tip;

  const Recipe({
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.difficulty,
    required this.temp,
    required this.oil,
    required this.icon,
    required this.ingredients,
    required this.steps,
    required this.tip,
  });
}

const List<Recipe> staticRecipes = [
  Recipe(
    title: 'Frites Belges Traditionnelles',
    subtitle: 'Le secret de la double cuisson croustillante',
    duration: '45 min',
    difficulty: 'Facile',
    temp: '160°C puis 190°C',
    oil: 'Blanc de bœuf ou Huile d\'arachide',
    icon: Icons.restaurant_rounded,
    ingredients: [
      '1.5 kg de pommes de terre (Bintje de préférence)',
      'Graisse de friture (blanc de bœuf traditionnel)',
      'Sel fin',
    ],
    steps: [
      'Épluchez et découpez les pommes de terre en frites régulières d\'environ 1 cm d\'épaisseur.',
      'Rincez abondamment les frites à l\'eau froide pour enlever l\'amidon, puis séchez-les extrêmement bien avec un torchon propre.',
      'Première cuisson : Plongez les frites dans l\'huile chauffée à 160°C pendant 6 à 8 minutes. Elles doivent être tendres à l\'intérieur mais ne pas dorer. Égouttez-les et laissez-les reposer 30 minutes.',
      'Deuxième cuisson (le coup de feu) : Juste avant de servir, plongez les frites dans l\'huile à 190°C pendant 2 à 3 minutes pour obtenir une croûte bien dorée et croustillante.',
      'Égouttez, salez généreusement dans un grand saladier et dégustez immédiatement !',
    ],
    tip: 'Ne surchargez jamais le panier de la friteuse pour éviter que la température de l\'huile ne chute !',
  ),
  Recipe(
    title: 'Churros Croustillants',
    subtitle: 'Délicieusement dorés et sucrés',
    duration: '30 min',
    difficulty: 'Moyen',
    temp: '180°C',
    oil: 'Huile de tournesol',
    icon: Icons.bakery_dining_rounded,
    ingredients: [
      '250 ml d\'eau',
      '225 g de farine',
      '60 g de beurre',
      '2 cuillères à soupe de sucre',
      '1 pincée de sel',
      'Sucre en poudre et cannelle pour le saupoudrage',
    ],
    steps: [
      'Dans une casserole, portez à ébullition l\'eau, le beurre, le sucre et le sel.',
      'Hors du feu, ajoutez la farine en une seule fois. Mélangez vigoureusement avec une spatule en bois jusqu\'à ce que la pâte forme une boule qui se détache des parois.',
      'Laissez tiédir, puis placez la pâte dans une poche à douille solide munie d\'une grosse douille cannelée.',
      'Faites chauffer l\'huile de friture à 180°C.',
      'Pressez la poche au-dessus de la friteuse, coupez des tronçons de pâte de 10 cm avec des ciseaux directement dans l\'huile.',
      'Laissez frire 3 à 4 minutes jusqu\'à ce qu\'ils soient bien dorés. Égouttez et roulez immédiatement dans le mélange sucre-cannelle.',
    ],
    tip: 'Utilisez une douille étoilée ! Les rayures permettent aux churros de gonfler régulièrement sans éclater dans l\'huile.',
  ),
  Recipe(
    title: 'Beignets de Fête Moelleux',
    subtitle: 'Aériens et irrésistiblement gonflés',
    duration: '2h 15 min',
    difficulty: 'Difficile',
    temp: '170°C',
    oil: 'Huile de tournesol ou arachide',
    icon: Icons.cookie_rounded,
    ingredients: [
      '500 g de farine T45',
      '20 g de levure boulangère fraîche',
      '200 ml de lait tiède',
      '2 œufs',
      '75 g de sucre',
      '75 g de beurre mou',
      '1 pincée de sel',
    ],
    steps: [
      'Délayez la levure dans le lait tiède avec une cuillère de sucre. Laissez reposer 10 minutes.',
      'Dans le bol du robot, mélangez la farine, le sel, le reste du sucre, les œufs et le mélange lait-levure. Pétrissez pendant 5 minutes.',
      'Ajoutez le beurre mou en morceaux et pétrissez encore 10 minutes jusqu\'à ce que la pâte soit lisse. Laissez lever 1h30 sous un torchon.',
      'Étalez la pâte sur 1.5 cm d\'épaisseur et découpez des disques. Laissez lever à nouveau 30 minutes.',
      'Plongez délicatement les beignets dans l\'huile à 170°C. Faites cuire environ 2 minutes de chaque côté. Ils doivent être bien gonflés et dorés.',
      'Égouttez, passez dans le sucre et garnissez de confiture ou pâte à tartiner avec une seringue.',
    ],
    tip: 'L\'huile ne doit pas être trop chaude (pas plus de 170°C) pour que l\'intérieur cuise bien sans brûler l\'extérieur.',
  ),
  Recipe(
    title: 'Calamars Frits à la Romaine',
    subtitle: 'Croustillants à l\'extérieur, tendres à l\'intérieur',
    duration: '20 min',
    difficulty: 'Facile',
    temp: '190°C',
    oil: 'Huile de friture classique',
    icon: Icons.set_meal_rounded,
    ingredients: [
      '500 g d\'anneaux de calamars nettoyés',
      '150 g de farine',
      '1 cuillère à café de levure chimique',
      '1 pincée de piment doux',
      '1 citron',
      'Sel et poivre',
    ],
    steps: [
      'Séchez minutieusement les anneaux de calamars avec du papier absorbant.',
      'Dans un grand sac de congélation, mélangez la farine, la levure, le sel, le poivre et le piment doux.',
      'Mettez les calamars dans le sac et secouez énergiquement pour bien les enrober de farine épicée.',
      'Secouez les calamars dans une passoire pour retirer l\'excédent de farine.',
      'Faites frire dans l\'huile à 190°C par petites quantités pendant seulement 1 à 2 minutes. Ils doivent être légèrement dorés (trop cuits, ils deviennent caoutchouteux).',
      'Servez chaud parsemé de fleur de sel et arrosé de jus de citron pressé.',
    ],
    tip: 'La levure chimique dans la farine apporte un côté ultra croustillant et léger à la friture !',
  ),
];
