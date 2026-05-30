class BathEntry {
  final String id;
  final int index;
  final String date;

  BathEntry({
    required this.id,
    required this.index,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'index': index,
        'date': date,
      };

  factory BathEntry.fromJson(Map<String, dynamic> json) => BathEntry(
        id: json['id'] as String,
        index: json['index'] as int,
        date: json['date'] as String,
      );
}
