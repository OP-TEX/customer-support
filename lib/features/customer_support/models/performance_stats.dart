class PerformanceStats {
  final int responses;

  PerformanceStats({required this.responses});

  factory PerformanceStats.fromJson(dynamic json) {
    return PerformanceStats(
      responses: json is int ? json : int.tryParse(json.toString()) ?? 0,
    );
  }
}
