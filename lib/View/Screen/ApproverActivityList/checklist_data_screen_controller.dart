import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:venkatesh_buildcon_app/Api/Apis/api_response.dart';
import 'package:venkatesh_buildcon_app/Api/Repo/project_repo.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/checklist_data_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/checklist_type_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/project_screen_res_model.dart';

class ChecklistDataScreenController extends GetxController {
  List<ActivityChecklistDataForApprover> checklistDataApprover = [];

  ChecklistDataResponseModel? checklistDataRes;
  ActivityChecklistDataForApprover? checklistTypeDataRes;

  @override
  void onInit() {
    super.onInit();
    getActivityChecklist();
  }

  ApiResponse _activityChecklistResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get activityChecklistResponse => _activityChecklistResponse;
  Future<void> getActivityChecklist() async {
    _activityChecklistResponse = ApiResponse.loading(message: 'Loading');
    update();

    try {
      checklistDataRes = await ProjectRepo().getapproveractivityRepo();
      _activityChecklistResponse = ApiResponse.complete(checklistDataRes);

      if (checklistDataRes?.activityChecklistData != null) {
        checklistDataApprover = checklistDataRes!.activityChecklistData!;
      }
    } catch (e) {
      _activityChecklistResponse = ApiResponse.error(message: e.toString());
    }

    update();
  }
}
