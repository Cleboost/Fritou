import 'package:fritou/models/bath_entry.dart';
import 'package:fritou/models/oil_type.dart';

class FryerState {
  final int bathCount;
  final List<BathEntry> bathHistory;
  final bool emojiExplosionEnabled;
  final int maxBathsLimit;
  final String selectedOilName;

  const FryerState({
    required this.bathCount,
    required this.bathHistory,
    required this.emojiExplosionEnabled,
    required this.maxBathsLimit,
    required this.selectedOilName,
  });

  static FryerState get initial => FryerState(
        bathCount: 0,
        bathHistory: const [],
        emojiExplosionEnabled: true,
        maxBathsLimit: availableOils.first.defaultMaxBaths,
        selectedOilName: availableOils.first.name,
      );

  FryerState copyWith({
    int? bathCount,
    List<BathEntry>? bathHistory,
    bool? emojiExplosionEnabled,
    int? maxBathsLimit,
    String? selectedOilName,
  }) {
    return FryerState(
      bathCount: bathCount ?? this.bathCount,
      bathHistory: bathHistory ?? this.bathHistory,
      emojiExplosionEnabled: emojiExplosionEnabled ?? this.emojiExplosionEnabled,
      maxBathsLimit: maxBathsLimit ?? this.maxBathsLimit,
      selectedOilName: selectedOilName ?? this.selectedOilName,
    );
  }
}
