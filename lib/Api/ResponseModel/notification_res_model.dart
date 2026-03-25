import 'dart:convert';
import 'dart:developer';

NotificationResModel notificationResModelFromJson(String str) =>
    NotificationResModel.fromJson(json.decode(str));

String notificationResModelToJson(NotificationResModel data) =>
    json.encode(data.toJson());

class NotificationResModel {
  String? status;
  String? message;
  List<NotificationData>? notificationData;

  NotificationResModel({
    this.status,
    this.message,
    this.notificationData,
  });

  factory NotificationResModel.fromJson(Map<String, dynamic> json) =>
      NotificationResModel(
        status: json["status"],
        message: json["message"],
        notificationData: json["notification_data"] == null
            ? []
            : List<NotificationData>.from(json["notification_data"]!
                .map((x) => NotificationData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "notification_data": notificationData == null
            ? []
            : List<dynamic>.from(notificationData!.map((x) => x.toJson())),
      };
}
class NotificationData {
  int? id;
  String? title;
  DateTime? notificationDt;
  String? redirectId;
  String? ncId;
  String? seq_no;
  String? detailLine;
  String? checklistStatus;
  String? checklistStatusTwo;
  String? towerId;
  String? projectId;
  int? activityId;
  String? activityName;
  bool? isSubmitted;
  //08/12
  String? approverRemark;

  
  NotificationData({
    this.id,
    this.title,
    this.notificationDt,
    this.redirectId,
    this.ncId,
    this.seq_no,
    this.detailLine,
    this.checklistStatus,
    this.checklistStatusTwo,
    this.towerId,
    this.projectId,
    this.activityId,
    this.activityName,
    this.isSubmitted,
    //08/12
    this.approverRemark,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json["id"] is bool ? (json["id"] ? 1 : 0) : json["id"],
      title: json["title"].toString(),
      notificationDt: json["notification_dt"] == null
          ? null
          : DateTime.tryParse(json["notification_dt"]),
      redirectId: json["redirect_id"]?.toString() ?? '',
      ncId: json["nc_id"]?.toString() ?? '',
      seq_no: (json["seq_no"] ?? 0).toString(),
      detailLine: json["detail_line"] ?? '',
      checklistStatus: json["checklist_status"] ?? '',
      checklistStatusTwo: json["checklist_status_two"] ?? '',
      towerId: (json["tower_id"] ?? 0).toString(),
      projectId: (json["project_id"] ?? 0).toString(),
      activityId:
          json["activity_id"] is bool ? (json["activity_id"] ? 1 : 0) : json["activity_id"],
      activityName: json["activity_name"].toString(),
      //08/12
      approverRemark: json["approver_remark"]?.toString() ?? '',



    );
  }

  Map<String, dynamic> toJson() =>  {
        "id": id,
        "title": title,
        "notification_dt": notificationDt?.toIso8601String(),
        "redirect_id": redirectId,
        "nc_id": ncId,
        "seq_no": seq_no,
        "detail_line": detailLine,
        "checklist_status": checklistStatus,
        "checklist_status_two": checklistStatusTwo,
        "tower_id": towerId,
        "project_id": projectId,
        "activity_id": activityId,
        "activity_name": activityName,
        //08/12
        "approver_remark": approverRemark,

      };
}















// class NotificationData {
//   int? id;
//   dynamic title;
//   DateTime? notificationDt;
//   String? redirectId;
//   String? seq_no;
//   String? detailLine;
//   String? checklistStatus;
//   String? towerId;
//   String? projectId;
//   int? activityId;
//   String? activityName;
//   bool? isSubmitted;



//   NotificationData({
//     this.id,
//     this.title,
//     this.notificationDt,
//     this.redirectId,
//     this.seq_no,
//     this.detailLine,
//     this.checklistStatus,
//     this.towerId,
//     this.projectId,
//     this.activityId,
//     this.activityName,
//     this.isSubmitted,

//   });

//   factory NotificationData.fromJson(Map<String, dynamic> json) {
//     return NotificationData(
//        id: json["id"] is bool ? (json["id"] ? 1 : 0) : json["id"],  
//     title: json["title"].toString(),
//     notificationDt: json["notification_dt"] == null
//         ? null
//         : DateTime.tryParse(json["notification_dt"]),  
//     redirectId: json["redirect_id"] is bool ? (json["redirect_id"] ? "1" : "0") : json["redirect_id"],
//     seq_no: (json["seq_no"] ?? 0).toString(),
//     detailLine: json["detail_line"] ?? '',
//     checklistStatus: json["checklist_status"] ?? '',
//     towerId: (json["tower_id"] ?? 0).toString(),
//     projectId: (json["project_id"] ?? 0).toString(),
//     activityId: json["activity_id"] is bool ? (json["activity_id"] ? 1 : 0) : json["activity_id"],  
//     activityName: json["activity_name"].toString(),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "title": title,
//         "notification_dt": notificationDt?.toIso8601String(),
//         "redirect_id": redirectId,
//         "seq_no": seq_no,
//         "detail_line": detailLine,
//         "checklist_status": checklistStatus,
//         "tower_id": towerId,
//         "project_id": projectId,
//         "activity_id": activityId,
//         "activity_name": activityName,
//       };
// }
