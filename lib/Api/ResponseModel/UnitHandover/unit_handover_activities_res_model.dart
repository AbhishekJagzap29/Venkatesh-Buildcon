class UnitHandoverActivitiesResModel {
  String? status;
  String? message;
  UnitHandoverActivitiesData? data;

  UnitHandoverActivitiesResModel({
    this.status,
    this.message,
    this.data,
  });

  factory UnitHandoverActivitiesResModel.fromJson(Map<String, dynamic> json) {
    var rawData = json['result'] ?? json;
    return UnitHandoverActivitiesResModel(
      status: rawData['status']?.toString(),
      message: rawData['message']?.toString(),
      data: rawData['data'] != null && rawData['data'] is Map<String, dynamic>
          ? UnitHandoverActivitiesData.fromJson(rawData['data'])
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

class UnitHandoverActivitiesData {
  int? handoverLocationId;
  dynamic categoryId;
  String? categoryName;
  List<HandoverActivityLine>? activityLines;

  UnitHandoverActivitiesData({
    this.handoverLocationId,
    this.categoryId,
    this.categoryName,
    this.activityLines,
  });

  int? get categoryIdInt {
    if (categoryId is int) return categoryId as int;
    if (categoryId != null && categoryId != false && categoryId != 'false' && categoryId != 'False') {
      return int.tryParse(categoryId.toString());
    }
    return null;
  }

  factory UnitHandoverActivitiesData.fromJson(Map<String, dynamic> json) {
    return UnitHandoverActivitiesData(
      handoverLocationId: json['handover_location_id'] is int
          ? json['handover_location_id']
          : int.tryParse(json['handover_location_id']?.toString() ?? ''),
      categoryId: json['category_id'],
      categoryName: json['category_name']?.toString(),
      activityLines:
          json['activity_lines'] != null && json['activity_lines'] is List
              ? (json['activity_lines'] as List)
                  .map((e) => HandoverActivityLine.fromJson(e))
                  .toList()
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'handover_location_id': handoverLocationId,
      'category_id': categoryId,
      'category_name': categoryName,
      'activity_lines': activityLines?.map((e) => e.toJson()).toList(),
    };
  }
}

class HandoverActivityLine {
  int? lineId;
  int? activityId;
  String? activityName;
  int? sequence;
  String? status;
  String? statusLabel;
  bool? categorySubmitted;

  HandoverActivityLine({
    this.lineId,
    this.activityId,
    this.activityName,
    this.sequence,
    this.status,
    this.statusLabel,
    this.categorySubmitted,
  });

  factory HandoverActivityLine.fromJson(Map<String, dynamic> json) {
    String? parsedStatus;
    var rawStatus = json['status'];
    if (rawStatus != null &&
        rawStatus != false &&
        rawStatus != 'false' &&
        rawStatus != 'False') {
      parsedStatus = rawStatus.toString();
    }

    String? parsedStatusLabel;
    var rawStatusLabel = json['status_label'];
    if (rawStatusLabel != null &&
        rawStatusLabel != false &&
        rawStatusLabel != 'false' &&
        rawStatusLabel != 'False') {
      parsedStatusLabel = rawStatusLabel.toString();
    }

    return HandoverActivityLine(
      lineId: json['line_id'] is int
          ? json['line_id']
          : int.tryParse(json['line_id']?.toString() ?? ''),
      activityId: json['activity_id'] is int
          ? json['activity_id']
          : int.tryParse(json['activity_id']?.toString() ?? ''),
      activityName: json['activity_name']?.toString(),
      sequence: json['sequence'] is int
          ? json['sequence']
          : int.tryParse(json['sequence']?.toString() ?? ''),
      status: parsedStatus,
      statusLabel: parsedStatusLabel,
      categorySubmitted: json['category_submitted'] is bool
          ? json['category_submitted']
          : (json['category_submitted']?.toString().toLowerCase() == 'true'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'line_id': lineId,
      'activity_id': activityId,
      'activity_name': activityName,
      'sequence': sequence,
      'status': status,
      'status_label': statusLabel,
      'category_submitted': categorySubmitted,
    };
  }
}
