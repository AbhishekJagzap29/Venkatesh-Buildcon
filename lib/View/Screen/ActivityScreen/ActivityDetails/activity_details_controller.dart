import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:venkatesh_buildcon_app/Api/Apis/api_response.dart';
import 'package:venkatesh_buildcon_app/Api/Repo/project_repo.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/constructor_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_checklist_by_activity_res_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_flat_data_res_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_floor_data_res_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/notification_res_model.dart';

class ActivityDetailsController extends GetxController {
  ConstDataModel constData = ConstDataModel();
  String id = '';
  String status1 = "";
  ListFloorData? floorData;
  ListFlatData? flatData;
  NotificationData? notificationData;
  List<ListChecklistDataByAc>? checklistData;
  var activityData;
  
  Future<dynamic> getActivityData() async {
    constData = Get.arguments["model"];
    id = Get.arguments["id"].toString();
    if (constData.screen == 'flat') {
      flatData = constData.data;
      await getActivityChecklistController(
          body: {"activity_id": '${flatData?.activityId ?? ""}'});
    }
    else if (constData.screen == 'notification') {
  notificationData = constData.data;
      await getActivityChecklistController(
           body: {"activity_id": '${notificationData?.activityId?? ""}'});
   }
    else if (constData.screen == 'floor') {
      floorData = constData.data;
      await getActivityChecklistController(
          body: {"activity_id": '${floorData?.activityId ?? ""}'});
    } else {

checklistData = constData.data;
    }
    update();
  }


  /// API

  ApiResponse _getActivityChecklistApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getActivityChecklistApiResponse =>
      _getActivityChecklistApiResponse;

  Future<dynamic> getActivityChecklistController(
      {Map<String, dynamic>? body}) async {
    _getActivityChecklistApiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      ChecklistByActivityResponseModel response =
          await ProjectRepo().getActivityChecklistRepo(body: body);
      _getActivityChecklistApiResponse = ApiResponse.complete(response);

      log("_getActivityChecklistApiResponse==>$response");
    } catch (e) {
      _getActivityChecklistApiResponse =
          ApiResponse.error(message: e.toString());
      log("_getActivityChecklistApiResponse=ERROR=getActivityChecklistController>$e");
    }
    update();
  }
}
































// import 'dart:developer';

// import 'package:get/get.dart';
// import 'package:venkatesh_buildcon_app/Api/Apis/api_response.dart';
// import 'package:venkatesh_buildcon_app/Api/Repo/project_repo.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/constructor_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_checklist_by_activity_res_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_checkpoint_details_by_activity_type_id.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_flat_data_res_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_floor_data_res_model.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/shared_prefs.dart';

// class ActivityDetailsController extends GetxController {
//   ConstDataModel constData = ConstDataModel();
//   ListChecklistDataByAc? activityData;

//   String id = '';
//   String status1 = "";
//   ListFloorData? floorData;
//   ListFlatData? flatData;
//   List<ListChecklistDataByAc>? checklistData;

//    bool isNotification = false;
//    bool isEdit = false; 

//   Future<dynamic> getActivityData() async {
//     constData = Get.arguments["model"];
//     id = Get.arguments["id"].toString();
//     // if (constData.screen == 'flat') {
//     //   flatData = constData.data;
//     //   await getCheckpointDataController(
//     //       body: {"activity_id": '${flatData?.activityId ?? ""}'});
//     // } else if (constData.screen == 'floor') {
//     //   floorData = constData.data;
//     //   await getCheckpointDataController(
//     //       body: {"activity_id": '${floorData?.activityId ?? ""}'});
//   //  } 
//    // else
//      {
//       checklistData = constData.data;
//             isNotification = true;
//       update();
//       int id = int.parse(Get.arguments["activity_type_id"].toString());
//       getCheckpointDataController(id, body: {}).then(
//         (value) {
//           if (getCheckpointDataApiResponse.status == Status.COMPLETE) {
//             ChecklistByActivityResponseModel res =
//                 getCheckpointDataApiResponse.data;
//             activityData = res.checklistData as ListChecklistDataByAc?;
//             status1 = activityData?.activityStatus == "draft"
//                 ? 'maker'
//                 : activityData?.activityStatus == "submit"
//                     ? 'checker'
//                     : 'approver';
//             if (activityData?.activityStatus == "approve") {
//               isEdit = false;
//             } else if (preferences.getString(SharedPreference.userType) ==
//                 status1) {
//               isEdit = true;
//             } else {
//               isEdit = false;
//             }
//             isNotification = false;
//             update();
//           } else if (getCheckpointDataApiResponse.status == Status.ERROR) {
//             isNotification = false;
//             update();
//           }
//         },
//       );
    
//     }
//     update();
//   }


//   ApiResponse _getCheckpointDataApiResponse =
//       ApiResponse.initial(message: 'Initialization');

//   ApiResponse get getCheckpointDataApiResponse => _getCheckpointDataApiResponse;

//   Future<dynamic> getCheckpointDataController(int id, {required Map<String, String> body}) async {
//     _getCheckpointDataApiResponse = ApiResponse.loading(message: 'Loading');
//     update();

//     Map<String, dynamic> body = {"id": id};
//     //log('body==========>>>>>> $body');

//     try {
//       ChecklistByActivityResponseModel response =
//           await ProjectRepo().getChecklistByActivityTypeId(body: body);
//       _getCheckpointDataApiResponse = ApiResponse.complete(response);

//       log("_getCheckpointDataApiResponse==>$response");
//     } catch (e) {
//       _getCheckpointDataApiResponse = ApiResponse.error(message: e.toString());
//       log("_getCheckpointDataApiResponse=ERROR=>$e");
//     }
//     update();
//   }


//   /// API

//   ApiResponse _getActivityChecklistApiResponse =
//       ApiResponse.initial(message: 'Initialization');

//   ApiResponse get getActivityChecklistApiResponse =>
//       _getActivityChecklistApiResponse;

//   Future<dynamic> getActivityChecklistController(
//       {Map<String, dynamic>? body}) async {
//     _getActivityChecklistApiResponse = ApiResponse.loading(message: 'Loading');
//     update();
//     try {
//       ChecklistByActivityResponseModel response =
//           await ProjectRepo().getActivityChecklistRepo(body: body);
//       _getActivityChecklistApiResponse = ApiResponse.complete(response);

//       log("_getActivityChecklistApiResponse==>$response");
//     } catch (e) {
//       _getActivityChecklistApiResponse =
//           ApiResponse.error(message: e.toString());
//       log("_getActivityChecklistApiResponse=ERROR=getActivityChecklistController>$e");
//     }
//     update();
//   }
// }

