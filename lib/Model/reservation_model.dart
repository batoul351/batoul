class ReservationModel {
  final String startTime;
  final String endTime;

  ReservationModel({required this.startTime, required this.endTime});

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      startTime: json['start_time'] ?? 'N/A',
      endTime: json['end_time'] ?? 'N/A',
    );
  }
}
