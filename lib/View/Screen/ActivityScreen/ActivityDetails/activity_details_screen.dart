import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:venkatesh_buildcon_app/Api/Apis/api_response.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/constructor_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_checklist_by_activity_res_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/notification_res_model.dart';
import 'package:venkatesh_buildcon_app/View/Constant/app_color.dart';
import 'package:venkatesh_buildcon_app/View/Constant/app_string.dart';
import 'package:venkatesh_buildcon_app/View/Constant/shared_prefs.dart';
import 'package:venkatesh_buildcon_app/View/Screen/ActivityScreen/ActivityDetails/activity_details_controller.dart';
import 'package:venkatesh_buildcon_app/View/Screen/BottomBarScreen/Notification/notification_controller.dart';
import 'package:venkatesh_buildcon_app/View/Utils/app_layout.dart';
import 'package:venkatesh_buildcon_app/View/Utils/app_routes.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/app_bar.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/back_to_home_button.dart';
import 'package:venkatesh_buildcon_app/View/utils/extension.dart';

class ActivityDetailsScreen extends StatefulWidget {
  const ActivityDetailsScreen({super.key});
  @override
  State<ActivityDetailsScreen> createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen> {
  ActivityDetailsController activityDetailsController =
      Get.put(ActivityDetailsController());

  NotificationController notificationController =
      Get.put(NotificationController());

  @override
  void initState() {
    activityDetailsController.getActivityData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      color: backGroundColor,
      child: Scaffold(
        floatingActionButton: const CommonBackToHomeButton(),
        appBar: AppBarWidget(
          title: AppString.activityDetails.boldRobotoTextStyle(fontSize: 20),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: backGroundColor,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.06),
          child: Column(
            children: [
              GetBuilder<ActivityDetailsController>(builder: (controller) {
                {
                  return Expanded(
                    child: controller.constData.screen == "save"
                        ? SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                (h * 0.03).addHSpace(),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: w * 0.05),
                                  decoration: BoxDecoration(
                                    color: containerColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: h * 0.02),
                                        child: CircleAvatar(
                                          backgroundColor: greenColor,
                                          radius: 8,
                                        ),
                                      ),
                                      (w * 0.04).addWSpace(),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: h * 0.05),
                                        child: SizedBox(
                                          width: w * 0.63,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                controller.constData
                                                        .activityName ??
                                                    "",
                                                style: black15Bold,
                                              ),
                                              (h * 0.005).addHSpace(),
                                              Text(
                                                  controller.constData
                                                          .flatFloorName ??
                                                      "",
                                                  style: black11Bold),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                (h * 0.02).addHSpace(),
                                controller.checklistData?.isEmpty ?? false
                                    ? SizedBox(
                                        height: h * 0.45,
                                        child: const Center(
                                          child: Text(
                                              'No activity checklist available!'),
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount:
                                            controller.checklistData?.length,
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () async {
                                              /// Maker

                                              if (preferences.getString(
                                                      SharedPreference
                                                          .userType) ==
                                                  "maker") {
                                                if (index + 1 > 1
                                                    ? controller
                                                            .checklistData![
                                                                index - 1]
                                                            .activityStatus ==
                                                        "draft"
                                                    : controller
                                                                .checklistData?[
                                                                    index]
                                                                .activityStatus ==
                                                            "draft" &&
                                                        index > 0) {
                                                  errorSnackBar("Oops!",
                                                      'Please update ${controller.checklistData![index - 1].name?.toUpperCase()} activity first');

                                                  return;
                                                }
                                              }

                                              /// Checker

                                              if (preferences.getString(
                                                      SharedPreference
                                                          .userType) ==
                                                  "checker") {
                                                if (controller
                                                        .checklistData![index]
                                                        .activityStatus ==
                                                    "draft") {
                                                  errorSnackBar(
                                                      "Stay Connected",
                                                      'Please wait, until maker submit checklist!');
                                                  return;
                                                } else if (index <= 0) {
                                                } else if (index + 1 > 1
                                                    ? controller
                                                            .checklistData![
                                                                index - 1]
                                                            .activityStatus ==
                                                        "submit"
                                                    : controller
                                                            .checklistData?[
                                                                index]
                                                            .activityStatus ==
                                                        "submit") {
                                                  errorSnackBar("Oops!",
                                                      'Please update ${controller.checklistData![index - 1].name?.toUpperCase()} activity first');
                                                  return;
                                                }
                                              }

                                              /// Approver

                                              if (preferences.getString(
                                                      SharedPreference
                                                          .userType) ==
                                                  "approver") {
                                                if (controller
                                                            .checklistData![
                                                                index]
                                                            .activityStatus ==
                                                        "submit" ||
                                                    controller
                                                            .checklistData![
                                                                index]
                                                            .activityStatus ==
                                                        "draft") {
                                                  errorSnackBar(
                                                      "Stay Connected",
                                                      'Please wait, until maker and checker submit checklist!');
                                                  return;
                                                } else if (controller
                                                        .checklistData![index]
                                                        .activityStatus ==
                                                    "submit") {
                                                  errorSnackBar(
                                                      "Stay Connected",
                                                      'Please wait, until checker submit checklist!');
                                                  return;
                                                } else if (index <= 0) {
                                                } else if (index + 1 > 1
                                                    ? controller
                                                            .checklistData![
                                                                index - 1]
                                                            .activityStatus ==
                                                        "checked"
                                                    : controller
                                                            .checklistData?[
                                                                index]
                                                            .activityStatus ==
                                                        "checked") {
                                                  errorSnackBar("Oops!",
                                                      'Please update ${controller.checklistData![index - 1].name?.toUpperCase()} activity first');
                                                  return;
                                                }
                                              }

                                              final data =
                                                  ActivityDataConstModel(
                                                towerName: controller
                                                        .constData.towerName ??
                                                    "",
                                                activityId: controller
                                                        .constData.activityId ??
                                                    "",
                                                flatFloorName: controller
                                                        .constData
                                                        .flatFloorName ??
                                                    "",
                                                activityName: controller
                                                        .constData
                                                        .activityName ??
                                                    "",
                                                activityData: controller
                                                    .checklistData?[index],
                                                floorFlatData: controller
                                                            .constData.screen ==
                                                        'flat'
                                                    ? controller.flatData
                                                    : controller.floorData,
                                              );

                                              await Get.toNamed(
                                                  Routes.editActivityScreen,
                                                  arguments: {
                                                    "model": data,
                                                    "screen": "activity",
                                                    "network": "no"
                                                  });
                                              controller.getActivityData();
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  bottom: h * 0.028),
                                              decoration: BoxDecoration(
                                                color: containerColor,
                                                border: Border.all(
                                                  color:
                                                      const Color(0xffE6E6E6),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: h * 0.02,
                                                            horizontal:
                                                                w * 0.06),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: CircleAvatar(
                                                            backgroundColor: controller
                                                                        .checklistData?[
                                                                            index]
                                                                        .color ==
                                                                    'red'
                                                                ? redColor
                                                                : controller.checklistData?[index]
                                                                            .color ==
                                                                        'green'
                                                                    ? greenColor
                                                                    : orangeColor,
                                                            radius: 12,
                                                          ),
                                                        ),
                                                        (w * 0.03).addWSpace(),
                                                        Expanded(
                                                          child: Row(
                                                            children: [
                                                              controller
                                                                  .checklistData![
                                                                      index]
                                                                  .name
                                                                  .toString()
                                                                  .toUpperCase()
                                                                  .boldRobotoTextStyle(
                                                                      textOverflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLine:
                                                                          2,
                                                                      fontSize:
                                                                          15),
                                                              (w * 0.01)
                                                                  .addWSpace(),
                                                              (preferences.getString(SharedPreference.userType) ==
                                                                              "maker" &&
                                                                          controller.checklistData![index].activityStatus !=
                                                                              "draft") ||
                                                                      (preferences.getString(SharedPreference.userType) ==
                                                                              "checker" &&
                                                                          (controller.checklistData![index].activityStatus != "draft" &&
                                                                              controller.checklistData![index].activityStatus !=
                                                                                  "submit")) ||
                                                                      (preferences.getString(SharedPreference.userType) ==
                                                                              "approver" &&
                                                                          (controller.checklistData![index].activityStatus != "draft" &&
                                                                              controller.checklistData![index].activityStatus !=
                                                                                  "submit" &&
                                                                              controller.checklistData![index].activityStatus !=
                                                                                  "checked"))
                                                                  ? Icon(
                                                                      Icons
                                                                          .done_all,
                                                                      color:
                                                                          greenColor)
                                                                  : const SizedBox()
                                                            ],
                                                          ),
                                                        ),
                                                        (w * 0.03).addWSpace(),
                                                        "(${controller.checklistData![index].lineData?.where((element) => element.value.toLowerCase() != "no").length.toString()}/${controller.checklistData![index].lineData?.length.toString()})"
                                                            .toString()
                                                            .boldRobotoTextStyle(
                                                                fontColor:
                                                                    Colors
                                                                        .black,
                                                                fontSize: 18),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: w,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                w * 0.06,
                                                            vertical:
                                                                h * 0.0072),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                      ),
                                                      border: Border.all(
                                                        color: Colors
                                                            .grey.shade300,
                                                      ),
                                                    ),
                                                    child: (controller
                                                                    .checklistData![
                                                                        index]
                                                                    .activityStatus ==
                                                                "draft"
                                                            ? "Status : ${controller.checklistData![index].activityStatus.toString().capitalizeFirst}"
                                                            //   : "Last updated by ${controller.checklistData![index].activityStatus == "submit" ? "Maker" : (controller.checklistData![index].activityStatus == "approve" /*|| res.checklistData!.listChecklistData![index].activityStatus == "approver_reject"*/) ? "Approver" : "Checker"}")

                                                            : "Last updated by ${controller.checklistData![index].activityStatus?.toLowerCase() == "submit" ? "Maker" : (controller.checklistData![index].activityStatus?.toLowerCase() == "approve") ? "Approver" : (controller.checklistData![index].activityStatus?.toLowerCase() == "approver_reject") ? "Checker" : (controller.checklistData![index].activityStatus?.toLowerCase() == "checker_reject") ? "Maker" : "Checker"}")
                                                        .toString()
                                                        .boldRobotoTextStyle(
                                                            fontColor: appColor,
                                                            fontSize: 14),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                (h * 0.015).addHSpace(),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                (h * 0.03).addHSpace(),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: w * 0.05),
                                  decoration: BoxDecoration(
                                    color: containerColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Padding(
                                      //   padding: EdgeInsets.symmetric(
                                      //       vertical: h * 0.02),
                                      //   child: CircleAvatar(
                                      //     backgroundColor: greenColor,
                                      //     radius: 8,
                                      //   ),
                                      // ),
                                      (w * 0.04).addWSpace(),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: h * 0.05),
                                        child: SizedBox(
                                          width: w * 0.63,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Text(
                                              //   controller.constData.screen ==
                                              //           'flat'
                                              //       ? controller
                                              //               .flatData?.name ??
                                              //           ""
                                              //       : controller
                                              //               .floorData?.name ??
                                              //           "",
                                              //   style: black15Bold,
                                              // ),
                                              // (h * 0.005).addHSpace(),

                                              Text(
                                                controller.constData.screen ==
                                                        'flat'
                                                    ? controller
                                                            .flatData?.name ??
                                                        ""
                                                    : controller.constData
                                                                .screen ==
                                                            'notification'
                                                        ? controller
                                                                .constData
                                                                .data
                                                                ?.activityName ??
                                                            ""
                                                        : controller.floorData
                                                                ?.name ??
                                                            "",
                                                style: black15Bold,
                                              ),
                                              (h * 0.005).addHSpace(),

                                              "Tower: ${(controller.constData?.towerName?.isNotEmpty ?? false ? controller.constData?.towerName : controller.activityData?.towerName) ?? 'N/A'}"
                                                  .regularBarlowTextStyle(
                                                      fontSize: 15),
                                              // (h * 0.007).addHSpace(),
                                              // (controller.constData.screen ==
                                              //             'notification'
                                              //         ? "Flat: ${(controller.constData?.flatFloorName?.isNotEmpty ?? false ? controller.constData?.flatFloorName : controller.activityData?.flatName) ?? 'N/A'}"
                                              //         : "Floor: ${(controller.constData?.flatFloorName?.isNotEmpty ?? false ? controller.constData?.flatFloorName : controller.activityData?.flooName) ?? 'N/A'}")

                                              //     .regularBarlowTextStyle(
                                              //         fontSize: 15),
                                              (h * 0.005).addHSpace(),

                                              () {
                                                String label = "Location: N/A";
                                                final name = (controller
                                                                .constData
                                                                .flatFloorName
                                                                ?.isNotEmpty ??
                                                            false
                                                        ? controller.constData
                                                            .flatFloorName
                                                        : controller
                                                            .activityData
                                                            ?.floorName) ??
                                                    'N/A';
                                                final isFlat = RegExp(r'^\d+$')
                                                        .hasMatch(name) ||
                                                    name.toLowerCase() ==
                                                        "false";
                                                label = isFlat
                                                    ? "Flat: $name"
                                                    : "Floor: $name";
                                                // Log for debugging
                                                print(
                                                    "ActivityDetailsScreen - towerName: ${controller.constData.towerName}, flatFloorName: ${controller.constData.flatFloorName}, displayLocation: $label");
                                                return label
                                                    .regularBarlowTextStyle(
                                                        fontSize: 15);
                                              }(),

                                              Text(
                                                  controller.constData.screen ==
                                                          'flat'
                                                      ? controller
                                                              .flatData?.desc
                                                              .toString() ??
                                                          ""
                                                      : controller
                                                              .floorData?.desc
                                                              .toString() ??
                                                          "",
                                                  style: black11Bold),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: h * 0.016, bottom: h * 0.017),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        AppString.lastUpdateTime
                                            .semiBoldBarlowTextStyle(
                                                fontSize: 11),
                                        DateFormat('dd/MM/yyyy hh:mm')
                                            .format(
                                                controller.constData.screen ==
                                                        'flat'
                                                    ? controller.flatData
                                                            ?.writeDate ??
                                                        DateTime.now()
                                                    : controller.floorData
                                                            ?.writeDate ??
                                                        DateTime.now())
                                            .regularRobotoTextStyle(
                                                fontSize: 11),
                                      ],
                                    ),
                                  ),
                                ),
                                (h * 0.015).addHSpace(),
                                Builder(
                                  builder: (context) {
                                    if (controller
                                            .getActivityChecklistApiResponse
                                            .status ==
                                        Status.LOADING) {
                                      return SizedBox(
                                        child: showCircular(),
                                        height: h * 0.425,
                                      );
                                    } else if (controller
                                            .getActivityChecklistApiResponse
                                            .status ==
                                        Status.COMPLETE) {
                                      ChecklistByActivityResponseModel res =
                                          controller
                                              .getActivityChecklistApiResponse
                                              .data;

                                      return res
                                                  .checklistData
                                                  ?.listChecklistData
                                                  ?.isEmpty ??
                                              false
                                          ? SizedBox(
                                              height: h * 0.45,
                                              child: const Center(
                                                child: Text(
                                                    'No activity checklist available!'),
                                              ),
                                            )
                                          : ListView.builder(
                                              itemCount: res.checklistData
                                                  ?.listChecklistData?.length,
                                              shrinkWrap: true,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                  onTap: () async {
                                                    /// Maker
                                                    /////////////////// for maker restriction per approver by checker then maker submit during
                                                    // if (preferences.getString(
                                                    //         SharedPreference
                                                    //             .userType) ==
                                                    //     "maker") {
                                                    //   if (index > 0) {
                                                    //     String activityName = res
                                                    //             .checklistData
                                                    //             ?.listChecklistData![
                                                    //                 index - 1]
                                                    //             .name
                                                    //             ?.toUpperCase() ??
                                                    //         "previous";
                                                    //     String activityStatus = res
                                                    //             .checklistData
                                                    //             ?.listChecklistData![
                                                    //                 index - 1]
                                                    //             .activityStatus ??
                                                    //         "";

                                                    //     if (activityStatus ==
                                                    //         "draft") {
                                                    //       errorSnackBar("Oops!",
                                                    //           'Please update $activityName activity first!');
                                                    //       return;
                                                    //     } else if (activityStatus ==
                                                    //         "submit") {
                                                    //       errorSnackBar(
                                                    //         "Oops!",
                                                    //         'Please wait until checker checks the $activityName activity!',
                                                    //       );
                                                    //       return;
                                                    //     }
                                                    //   }
                                                    // }

                                                    if (preferences.getString(
                                                            SharedPreference
                                                                .userType) ==
                                                        "maker") {
                                                      if (index + 1 > 1
                                                          ? res
                                                                  .checklistData
                                                                  ?.listChecklistData![
                                                                      index - 1]
                                                                  .activityStatus ==
                                                              "draft"
                                                          : res
                                                                      .checklistData
                                                                      ?.listChecklistData?[
                                                                          index]
                                                                      .activityStatus ==
                                                                  "draft" &&
                                                              index > 0) {
                                                        errorSnackBar("Oops!",
                                                            'Please update ${res.checklistData?.listChecklistData![index - 1].name?.toUpperCase()} activity first');

                                                        return;
                                                      }
                                                    }

                                                    //// Checker

                                                    if (preferences.getString(
                                                            SharedPreference
                                                                .userType) ==
                                                        "checker") {
                                                      if (res
                                                              .checklistData!
                                                              .listChecklistData![
                                                                  index]
                                                              .activityStatus ==
                                                          "draft") {
                                                        errorSnackBar(
                                                            "Stay Connected",
                                                            'Please wait, until maker submit checklist!');
                                                        return;
                                                      } else if (index <= 0) {
                                                      } else if (index + 1 > 1
                                                          ? res
                                                                  .checklistData
                                                                  ?.listChecklistData![
                                                                      index - 1]
                                                                  .activityStatus ==
                                                              "submit"
                                                          : res
                                                                  .checklistData
                                                                  ?.listChecklistData?[
                                                                      index]
                                                                  .activityStatus ==
                                                              "submit") {
                                                        errorSnackBar("Oops!",
                                                            'Please update ${res.checklistData?.listChecklistData![index - 1].name?.toUpperCase()} activity first');
                                                        return;
                                                      }
                                                    }

                                                    /// Approver

                                                    if (preferences.getString(
                                                            SharedPreference
                                                                .userType) ==
                                                        "approver") {
                                                      if (res
                                                                  .checklistData!
                                                                  .listChecklistData![
                                                                      index]
                                                                  .activityStatus ==
                                                              "submit" ||
                                                          res
                                                                  .checklistData!
                                                                  .listChecklistData![
                                                                      index]
                                                                  .activityStatus ==
                                                              "draft") {
                                                        errorSnackBar(
                                                            "Stay Connected",
                                                            'Please wait, until maker and checker submit checklist!');
                                                        return;
                                                      } else if (res
                                                              .checklistData!
                                                              .listChecklistData![
                                                                  index]
                                                              .activityStatus ==
                                                          "submit") {
                                                        errorSnackBar(
                                                            "Stay Connected",
                                                            'Please wait, until checker submit checklist!');
                                                        return;
                                                      } else if (index <= 0) {
                                                      } else if (index + 1 > 1
                                                          ? res
                                                                  .checklistData
                                                                  ?.listChecklistData![
                                                                      index - 1]
                                                                  .activityStatus ==
                                                              "checked"
                                                          : res
                                                                  .checklistData
                                                                  ?.listChecklistData?[
                                                                      index]
                                                                  .activityStatus ==
                                                              "checked") {
                                                        errorSnackBar("Oops!",
                                                            'Please update ${res.checklistData?.listChecklistData![index - 1].name?.toUpperCase()} activity first');
                                                        return;
                                                      }
                                                    }

                                                    final data =
                                                        ActivityDataConstModel(
                                                      towerName: controller
                                                              .constData
                                                              .towerName ??
                                                          "",
                                                      flatFloorName: controller
                                                              .constData
                                                              .flatFloorName ??
                                                          "",

                                                      activityName: controller
                                                                  .constData
                                                                  .screen ==
                                                              'flat'
                                                          ? controller.flatData
                                                                  ?.name ??
                                                              ""
                                                          : controller.constData
                                                                      .screen ==
                                                                  'notification'
                                                              ? controller
                                                                      .constData
                                                                      .data
                                                                      ?.activityName ??
                                                                  ""
                                                              : controller
                                                                      .floorData
                                                                      ?.name ??
                                                                  "",

                                                      // activityName: controller
                                                      //             .constData
                                                      //             .screen ==
                                                      //         'flat'
                                                      //     ? controller.flatData
                                                      //             ?.name ??
                                                      //         ""
                                                      //     : controller.floorData
                                                      //             ?.name ??
                                                      //         "",
                                                      activityData: res
                                                              .checklistData!
                                                              .listChecklistData?[
                                                          index],
                                                      floorFlatData: controller
                                                                  .constData
                                                                  .screen ==
                                                              'flat'
                                                          ? controller.flatData
                                                          : controller
                                                              .floorData,
                                                    );

                                                    await Get.toNamed(
                                                        Routes
                                                            .editActivityScreen,
                                                        arguments: {
                                                          "model": data,
                                                          "screen": "activity",
                                                        });
                                                    controller
                                                        .getActivityData();
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: h * 0.028),
                                                    decoration: BoxDecoration(
                                                      color: containerColor,
                                                      border: Border.all(
                                                        color: const Color(
                                                            0xffE6E6E6),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      h * 0.02,
                                                                  horizontal:
                                                                      w * 0.06),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    CircleAvatar(
                                                                      backgroundColor: res.checklistData?.listChecklistData?[index].color ==
                                                                              'red'
                                                                          ? redColor
                                                                          : res.checklistData?.listChecklistData?[index].color == 'green'
                                                                              ? greenColor
                                                                              : orangeColor,
                                                                      radius: 7,
                                                                    ),
                                                                    (w * 0.03)
                                                                        .addWSpace(),
                                                                    Expanded(
                                                                      child: res
                                                                          .checklistData!
                                                                          .listChecklistData![
                                                                              index]
                                                                          .name
                                                                          .toString()
                                                                          .toUpperCase()
                                                                          .boldRobotoTextStyle(
                                                                              textOverflow: TextOverflow.ellipsis,
                                                                              maxLine: 2,
                                                                              fontSize: 15),
                                                                    ),
                                                                    (w * 0.01)
                                                                        .addWSpace(),
                                                                    (preferences.getString(SharedPreference.userType) == "maker" && res.checklistData!.listChecklistData![index].activityStatus != "draft") ||
                                                                            (preferences.getString(SharedPreference.userType) == "checker" &&
                                                                                (res.checklistData!.listChecklistData![index].activityStatus != "draft" && res.checklistData!.listChecklistData![index].activityStatus != "submit")) ||
                                                                            (preferences.getString(SharedPreference.userType) == "approver" && (res.checklistData!.listChecklistData![index].activityStatus != "draft" && res.checklistData!.listChecklistData![index].activityStatus != "submit" && res.checklistData!.listChecklistData![index].activityStatus != "checked"))
                                                                        ? Icon(Icons.done_all, color: greenColor)
                                                                        : const SizedBox()
                                                                  ],
                                                                ),
                                                              ),
                                                              (w * 0.03)
                                                                  .addWSpace(),
                                                              "(${res.checklistData!.listChecklistData![index].lineData?.where((element) => element.value.toLowerCase() != "no").length.toString()}/${res.checklistData!.listChecklistData![index].lineData?.length.toString()})"
                                                                  .toString()
                                                                  .boldRobotoTextStyle(
                                                                      fontColor:
                                                                          Colors
                                                                              .black,
                                                                      fontSize:
                                                                          18),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          width: w,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      w * 0.06,
                                                                  vertical: h *
                                                                      0.0072),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            border: Border.all(
                                                              color: Colors.grey
                                                                  .shade300,
                                                            ),
                                                          ),
                                                          child: (res
                                                                          .checklistData!
                                                                          .listChecklistData![
                                                                              index]
                                                                          .activityStatus ==
                                                                      "draft"
                                                                  ? "Status : ${res.checklistData!.listChecklistData![index].activityStatus.toString().capitalizeFirst}"
                                                                  : "Last updated by ${res.checklistData!.listChecklistData![index].activityStatus == "submit" ? "Maker" : (res.checklistData!.listChecklistData![index].activityStatus == "approve") ? "Approver" : (res.checklistData!.listChecklistData![index].activityStatus == "approver_reject") ? "Checker" : (res.checklistData!.listChecklistData![index].activityStatus == "checker_reject") ? "Maker" : "Checker"}")
                                                              .toString()
                                                              .boldRobotoTextStyle(
                                                                  fontColor:
                                                                      appColor,
                                                                  fontSize: 14),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                    } else if (controller
                                            .getActivityChecklistApiResponse
                                            .status ==
                                        Status.ERROR) {
                                      return const Center(
                                        child: Text('Server Error'),
                                      );
                                    } else {
                                      controller.getActivityData();
                                      return const Center(
                                        child: Text('Something went wrong'),
                                      );
                                    }
                                  },
                                ),
                                (h * 0.015).addHSpace(),
                              ],
                            ),
                          ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
