class UnitHandoverCategoriesResModel {
  String? status;
  String? message;
  UnitHandoverCategoriesData? data;

  UnitHandoverCategoriesResModel({
    this.status,
    this.message,
    this.data,
  });

  factory UnitHandoverCategoriesResModel.fromJson(Map<String, dynamic> json) {
    var rawData = json['result'] ?? json;
    return UnitHandoverCategoriesResModel(
      status: rawData['status']?.toString(),
      message: rawData['message']?.toString(),
      data: rawData['data'] != null && rawData['data'] is Map<String, dynamic>
          ? UnitHandoverCategoriesData.fromJson(rawData['data'])
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

class UnitHandoverCategoriesData {
  int? handoverLocationId;
  String? locationName;
    String? submittedAt;

  List<HandoverCategory>? categories;

  UnitHandoverCategoriesData({
    this.handoverLocationId,
    this.locationName,
    this.categories,
    this.submittedAt,
  });

  factory UnitHandoverCategoriesData.fromJson(Map<String, dynamic> json) {
    return UnitHandoverCategoriesData(
      handoverLocationId: json['handover_location_id'] is int
          ? json['handover_location_id']
          : int.tryParse(json['handover_location_id']?.toString() ?? ''),
      locationName: json['location_name']?.toString(),
      submittedAt: json['submitted_at'] is String
          ? json['submitted_at']
          : null,

      categories: json['categories'] != null && json['categories'] is List
          ? (json['categories'] as List)
              .map((e) => HandoverCategory.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'handover_location_id': handoverLocationId,
      'location_name': locationName,
      'categories': categories?.map((e) => e.toJson()).toList(),
            'submitted_at': submittedAt,

    };
  }
}

class HandoverCategory {
  int? categoryId;
  String? categoryName;
  int? sequence;
  int? activityCount;
  bool? submitted;
  String? color;
      String? submittedAt;


  HandoverCategory({
    this.categoryId,
    this.categoryName,
    this.sequence,
    this.activityCount,
    this.submitted,
    this.color,
    this.submittedAt,
  });

  factory HandoverCategory.fromJson(Map<String, dynamic> json) {
    return HandoverCategory(
      categoryId: json['category_id'] is int
          ? json['category_id']
          : int.tryParse(
              json['category_id']?.toString() ?? '',
            ),
      categoryName: json['category_name']?.toString(),
      sequence: json['sequence'] is int
          ? json['sequence']
          : int.tryParse(
              json['sequence']?.toString() ?? '',
            ),
      activityCount: json['activity_count'] is int
          ? json['activity_count']
          : int.tryParse(
              json['activity_count']?.toString() ?? '',
            ),
      submitted: json['submitted'] is bool
          ? json['submitted']
          : (json['submitted']?.toString().toLowerCase() == 'true'),
      color: json['color']?.toString(),
        submittedAt: json['submitted_at'] is String
          ? json['submitted_at']
          : null,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'category_name': categoryName,
      'sequence': sequence,
      'activity_count': activityCount,
      'submitted': submitted,
      'color': color,
                  'submitted_at': submittedAt,

    };
  }
}
