import 'dart:convert';

ActivityAsPerTypeResponseModel activityTypeResponseModelFromJson(String str) =>
    ActivityAsPerTypeResponseModel.fromJson(json.decode(str));

class ActivityAsPerTypeResponseModel {
  String? status;
  String? message;
  List<ActivityTypesChecklist>? activityTypesChecklist;

  ActivityAsPerTypeResponseModel({
    this.status,
    this.message,
    this.activityTypesChecklist,
  });

  factory ActivityAsPerTypeResponseModel.fromJson(Map<String, dynamic> json) =>
      ActivityAsPerTypeResponseModel(
        status: json["status"],
        message: json["message"],
        activityTypesChecklist: json["data"] == null
            ? []
            : List<ActivityTypesChecklist>.from(
                json["data"].map((x) => ActivityTypesChecklist.fromJson(x))),
      );
}

class ActivityTypesChecklist {
  
  int?  id;
  String name; 

  ActivityTypesChecklist({required this.id, required this.name});

  factory ActivityTypesChecklist.fromJson(Map<String, dynamic> json) => ActivityTypesChecklist(
        id: json["patn_id"],
        name: json['name'] ?? '',
      );

}


