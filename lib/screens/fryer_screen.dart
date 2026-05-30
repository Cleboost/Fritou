import 'package:flutter/material.dart';
import 'package:fritou/models/bath_entry.dart';
import 'package:fritou/widgets/frying_oil_visualizer.dart';

class FryerScreen extends StatelessWidget {
  final int bathCount;
  final List<BathEntry> bathHistory;
  final VoidCallback onAddBath;
  final VoidCallback onResetFryer;
  final Color oilColor;
  final int maxBathsLimit;

  const FryerScreen({
    super.key,
    required this.bathCount,
    required this.bathHistory,
    required this.onAddBath,
    required this.onResetFryer,
    required this.oilColor,
    required this.maxBathsLimit,
  });

  String _getHeadline() {
    if (bathCount == 0) return "Friteuse Propre";
    if (bathCount < (maxBathsLimit / 2)) return "Qualité Parfaite";
    if (bathCount < maxBathsLimit - 1) return "Bonne Friture";
    if (bathCount < maxBathsLimit) return "Dernier Bain !";
    return "TOXIQUE - STOP";
  }

  String _getSubline() {
    if (bathCount == 0) return "Prête pour croustiller ! ✨";
    if (bathCount < (maxBathsLimit / 2)) return "L'huile est super dorée. 🍟";
    if (bathCount < maxBathsLimit - 1) return "Les frites seront succulentes. 🍗";
    if (bathCount < maxBathsLimit) return "Vidangez bientôt. 🚨";
    return "Ne mangez surtout pas ça ! 💀";
  }

  @override
  Widget build(BuildContext context) {
    final double toxicPercent = (bathCount / maxBathsLimit.toDouble()).clamp(0.0, 1.0);
    final bool isToxic = bathCount >= maxBathsLimit;
    final bool isWarning = bathCount >= (maxBathsLimit - 2).clamp(2, 8) && bathCount < maxBathsLimit;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
          ),
        ),
        title: const Text('FRITOU'),
        actions: [
          if (bathCount > 0)
            IconButton(
              icon: const Icon(Icons.cleaning_services_rounded, color: Color(0xFFFF7043)),
              onPressed: onResetFryer,
              tooltip: 'Vidanger la friteuse',
            ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Animated Fryer Bowl
              Center(
                child: FryingOilVisualizer(
                  bathCount: bathCount,
                  oilColor: oilColor,
                  maxBathsLimit: maxBathsLimit,
                ),
              ),
              const SizedBox(height: 20),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: (isToxic
                          ? Colors.redAccent
                          : isWarning
                              ? const Color(0xFFFF7043)
                              : const Color(0xFFFFB74D))
                      .withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: (isToxic
                            ? Colors.redAccent
                            : isWarning
                                ? const Color(0xFFFF7043)
                                : const Color(0xFFFFB74D))
                        .withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isToxic
                            ? Colors.redAccent
                            : isWarning
                                ? const Color(0xFFFF7043)
                                : Colors.green,
                        boxShadow: [
                          BoxShadow(
                            color: (isToxic
                                    ? Colors.redAccent
                                    : isWarning
                                        ? const Color(0xFFFF7043)
                                        : Colors.green)
                                .withOpacity(0.5),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getHeadline().toUpperCase(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isToxic
                            ? Colors.redAccent
                            : isWarning
                                ? const Color(0xFFFF7043)
                                : const Color(0xFFFFB74D),
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _getSubline(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 20),
              // Interactive Action Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        value: toxicPercent,
                        backgroundColor: Colors.white.withOpacity(0.05),
                        color: isToxic
                            ? Colors.redAccent
                            : isWarning
                                ? const Color(0xFFFF7043)
                                : const Color(0xFFFFB74D),
                        minHeight: 12,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Propreté de l\'huile',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                          Text(
                            '${(100 - (toxicPercent * 100)).toInt()}% propre',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isToxic
                                  ? Colors.redAccent
                                  : isWarning
                                      ? const Color(0xFFFF7043)
                                      : const Color(0xFFFFB74D),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isToxic
                                ? Colors.redAccent.withOpacity(0.8)
                                : const Color(0xFFFFB74D),
                            foregroundColor: isToxic ? Colors.white : const Color(0xFF0F0E0F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                          ),
                          onPressed: onAddBath,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isToxic ? '💀 HUILE HORS D\'USAGE' : '🍟 NOUVEAU BAIN DE FRITURE !',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                if (!isToxic) ...[
                                  const SizedBox(width: 8),
                                  const Icon(Icons.add_circle_outline_rounded, size: 20),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Icon(Icons.history_rounded, color: Colors.white54, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Historique de l\'huile actuelle',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const Spacer(),
                  if (bathHistory.isNotEmpty)
                    Text(
                      '${bathHistory.length} bains',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 5),
              // History content
              bathHistory.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cookie_outlined,
                            size: 48,
                            color: Colors.white.withOpacity(0.15),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Aucun bain enregistré dans cette huile',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.3),
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Cliquez sur le bouton ci-dessus pour commencer !',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.2),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 24.0, top: 8.0),
                      itemCount: bathHistory.length,
                      itemBuilder: (context, index) {
                        final item = bathHistory[index];
                        final bathIdx = item.index;
                        final isLast = index == 0;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: isLast
                                ? oilColor.withOpacity(0.15)
                                : const Color(0xFF1E1C1F),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: isLast
                                  ? oilColor.withOpacity(0.4)
                                  : Colors.white.withOpacity(0.04),
                              width: 1.5,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: (bathIdx >= 10
                                        ? Colors.redAccent
                                        : bathIdx >= 8
                                            ? const Color(0xFFFF7043)
                                            : const Color(0xFFFFB74D))
                                    .withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '#$bathIdx',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: bathIdx >= 10
                                        ? Colors.redAccent
                                        : bathIdx >= 8
                                            ? const Color(0xFFFF7043)
                                            : const Color(0xFFFFB74D),
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              'Bain de Friture #$bathIdx',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              item.date,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 12,
                              ),
                            ),
                            trailing: Icon(
                              bathIdx >= 10
                                  ? Icons.warning_rounded
                                  : Icons.check_circle_outline_rounded,
                              color: bathIdx >= 10
                                  ? Colors.redAccent
                                  : bathIdx >= 8
                                      ? const Color(0xFFFF7043)
                                      : Colors.green.shade400,
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
