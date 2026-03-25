// get_checklist_by_activity_res_model.dart (modified)
import 'dart:convert';

import 'package:flutter/material.dart';

ChecklistByActivityResponseModel checklistByActivityResponseModelFromJson(
        String str) =>
    ChecklistByActivityResponseModel.fromJson(json.decode(str));

String checklistByActivityResponseModelToJson(
        ChecklistByActivityResponseModel data) =>
    json.encode(data.toJson());

class ChecklistByActivityResponseModel {
  String? status;
  String? message;
  ChecklistData? checklistData;

  ChecklistByActivityResponseModel({
    this.status,
    this.message,
    this.checklistData,
  });

  factory ChecklistByActivityResponseModel.fromJson(
          Map<String, dynamic> json) =>
      ChecklistByActivityResponseModel(
        status: json["status"].toString(),
        message: json["message"].toString(),
        checklistData: json["checklist_data"] == null
            ? null
            : ChecklistData.fromJson(json["checklist_data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "checklist_data": checklistData?.toJson(),
      };
}

class ChecklistData {
  String? activityName;
  int? activityId;
  List<ListChecklistDataByAc>? listChecklistData;

  ChecklistData({
    this.activityName,
    this.activityId,
    this.listChecklistData,
  });

  factory ChecklistData.fromJson(Map<String, dynamic> json) => ChecklistData(
        activityName: json["activity_name"].toString(),
        activityId: json["activity_id"],
        listChecklistData: json["list_checklist_data"] == null
            ? []
            : List<ListChecklistDataByAc>.from(json["list_checklist_data"]!
                .map((x) => ListChecklistDataByAc.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "activity_name": activityName,
        "activity_id": activityId,
        "list_checklist_data": listChecklistData == null
            ? []
            : List<dynamic>.from(listChecklistData!.map((x) => x.toJson())),
      };
}

class ListChecklistDataByAc {
  String? name;
  String? activity_name;
  String? activityStatus;
  int? checklistId;
  int? activityTypeId;
  String? activityTypeProgress;
  List<LineData>? lineData;
  String? projectId;
  String? projectName;
  String? flat;
  String? flatName;
  String? towerId;
  String? towerName;
  dynamic floodId;
  dynamic flooName;
  List? overallImagesList;
  List<String>? overallImgDescs;
  String? color;
  String? wiStatus;
  String? makerRemark;
  String? checkerRemark;
  String? approverRemark;
  // String? rejectStatus;

  ListChecklistDataByAc({
    this.name,
    this.activity_name,
    this.activityStatus,
    this.checklistId,
    this.activityTypeId,
    this.lineData,
    this.activityTypeProgress,
    this.projectId,
    this.towerName,
    this.flat,
    this.flatName,
    this.floodId,
    this.flooName,
    this.projectName,
    this.towerId,
    this.overallImagesList,
    this.overallImgDescs,
    this.color,
    this.wiStatus,
    this.makerRemark,
    this.checkerRemark,
    this.approverRemark,
  });

  factory ListChecklistDataByAc.fromJson(Map<String, dynamic> json) {
    List<dynamic> overallImages = json["overall_images"] ?? [];
    List<String> overallUrls = [];
    List<String> overallDescs = [];
    for (var img in overallImages) {
      String url = '';
      String desc = '';
      if (img is Map<String, dynamic>) {
        url = img['url'] ?? '';
        desc = img['img_desc'] ?? '';
      } else if (img is String) {
        url = img;
        desc = '';
      }
      if (url.isNotEmpty) {
        overallUrls.add(url);
        overallDescs.add(desc);
      }
    }

    return ListChecklistDataByAc(
      projectId: json["project_id"].toString(),
      activity_name: json["activity_name"].toString(),
      projectName: json["project_name"].toString(),
      flat: json["flat"].toString(),
      flatName: json["flat_name"].toString(),
      towerId: json["tower_id"].toString(),
      towerName: json["tower_name"].toString(),
      floodId: json["floor_id"].toString(),
      flooName: json["floor_name"].toString(),
      name: json["name"].toString(),
      checklistId: json["checklist_id"],
      activityTypeId: json["activity_type_id"],
      activityStatus: json["activity_status"].toString(),
      activityTypeProgress: json["activity_type_progress"].toString(),
      lineData: json["line_data"] == null
          ? []
          : List<LineData>.from(
              json["line_data"]!.map((x) => LineData.fromJson(x))),
      overallImagesList: overallUrls,
      overallImgDescs: overallDescs,
      color: json["color"] ?? '',
      wiStatus: json["wi_status"] ?? '',
      makerRemark: json["overall_remarks_maker"]?.toString() ?? "",
      checkerRemark: json["overall_remarks_checker"]?.toString() ?? "",
      approverRemark: json["overall_remarks_approver"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "project_id": projectId,
        "activity_name": activity_name,
        "project_name": projectName,
        "flat": flat,
        "flat_name": flatName,
        "tower_id": towerId,
        "tower_name": towerName,
        "floor_id": floodId,
        "floor_name": flooName,
        "name": name,
        "activity_status": activityStatus,
        "checklist_id": checklistId,
        "activity_type_progress": activityTypeProgress,
        "activity_type_id": activityTypeId,
        "line_data": lineData == null
            ? []
            : List<dynamic>.from(lineData!.map((x) => x.toJson())),
        "overall_images": overallImagesList ?? [],
        "overall_image_descs": overallImgDescs == null
            ? []
            : List<dynamic>.from(overallImgDescs!.map((x) => x)),
        "color": color,
        "wi_status": wiStatus,
        "overall_remarks_maker": makerRemark,
        "overall_remarks_checker": checkerRemark,
        "overall_remarks_approver": approverRemark,
      };
}

class LineData {
  dynamic name;
  int? lineId;
  TextEditingController controller;
  List imageList;
  List imageData;
  String value = "Yes";
  dynamic reason;
  List<History>? history;
  // String? imgDesc;
  List<String>? imgDescs;

  LineData(
      {this.name,
      this.lineId,
      required this.controller,
      required this.imageList,
      required this.imageData,
      //this.imgDesc,
      this.imgDescs,
      this.value = "Yes",
      this.history,
      this.reason});

  factory LineData.fromJson(Map<String, dynamic> json) {
    var images = json["image_url"] ?? json["image_urls"] ?? [];
    List<String> urls = [];
    List<String> descs = [];
    for (var img in images) {
      String url = '';
      String desc = '';
      if (img is Map<String, dynamic>) {
        url = img['url'] ?? '';
        desc = img['img_desc'] ?? '';
      } else if (img is String) {
        url = img;
        desc = '';
      }
      if (url.isNotEmpty) {
        urls.add(url);
        descs.add(desc);
      }
    }

    return LineData(
      name: json["name"].toString(),
      //  imgDesc: json["img_desc"].toString(),
      //  KWORKING // imgDesc: json["img_desc"] == null || json["img_desc"] == "null"
      // ? null
      // : json["img_desc"].toString(),
      imgDescs: descs,
      lineId: json["line_id"],
      controller: TextEditingController(
          text: json["reason"] == null ||
                  json["reason"] == false ||
                  json["reason"] == "false"
              ? ""
              : json["reason"].toString()),

      imageList: urls,

      imageData: json["image_data"] ?? [],
      value: json["is_pass"] == null ||
              json["is_pass"] == false ||
              json["is_pass"] == "false"
          ? "yes"
          : json["is_pass"].toString(),
      reason: json["reason"] == null ||
              json["reason"] == false ||
              json["reason"] == "false"
          ? ""
          : json["reason"].toString(),
      history: json["history"] == null
          ? []
          : List<History>.from(
              json["history"]!.map((x) => History.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "image_data": imageData,
        "name": name,
        //"img_desc": imgDesc,
        "img_desc":
            imgDescs == null ? [] : List<dynamic>.from(imgDescs!.map((x) => x)),
        "line_id": lineId,
        "image_url": imageList,
        "image_urls": imageList,
        "is_pass": value,
        "reason": reason,
        "history": history == null
            ? []
            : List<dynamic>.from(history!.map((x) => x.toJson())),
      };
}

class History {
  int? id;
  String? name;
  dynamic reason;
  String? isPass;
  SubmittedBy? submittedBy;
  List imageList;
  String? updateTime;
  TextEditingController controller;

  History(
      {this.id,
      this.name,
      required this.imageList,
      this.reason,
      this.isPass,
      this.submittedBy,
      this.updateTime,
      required this.controller});

  factory History.fromJson(Map<String, dynamic> json) => History(
        id: json["id"],
        name: json["name"].toString(),
        reason: json["reason"].toString(),
        imageList: json["image_url"] ?? json["image_urls"] ?? [],
        controller: TextEditingController(
            text: json["reason"] == null ||
                    json["reason"] == false ||
                    json["reason"] == "false"
                ? ""
                : json["reason"].toString()),
        isPass: json["is_pass"] == null ||
                json["is_pass"] == false ||
                json["is_pass"] == "false"
            ? "yes"
            : json["is_pass"].toString(),
        submittedBy: json["submittedBy"] == null
            ? null
            : SubmittedBy.fromJson(json["submittedBy"]),
        updateTime: json["update_time"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "reason": reason,
        "image_url": imageList,
        "is_pass": isPass,
        "submittedBy": submittedBy?.toJson(),
        "update_time": updateTime,
      };
}

class SubmittedBy {
  dynamic id;
  dynamic name;
  String? role;

  SubmittedBy({
    this.id,
    this.name,
    this.role,
  });

  factory SubmittedBy.fromJson(Map<String, dynamic> json) => SubmittedBy(
        id: json["id"] ?? 0,
        name: json["name"].toString(),
        role: json["role"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "role": role,
      };
}
