import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fritou/models/bath_entry.dart';
import 'package:fritou/services/fryer_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FryerPreferencesService {
  static const _keyBathCount = 'bath_count';
  static const _keyBathHistory = 'bath_history';
  static const _keyEmojiExplosionEnabled = 'emoji_explosion_enabled';
  static const _keyMaxBathsLimit = 'max_baths_limit';
  static const _keySelectedOilName = 'selected_oil_name';

  Future<FryerState> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final defaults = FryerState.initial;

      final historyString = prefs.getString(_keyBathHistory);
      List<BathEntry> bathHistory = [];
      if (historyString != null) {
        final decoded = jsonDecode(historyString) as List;
        bathHistory = decoded
            .map((e) => BathEntry.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }

      return FryerState(
        bathCount: prefs.getInt(_keyBathCount) ?? defaults.bathCount,
        bathHistory: bathHistory,
        emojiExplosionEnabled:
            prefs.getBool(_keyEmojiExplosionEnabled) ?? defaults.emojiExplosionEnabled,
        maxBathsLimit: prefs.getInt(_keyMaxBathsLimit) ?? defaults.maxBathsLimit,
        selectedOilName: prefs.getString(_keySelectedOilName) ?? defaults.selectedOilName,
      );
    } catch (e) {
      debugPrint('Error loading fryer state: $e');
      return FryerState.initial;
    }
  }

  Future<void> save(FryerState state) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keyBathCount, state.bathCount);
      await prefs.setBool(_keyEmojiExplosionEnabled, state.emojiExplosionEnabled);
      await prefs.setInt(_keyMaxBathsLimit, state.maxBathsLimit);
      await prefs.setString(_keySelectedOilName, state.selectedOilName);
      await prefs.setString(
        _keyBathHistory,
        jsonEncode(state.bathHistory.map((e) => e.toJson()).toList()),
      );
    } catch (e) {
      debugPrint('Error saving fryer state: $e');
    }
  }
}
