import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:venkatesh_buildcon_app/Api/Apis/api_response.dart';
import 'package:venkatesh_buildcon_app/Api/Repo/project_repo.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_flat_floor_res_model.dart';

class TowerController extends GetxController {
  String towerId = Get.arguments['towerId'];
  GetFlatFloorDataResponseModel? flatFloorRes;
  final searchController = TextEditingController();
  bool loading = false;
  List<ListFloor> listFloorData = [];
  List<ListFloor> listFlatData = [];
  List<ListFloor> searchListFloorData = [];
  List<ListFloor> searchListFlatData = [];

  int flatLength = 0;
  int floorLength = 0;
  bool load = false;

  setFloorLength(bool isFirst) async {
    if (!isFirst) {
      load = true;
      update();
      await Future.delayed(const Duration(seconds: 1));
    }

    if (floorLength > searchListFloorData.length) {
      floorLength = searchListFloorData.length;
    } else if (floorLength + 20 > searchListFloorData.length) {
      floorLength = searchListFloorData.length;
    } else {
      floorLength += 20;
    }
    load = false;
    update();
  }

  setFlatLength(bool isFirst) async {
    if (!isFirst) {
      load = true;
      update();
      await Future.delayed(const Duration(seconds: 1));
    }
    if (flatLength > searchListFlatData.length) {
      flatLength = searchListFlatData.length;
    } else if (flatLength + 20 > searchListFlatData.length) {
      flatLength = searchListFlatData.length;
    } else {
      flatLength += 20;
    }
    load = false;
    update();
  }

  // fetchSqlData() async {
  //   loading = true;
  //   update();
  //
  //   final fetchTowerData = await dbHelper.getSingleDataFromTable(
  //       tableName: 'TowerData', id: int.parse(towerId), where: "towerId");
  //   TowerDataModel towerDataModel = TowerDataModel.fromJson(fetchTowerData!);
  //
  //   final fetchFlatData =
  //       await dbHelper.getDataFromTable(tableName: 'FlatData', where: "towerId", id: int.parse(towerId));
  //
  //   List<FlatDataModel> flatData =
  //       List<FlatDataModel>.from(fetchFlatData.map((x) => FlatDataModel.fromJson(x)));
  //
  //   final fetchFloorData =
  //       await dbHelper.getDataFromTable(tableName: 'FloorData', where: "towerId", id: int.parse(towerId));
  //
  //   List<FloorDataModel> floorData =
  //       List<FloorDataModel>.from(fetchFloorData.map((x) => FloorDataModel.fromJson(x)));
  //
  //   for (var element in floorData) {
  //     ListFloor data = ListFloor(
  //       floorId: element.floorId,
  //       name: element.floorName,
  //     );
  //     listFloorData.add(data);
  //   }
  //   searchListFloorData = listFloorData;
  //   for (var element in flatData) {
  //     ListFloor data = ListFloor(
  //       floorId: element.flatId,
  //       name: element.flatName,
  //     );
  //     listFlatData.add(data);
  //   }
  //
  //   searchListFlatData = listFlatData;
  //
  //   flatFloor.TowerData towerData = flatFloor.TowerData(
  //       towerName: towerDataModel.towerName,
  //       towerId: towerDataModel.towerId,
  //       listFlatData: listFlatData,
  //       listFloorData: listFloorData);
  //
  //   flatFloorRes = GetFlatFloorDataResponseModel(towerData: towerData);
  //   loading = false;
  //   setFloorLength(true);
  //   setFlatLength(true);
  //   update();
  // }

  searchData() {
    if (select == 0) {
      flatLength = 0;
      if (searchController.text.isNotEmpty) {
        searchListFlatData = [];
        for (var element in listFlatData) {
          if (element.name
              .toString()
              .toLowerCase()
              .contains(searchController.text.toString().toLowerCase())) {
            searchListFlatData.add(element);
          }
        }
      } else {
        searchListFlatData = listFlatData;
      }
      setFlatLength(true);
    } else {
      floorLength = 0;

      if (searchController.text.isNotEmpty) {
        searchListFloorData = [];
        for (var element in listFloorData) {
          if (element.name
              .toString()
              .toLowerCase()
              .contains(searchController.text.toString().toLowerCase())) {
            searchListFloorData.add(element);
          }
        }
      } else {
        searchListFloorData = listFloorData;
      }
      setFloorLength(true);
    }
    update();
  }

  @override
  void onInit() {
    getFlatFloorController();
    // fetchSqlData();
    super.onInit();
  }

  @override
  void dispose() {
    select = 0;
    super.dispose();
  }

  int select = 0;
  selectFlatFloor(int index) {
    select = index;
    update();
  }

  /// API
  ApiResponse _getFlatFlorApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getFlatFlorApiResponse => _getFlatFlorApiResponse;

  Future<dynamic> getFlatFloorController() async {
    _getFlatFlorApiResponse = ApiResponse.loading(message: 'Loading');
    listFloorData = [];
    listFlatData = [];
    searchListFloorData = [];
    searchListFlatData = [];
    update();

    try {
      flatFloorRes = await ProjectRepo().getFlatFloorRepo(body: {"tower_id": towerId});
      log('towerId==========>>>>>$towerId');
      listFloorData = flatFloorRes?.towerData?.listFloorData ?? [];
      listFlatData = flatFloorRes?.towerData?.listFlatData ?? [];
      searchListFloorData = listFloorData;
      searchListFlatData = listFlatData;
      setFlatLength(true);
      setFloorLength(true);
      _getFlatFlorApiResponse = ApiResponse.complete(flatFloorRes);
      log("_getFlatFlorApiResponse==>$flatFloorRes");
      update();
    } catch (e) {
      _getFlatFlorApiResponse = ApiResponse.error(message: e.toString());
      log("_getFlatFlorApiResponse=ERROR=>$e");
      update();
    }
  }
}
