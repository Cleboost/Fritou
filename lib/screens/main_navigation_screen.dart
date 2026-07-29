import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fritou/models/bath_entry.dart';
import 'package:fritou/models/oil_type.dart';
import 'package:fritou/screens/fryer_screen.dart';
import 'package:fritou/screens/recipes_screen.dart';
import 'package:fritou/screens/settings_screen.dart';
import 'package:fritou/services/fryer_preferences_service.dart';
import 'package:fritou/services/fryer_state.dart';
import 'package:fritou/widgets/emoji_explosion_overlay.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final FryerPreferencesService _preferencesService = FryerPreferencesService();

  int _currentIndex = 0;
  FryerState _fryerState = FryerState.initial;
  bool _isLoading = true;
  int _explosionTrigger = 0;

  int get _bathCount => _fryerState.bathCount;
  List<BathEntry> get _bathHistory => _fryerState.bathHistory;
  bool get _emojiExplosionEnabled => _fryerState.emojiExplosionEnabled;
  int get _maxBathsLimit => _fryerState.maxBathsLimit;
  String get _selectedOilName => _fryerState.selectedOilName;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final state = await _preferencesService.load();
    if (!mounted) return;
    setState(() {
      _fryerState = state;
      _isLoading = false;
    });
  }

  Future<void> _saveState() async {
    await _preferencesService.save(_fryerState);
  }

  void _updateFryerState(FryerState Function(FryerState current) update) {
    setState(() {
      _fryerState = update(_fryerState);
    });
    _saveState();
  }

  void _addBath() {
    if (_bathCount >= _maxBathsLimit) {
      _showToxicAlert();
      return;
    }

    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final dateStr = '$day/$month/${now.year} à ${hour}h$minute';
    final newBathCount = _bathCount + 1;

    _updateFryerState((current) {
      return current.copyWith(
        bathCount: newBathCount,
        bathHistory: [
          BathEntry(
            id: now.millisecondsSinceEpoch.toString(),
            index: newBathCount,
            date: dateStr,
          ),
          ...current.bathHistory,
        ],
      );
    });
    setState(() {
      _explosionTrigger++;
    });

    HapticFeedback.mediumImpact();
  }

  void _toggleEmojiExplosion(bool value) {
    _updateFryerState((current) => current.copyWith(emojiExplosionEnabled: value));
  }

  void _changeMaxBathsLimit(int value) {
    _updateFryerState((current) => current.copyWith(maxBathsLimit: value));
  }

  void _changeOilName(String name) {
    final oil = availableOils.firstWhere(
      (o) => o.name == name,
      orElse: () => availableOils.first,
    );
    _updateFryerState(
      (current) => current.copyWith(
        selectedOilName: name,
        maxBathsLimit: oil.defaultMaxBaths,
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
              final messenger = ScaffoldMessenger.of(context);
              Navigator.of(context).pop();
              _updateFryerState(
                (current) => current.copyWith(
                  bathCount: 0,
                  bathHistory: const [],
                ),
              );
              HapticFeedback.heavyImpact();
              messenger.clearSnackBars();
              messenger.showSnackBar(
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
        content: Text(
          'Vous avez atteint la limite critique de $_maxBathsLimit bains de friture. Chauffer cette huile produit des composés toxiques nocifs pour la santé.\n\nVous devez impérativement vidanger l\'huile avant de relancer une friture ! 💀',
          style: const TextStyle(height: 1.5, color: Colors.white70),
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

  Color _getOilColor() {
    if (_bathCount == 0) return const Color(0xFFFFE082);
    if (_bathCount <= 3) return const Color(0xFFFFB74D);
    if (_bathCount <= 6) return const Color(0xFFF57C00);
    if (_bathCount <= 8) return const Color(0xFFD84315);
    if (_bathCount == 9) return const Color(0xFFBF360C);
    return const Color(0xFF3E1F1F);
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
      FryerScreen(
        bathCount: _bathCount,
        bathHistory: _bathHistory,
        onAddBath: _addBath,
        onResetFryer: _resetFryer,
        oilColor: _getOilColor(),
        maxBathsLimit: _maxBathsLimit,
      ),
      const RecipesScreen(),
      SettingsScreen(
        emojiExplosionEnabled: _emojiExplosionEnabled,
        onToggleEmojiExplosion: _toggleEmojiExplosion,
        maxBathsLimit: _maxBathsLimit,
        onMaxBathsLimitChanged: _changeMaxBathsLimit,
        selectedOilName: _selectedOilName,
        onOilNameChanged: _changeOilName,
      ),
    ];

    return EmojiExplosionOverlay(
      triggerCount: _explosionTrigger,
      enabled: _emojiExplosionEnabled,
      child: Scaffold(
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
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: 'Paramètres',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
