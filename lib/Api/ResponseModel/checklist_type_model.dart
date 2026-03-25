import 'dart:convert';

ActivityTypeResponseModel activityTypeResponseModelFromJson(String str) =>
    ActivityTypeResponseModel.fromJson(json.decode(str));

class ActivityTypeResponseModel {
  String? status;
  String? message;
  List<ActivityType>? activityTypes;

  ActivityTypeResponseModel({
    this.status,
    this.message,
    this.activityTypes,
  });

  factory ActivityTypeResponseModel.fromJson(Map<String, dynamic> json) =>
      ActivityTypeResponseModel(
        status: json["status"],
        message: json["message"],
        activityTypes: json["data"] == null
            ? []
            : List<ActivityType>.from(
                json["data"].map((x) => ActivityType.fromJson(x))),
      );
}

class ActivityType {
// int activity_id;
 String name;
 int patn_id;
 

  ActivityType({ //required this.activity_id,
  required this.name, required this.patn_id});

  factory ActivityType.fromJson(Map<String, dynamic> json) => ActivityType(
   // activity_id: json["activity_id"],
       name: json["name"],
      patn_id: json["patn_id"],

      );


}


