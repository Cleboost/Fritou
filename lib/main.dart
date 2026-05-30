import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fritou',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF9800),
          brightness: Brightness.dark,
          primary: const Color(0xFFFFB74D), // Golden fry yellow
          secondary: const Color(0xFFFF7043), // Warm orange
          tertiary: const Color(0xFF8D6E63), // Brownish crisp
          background: const Color(0xFF0F0E0F), // Very dark charcoal
          surface: const Color(0xFF1E1C1F), // Dark card surface
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0E0F),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F0E0F),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFB74D),
            letterSpacing: 1.2,
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E1C1F),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  int _bathCount = 0;
  List<Map<String, dynamic>> _bathHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _bathCount = prefs.getInt('bath_count') ?? 0;
        final historyString = prefs.getString('bath_history');
        if (historyString != null) {
          final decoded = jsonDecode(historyString) as List;
          _bathHistory = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
        }
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading state: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('bath_count', _bathCount);
      await prefs.setString('bath_history', jsonEncode(_bathHistory));
    } catch (e) {
      debugPrint("Error saving state: $e");
    }
  }

  void _addBath() {
    if (_bathCount >= 10) {
      _showToxicAlert();
      return;
    }

    setState(() {
      _bathCount++;
      final now = DateTime.now();
      // Format as DD/MM/YYYY at HH:MM
      final day = now.day.toString().padLeft(2, '0');
      final month = now.month.toString().padLeft(2, '0');
      final hour = now.hour.toString().padLeft(2, '0');
      final minute = now.minute.toString().padLeft(2, '0');
      final dateStr = "$day/$month/${now.year} à ${hour}h$minute";

      _bathHistory.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'index': _bathCount,
        'date': dateStr,
      });
    });
    _saveState();

    // Soft feedback vibration
    HapticFeedback.mediumImpact();

    // Fun snackbar
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Text('🍟 ', style: TextStyle(fontSize: 20)),
            Expanded(
              child: Text(
                _getSuccessMessage(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: _getOilColor().withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _resetFryer() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.cleaning_services_rounded, color: Color(0xFFFFB74D)),
            const SizedBox(width: 10),
            const Text('Vidanger l\'huile ?'),
          ],
        ),
        content: const Text(
          'Êtes-vous sûr de vouloir vider la friteuse ? Cela remettra le compteur de bains à zéro et nettoiera l\'huile.',
          style: TextStyle(height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF7043),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _bathCount = 0;
                _bathHistory.clear();
              });
              _saveState();
              HapticFeedback.heavyImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('✨ Huile vidangée ! Friteuse propre et prête.'),
                  backgroundColor: Colors.green.shade700,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Vidanger'),
          ),
        ],
      ),
    );
  }

  void _showToxicAlert() {
    HapticFeedback.vibrate();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C1010),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.redAccent, width: 2),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 30),
            const SizedBox(width: 10),
            const Text('HUILE TOXIQUE !', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'Vous avez atteint la limite critique de 10 bains de friture. Chauffer cette huile produit des composés toxiques nocifs pour la santé.\n\nVous devez impérativement vidanger l\'huile avant de relancer une friture ! 💀',
          style: TextStyle(height: 1.5, color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              _resetFryer();
            },
            child: const Text('Vidanger maintenant 🧹'),
          ),
        ],
      ),
    );
  }

  String _getSuccessMessage() {
    switch (_bathCount) {
      case 1:
        return 'Premier bain croustillant lancé !';
      case 2:
        return 'Deuxième bain, ça chauffe dur !';
      case 3:
        return 'L\'huile est à point pour de super frites !';
      case 4:
        return 'Bain #4 : Miam, quelle belle couleur !';
      case 5:
        return 'À mi-chemin ! L\'huile est encore bonne.';
      case 6:
        return 'Bain #6 : Ça commence à dorer fort !';
      case 7:
        return 'Bain #7 : L\'huile se fatigue un peu.';
      case 8:
        return 'Bain #8 : Attention, l\'huile commence à brunir !';
      case 9:
        return '🚨 Bain #9 : Dernier bain recommandé !';
      case 10:
        return '⚠️ Bain #10 : LIMITE ATTEINTE ! HUILE À CHANGER !';
      default:
        return 'Bain ajouté !';
    }
  }

  Color _getOilColor() {
    if (_bathCount == 0) return const Color(0xFFFFE082); // Golden translucent yellow
    if (_bathCount <= 3) return const Color(0xFFFFB74D); // Soft warm golden
    if (_bathCount <= 6) return const Color(0xFFF57C00); // Darker amber orange
    if (_bathCount <= 8) return const Color(0xFFD84315); // Dark brownish orange
    if (_bathCount == 9) return const Color(0xFFBF360C); // Dark brownish red
    return const Color(0xFF3E1F1F); // Toxic dark purple/red/black
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFFB74D)),
        ),
      );
    }

    final pages = [
      FryerTab(
        bathCount: _bathCount,
        bathHistory: _bathHistory,
        onAddBath: _addBath,
        onResetFryer: _resetFryer,
        oilColor: _getOilColor(),
      ),
      const RecipesTab(),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.08),
              width: 1,
            ),
          ),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: const Color(0xFFFFB74D).withOpacity(0.2),
            labelTextStyle: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return const TextStyle(
                  color: Color(0xFFFFB74D),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                );
              }
              return TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
              );
            }),
            iconTheme: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return const IconThemeData(
                  color: Color(0xFFFFB74D),
                  size: 26,
                );
              }
              return IconThemeData(
                color: Colors.white.withOpacity(0.6),
                size: 24,
              );
            }),
          ),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: const Color(0xFF0F0E0F),
            height: 70,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.opacity_outlined),
                selectedIcon: Icon(Icons.opacity),
                label: 'Friteuse',
              ),
              NavigationDestination(
                icon: Icon(Icons.menu_book_outlined),
                selectedIcon: Icon(Icons.menu_book),
                label: 'Recettes',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FryerTab extends StatefulWidget {
  final int bathCount;
  final List<Map<String, dynamic>> bathHistory;
  final VoidCallback onAddBath;
  final VoidCallback onResetFryer;
  final Color oilColor;

  const FryerTab({
    super.key,
    required this.bathCount,
    required this.bathHistory,
    required this.onAddBath,
    required this.onResetFryer,
    required this.oilColor,
  });

  @override
  State<FryerTab> createState() => _FryerTabState();
}

class _FryerTabState extends State<FryerTab> with SingleTickerProviderStateMixin {
  late AnimationController _bubbleController;

  @override
  void initState() {
    super.initState();
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    super.dispose();
  }

  String _getHeadline() {
    if (widget.bathCount == 0) return "Friteuse Propre";
    if (widget.bathCount <= 3) return "Qualité Parfaite";
    if (widget.bathCount <= 6) return "Bonne Friture";
    if (widget.bathCount <= 8) return "Huile Fatiguée";
    if (widget.bathCount == 9) return "Dernier Bain !";
    return "TOXIQUE - STOP";
  }

  String _getSubline() {
    if (widget.bathCount == 0) return "Prête pour croustiller ! ✨";
    if (widget.bathCount <= 3) return "L'huile est super dorée. 🍟";
    if (widget.bathCount <= 6) return "Les frites seront succulentes. 🍗";
    if (widget.bathCount <= 8) return "L'huile commence à fatiguer... ⚠️";
    if (widget.bathCount == 9) return "Vidangez bientôt. 🚨";
    return "Ne mangez surtout pas ça ! 💀";
  }

  @override
  Widget build(BuildContext context) {
    final double toxicPercent = math.min(widget.bathCount / 10.0, 1.0);
    final bool isToxic = widget.bathCount >= 10;
    final bool isWarning = widget.bathCount >= 8 && widget.bathCount < 10;

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.local_fire_department, color: Color(0xFFFFB74D)),
        title: const Text('FRITOU'),
        actions: [
          if (widget.bathCount > 0)
            IconButton(
              icon: const Icon(Icons.cleaning_services_rounded, color: Color(0xFFFF7043)),
              onPressed: widget.onResetFryer,
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
                child: Container(
                  width: 230,
                  height: 230,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1E1C1F),
                    border: Border.all(
                      color: isToxic
                          ? Colors.redAccent
                          : isWarning
                              ? const Color(0xFFFF7043)
                              : const Color(0xFFFFB74D).withOpacity(0.5),
                      width: 6,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isToxic
                                ? Colors.redAccent
                                : isWarning
                                    ? const Color(0xFFFF7043)
                                    : const Color(0xFFFFB74D))
                            .withOpacity(0.2),
                        blurRadius: 25,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Stack(
                      children: [
                        // Oil background matching usage status
                        Positioned.fill(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 600),
                            color: widget.oilColor,
                          ),
                        ),
                        // Animated Bubbles
                        Positioned.fill(
                          child: AnimatedBuilder(
                            animation: _bubbleController,
                            builder: (context, child) {
                              return CustomPaint(
                                painter: OilBubblesPainter(
                                  progress: _bubbleController.value,
                                  intensity: widget.bathCount,
                                  isToxic: isToxic,
                                ),
                              );
                            },
                          ),
                        ),
                        // Center circular container with Fry details
                        Center(
                          child: Container(
                            width: 146,
                            height: 146,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF0F0E0F).withOpacity(0.85),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isToxic ? Icons.warning_rounded : Icons.local_fire_department,
                                  size: isToxic ? 36 : 30,
                                  color: isToxic ? Colors.redAccent : const Color(0xFFFFB74D),
                                ),
                                const SizedBox(height: 4),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 600),
                                  transitionBuilder: (Widget child, Animation<double> animation) {
                                    final scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
                                      CurvedAnimation(
                                        parent: animation,
                                        curve: const Interval(0.0, 1.0, curve: Curves.elasticOut),
                                      ),
                                    );
                                    final slideAnimation = Tween<Offset>(
                                      begin: const Offset(0.0, 0.4),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: animation,
                                        curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
                                      ),
                                    );
                                    return ScaleTransition(
                                      scale: scaleAnimation,
                                      child: SlideTransition(
                                        position: slideAnimation,
                                        child: FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    '${widget.bathCount} / 10',
                                    key: ValueKey<int>(widget.bathCount),
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: isToxic
                                          ? Colors.redAccent
                                          : isWarning
                                              ? const Color(0xFFFF7043)
                                              : Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                  widget.bathCount > 1 ? 'bains' : 'bain',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.5),
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                          onPressed: widget.onAddBath,
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
                  if (widget.bathHistory.isNotEmpty)
                    Text(
                      '${widget.bathHistory.length} bains',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 5),
              // History content
              widget.bathHistory.isEmpty
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
                      itemCount: widget.bathHistory.length,
                      itemBuilder: (context, index) {
                        final item = widget.bathHistory[index];
                        final bathIdx = item['index'] as int;
                        final isLast = index == 0;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: isLast
                                ? widget.oilColor.withOpacity(0.15)
                                : const Color(0xFF1E1C1F),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: isLast
                                  ? widget.oilColor.withOpacity(0.4)
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
                              item['date'] ?? '',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 12,
                              ),
                            ),
                            trailing: Icon(
                              bathIdx >= 10
                                  ? Icons.warning_amber_rounded
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

// Custom Painter to draw bubbles in the oil
class OilBubblesPainter extends CustomPainter {
  final double progress;
  final int intensity;
  final bool isToxic;

  OilBubblesPainter({
    required this.progress,
    required this.intensity,
    required this.isToxic,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // The number of bubbles increases with intensity
    final int bubbleCount = 8 + (intensity * 2);
    final math.Random random = math.Random(42); // Seeded random for consistent layout

    for (int i = 0; i < bubbleCount; i++) {
      // Calculate animated vertical position
      final double speed = 0.5 + random.nextDouble() * 1.5;
      final double offset = (progress * speed) % 1.0;
      final double y = size.height * (1.0 - offset);

      // Horizontal position
      final double x = size.width * random.nextDouble();

      // Bubble size
      final double radius = 3.0 + random.nextDouble() * (isToxic ? 12.0 : 7.0);

      // Bubble color
      if (isToxic) {
        paint.color = Colors.greenAccent.withOpacity(0.25 + (random.nextDouble() * 0.25));
      } else {
        paint.color = Colors.white.withOpacity(0.15 + (random.nextDouble() * 0.2));
      }

      // Draw bubble outline & center highlight
      canvas.drawCircle(Offset(x, y), radius, paint);
      
      final highlightPaint = Paint()
        ..color = Colors.white.withOpacity(0.15)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x - radius * 0.3, y - radius * 0.3), radius * 0.25, highlightPaint);
    }
  }

  @override
  bool shouldRepaint(covariant OilBubblesPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.intensity != intensity ||
        oldDelegate.isToxic != isToxic;
  }
}

class RecipesTab extends StatelessWidget {
  const RecipesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> recipes = [
      {
        'title': 'Frites Belges Traditionnelles',
        'subtitle': 'Le secret de la double cuisson croustillante',
        'duration': '45 min',
        'difficulty': 'Facile',
        'temp': '160°C puis 190°C',
        'oil': 'Blanc de bœuf ou Huile d\'arachide',
        'icon': Icons.restaurant_rounded,
        'ingredients': [
          '1.5 kg de pommes de terre (Bintje de préférence)',
          'Graisse de friture (blanc de bœuf traditionnel)',
          'Sel fin',
        ],
        'steps': [
          'Épluchez et découpez les pommes de terre en frites régulières d\'environ 1 cm d\'épaisseur.',
          'Rincez abondamment les frites à l\'eau froide pour enlever l\'amidon, puis séchez-les extrêmement bien avec un torchon propre.',
          'Première cuisson : Plongez les frites dans l\'huile chauffée à 160°C pendant 6 à 8 minutes. Elles doivent être tendres à l\'intérieur mais ne pas dorer. Égouttez-les et laissez-les reposer 30 minutes.',
          'Deuxième cuisson (le coup de feu) : Juste avant de servir, plongez les frites dans l\'huile à 190°C pendant 2 à 3 minutes pour obtenir une croûte bien dorée et croustillante.',
          'Égouttez, salez généreusement dans un grand saladier et dégustez immédiatement !',
        ],
        'tip': 'Ne surchargez jamais le panier de la friteuse pour éviter que la température de l\'huile ne chute !'
      },
      {
        'title': 'Churros Croustillants',
        'subtitle': 'Délicieusement dorés et sucrés',
        'duration': '30 min',
        'difficulty': 'Moyen',
        'temp': '180°C',
        'oil': 'Huile de tournesol',
        'icon': Icons.bakery_dining_rounded,
        'ingredients': [
          '250 ml d\'eau',
          '225 g de farine',
          '60 g de beurre',
          '2 cuillères à soupe de sucre',
          '1 pincée de sel',
          'Sucre en poudre et cannelle pour le saupoudrage',
        ],
        'steps': [
          'Dans une casserole, portez à ébullition l\'eau, le beurre, le sucre et le sel.',
          'Hors du feu, ajoutez la farine en une seule fois. Mélangez vigoureusement avec une spatule en bois jusqu\'à ce que la pâte forme une boule qui se détache des parois.',
          'Laissez tiédir, puis placez la pâte dans une poche à douille solide munie d\'une grosse douille cannelée.',
          'Faites chauffer l\'huile de friture à 180°C.',
          'Pressez la poche au-dessus de la friteuse, coupez des tronçons de pâte de 10 cm avec des ciseaux directement dans l\'huile.',
          'Laissez frire 3 à 4 minutes jusqu\'à ce qu\'ils soient bien dorés. Égouttez et roulez immédiatement dans le mélange sucre-cannelle.',
        ],
        'tip': 'Utilisez une douille étoilée ! Les rayures permettent aux churros de gonfler régulièrement sans éclater dans l\'huile.'
      },
      {
        'title': 'Beignets de Fête Moelleux',
        'subtitle': 'Aériens et irrésistiblement gonflés',
        'duration': '2h 15 min',
        'difficulty': 'Difficile',
        'temp': '170°C',
        'oil': 'Huile de tournesol ou arachide',
        'icon': Icons.cookie_rounded,
        'ingredients': [
          '500 g de farine T45',
          '20 g de levure boulangère fraîche',
          '200 ml de lait tiède',
          '2 œufs',
          '75 g de sucre',
          '75 g de beurre mou',
          '1 pincée de sel',
        ],
        'steps': [
          'Délayez la levure dans le lait tiède avec une cuillère de sucre. Laissez reposer 10 minutes.',
          'Dans le bol du robot, mélangez la farine, le sel, le reste du sucre, les œufs et le mélange lait-levure. Pétrissez pendant 5 minutes.',
          'Ajoutez le beurre mou en morceaux et pétrissez encore 10 minutes jusqu\'à ce que la pâte soit lisse. Laissez lever 1h30 sous un torchon.',
          'Étalez la pâte sur 1.5 cm d\'épaisseur et découpez des disques. Laissez lever à nouveau 30 minutes.',
          'Plongez délicatement les beignets dans l\'huile à 170°C. Faites cuire environ 2 minutes de chaque côté. Ils doivent être bien gonflés et dorés.',
          'Égouttez, passez dans le sucre et garnissez de confiture ou pâte à tartiner avec une seringue.',
        ],
        'tip': 'L\'huile ne doit pas être trop chaude (pas plus de 170°C) pour que l\'intérieur cuise bien sans brûler l\'extérieur.'
      },
      {
        'title': 'Calamars Frits à la Romaine',
        'subtitle': 'Croustillants à l\'extérieur, tendres à l\'intérieur',
        'duration': '20 min',
        'difficulty': 'Facile',
        'temp': '190°C',
        'oil': 'Huile de friture classique',
        'icon': Icons.set_meal_rounded,
        'ingredients': [
          '500 g d\'anneaux de calamars nettoyés',
          '150 g de farine',
          '1 cuillère à café de levure chimique',
          '1 pincée de piment doux',
          '1 citron',
          'Sel et poivre',
        ],
        'steps': [
          'Séchez minutieusement les anneaux de calamars avec du papier absorbant.',
          'Dans un grand sac de congélation, mélangez la farine, la levure, le sel, le poivre et le piment doux.',
          'Mettez les calamars dans le sac et secouez énergiquement pour bien les enrober de farine épicée.',
          'Secouez les calamars dans une passoire pour retirer l\'excédent de farine.',
          'Faites frire dans l\'huile à 190°C par petites quantités pendant seulement 1 à 2 minutes. Ils doivent être légèrement dorés (trop cuits, ils deviennent caoutchouteux).',
          'Servez chaud parsemé de fleur de sel et arrosé de jus de citron pressé.',
        ],
        'tip': 'La levure chimique dans la farine apporte un côté ultra croustillant et léger à la friture !'
      }
    ];

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu_book_rounded, color: Color(0xFFFFB74D)),
        title: const Text('RECETTES SECRÈTES'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        physics: const BouncingScrollPhysics(),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _showRecipeDetails(context, recipe),
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
                          recipe['icon'] as IconData? ?? Icons.restaurant_rounded,
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
                            recipe['title'] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            recipe['subtitle'] ?? '',
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
                                recipe['duration'] ?? '',
                                style: const TextStyle(fontSize: 11, color: Colors.white70),
                              ),
                              const SizedBox(width: 12),
                              const Icon(Icons.thermostat_rounded, size: 14, color: Color(0xFFFF7043)),
                              const SizedBox(width: 4),
                              Text(
                                recipe['temp'] ?? '',
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
        },
      ),
    );
  }

  void _showRecipeDetails(BuildContext context, Map<String, dynamic> recipe) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1C1F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle line
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Header
                    Row(
                      children: [
                        Icon(
                          recipe['icon'] as IconData? ?? Icons.restaurant_rounded,
                          size: 40,
                          color: const Color(0xFFFFB74D),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe['title'] ?? '',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFB74D),
                                ),
                              ),
                              Text(
                                recipe['subtitle'] ?? '',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Badges
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoBadge(Icons.timer_outlined, 'Temps', recipe['duration'] ?? ''),
                        _buildInfoBadge(Icons.speed_rounded, 'Difficulté', recipe['difficulty'] ?? ''),
                        _buildInfoBadge(Icons.thermostat_rounded, 'Température', recipe['temp'] ?? ''),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Ingredients
                    const Text(
                      'Ingrédients',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFB74D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...(recipe['ingredients'] as List<String>).map((ingredient) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              const Icon(Icons.circle, size: 6, color: Color(0xFFFF7043)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  ingredient,
                                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 24),
                    // Cooking tip banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF9800).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xFFFF9800).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.tips_and_updates_rounded, color: Color(0xFFFFB74D), size: 28),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Astuce du Chef',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFFB74D),
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  recipe['tip'] ?? '',
                                  style: const TextStyle(fontSize: 12, color: Colors.white70, height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Steps
                    const Text(
                      'Préparation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFB74D),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...(recipe['steps'] as List<String>).asMap().entries.map((entry) {
                      final idx = entry.key + 1;
                      final stepText = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF7043),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '$idx',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                stepText,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoBadge(IconData icon, String label, String value) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: const Color(0xFFFFB74D)),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.4)),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
