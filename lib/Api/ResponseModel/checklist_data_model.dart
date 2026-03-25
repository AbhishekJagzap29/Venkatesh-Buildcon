import 'dart:convert';

ChecklistDataResponseModel checklistDataResponseModelFromJson(String str) =>
    ChecklistDataResponseModel.fromJson(json.decode(str));

String checklistDataResponseModelToJson(ChecklistDataResponseModel data) =>
    json.encode(data.toJson());

class ChecklistDataResponseModel {
  String? status;
  String? message;
  List<ActivityChecklistDataForApprover>? activityChecklistData;

  ChecklistDataResponseModel({
    this.status,
    this.message,
    this.activityChecklistData,
  });

  factory ChecklistDataResponseModel.fromJson(Map<String, dynamic> json) =>
      ChecklistDataResponseModel(
        status: json["status"] as String?,
        message: json["message"] as String?,
        activityChecklistData: json["data"] == null
            ? null
            : List<ActivityChecklistDataForApprover>.from(
                json["data"]
                    .map((x) => ActivityChecklistDataForApprover.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": activityChecklistData?.map((x) => x.toJson()).toList(),
      };
}

class ActivityChecklistDataForApprover {
  String? name;
  int? activity_id; 

  ActivityChecklistDataForApprover({
    this.name,
    this.activity_id,
  });

  factory ActivityChecklistDataForApprover.fromJson(Map<String, dynamic> json) =>
      ActivityChecklistDataForApprover(
        name: json["name"] as String?,
        activity_id: json["activity_id"] as int?,

      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "activity_id": activity_id,
      };
}


