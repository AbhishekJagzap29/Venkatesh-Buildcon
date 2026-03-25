// edit_activity_controller.dart (modified)
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:venkatesh_buildcon_app/Api/Apis/api_response.dart';
import 'package:venkatesh_buildcon_app/Api/Repo/project_repo.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/constructor_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_checklist_by_activity_res_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_checkpoint_details_by_activity_type_id.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_flat_data_res_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_floor_data_res_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/success_data_res_model.dart';
import 'package:venkatesh_buildcon_app/View/Constant/shared_prefs.dart';
import 'package:venkatesh_buildcon_app/View/Screen/ActivityScreen/ActivityDetails/activity_details_controller.dart';
import 'package:venkatesh_buildcon_app/View/Screen/ActivityScreen/EditActivity/image_capture_screen.dart';
import 'package:venkatesh_buildcon_app/View/Utils/app_layout.dart';

class EditActivityController extends GetxController {
  ListFloorData? floorData;
  ListFlatData? flatData;
  ListChecklistDataByAc? activityData;
  String? activityId;
  ActivityDataConstModel? constData;
  List<LineData> savedLineData = [];
  String overallRemark = "";
  String offlineStatus = "";
  String screen = Get.arguments["screen"];
  String isNetwork = Get.arguments["network"] ?? "";
  String? imgFile;
  String status = '';
  bool isEdit = false;
  bool imageSaver = false;
  int userId = int.parse(preferences.getString(SharedPreference.userId) ?? "0");
  List<History> history = [];

  // List overallImageList = [];

  ActivityDetailsController activityDetailsController =
      Get.put(ActivityDetailsController());

  TextEditingController makerRemarkController = TextEditingController();
  TextEditingController checkerRemarkController = TextEditingController();
  TextEditingController approverRemarkController = TextEditingController();

  loader(bool value) {
    imageSaver = value;
    update();
  }

  @override
  void onInit() {
    getActivityFloorFlatData();
    super.onInit();
  }

  bool isNotification = false;

  getActivityFloorFlatData() async {
    // if (isNetwork == "no") {
    constData = Get.arguments["model"];
    activityId = constData?.activityId.toString();
    activityData = constData?.activityData;

    makerRemarkController.text = activityData?.makerRemark ?? "";
    checkerRemarkController.text = activityData?.checkerRemark ?? "";
    approverRemarkController.text = activityData?.approverRemark ?? "";

    String resData =
        preferences.getString(SharedPreference.savedActivityData).toString();

    if (resData.isNotEmpty) {
      List existingData = jsonDecode(resData);
      final data1 = existingData
          .where((element) =>
              element["activity_type_id"] == activityData?.activityTypeId)
          .toList();

      if (data1.isNotEmpty) {
        activityData!.makerRemark =
            data1.first["overall_remarks_maker"]?.toString() ?? "";
        activityData!.checkerRemark =
            data1.first["overall_remarks_checker"]?.toString() ?? "";
        activityData!.approverRemark =
            data1.first["overall_remarks_approver"]?.toString() ?? "";

        // overallRemark = data1.first["overall_remarks"];
        // activityData!.controller.text = overallRemark;
        if (isNetwork == "no") {
          offlineStatus = data1.first["status"];
        }

        savedLineData.addAll(
          List<LineData>.from(
            data1.first["checklist_line"].map((x) => LineData.fromJson(x)),
          ),
        );
      }

      if (isNetwork.isEmpty) {
        isNetwork = "yes";
      }

      changeStatus();
    }
    // } else {
    if (screen == "activity") {
      constData = Get.arguments["model"];
      activityId = constData?.activityId.toString();
      activityData = constData?.activityData;
      changeStatus();
      if (constData?.floorFlatData.runtimeType.toString() == "ListFloorData") {
        floorData = constData?.floorFlatData;
      } else {
        flatData = constData?.floorFlatData;
      }
    } else {
      isNotification = true;
      update();
      int id = int.parse(Get.arguments["activity_type_id"].toString());
      getCheckpointDataController(id).then(
        (value) {
          if (getCheckpointDataApiResponse.status == Status.COMPLETE) {
            GetCheckPointDetailsByActivityTypeId res =
                getCheckpointDataApiResponse.data;
            activityData = res.activityData;
            status = activityData?.activityStatus == "draft"
                ? 'maker'
                : activityData?.activityStatus == "submit"
                    ? 'checker'
                    : 'approver';
            if (activityData?.activityStatus == "approve") {
              isEdit = false;
            } else if (preferences.getString(SharedPreference.userType) ==
                status) {
              isEdit = true;
            } else {
              isEdit = false;
            }
            isNotification = false;
            update();
          } else if (getCheckpointDataApiResponse.status == Status.ERROR) {
            isNotification = false;
            update();
          }
        },
      );
    }
    // }

    update();
  }

  changeStatus() {
    status = activityData?.activityStatus == "draft"
        ? 'maker'
        : activityData?.activityStatus == "submit"
            ? 'checker'
            : 'approver';

    log('status----------- $status');
    if (activityData?.activityStatus == "approve") {
      isEdit = false;
    } else if (preferences.getString(SharedPreference.userType) == status) {
      isEdit = true;
    } else {
      isEdit = false;
    }
    update();
  }

  capturePhoto({required int index, required BuildContext context}) async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker
        .pickImage(imageQuality: 15, source: ImageSource.camera)
        .then(
      (value) async {
        if (value != null) {
          Uint8List imageBytes = await value.readAsBytes();
          img.Image? image = img.decodeImage(imageBytes);
          img.Image resizedImage = img.copyResize(image!, width: 800);
          List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 35);
          File compressedFile = File(value.path)
            ..writeAsBytesSync(compressedBytes);

          return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageCaptureScreen(
                  image: File(compressedFile.path.toString()),
                  title: (constData?.flatFloorName ?? "").toString()),
            ),
          )
              // .then(
              //   (value1) {
              //     if (value1 != true) {
              //       imgFile = value1["image"];
              //       activityData?.lineData?[index].imageList.add(imgFile);
              //     }
              //     return;
              //   },
              // );
              //capturePhoto - edit activity controller
              .then((value1) {
            if (value1 != true) {
              imgFile = value1["image"];
              String desc = value1["description"]?.trim() ?? "";
              activityData?.lineData?[index].imageList.add(imgFile);
              activityData?.lineData?[index].imgDescs ??= [];
              activityData?.lineData?[index].imgDescs!.add(desc);
              update();
            }
            return;
          });
        } else {
          return value;
        }
      },
    );

    update();
  }

  removeImage(int id, int index) {
    activityData!.lineData?[index].imageList.removeAt(id);
    activityData!.lineData?[index].imgDescs?.removeAt(id);
    update();
  }

  /// Overall Image Capture
  captureOverallImage({required BuildContext context}) async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker
        .pickImage(imageQuality: 15, source: ImageSource.camera)
        .then(
      (value) async {
        if (value != null) {
          Uint8List imageBytes = await value.readAsBytes();
          img.Image? image = img.decodeImage(imageBytes);
          img.Image resizedImage = img.copyResize(image!, width: 800);
          List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 35);
          File compressedFile = File(value.path)
            ..writeAsBytesSync(compressedBytes);
          return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageCaptureScreen(
                  image: File(compressedFile.path.toString()),
                  title: (constData?.flatFloorName ?? "").toString()),
            ),
          )
              // .then(
              //   (value1) {
              //     if (value1 != true) {
              //       imgFile = value1["image"];
              //       activityData?.overallImagesList?.add(imgFile);
              //     }
              //     return;
              //   },
              // );
              .then((value1) {
            if (value1 != true) {
              imgFile = value1["image"];
              String desc = value1["description"]?.trim() ?? "";
              activityData?.overallImagesList?.add(imgFile);
              activityData?.overallImgDescs ??= [];
              activityData?.overallImgDescs!.add(desc);
              update();
            }
            return;
          });
        } else {
          return value;
        }
      },
    );

    update();
  }

  removeOverallImage(int id) {
    activityData?.overallImagesList?.removeAt(id);
    activityData?.overallImgDescs?.removeAt(id);
    update();
  }

  changeDropDownValue(
      int index, ListChecklistDataByAc activityData, String newValue) {
    activityData.lineData?[index].value = newValue;
    update();
  }

  /// API

  /// UPLOAD DATA

  ApiResponse _uploadDataApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get uploadDataApiResponse => _uploadDataApiResponse;

  Future<dynamic> uploadCheckListController({required String isDraft}) async {
    if (activityData?.lineData?.any(
            (element) => (element.value == "No" || element.value == "no")) ==
        true) {
      errorSnackBar("Alert !",
          'You can not Submit this checklist because You Selected "No" checkpoints');
    } else if (activityData?.lineData?.any((element) =>
            element.imageList.isNotEmpty &&
            (element.value == "No" || element.value == "no")) ==
        true) {
      errorSnackBar("Required Field",
          "Please enter at least one image for 'No' selected checkpoints");
    } else if ((activityData?.overallImagesList!.isEmpty)!) {
      errorSnackBar(
          "Required Field", "Please enter at least one Overall image");
    } else {
      if (activityData!.lineData!
          .any((element) => element.history!.isNotEmpty)) {
        if (activityData?.lineData?.any((element) =>
                element.history?.first.isPass?.toLowerCase() == "no" &&
                !element.imageList
                    .any((element1) => !element1.contains('http://'))) ==
            true) {
          errorSnackBar("Required Field",
              "Please enter at least one image for recently 'Yes' selected checkpoints");
          return;
        }
      }
      _uploadDataApiResponse = ApiResponse.loading(message: 'Loading');
      update();
      List<Map<String, dynamic>> checkListData = [];

      activityData?.lineData?.forEach((element) {
        element.imageData = [];
        int imgIndex = 0;
        for (var element1 in element.imageList) {
          if (!element1.contains('http://')) {
            String base64String = '';
            File path = File(element1);
            if (path.existsSync()) {
              List<int> fileBytes = path.readAsBytesSync();
              base64String = base64Encode(fileBytes);
            }
            String desc = element.imgDescs?[imgIndex] ?? '';
            element.imageData.add({'image': base64String, 'img_desc': desc});
          }
          imgIndex++;
        }

        checkListData.add(
          {
            "line_id": element.lineId,
            "is_pass": element.value.toLowerCase() == "yes"
                ? 'yes'
                : element.value.toLowerCase() == "no"
                    ? 'no'
                    : 'nop',
            if (element.value.toLowerCase() == "no")
              "reason": element.controller.text,
            if (element.value.toLowerCase() == "yes" &&
                element.controller.text.isNotEmpty)
              "reason": element.controller.text,
            if (element.value.toLowerCase() == "no")
              "image_data": element.imageData,
            if (element.value.toLowerCase() == "yes" &&
                element.imageData.isNotEmpty)
              "image_data": element.imageData,
          },
        );
      });

      /// Overall Image add
      List overallImageListData = [];
      int overallIndex = 0;
      activityData?.overallImagesList?.forEach((element) {
        if (!element.contains('http://')) {
          String base64String = '';
          File path = File(element);
          if (path.existsSync()) {
            List<int> fileBytes = path.readAsBytesSync();
            base64String = base64Encode(fileBytes);
          }
          String desc = activityData?.overallImgDescs?[overallIndex] ?? '';
          overallImageListData.add({'image': base64String, 'img_desc': desc});
          update();
        }
        overallIndex++;
      });

      if (status == 'maker') {
        activityData?.makerRemark = makerRemarkController.text.trim();
      } else if (status == 'checker') {
        activityData?.checkerRemark = checkerRemarkController.text.trim();
      } else if (status == 'approver') {
        activityData?.approverRemark = approverRemarkController.text.trim();
      }
      Map<String, dynamic> body = {
        "user_id": userId,
        "is_draft": isDraft,
        "activity_type_id": activityData?.activityTypeId,
        "checklist_line": checkListData,
        "overall_remarks_maker": activityData?.makerRemark.toString().trim(),
        "overall_remarks_checker":
            activityData?.checkerRemark.toString().trim(),
        "overall_remarks_approver":
            activityData?.approverRemark.toString().trim(),
        if (preferences.getString(SharedPreference.userType) == "maker" &&
            overallImageListData.isNotEmpty)
          "overall_images": overallImageListData,
      };

      try {
        //25/02/26 log
        log("========== FINAL REQUEST BODY ==========");
log(jsonEncode(body));
log("=========================================");
///
        SuccessDataResponseModel response =
            await ProjectRepo().updateChecklistRepo(body: body);
        _uploadDataApiResponse = ApiResponse.complete(response);

        if (response.status == "SUCCESS" || response.status == "Maker") {
          Get.back();
          await Future.delayed(const Duration(milliseconds: 500));
          successSnackBar(
              "Success",
              isDraft == "yes"
                  ? 'Checklist data saved successfully'
                  : 'Checklist data updated successfully');
        }
        log("_makerUploadDataApiResponse==>$response");
      } catch (e) {
        _uploadDataApiResponse = ApiResponse.error(message: e.toString());
        log("_makerUploadDataApiResponse=ERROR=>$e");
      }
      update();
    }
  }

  /// REJECT DATA

  ApiResponse _rejectDataApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get rejectDataApiResponse => _rejectDataApiResponse;

  Future<dynamic> rejectCheckListController() async {
    int? con = activityData?.lineData
        ?.indexWhere((element) => (element.value.toLowerCase() == "no"));

    if (con! < 0) {
      errorSnackBar("Alert !",
          'You can not reject or sent back this checklist because not any points select as "No"');
      return;
    }

    if (activityData?.lineData?.any((element) =>
            element.controller.text.isEmpty &&
            (element.value == "No" || element.value == "no")) ==
        true) {
      errorSnackBar("Required Field",
          "Please enter description for 'No' selected checkpoints");
      log('Hello description validation');
    } else if (activityData?.lineData?.any((element) =>
            element.imageList.isEmpty &&
            (element.value == "No" || element.value == "no")) ==
        true) {
      errorSnackBar("Required Field",
          "Please enter at least one image for 'No' selected checkpoints");
    } else {
      _rejectDataApiResponse = ApiResponse.loading(message: 'Loading');
      update();

      List<Map<String, dynamic>> checkListData = [];

      activityData?.lineData?.forEach((element) {
        element.imageData = [];

        int imgIndex = 0;
        for (var element1 in element.imageList) {
          if (!element1.contains('http')) {
            String base64String = '';
            File path = File(element1);
            if (path.existsSync()) {
              List<int> fileBytes = path.readAsBytesSync();
              base64String = base64Encode(fileBytes);
            }
            String desc = element.imgDescs?[imgIndex] ?? '';
            element.imageData.add({'image': base64String, 'img_desc': desc});
          }
          imgIndex++;
        }

        checkListData.add(
          {
            "line_id": element.lineId,
            "is_pass": element.value.toLowerCase() == "yes"
                ? 'yes'
                : element.value.toLowerCase() == "no"
                    ? 'no'
                    : 'nop',
            if (element.value.toLowerCase() == "no")
              "reason": element.controller.text,
            if (element.value.toLowerCase() == "yes" &&
                element.controller.text.isNotEmpty)
              "reason": element.controller.text,
            if (element.value.toLowerCase() == "no")
              "image_data": element.imageData,
            if (element.value.toLowerCase() == "yes" &&
                element.imageData.isNotEmpty)
              "image_data": element.imageData,
          },
        );
      });

      if (status == 'maker') {
        activityData?.makerRemark = makerRemarkController.text.trim();
      } else if (status == 'checker') {
        activityData?.checkerRemark = checkerRemarkController.text.trim();
      } else if (status == 'approver') {
        activityData?.approverRemark = approverRemarkController.text.trim();
      }

      Map<String, dynamic> body = {
        "user_id": userId,
        "activity_type_id": activityData?.activityTypeId,
        "checklist_line": checkListData,

        "overall_remarks_maker": activityData?.makerRemark.toString().trim(),
        "overall_remarks_checker":
            activityData?.checkerRemark.toString().trim(),
        "overall_remarks_approver":
            activityData?.approverRemark.toString().trim(),

        //    "overall_remarks": activityData?.controller.text.toString().trim(),
      };

      try {
        SuccessDataResponseModel response =
            await ProjectRepo().rejectChecklistRepo(body: body);
        _rejectDataApiResponse = ApiResponse.complete(response);

        if (response.status == "SUCCESS") {
          Get.back();
          await Future.delayed(const Duration(milliseconds: 500));
          successSnackBar("Success", 'Checklist data rejected successfully');
        }
        log("_rejectDataApiResponse==>$response");
      } catch (e) {
        _rejectDataApiResponse = ApiResponse.error(message: e.toString());
        log("_rejectDataApiResponse=ERROR=>$e");
      }
      update();
    }
  }

  /// GET CHECKPOINT DATA BY ACTIVITY TYPE ID

  ApiResponse _getCheckpointDataApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getCheckpointDataApiResponse => _getCheckpointDataApiResponse;

  Future<dynamic> getCheckpointDataController(int id) async {
    _getCheckpointDataApiResponse = ApiResponse.loading(message: 'Loading');
    update();

    Map<String, dynamic> body = {"id": id};
    log('body==========>>>>>> $body');

    try {
      GetCheckPointDetailsByActivityTypeId response =
          await ProjectRepo().getChecklistByActivityTypeId(body: body);
      _getCheckpointDataApiResponse = ApiResponse.complete(response);
      //25/02/26 log
      log("========== RELOAD RESPONSE ==========");
log(jsonEncode(response.toJson()));
log("======================================");
//

      log("_getCheckpointDataApiResponse==>$response");
    } catch (e) {
      _getCheckpointDataApiResponse = ApiResponse.error(message: e.toString());
      log("_getCheckpointDataApiResponse=ERROR=>$e");
    }
    update();
  }

  saveData(bool isReject) async {
    if (isReject == true) {
      int? con = activityData?.lineData
          ?.indexWhere((element) => (element.value.toLowerCase() == "no"));

      if (con! < 0) {
        errorSnackBar("Alert !",
            'You can not reject or sent back this checklist because not any points select as "No"');
        return;
      }
    }

    if (activityData?.lineData?.any((element) =>
            element.controller.text.isEmpty &&
            (element.value == "No" || element.value == "no")) ==
        true) {
      errorSnackBar("Required Field",
          "Please enter description for 'No' selected checkpoints");
      log('Hello description validation');
    } else if (activityData?.lineData?.any((element) =>
            element.imageList.isEmpty &&
            (element.value == "No" || element.value == "no")) ==
        true) {
      errorSnackBar("Required Field",
          "Please enter at least one image for 'No' selected checkpoints");
    } else {
      List<Map<String, dynamic>> checkListData = [];

      activityData?.lineData?.forEach((element) {
        element.imageData = [];
        int imgIndex = 0;
        for (var element1 in element.imageList) {
          if (!element1.contains('http://')) {
            String base64String = '';
            File path = File(element1);
            if (path.existsSync()) {
              List<int> fileBytes = path.readAsBytesSync();

              base64String = base64Encode(fileBytes);
            }
            String desc = element.imgDescs?[imgIndex] ?? '';
            element.imageData.add({'image': base64String, 'img_desc': desc});
          }
          imgIndex++;
        }

        checkListData.add(
          {
            "line_id": element.lineId,
            "name": element.name,
            "is_pass": element.value.toLowerCase() == "yes"
                ? 'yes'
                : element.value.toLowerCase() == "no"
                    ? 'no'
                    : 'nop',
            if (element.value.toLowerCase() == "no")
              "reason": element.controller.text,
            if (element.value.toLowerCase() == "yes" &&
                element.controller.text.isNotEmpty)
              "reason": element.controller.text,
            if (element.value.toLowerCase() == "no")
              "image_data": element.imageData,
            if (element.value.toLowerCase() == "yes" &&
                element.imageData.isNotEmpty)
              "image_data": element.imageData,
          },
        );
      });

      List overallImageData = [];
      if (activityData?.overallImagesList != null) {
        int overallIndex = 0;
        for (var imgPath in activityData!.overallImagesList!) {
          if (!imgPath.contains('http://')) {
            String base64String = '';
            File file = File(imgPath);
            if (file.existsSync()) {
              List<int> bytes = file.readAsBytesSync();
              base64String = base64Encode(bytes);
            }
            String desc = activityData?.overallImgDescs?[overallIndex] ?? '';
            overallImageData.add({'image': base64String, 'img_desc': desc});
          }
          overallIndex++;
        }
      }

      if (status == 'maker') {
        activityData?.makerRemark = makerRemarkController.text.trim();
      } else if (status == 'checker') {
        activityData?.checkerRemark = checkerRemarkController.text.trim();
      } else if (status == 'approver') {
        activityData?.approverRemark = approverRemarkController.text.trim();
      }

      Map<String, dynamic> body = {
        "user_id": userId,
        "is_draft": "yes",
        "activity_type_id": activityData?.activityTypeId,
        "checklist_line": checkListData,
        "overall_remarks_maker": activityData?.makerRemark.toString().trim(),
        "overall_remarks_checker":
            activityData?.checkerRemark.toString().trim(),
        "overall_remarks_approver":
            activityData?.approverRemark.toString().trim(),
        // "overall_remarks": activityData?.controller.text.toString().trim(),
        "overall_images": overallImageData,
        "status": activityData?.activityStatus == "draft"
            ? 'submit'
            : activityData?.activityStatus == "submit"
                ? 'checked'
                : 'approve',
        "isReject": isReject,
      };
      String resData =
          preferences.getString(SharedPreference.savedActivityData).toString();
      if (resData.isEmpty) {
        preferences.putString(
            SharedPreference.savedActivityData, jsonEncode([body]));
        activityDetailsController.checklistData?.forEach((element) {
          if (element.activityTypeId == activityData?.activityTypeId) {
            element.activityStatus = activityData?.activityStatus == "draft"
                ? 'submit'
                : activityData?.activityStatus == "submit"
                    ? 'checked'
                    : 'approve';
          }
        });
      } else {
        List existingData = jsonDecode(resData);
        existingData.removeWhere((element) =>
            element["activity_type_id"] == activityData?.activityTypeId);
        activityDetailsController.checklistData?.forEach((element) {
          if (element.activityTypeId == activityData?.activityTypeId) {
            element.activityStatus = activityData?.activityStatus == "draft"
                ? 'submit'
                : activityData?.activityStatus == "submit"
                    ? 'checked'
                    : 'approve';
          }
        });
        existingData.add(body);
        preferences.putString(
            SharedPreference.savedActivityData, jsonEncode(existingData));
      }

      Get.back();

      successSnackBar("Success", "Data saved successfully");
    }
  }
}