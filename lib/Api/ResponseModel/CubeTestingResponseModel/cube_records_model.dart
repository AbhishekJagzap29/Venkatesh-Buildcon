class CubeRecordsModel {
  final int id;
  final String cubeId;
  final String dateCasting;
  final String dateTesting;

  CubeRecordsModel({
    required this.id,
    required this.cubeId,
    required this.dateCasting,
    required this.dateTesting,
  });

  factory CubeRecordsModel.fromJson(Map<String, dynamic> json) {
    return CubeRecordsModel(
      id: json['id'] ?? 0,
      cubeId: json['cube_id'] ?? "",
      dateCasting: json['date_casting'] ?? "",
      dateTesting: json['date_testing'] ?? "",
    );
  }
}
