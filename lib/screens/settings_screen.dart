import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final bool emojiExplosionEnabled;
  final ValueChanged<bool> onToggleEmojiExplosion;
  final int maxBathsLimit;
  final ValueChanged<int> onMaxBathsLimitChanged;

  const SettingsScreen({
    super.key,
    required this.emojiExplosionEnabled,
    required this.onToggleEmojiExplosion,
    required this.maxBathsLimit,
    required this.onMaxBathsLimitChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
          ),
        ),
        title: const Text('PARAMÈTRES'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Header Info Card
            Card(
              color: const Color(0xFF1E1C1F),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB74D).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.info_outline_rounded,
                        color: Color(0xFFFFB74D),
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Fritou App v1.0.0',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Votre assistant friture indispensable et sans danger !',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            // Category Section Title 1
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: Text(
                'SÉCURITÉ & HUILE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFFB74D).withOpacity(0.8),
                  letterSpacing: 1.5,
                ),
              ),
            ),
            // Oil Settings Card
            Card(
              color: const Color(0xFF1E1C1F),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB74D).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.opacity_rounded,
                            color: Color(0xFFFFB74D),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Limite maximale de bains',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                'Alerte de vidange recommandée après X bains (recommandé : 10 max).',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: const Color(0xFFFFB74D),
                              inactiveTrackColor: Colors.white.withOpacity(0.1),
                              thumbColor: const Color(0xFFFF7043),
                              overlayColor: const Color(0xFFFF7043).withOpacity(0.2),
                              valueIndicatorColor: const Color(0xFFFF7043),
                              valueIndicatorTextStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: Slider(
                              value: maxBathsLimit.toDouble(),
                              min: 2,
                              max: 10,
                              divisions: 8,
                              label: '$maxBathsLimit bains',
                              onChanged: (value) {
                                onMaxBathsLimitChanged(value.round());
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF7043).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFFFF7043).withOpacity(0.3),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$maxBathsLimit',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFB74D),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('2 bains (strict)', style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.4))),
                          Text('10 bains (toxique)', style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.4))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            // Category Section Title 2
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: Text(
                'ANIMATIONS & EFFETS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFFB74D).withOpacity(0.8),
                  letterSpacing: 1.5,
                ),
              ),
            ),
            // Settings List Card
            Card(
              color: const Color(0xFF1E1C1F),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: emojiExplosionEnabled,
                      onChanged: onToggleEmojiExplosion,
                      secondary: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: emojiExplosionEnabled
                              ? const Color(0xFFFF7043).withOpacity(0.2)
                              : Colors.white.withOpacity(0.05),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          emojiExplosionEnabled
                              ? Icons.auto_awesome_rounded
                              : Icons.auto_awesome_outlined,
                          color: emojiExplosionEnabled
                              ? const Color(0xFFFF7043)
                              : Colors.white60,
                        ),
                      ),
                      activeColor: const Color(0xFFFFB74D),
                      activeTrackColor: const Color(0xFFFF7043).withOpacity(0.4),
                      title: const Text(
                        'Explosion d\'émojis festive',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Text(
                        'Projette des frites et des snacks en l\'air de chaque côté lors de l\'ajout d\'un nouveau bain.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
