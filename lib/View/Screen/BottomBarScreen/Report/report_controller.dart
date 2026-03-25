import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:venkatesh_buildcon_app/Api/Apis/api_response.dart';
import 'package:venkatesh_buildcon_app/Api/Repo/report_repo.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_report_response_model.dart'
    as r;
import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_tower_response_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/project_screen_res_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/success_data_res_model.dart';
import 'package:venkatesh_buildcon_app/View/Constant/shared_prefs.dart';
import 'package:venkatesh_buildcon_app/View/Screen/ActivityScreen/EditActivity/image_capture_screen.dart';
import 'package:venkatesh_buildcon_app/View/Screen/BottomBarScreen/HomeScreen/home_screen_controller.dart';
import 'package:venkatesh_buildcon_app/View/Utils/app_layout.dart';

class ReportController extends GetxController {
  HomeScreenController homeScreenController = Get.find();
  final formKey = GlobalKey<FormState>();
  TextEditingController trainingDateController = TextEditingController();
  TextEditingController trainingStartController =
      TextEditingController(text: TimeOfDay.now().format(Get.context!));
  TextEditingController trainingEndController =
      TextEditingController(text: TimeOfDay.now().format(Get.context!));
  List<TextEditingController> trainingController = [];
  List<FocusNode> focusNodes = [];
  TextEditingController topicController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController tNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController tDurationController =
      TextEditingController(text: "0.0");
  TextEditingController tManHourController = TextEditingController(text: "0.0");
  List overallImages = [];
  List<TowerDatum>? towerData = [];
  List<r.TowerDatum>? towerDataList;
  r.TowerDatum? selectedTowerData;
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  Duration? difference;
  ProjectDetails? selectProject;
  changeProject(ProjectDetails value) {
    selectProject = value;
    getTowerData();
    selectTower = null;
    update();
  }

  TowerDatum? selectTower;
  changeTower(TowerDatum value) {
    selectTower = value;
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    for (int i = 0; i < 1; i++) {
      trainingController.add(TextEditingController());
      focusNodes.add(FocusNode());
    }
    getReportData();
    super.onInit();
  }

  /// Calculate Total Duration
  void calculateTimeOfDayDifference() {
    DateTime now = DateTime.now();
    DateTime startDateTime = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);
    DateTime endDateTime =
        DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);
    difference = endDateTime.difference(startDateTime);
    tDurationController.text =
        "${difference!.inHours} Hour : ${difference!.inMinutes % 60} Minutes";
    getNonEmptyTextFieldsCount();
    update();
  }

  ///Get Text field Length
  void getNonEmptyTextFieldsCount() {
    int length = trainingController
        .where((controller) => controller.text.isNotEmpty)
        .length;

    if (difference != null) {
      int hour = difference!.inHours * length;
      int minutes = (difference!.inMinutes % 60) * length;
      if (minutes >= 60) {
        hour += 1;
        minutes = minutes - 60;
      }
      tManHourController.text = "$hour.$minutes";
    }
    update();
  }

  ///Check End Time Validation
  bool isTimeValid(TimeOfDay selectedEndTime, TimeOfDay startTime) {
    final now = DateTime.now();
    final startDateTime = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);
    final endDateTime = DateTime(now.year, now.month, now.day,
        selectedEndTime.hour, selectedEndTime.minute);
    return endDateTime.isAfter(startDateTime);
  }

  /// Overall Image Capture
  captureOverallImage({required BuildContext context}) async {
    final ImagePicker picker = ImagePicker();
    String? imgFile;
    await picker
        .pickImage(imageQuality: 15, source: ImageSource.camera)
        .then((value) async {
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
                title: ("").toString()),
          ),
        ).then(
          (value1) {
            if (value1 != true) {
              imgFile = value1["image"];
              overallImages.add(imgFile);
            }
            return;
          },
        );
      } else {
        return value;
      }
    });

    update();
  }

  /// Remove Overall Image
  removeOverallImage(int id) {
    overallImages.removeAt(id);
    update();
  }

  ///Get Report Data

  ApiResponse _getReportResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getReportResponse => _getReportResponse;

  Future<void> getReportData() async {
    _getReportResponse = ApiResponse.loading(message: 'Loading');
    try {
      ///Request Body
      Map<String, dynamic> reqBody = {
        "user_id":
            int.parse(preferences.getString(SharedPreference.userId).toString())
      };
      r.GetReportResponseModel getReportResponseModel =
          await ReportRepo().getReportRepo(body: reqBody);
      if (getReportResponseModel.status == "SUCCESS") {
        towerDataList = getReportResponseModel.towerData;
        towerDataList!.sort((a, b) {
          int dateComparison = b.trainingDatedOn!.compareTo(a.trainingDatedOn!);
          return dateComparison;
        });
        update();
      } else {
        errorSnackBar(
            "Something Went Wrong", getReportResponseModel.message ?? "");
      }
      _getReportResponse = ApiResponse.complete(getReportResponseModel);
    } catch (e) {
      _getReportResponse = ApiResponse.error(message: e.toString());
      log("Get Report ERROR=>$e");
    }

    update();
  }

  ///Get Tower Data

  ApiResponse _getTowerResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getTowerResponse => _getTowerResponse;

  Future<void> getTowerData() async {
    _getTowerResponse = ApiResponse.loading(message: 'Loading');
    try {
      ///Request Body
      Map<String, dynamic> reqBody = {
        "user_id": int.parse(
            preferences.getString(SharedPreference.userId).toString()),
        "project_id": int.parse(selectProject!.projectId.toString())
      };
      debugPrint("reqBody===================${reqBody}");
      GetTowerResponseModel getTowerResponseModel =
          await ReportRepo().getTowerRepo(body: reqBody);
      if (getTowerResponseModel.status == "SUCCESS") {
        towerData = getTowerResponseModel.towerData;
        update();
      } else {
        errorSnackBar(
            "Something Went Wrong", getTowerResponseModel.message ?? "");
      }
      _getTowerResponse = ApiResponse.complete(getTowerResponseModel);
    } catch (e) {
      _getTowerResponse = ApiResponse.error(message: e.toString());
      log("Get Tower ERROR=>$e");
    }

    update();
  }

  ///Clear Data
  clearData() {
    trainingDateController.clear();
    topicController.clear();
    locationController.clear();
    tNameController.clear();
    descriptionController.clear();
    tManHourController.text = "0.0";
    tDurationController.text = "0.0";
    trainingStartController.text = TimeOfDay.now().format(Get.context!);
    trainingEndController.text = TimeOfDay.now().format(Get.context!);
    selectProject = null;
    selectTower = null;
    overallImages = [];
    difference = null;
    trainingController.clear();
    focusNodes.clear();
    for (int i = 0; i < 1; i++) {
      trainingController.add(TextEditingController());
      focusNodes.add(FocusNode());
    }
    update();
  }

  /// Add Checker Report
  ApiResponse _addReportResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get addReportResponse => _addReportResponse;

  Future<void> addCheckerReport() async {
    try {
      if (selectProject == null) {
        errorSnackBar("Required Field", 'Please select project');
      } else if (selectTower == null) {
        errorSnackBar("Required Field", 'Please select tower');
      } else {
        _addReportResponse = ApiResponse.loading(message: 'Loading');

        ///training Date
        DateTime parsedDate = DateFormat('dd-MM-yyyy')
            .parse(trainingDateController.text.toString());
        String trainingDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(
          DateTime(
            parsedDate.year,
            parsedDate.month,
            parsedDate.day,
            DateTime.now().hour,
            DateTime.now().minute,
            DateTime.now().second,
          ),
        );

        /// Overall Image
        List overallImageListData = [];
        for (var element in overallImages) {
          String base64String = '';
          File path = File(element);
          if (path.existsSync()) {
            List<int> fileBytes = path.readAsBytesSync();
            base64String = base64Encode(fileBytes);
          }
          overallImageListData.add(base64String);
          update();
        }

        ///Request Body
        Map<String, dynamic> reqBody = {
          "user_id": int.parse(
              preferences.getString(SharedPreference.userId).toString()),
          "project_id": selectProject?.projectId.toString(),
          "tower_id": selectTower?.towerId.toString(),
          "training_date": trainingDate,
          "training_topic": topicController.text.trim(),
          "location": locationController.text.trim(),
          "trainer_name": tNameController.text.trim(),
          "training_given_to": trainingController
              .map((controller) => controller.text.trim())
              .toList(),
          "start_time": trainingStartController.text.trim(),
          "end_time": trainingEndController.text.trim(),
          "total_duration": tDurationController.text.trim(),
          "total_manhours":
              "${tManHourController.text.toString().split(".").first} Hour : ${tManHourController.text.toString().split(".").last} Minutes",
          "description": descriptionController.text.trim(),
          "overall_images":
              overallImageListData.isEmpty ? [] : overallImageListData
        };

        log("reqBody===================${reqBody}");
        SuccessDataResponseModel successDataResponseModel =
            await ReportRepo().addCheckerReportRepo(body: reqBody);
        if (successDataResponseModel.status == "SUCCESS") {
          clearData();
          Get.back();
          getReportData();
        } else {
          errorSnackBar(
              "Something Went Wrong", successDataResponseModel.message ?? "");
        }
        _addReportResponse = ApiResponse.complete(successDataResponseModel);
      }
    } catch (e) {
      _addReportResponse = ApiResponse.error(message: e.toString());
      log("Add Report ERROR=>$e");
    }

    update();
  }
}
