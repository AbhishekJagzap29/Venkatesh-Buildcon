import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:venkatesh_buildcon_app/Api/Apis/api_response.dart';
import 'package:venkatesh_buildcon_app/Api/Repo/project_repo.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/project_screen_res_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/success_data_res_model.dart';
import 'package:venkatesh_buildcon_app/View/Constant/shared_prefs.dart';
import 'package:venkatesh_buildcon_app/View/Controller/network_controller.dart';
import 'package:venkatesh_buildcon_app/View/Utils/app_layout.dart';

class HomeScreenController extends GetxController {
  final searchController = TextEditingController();
  List<ProjectDetails> projectData = [];
  List<ProjectDetails> searchDataList = [];
  bool sync = false;
  bool loading = false;

  NetworkController networkController = Get.put(NetworkController());

  // fetchSqlData() async {
  //   var data = await dbHelper.fetchData(projectName: "ProjectData");
  //   List<ProjectDataModel> temp = List<ProjectDataModel>.from(data.map((x) => ProjectDataModel.fromJson(x)));
  //
  //   List<ProjectDetails> projectDetails = [];
  //
  //   for (var element in temp) {
  //     ProjectDetails data = ProjectDetails(
  //       projectId: element.id,
  //       image: element.projectImage,
  //       name: element.projectName,
  //     );
  //     projectDetails.add(data);
  //   }
  //   projectData.addAll(projectDetails);
  //   searchDataList = projectData;
  //
  //   loading = false;
  //   update();
  // }

  updateSync(value) {
    sync = value;
    update();
  }

  getData() async {
    // loading = true;
    // update();
    // networkController.checkConnectivity().then((value) async {
    //   if (networkController.isResult == false) {
    //     await offlineDataController.getProjectController();
    //     await fetchSqlData();
    //     await offlineDataController.getTowerController();
    //     await offlineDataController.getFlatController();
    //     await offlineDataController.getFloorController();
    //     await offlineDataController.getFlatActivityController();
    //     await offlineDataController.getFloorActivityController();
    //   } else {
    //     fetchSqlData();
    //   }
    // });
    // update();

    await getAssignedProjectController();
  }

  searchData() {
    if (searchController.text.isNotEmpty) {
      searchDataList = [];
      for (var element in projectData) {
        if (element.name
            .toString()
            .toLowerCase()
            .contains(searchController.text.toString().toLowerCase())) {
          searchDataList.add(element);
        }
      }
    } else {
      searchDataList = projectData;
    }
    update();
  }

  /// API

  ApiResponse _getAssignedProjectResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getAssignedProjectResponse => _getAssignedProjectResponse;

  Future<dynamic> getAssignedProjectController() async {
    if (projectData.isNotEmpty && searchDataList.isNotEmpty) {
      return;
    }
    _getAssignedProjectResponse = ApiResponse.loading(message: 'Loading');

    update();
    projectData = [];
    searchDataList = [];
    try {
      AssignedProjectResponseModel response =
          await ProjectRepo().getAssignedProjectRepo();
      projectData = response.projectData!;
      searchDataList = projectData;
      _getAssignedProjectResponse = ApiResponse.complete(response);
    } catch (e) {
      _getAssignedProjectResponse = ApiResponse.error(message: e.toString());
      log("ProjectScreenController=ERROR=>$e");
    }
    update();
  }

  changeSyncStatus() {
    sync = false;
    String rowData =
        preferences.getString(SharedPreference.savedActivityData) ?? "";
    if (rowData.isNotEmpty) {
      sync = true;
    }
    update();
  }

  bool syncing = false;

  syncData() async {
    syncing = true;
    update();
    String rowData =
        preferences.getString(SharedPreference.savedActivityData) ?? "";
    if (rowData.isNotEmpty) {
      List data = jsonDecode(rowData);
      for (var i = 0; i < data.length; i++) {
        Map<String, dynamic> body = {
          "user_id": data[i]["user_id"],
          "is_draft": data[i]["is_draft"],
          "activity_type_id": data[i]["activity_type_id"],
          "checklist_line": data[i]["checklist_line"],
        //  "overall_remarks": data[i]["overall_remarks"],
          "overall_images": data[i]["overall_images"],
                    "overall_remarks_maker": data[i]["overall_remarks_maker"],
          "overall_remarks_checker": data[i]["overall_remarks_checker"],
          "overall_remarks_approver": data[i]["overall_remarks_approver"],


        };
        await uploadData(body: body);
        if (i + 1 == data.length) {
          preferences.removePreference(SharedPreference.savedActivityData);
          preferences.removePreference(SharedPreference.activityData);
          successSnackBar("Synced", "Data synced successfully");
        }
      }
    }
    sync = false;
    syncing = false;
    update();
  }

  ApiResponse _uploadDataApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get uploadDataApiResponse => _uploadDataApiResponse;

  uploadData({required Map<String, dynamic> body}) async {
    _uploadDataApiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      SuccessDataResponseModel response =
          await ProjectRepo().updateChecklistRepo(body: body);
      _uploadDataApiResponse = ApiResponse.complete(response);

      log("_makerUploadDataApiResponse==>$response");
    } catch (e) {
      _uploadDataApiResponse = ApiResponse.error(message: e.toString());
      log("_makerUploadDataApiResponse=ERROR=>$e");
    }
  }
}
