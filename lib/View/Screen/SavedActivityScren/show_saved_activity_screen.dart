import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/constructor_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_checklist_by_activity_res_model.dart';
import 'package:venkatesh_buildcon_app/View/Constant/app_color.dart';
import 'package:venkatesh_buildcon_app/View/Constant/app_string.dart';
import 'package:venkatesh_buildcon_app/View/Constant/responsive.dart';
import 'package:venkatesh_buildcon_app/View/Constant/shared_prefs.dart';
import 'package:venkatesh_buildcon_app/View/Utils/app_routes.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/app_bar.dart';
import 'package:venkatesh_buildcon_app/View/utils/extension.dart';

class SaveActivityScreen extends StatefulWidget {
  const SaveActivityScreen({super.key});

  @override
  State<SaveActivityScreen> createState() => _SaveActivityScreenState();
}

class _SaveActivityScreenState extends State<SaveActivityScreen> {
  bool showLoader = false;
  List<ChecklistData> savedChecklist = [];
  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getData();
    });
    super.initState();
  }

  getData() {
    savedChecklist = [];
    setState(() {
      showLoader = true;
    });
    String resData =
        preferences.getString(SharedPreference.activityData).toString();

    if (resData.isEmpty) {
      return;
    }

    var data = jsonDecode(resData);
    savedChecklist =
        List<ChecklistData>.from(data.map((x) => ChecklistData.fromJson(x)));
    setState(() {
      showLoader = false;
    });
    log('data--SaveActivityScreen--- $data');
    log('data---------savedChecklist-- ${json.encode(data)}');
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Container(
      color: backGroundColor,
      child: Scaffold(
        backgroundColor: const Color(0xffFDFDFD),
        appBar: AppBarWidget(
          centerTitle: true,
          title: AppString.savedActivity.boldRobotoTextStyle(fontSize: 20),
        ),
        body: savedChecklist.isEmpty
            ? const Center(
                child: Text('No any saved activity found!'),
              )
            : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05).copyWith(
                    top: Responsive.isDesktop(context) ? h * 0.03 : h * 0.017,
                    bottom: 20),
                shrinkWrap: true,
                itemCount: savedChecklist.length,
                itemBuilder: (context, index) {
                  log('savedChecklist----------- ${savedChecklist[index].toJson()}');

                  return GestureDetector(
                    onTap: () async {
                      final data = ConstDataModel(
                          towerName: savedChecklist[index]
                                  .listChecklistData?[0]
                                  .towerName ??
                              "",
                          activityId:
                              savedChecklist[index].activityId!.toString(),
                          flatFloorName: (savedChecklist[index]
                                          .listChecklistData?[0]
                                          .flatName !=
                                      null &&
                                  savedChecklist[index]
                                          .listChecklistData?[0]
                                          .flatName !=
                                      "false")
                              ? "${savedChecklist[index].listChecklistData?[0].flatName}"
                              : "${savedChecklist[index].listChecklistData?[0].flooName}",
                          data: savedChecklist[index].listChecklistData,
                          screen: 'save',
                          activityName:
                              "${savedChecklist[index].activityName}");
                      log('data--------activityName--- ${data.activityName}');

                      final result = await Get.toNamed(
                        Routes.activityDetailsScreen,
                        arguments: {"model": data},
                      );
                      log('result---------->>>>>> $result');
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: h * 0.01),
                      decoration: BoxDecoration(
                        color: containerColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: w * 0.035, vertical: h * 0.017),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: CircleAvatar(
                                      backgroundColor: greenColor,
                                      radius: 12,
                                    ),
                                  ),
                                  (w * 0.03).addWSpace(),
                                  Expanded(
                                    flex: 20,
                                    child:
                                        "${savedChecklist[index].activityName}"
                                            .toString()
                                            .boldRobotoTextStyle(
                                                maxLine: 2,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.symmetric(horizontal: w * 0.03),
                              padding: EdgeInsets.symmetric(
                                  vertical: h * 0.008, horizontal: w * 0.03),
                              decoration: BoxDecoration(
                                border: Border.all(color: greyTextColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              width: w,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      "Project Name".semiBoldBarlowTextStyle(
                                          fontSize: 14),
                                      "${savedChecklist[index].listChecklistData?[0].projectName}"
                                          .regularBarlowTextStyle(fontSize: 14),
                                    ],
                                  ),
                                  (h * 0.01).addHSpace(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      "Tower Name".semiBoldBarlowTextStyle(
                                          fontSize: 14),
                                      "${savedChecklist[index].listChecklistData?[0].towerName}"
                                          .regularBarlowTextStyle(fontSize: 14),
                                    ],
                                  ),
                                  (h * 0.01).addHSpace(),
                                  if (savedChecklist[index]
                                              .listChecklistData?[0]
                                              .flooName !=
                                          null &&
                                      savedChecklist[index]
                                              .listChecklistData?[0]
                                              .flooName !=
                                          "false")
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        "Floor Name".semiBoldBarlowTextStyle(
                                            fontSize: 14),
                                        "${savedChecklist[index].listChecklistData?[0].flooName}"
                                            .regularBarlowTextStyle(
                                                fontSize: 14),
                                      ],
                                    ),
                                  if (savedChecklist[index]
                                              .listChecklistData?[0]
                                              .flatName !=
                                          null &&
                                      savedChecklist[index]
                                              .listChecklistData?[0]
                                              .flatName !=
                                          "false")
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        "Flat Name : ".semiBoldBarlowTextStyle(
                                            fontSize: 14),
                                        "${savedChecklist[index].listChecklistData?[0].flatName}"
                                            .regularBarlowTextStyle(
                                                fontSize: 14),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                            (h * 0.01).addHSpace(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
