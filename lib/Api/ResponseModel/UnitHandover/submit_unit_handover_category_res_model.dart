class SubmitUnitHandoverCategoryResModel {
  String? status;
  String? message;
  SubmitUnitHandoverCategoryData? data;

  SubmitUnitHandoverCategoryResModel({
    this.status,
    this.message,
    this.data,
  });

  factory SubmitUnitHandoverCategoryResModel.fromJson(
      Map<String, dynamic> json) {
    var rawData = json['result'] ?? json;
    return SubmitUnitHandoverCategoryResModel(
      status: rawData['status']?.toString(),
      message: rawData['message']?.toString(),
      data: rawData['data'] != null && rawData['data'] is Map<String, dynamic>
          ? SubmitUnitHandoverCategoryData.fromJson(rawData['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class SubmitUnitHandoverCategoryData {
  int? handoverLocationId;
  dynamic categoryId;
  String? categoryName;
  bool? submitted;
  String? locationState;

  SubmitUnitHandoverCategoryData({
    this.handoverLocationId,
    this.categoryId,
    this.categoryName,
    this.submitted,
    this.locationState,
  });

  factory SubmitUnitHandoverCategoryData.fromJson(Map<String, dynamic> json) {
    return SubmitUnitHandoverCategoryData(
      handoverLocationId: json['handover_location_id'] is int
          ? json['handover_location_id']
          : int.tryParse(json['handover_location_id']?.toString() ?? ''),
      categoryId: json['category_id'],
      categoryName: json['category_name']?.toString(),
      submitted: json['submitted'] is bool
          ? json['submitted']
          : (json['submitted']?.toString().toLowerCase() == 'true'),
      locationState: json['location_state']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'handover_location_id': handoverLocationId,
      'category_id': categoryId,
      'category_name': categoryName,
      'submitted': submitted,
      'location_state': locationState,
    };
  }
}
