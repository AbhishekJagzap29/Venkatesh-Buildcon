/// NEW CODE
import 'dart:convert';

GetFlatFloorDataResponseModel getFlatFloorDataResponseModelFromJson(
        String str) =>
    GetFlatFloorDataResponseModel.fromJson(json.decode(str));

String getFlatFloorDataResponseModelToJson(
        GetFlatFloorDataResponseModel data) =>
    json.encode(data.toJson());

class GetFlatFloorDataResponseModel {
  dynamic status;
  dynamic message;
  TowerData? towerData;

  GetFlatFloorDataResponseModel({
    this.status,
    this.message,
    this.towerData,
  });

  factory GetFlatFloorDataResponseModel.fromJson(Map<String, dynamic> json) =>
      GetFlatFloorDataResponseModel(
        status: json["status"].toString(),
        message: json["message"].toString(),
        towerData: json["tower_data"] == null
            ? null
            : TowerData.fromJson(json["tower_data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "tower_data": towerData?.toJson(),
      };
}

class TowerData {
  dynamic towerName;
  int? towerId;
  double? progress;
  List<ListFloor>? listFloorData;
  List<ListFloor>? listFlatData;
  int? towerTotalCount;
  int? towerMakerCount;
  int? towerCheckerCount;
  int? towerApproverCount;
  int? flatTotalCount;
  int? flatMakerCount;
  int? flatCheckerCount;
  int? flatApproverCount;
  int? floorTotalCount;
  int? floorMakerCount;
  int? floorCheckerCount;
  int? floorApproverCount;

  TowerData({
    this.towerName,
    this.towerId,
    this.progress,
    this.listFloorData,
    this.listFlatData,
    this.towerTotalCount,
    this.towerMakerCount,
    this.towerCheckerCount,
    this.towerApproverCount,
    this.flatTotalCount,
    this.flatMakerCount,
    this.flatCheckerCount,
    this.flatApproverCount,
    this.floorTotalCount,
    this.floorMakerCount,
    this.floorCheckerCount,
    this.floorApproverCount,
  });

  factory TowerData.fromJson(Map<String, dynamic> json) => TowerData(
        towerName: json["tower_name"].toString(),
        towerId: json["tower_id"],
         progress: json["progress"],
        listFloorData: json["list_floor_data"] == null
            ? []
            : List<ListFloor>.from(
                json["list_floor_data"]!.map((x) => ListFloor.fromJson(x))),
        listFlatData: json["list_flat_data"] == null
            ? []
            : List<ListFloor>.from(
                json["list_flat_data"]!.map((x) => ListFloor.fromJson(x))),
        towerTotalCount: json["tower_total_count"],
        towerMakerCount: json["tower_maker_count"],
        towerCheckerCount: json["tower_checker_count"],
        towerApproverCount: json["tower_approver_count"],
        flatTotalCount: json["flat_total_count"],
        flatMakerCount: json["flat_maker_count"],
        flatCheckerCount: json["flat_checker_count"],
        flatApproverCount: json["flat_approver_count"],
        floorTotalCount: json["floor_total_count"],
        floorMakerCount: json["floor_maker_count"],
        floorCheckerCount: json["floor_checker_count"],
        floorApproverCount: json["floor_approver_count"],
      );

  Map<String, dynamic> toJson() => {
        "tower_name": towerName,
        "tower_id": towerId,
        "progress": progress,
        "list_floor_data": listFloorData == null
            ? []
            : List<dynamic>.from(listFloorData!.map((x) => x.toJson())),
        "list_flat_data": listFlatData == null
            ? []
            : List<dynamic>.from(listFlatData!.map((x) => x.toJson())),
        "tower_total_count": towerTotalCount,
        "tower_maker_count": towerMakerCount,
        "tower_checker_count": towerCheckerCount,
        "tower_approver_count": towerApproverCount,
        "flat_total_count": flatTotalCount,
        "flat_maker_count": flatMakerCount,
        "flat_checker_count": flatCheckerCount,
        "flat_approver_count": flatApproverCount,
        "floor_total_count": floorTotalCount,
        "floor_maker_count": floorMakerCount,
        "floor_checker_count": floorCheckerCount,
        "floor_approver_count": floorApproverCount,
      };
}

class ListFloor {
  dynamic name;
  int? floorId;
  String? progress;
  String? totalCount;
  String? makerCount;
  String? checkerCount;
  String? approverCount;

  ListFloor({
    this.name,
    this.floorId,
    this.progress,
    this.totalCount,
    this.approverCount,
    this.checkerCount,
    this.makerCount,
  });

  factory ListFloor.fromJson(Map<String, dynamic> json) => ListFloor(
        name: json["name"].toString(),
        progress: json["progress"].toString(),
        floorId: json["floor_id"] ?? json["flat_id"],
        totalCount: json["total_count"].toString(),
        makerCount: json["maker_count"].toString(),
        checkerCount: json["checker_count"].toString(),
        approverCount: json["approver_count"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "floor_id": floorId,
        "progress": progress,
        "total_count": totalCount,
        "maker_count": makerCount,
        "checker_count": checkerCount,
        "approver_count": approverCount,
      };
}

///
// class ListFloor {
//   bool? name;
//   String? desc;
//   int? activityId;
//   DateTime? writeDate;
//
//   ListFloor({
//     this.name,
//     this.desc,
//     this.activityId,
//     this.writeDate,
//   });
//
//   factory ListFloor.fromJson(Map<String, dynamic> json) => ListFloor(
//         name: json["name"],
//         desc: json["desc"],
//         activityId: json["activity_id"],
//         writeDate: json["write_date"] == null
//             ? null
//             : DateTime.parse(json["write_date"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "name": name,
//         "desc": desc,
//         "activity_id": activityId,
//         "write_date": writeDate?.toIso8601String(),
//       };
// }

/// OLD CODE
//
// import 'dart:convert';
//
// GetFlatFloorDataResponseModel getFlatFloorDataResponseModelFromJson(
//         String str) =>
//     GetFlatFloorDataResponseModel.fromJson(json.decode(str));
//
// String getFlatFloorDataResponseModelToJson(
//         GetFlatFloorDataResponseModel data) =>
//     json.encode(data.toJson());
//
// class GetFlatFloorDataResponseModel {
//   dynamic status;
//   dynamic message;
//   TowerData? towerData;
//
//   GetFlatFloorDataResponseModel({
//     this.status,
//     this.message,
//     this.towerData,
//   });
//
//   factory GetFlatFloorDataResponseModel.fromJson(Map<String, dynamic> json) =>
//       GetFlatFloorDataResponseModel(
//         status: json["status"].toString(),
//         message: json["message"].toString(),
//         towerData: json["tower_data"] == null
//             ? null
//             : TowerData.fromJson(json["tower_data"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "message": message,
//         "tower_data": towerData?.toJson(),
//       };
// }
//
// class TowerData {
//   dynamic towerName;
//   int? towerId;
//   List<ListFloor>? listFloorData;
//   List<ListFloor>? listFlatData;
//
//   TowerData({
//     this.towerName,
//     this.towerId,
//     this.listFloorData,
//     this.listFlatData,
//   });
//
//   factory TowerData.fromJson(Map<String, dynamic> json) => TowerData(
//         towerName: json["tower_name"].toString(),
//         towerId: json["tower_id"],
//         listFloorData: json["list_floor_data"] == null
//             ? []
//             : List<ListFloor>.from(
//                 json["list_floor_data"]!.map((x) => ListFloor.fromJson(x))),
//         listFlatData: json["list_flat_data"] == null
//             ? []
//             : List<ListFloor>.from(
//                 json["list_flat_data"]!.map((x) => ListFloor.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "tower_name": towerName,
//         "tower_id": towerId,
//         "list_floor_data": listFloorData == null
//             ? []
//             : List<dynamic>.from(listFloorData!.map((x) => x.toJson())),
//         "list_flat_data": listFlatData == null
//             ? []
//             : List<dynamic>.from(listFlatData!.map((x) => x.toJson())),
//       };
// }
//
// class ListFloor {
//   dynamic name;
//   int? floorId;
//   String? progress;
//   String? makerCount;
//   String? checkerCount;
//   String? approverCount;
//
//   ListFloor({
//     this.name,
//     this.floorId,
//     this.progress,
//     this.approverCount,
//     this.checkerCount,
//     this.makerCount,
//   });
//
//   factory ListFloor.fromJson(Map<String, dynamic> json) => ListFloor(
//         name: json["name"].toString(),
//         progress: json["progress"].toString(),
//         floorId: json["floor_id"] ?? json["flat_id"],
//         makerCount: json["maker_count"].toString(),
//         checkerCount: json["checker_count"].toString(),
//         approverCount: json["approver_count"].toString(),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "name": name,
//         "floor_id": floorId,
//         "progress": progress,
//         "maker_count": makerCount,
//         "checker_count": checkerCount,
//         "approver_count": approverCount,
//       };
// }
//
// ///
// ///
// ///
// // class ListFloor {
// //   bool? name;
// //   String? desc;
// //   int? activityId;
// //   DateTime? writeDate;
// //
// //   ListFloor({
// //     this.name,
// //     this.desc,
// //     this.activityId,
// //     this.writeDate,
// //   });
// //
// //   factory ListFloor.fromJson(Map<String, dynamic> json) => ListFloor(
// //         name: json["name"],
// //         desc: json["desc"],
// //         activityId: json["activity_id"],
// //         writeDate: json["write_date"] == null
// //             ? null
// //             : DateTime.parse(json["write_date"]),
// //       );
// //
// //   Map<String, dynamic> toJson() => {
// //         "name": name,
// //         "desc": desc,
// //         "activity_id": activityId,
// //         "write_date": writeDate?.toIso8601String(),
// //       };
// // }
