import 'package:flutter/material.dart';
import 'package:fritou/data/recipes_data.dart';
import 'package:fritou/widgets/recipe_detail_sheet.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => RecipeDetailSheet.show(context, recipe),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB74D).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Icon(
                    recipe.icon,
                    size: 30,
                    color: const Color(0xFFFFB74D),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      recipe.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, size: 14, color: Color(0xFFFFB74D)),
                        const SizedBox(width: 4),
                        Text(
                          recipe.duration,
                          style: const TextStyle(fontSize: 11, color: Colors.white70),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.thermostat_rounded, size: 14, color: Color(0xFFFF7043)),
                        const SizedBox(width: 4),
                        Text(
                          recipe.temp,
                          style: const TextStyle(fontSize: 11, color: Colors.white70),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withOpacity(0.3),
              )
            ],
          ),
        ),
      ),
    );
  }
}
