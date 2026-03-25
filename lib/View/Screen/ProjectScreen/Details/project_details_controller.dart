import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:venkatesh_buildcon_app/Api/Apis/api_response.dart';
import 'package:venkatesh_buildcon_app/Api/Repo/project_repo.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_tower_checklist_res_model.dart';
import 'package:venkatesh_buildcon_app/View/Constant/shared_prefs.dart';
import 'package:venkatesh_buildcon_app/View/Controller/network_controller.dart';

class ProjectDetailsController extends GetxController {
  var checkListId = Get.arguments['cId'];
  var projectId = Get.arguments['pId'];
  var projectName = Get.arguments['pName'];
  final searchController = TextEditingController();
  bool isFavorite = true;
  NetworkController networkController = Get.put(NetworkController());
  GetTowerInfoChecklistResponseModel? towerDataRes;

  bool loading = false;

  // fetchSqlData() async {
  //   loading = true;
  //   update();
  //
  //   final fetchDetailsData = await dbHelper.getDataById(tableName: 'DetailsLine', id: int.parse(checkListId));
  //   DetailsLineModel detailsLineModel = DetailsLineModel.fromJson(fetchDetailsData!);
  //
  //   final fetchTowerData = await dbHelper.getDataFromTable(
  //       where: 'detailsLineId', tableName: 'TowerData', id: int.parse(checkListId));
  //
  //   List<TowerDataModel> temp =
  //       List<TowerDataModel>.from(fetchTowerData.map((x) => TowerDataModel.fromJson(x)));
  //   List<towerData.TowerData> towerData1 = [];
  //   for (var element in temp) {
  //     towerData.TowerData data = towerData.TowerData(
  //       towerId: element.towerId,
  //       name: element.towerName,
  //     );
  //     if (element.detailsLineId == checkListId) {
  //       towerData1.add(data);
  //     }
  //   }
  //   towerData.ProjectData finalData = towerData.ProjectData(
  //       imageUrl: detailsLineModel.detailsLineImage,
  //       checklistId: detailsLineModel.id,
  //       checklistName: detailsLineModel.detailsLineName,
  //       towerData: towerData1);
  //   towerDataRes = GetTowerInfoChecklistResponseModel(projectData: finalData);
  //   loading = false;
  //   update();
  // }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
  

  getData() async {
    await getTowerChecklistController();

    // fetchSqlData();
    update();
  }

  favourite() {
    isFavorite = !isFavorite;
    update();
  }

  /// API

  ApiResponse _getTowerChecklistResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getTowerChecklistResponse => _getTowerChecklistResponse;

  Future<dynamic> getTowerChecklistController() async {
    _getTowerChecklistResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      towerDataRes = await ProjectRepo().towerInfoChecklistRepo(body: {
        "checklist_id": checkListId,
        "user_id": int.parse(preferences.getString(SharedPreference.userId) ?? "0")
      });
     
      log('checkListId==========>>>>>$checkListId');
      log('int.parse(preferences.getString(SharedPreference.userId) ?? "0")==========>>>>>${int.parse(preferences.getString(SharedPreference.userId) ?? "0")}');
      _getTowerChecklistResponse = ApiResponse.complete(towerDataRes);
      log("_getTowerChecklistResponse==>$towerDataRes");
    } catch (e) {
      _getTowerChecklistResponse = ApiResponse.error(message: e.toString());
      log("_getTowerChecklistResponse=ERROR=>$e");
    }
    update();
  }
}
