class UnitHandoverLocationsResModel {
  String? status;
  String? message;
  UnitHandoverData? data;

  UnitHandoverLocationsResModel({
    this.status,
    this.message,
    this.data,
  });

  factory UnitHandoverLocationsResModel.fromJson(Map<String, dynamic> json) {
    var rawData = json['result'] ?? json;
    return UnitHandoverLocationsResModel(
      status: rawData['status']?.toString(),
      message: rawData['message']?.toString(),
      data: rawData['data'] != null && rawData['data'] is Map<String, dynamic>
          ? UnitHandoverData.fromJson(rawData['data'])
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

class UnitHandoverData {
  int? flatId;
  String? flatName;
  int? projectId;
  String? projectName;
  int? towerId;
  String? towerName;
  String? unitType;
  String? unitTypeLabel;
  int? totalLocationCount;
  int? pendingLocationCount;
  int? submittedLocationCount;
  String? submittedAt;

  List<HandoverLocation>? locations;

  UnitHandoverData({
    this.flatId,
    this.flatName,
    this.projectId,
    this.projectName,
    this.towerId,
    this.towerName,
    this.unitType,
    this.unitTypeLabel,
    this.locations,
    this.totalLocationCount,
    this.pendingLocationCount,
    this.submittedLocationCount,
    this.submittedAt,
  });

  factory UnitHandoverData.fromJson(Map<String, dynamic> json) {
    return UnitHandoverData(
      flatId: json['flat_id'] is int
          ? json['flat_id']
          : int.tryParse(json['flat_id']?.toString() ?? ''),
      flatName: json['flat_name']?.toString(),
      projectId: json['project_id'] is int
          ? json['project_id']
          : int.tryParse(json['project_id']?.toString() ?? ''),
      projectName: json['project_name']?.toString(),
      towerId: json['tower_id'] is int
          ? json['tower_id']
          : int.tryParse(json['tower_id']?.toString() ?? ''),
      towerName: json['tower_name']?.toString(),
      unitType: json['unit_type']?.toString(),
      unitTypeLabel: json['unit_type_label']?.toString(),
      submittedAt: json['submitted_at']?.toString(),
      locations: json['locations'] != null && json['locations'] is List
          ? (json['locations'] as List)
              .map((e) => HandoverLocation.fromJson(e))
              .toList()
          : [],
      totalLocationCount: json['total_location_count'] is int
          ? json['total_location_count']
          : int.tryParse(
              json['total_location_count']?.toString() ?? '',
            ),
      pendingLocationCount: json['pending_location_count'] is int
          ? json['pending_location_count']
          : int.tryParse(
              json['pending_location_count']?.toString() ?? '',
            ),
      submittedLocationCount: json['submitted_location_count'] is int
          ? json['submitted_location_count']
          : int.tryParse(
              json['submitted_location_count']?.toString() ?? '',
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flat_id': flatId,
      'flat_name': flatName,
      'project_id': projectId,
      'project_name': projectName,
      'tower_id': towerId,
      'tower_name': towerName,
      'unit_type': unitType,
      'unit_type_label': unitTypeLabel,
      'locations': locations?.map((e) => e.toJson()).toList(),
      'total_location_count': totalLocationCount,
      'pending_location_count': pendingLocationCount,
      'submitted_location_count': submittedLocationCount,
      'submitted_at': submittedAt,
    };
  }
}

class HandoverLocation {
  int? handoverLocationId;
  int? locationId;
  String? locationName;
  String? state;
  String? stateLabel;
  int? activityCount;
  String? color;
  String? submittedAt;

  HandoverLocation({
    this.handoverLocationId,
    this.locationId,
    this.locationName,
    this.state,
    this.stateLabel,
    this.activityCount,
    this.color,
    this.submittedAt,
  });

  factory HandoverLocation.fromJson(Map<String, dynamic> json) {
    return HandoverLocation(
      handoverLocationId: json['handover_location_id'] is int
          ? json['handover_location_id']
          : int.tryParse(json['handover_location_id']?.toString() ?? ''),
      locationId: json['location_id'] is int
          ? json['location_id']
          : int.tryParse(json['location_id']?.toString() ?? ''),
      locationName: json['location_name']?.toString(),
      state: json['state']?.toString(),
      stateLabel: json['state_label']?.toString(),
      activityCount: json['activity_count'] is int
          ? json['activity_count']
          : int.tryParse(json['activity_count']?.toString() ?? ''),
      color: json['color']?.toString(),
      submittedAt: json['submitted_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'handover_location_id': handoverLocationId,
      'location_id': locationId,
      'location_name': locationName,
      'state': state,
      'state_label': stateLabel,
      'activity_count': activityCount,
      'color': color,
      'submitted_at': submittedAt,
    };
  }
}
