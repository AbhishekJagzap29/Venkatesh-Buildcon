import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:venkatesh_buildcon_app/Api/Apis/api_response.dart';
import 'package:venkatesh_buildcon_app/Api/Repo/notification_repo.dart';
import 'package:venkatesh_buildcon_app/Api/Repo/project_repo.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/GenerateNcResponseModel/nc_routing_through_notification_res_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/GenerateNcResponseModel/nc_submit_button_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/constructor_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_checklist_by_activity_res_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_flat_data_res_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_floor_data_res_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_tower_checklist_res_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/notification_res_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/project_details_res_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/project_screen_res_model.dart';
import 'package:venkatesh_buildcon_app/View/Constant/shared_prefs.dart';
import 'package:venkatesh_buildcon_app/View/Screen/BottomBarScreen/HomeScreen/home_screen_controller.dart';
import 'package:venkatesh_buildcon_app/View/Utils/app_layout.dart';

class NotificationController extends GetxController {
  HomeScreenController homeScreenController = Get.find();

  /// GET NOTIFICATION
  List<NotificationData> notificationData = [];
  List<NotificationData> searchNotificationData = [];
  List<NotificationData> notificationFilterData = [];

  List<NcRoutingThroughNotificationModel> ncRoutingThroughNotificationModel =
      [];
  List<NcRoutingThroughNotificationModel>
      sreachNcRoutingThroughNotificationModel = [];

  List<SubmitNcData> searchSubmitNcData = [];

  List<ListFloorData> searchListFloorOfActivityData = [];

  List<ListFlatData> searchListOfActivityData = [];

  NotificationResModel? notificationResModel;

  GetFlatDataResponseModel? flatActivityRes;

  final searchController = TextEditingController();
  bool isResult = false;

  int selectInspection = 0;
  int selectStatus = 0;

  List<ProjectDetails> projectList = [];
  ProjectDetails? selectedProject;

  List<TowerData> towerList = [];
  TowerData? selectedTower;

  ProjectDetailsResponseModel? projectDetailsRes;
  GetTowerInfoChecklistResponseModel? towerDataRes;

  List<ListChecklistDataByAc>? checklistData;

  ListChecklistDataByAc? activityData;
  String? activityId;
  ActivityDataConstModel? constData;
  List<LineData> savedLineData = [];

  List checklistStatusList = [
    "Pending",
    "Completed",
  ];
  String selectedCheckListStatus = '';

  bool isFilterApply = false;
  bool isPreFilled = false;
  bool isDuringFilled = false;
  bool isPostFilled = false;

  /// SELECTION Inspections
  selectInspections(int index) {
    selectInspection = index;
    update();
  }

  /// SELECTION Status
  selectInspectionStatus(int index) {
    selectStatus = index;
    update();
  }

  /// CLEAR FILTER
  clearFilter() {
    isFilterApply = false;
    selectInspection = 0;
    selectStatus = 0;
    searchController.clear();
    selectedProject = null;
    selectedTower = null;
    towerList = [];
    selectedCheckListStatus = '';
    searchNotificationData = notificationData;
    notificationFilterData = [];
    update();
  }

  /// APPLY FILTER
  applyFilter() {
    isFilterApply = true;
    final temp = notificationData;
    searchController.clear();
    searchNotificationData = [];
    notificationFilterData = [];

    for (var element in temp) {
      if (element.detailLine == (selectInspection == 1 ? "mi" : 'wi')) {
        searchNotificationData.add(element);
        notificationFilterData.add(element);
      }
    }
    update();

    /// select Project

    if (selectedProject != null) {
      List<NotificationData> projectList = searchNotificationData;
      update();

      searchNotificationData = [];
      notificationFilterData = [];
      for (var element in projectList) {
        if ((element.projectId!.isNotEmpty
                ? int.parse("${element.projectId}")
                : element.projectId) ==
            selectedProject?.projectId) {
          searchNotificationData.add(element);
          notificationFilterData.add(element);
        }
      }
      update();
    }

    /// select Tower

    if (selectedTower != null) {
      List<NotificationData> towerList = searchNotificationData;
      update();
      searchNotificationData = [];
      notificationFilterData = [];
      for (var element in towerList) {
        if ((element.towerId!.isNotEmpty
                ? int.parse("${element.towerId}")
                : element.towerId) ==
            selectedTower?.towerId) {
          searchNotificationData.add(element);
          notificationFilterData.add(element);
        }
      }
      update();
    }

    /// select CheckList Status

    if (selectedCheckListStatus != '') {
      List<NotificationData> checkList = searchNotificationData;
      update();
      searchNotificationData = [];
      notificationFilterData = [];
      for (var element in checkList) {
        /// Maker
        if (preferences.getString(SharedPreference.userType) == "maker") {
          if (selectedCheckListStatus == "Pending") {
            if (element.checklistStatus?.toLowerCase() == "draft") {
              searchNotificationData.add(element);
              notificationFilterData.add(element);
            }
          } else {
            if (element.checklistStatus?.toLowerCase() == "submit") {
              searchNotificationData.add(element);
              notificationFilterData.add(element);
            }
          }
        }

        /// Checker
        if (preferences.getString(SharedPreference.userType) == "checker") {
          if (selectedCheckListStatus == "Pending") {
            if (element.checklistStatus?.toLowerCase() == "submit") {
              searchNotificationData.add(element);
              notificationFilterData.add(element);
            }
          } else {
            if (element.checklistStatus?.toLowerCase() == "checked") {
              searchNotificationData.add(element);
              notificationFilterData.add(element);
            }
          }
        }

        /// Approver
        if (preferences.getString(SharedPreference.userType) == "approver") {
          if (selectedCheckListStatus == "Pending") {
            if (element.checklistStatus?.toLowerCase() == "checked") {
              searchNotificationData.add(element);
              notificationFilterData.add(element);
            }
          } else {
            if (element.checklistStatus?.toLowerCase() == "approve") {
              searchNotificationData.add(element);
              notificationFilterData.add(element);
            }
          }
        }
      }
      update();
    }
    Get.back();
  }

  getProjectData() {
    if (homeScreenController.projectData.isNotEmpty) {
      projectList = homeScreenController.projectData;
    } else {
      homeScreenController
          .getAssignedProjectController()
          .then((value) => projectList = homeScreenController.projectData);
    }
  }

  selectProject(int id) async {
    for (var element in projectList) {
      if (element.projectId == id) {
        selectedProject = element;
      }
    }
    update();

    await projectDetailsContro();
  }

  selectTower(int id) async {
    for (var element in towerList) {
      if (element.towerId == id) {
        selectedTower = element;
      }
    }
    update();
  }

  selectCheckListStatus(String value) async {
    for (var element in checklistStatusList) {
      if (element == value) {
        selectedCheckListStatus = element;
      }
    }
    update();
  }

  searchData() {
    if (notificationFilterData.isNotEmpty) {
      if (searchController.text.isNotEmpty) {
        searchNotificationData = [];
        for (var element in notificationFilterData) {
          if (element.seq_no
              .toString()
              .toLowerCase()
              .contains(searchController.text.toString().toLowerCase())) {
            searchNotificationData.add(element);
          }
        }
      } else {}
    } else {
      if (searchController.text.isNotEmpty) {
        if (isFilterApply == false) {
          searchNotificationData = [];
          for (var element in notificationData) {
            if (element.seq_no
                .toString()
                .toLowerCase()
                .contains(searchController.text.toString().toLowerCase())) {
              searchNotificationData.add(element);
            }
          }
        }
      }
    }
    update();
  }

  /// API

  ApiResponse _getNotificationApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getNotificationApiResponse => _getNotificationApiResponse;

  Future<dynamic> getNotificationController() async {
    notificationData = [];
    searchNotificationData = [];
    _getNotificationApiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      NotificationResModel response =
          await NotificationRepo().getNotificationRepo();

      log("API Response: ${response.toJson()}");

      _getNotificationApiResponse = ApiResponse.complete(response);
      notificationData = response.notificationData!;
      searchNotificationData = notificationData;
      log("_getNotificationApiResponse==>$response");
    } catch (e) {
      _getNotificationApiResponse = ApiResponse.error(message: e.toString());
      log("_getNotificationApiResponse=ERROR=>$e");
    }
    update();
  }

///////////////////// nc routing through the notification
  ApiResponse _ncRoutingResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get ncRoutingResponse => _ncRoutingResponse;

  Future<void> getNcRoutingForNotification(int ncId) async {
    ncRoutingThroughNotificationModel = [];
    sreachNcRoutingThroughNotificationModel = [];
    _ncRoutingResponse = ApiResponse.loading(message: 'Loading NC details');
    update();

    if (ncId == null || ncId <= 0) {
      errorSnackBar("Error", "Invalid NC ID.");
      return;
    }
    try {
      print("Making API call with NC ID: $ncId");
      NcRoutingThroughNotificationResponseModel? response =
          await ProjectRepo().getNotificationRoutingForNc(map: {'nc_id': ncId});

      log("NC Routing Response: ${response?.toJson()}");

      if (response != null && response.status.toLowerCase() == 'success') {
        _ncRoutingResponse = ApiResponse.complete(response.nc);
        log("Data loaded Successfully!");
      }
//====================

      else {
        _ncRoutingResponse = ApiResponse.error(message: "Failed to Navigate");
      }
    } catch (e) {
      _ncRoutingResponse = ApiResponse.error(message: e.toString());
      log("Error fetching NC Routing: $e");
    }

    update();
  }

  /// API

  ApiResponse _projectDetailsResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get projectDetailsResponse => _projectDetailsResponse;

  Future<dynamic> projectDetailsContro() async {
    _projectDetailsResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      projectDetailsRes = await ProjectRepo().projectDetailsRepo(
          body: {"project_id": selectedProject?.projectId ?? 0});
      _projectDetailsResponse = ApiResponse.complete(projectDetailsRes);
      update();

      /// get Tower List API
      await getTowerChecklistController();
      log("_projectDetailsResponse=11=>$projectDetailsRes");
    } catch (e) {
      _projectDetailsResponse = ApiResponse.error(message: e.toString());
      log("_projectDetailsResponse=ERROR=11=>$e");
    }
    update();
  }

  /// API

  ApiResponse _getTowerChecklistResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getTowerChecklistResponse => _getTowerChecklistResponse;

  Future<dynamic> getTowerChecklistController() async {
    _getTowerChecklistResponse = ApiResponse.loading(message: 'Loading');
    update();
    int? checklistId;

    projectDetailsRes?.projectData?.checklistData?.forEach((element) {
      if (selectInspection == 1) {
        if (element.name!.contains("Material Inspection")) {
          checklistId = element.checklistId;
          update();
        }
      } else {
        if (element.name!.contains("Work Inspection")) {
          checklistId = element.checklistId;
          update();
        }
      }
    });

    try {
      towerDataRes = await ProjectRepo().towerInfoChecklistRepo(body: {
        "checklist_id": checklistId ?? 0,
        "user_id":
            int.parse(preferences.getString(SharedPreference.userId) ?? "0")
      });
      _getTowerChecklistResponse = ApiResponse.complete(towerDataRes);

      log("_getTowerChecklistResponse=11=>$towerDataRes");

      if (towerDataRes?.status == "SUCCESS" &&
          towerDataRes?.projectData != null) {
        towerList = towerDataRes?.projectData?.towerData ?? [];
        update();
      }
    } catch (e) {
      _getTowerChecklistResponse = ApiResponse.error(message: e.toString());
      log("_getTowerChecklistResponse=ERROR=11=>$e");
    }
    update();
  }
}
