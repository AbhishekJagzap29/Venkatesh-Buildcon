import 'dart:convert';

GetReportResponseModel getReportResponseModelFromJson(String str) =>
    GetReportResponseModel.fromJson(json.decode(str));

String getReportResponseModelToJson(GetReportResponseModel data) =>
    json.encode(data.toJson());

class GetReportResponseModel {
  String? status;
  String? message;
  List<TowerDatum>? towerData;

  GetReportResponseModel({
    this.status,
    this.message,
    this.towerData,
  });

  factory GetReportResponseModel.fromJson(Map<String, dynamic> json) =>
      GetReportResponseModel(
        status: json["status"],
        message: json["message"],
        towerData: List<TowerDatum>.from(
            json["tower_data"].map((x) => TowerDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "tower_data": List<dynamic>.from(towerData!.map((x) => x.toJson())),
      };
}

class TowerDatum {
  String? projectInfoId;
  String? projectName; // New field
  String? userId;
  DateTime? trainingDatedOn;
  String? topicOfTraining;
  String? towerId;
  String? towerName; // New field
  String? trainerName;
  String? trainingStartTime;
  String? trainingEndTime;
  String? totalDuration;
  String? totalManhours;
  String? description;
  String? location; // New field
  List<String>? trainingGivenTo;
  List<String>? overallImages;

  TowerDatum({
    this.projectInfoId,
    this.projectName,
    this.userId,
    this.trainingDatedOn,
    this.topicOfTraining,
    this.towerId,
    this.towerName,
    this.trainerName,
    this.trainingStartTime,
    this.trainingEndTime,
    this.totalDuration,
    this.totalManhours,
    this.description,
    this.location,
    this.trainingGivenTo,
    this.overallImages,
  });

  factory TowerDatum.fromJson(Map<String, dynamic> json) => TowerDatum(
        projectInfoId: json["project_info_id"],
        projectName: json["project_name"] ?? "", // Parse new field
        userId: json["user_id"],
        trainingDatedOn: DateTime.parse(json["training_dated_on"]),
        topicOfTraining: json["topic_of_training"],
        towerId: json["tower_id"],
        towerName: json["tower_name"] ?? "", // Parse new field
        trainerName: json["trainer_name"],
        trainingStartTime: json["training_start_time"],
        trainingEndTime: json["training_end_time"],
        totalDuration: json["total_duration"],
        totalManhours: json["total_manhours"],
        description: json["description"],
        location: json["location"] ?? "", // Parse new field
        trainingGivenTo:
            List<String>.from(json["training_given_to"].map((x) => x)),
        overallImages: List<String>.from(json["overall_images"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "project_info_id": projectInfoId,
        "project_name": projectName, // Serialize new field
        "user_id": userId,
        "training_dated_on":
            "${trainingDatedOn!.year.toString().padLeft(4, '0')}-${trainingDatedOn!.month.toString().padLeft(2, '0')}-${trainingDatedOn!.day.toString().padLeft(2, '0')}",
        "topic_of_training": topicOfTraining,
        "tower_id": towerId,
        "tower_name": towerName, // Serialize new field
        "trainer_name": trainerName,
        "training_start_time": trainingStartTime,
        "training_end_time": trainingEndTime,
        "total_duration": totalDuration,
        "total_manhours": totalManhours,
        "description": description,
        "location": location, // Serialize new field
        "training_given_to": List<dynamic>.from(trainingGivenTo!.map((x) => x)),
        "overall_images": List<dynamic>.from(overallImages!.map((x) => x)),
      };
}
