class ActivityTypeNamesResponseModel {
  String? status;
  String? message;
  List<ActivityTypeName>? data;

  ActivityTypeNamesResponseModel({this.status, this.message, this.data});

  factory ActivityTypeNamesResponseModel.fromJson(Map<String, dynamic> json) {
    return ActivityTypeNamesResponseModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => ActivityTypeName.fromJson(item))
              .toList()
          : null,
    );
  }
}

class ActivityTypeName {
  int? patnId;
  String? name;

  ActivityTypeName({this.patnId, this.name});

  factory ActivityTypeName.fromJson(Map<String, dynamic> json) {
    return ActivityTypeName(
      patnId: json['patn_id'],
      name: json['name'],
    );
  }
}
