import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:venkatesh_buildcon_app/Api/Apis/api_response.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/GenerateNcResponseModel/nc_routing_through_notification_res_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/constructor_model.dart';
import 'package:venkatesh_buildcon_app/View/Constant/no_internet.dart';
import 'package:venkatesh_buildcon_app/View/Controller/network_controller.dart';
import 'package:venkatesh_buildcon_app/View/Screen/BottomBarScreen/Notification/notification_controller.dart';
import 'package:venkatesh_buildcon_app/View/Constant/app_color.dart';
import 'package:venkatesh_buildcon_app/View/Constant/app_string.dart';
import 'package:venkatesh_buildcon_app/View/Utils/app_layout.dart';
import 'package:venkatesh_buildcon_app/View/Utils/app_routes.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/app_bar.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/search_filter_row.dart';
import 'package:venkatesh_buildcon_app/View/utils/extension.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationController notificationController =
      Get.put(NotificationController());

  NetworkController networkController = Get.put(NetworkController());

  @override
  void initState() {
    getNotificationData();
    super.initState();
  }

  getNotificationData() async {
    networkController.checkConnectivity().then((value) async {
      if (networkController.isResult == false) {
        await notificationController.getNotificationController();
      }
    });
  }

  @override
  void dispose() {
    notificationController.clearFilter();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return GetBuilder<NetworkController>(
      builder: (netController) {
        return Container(
          color: backGroundColor,
          child: Scaffold(
            backgroundColor: const Color(0xffFDFDFD),
            appBar: AppBarWidget(
              leading: false,
              centerTitle: false,
              title: AppString.notification.boldRobotoTextStyle(fontSize: 20),
            ),
            body: netController.isResult == true
                ? NoInternetWidget(
                    h: h,
                    w: w,
                    onPressed: () {
                      getNotificationData();
                    },
                  ).paddingOnly(bottom: h * 0.178)
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                    child: GetBuilder<NotificationController>(
                      builder: (controller) {
                        if (controller.getNotificationApiResponse.status ==
                            Status.LOADING) {
                          return showCircular();
                        } else if (controller
                                .getNotificationApiResponse.status ==
                            Status.COMPLETE) {
                          return Column(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: h * 0.02),
                                child: SearchAndFilterRow(
                                  type: TextInputType.text,
                                  onChanged: (p0) {
                                    controller.searchData();
                                  },
                                  controller: controller.searchController,
                                  hintText: "Search sequence no..",
                                  onTap: () {
                                    Get.toNamed(
                                        Routes.notificationFilterScreen);
                                  },
                                ),
                              ),
                              Expanded(
                                child: controller.searchNotificationData.isEmpty
                                    ? const Center(
                                        child: Text('No Notification!'))
                                    : RefreshIndicator(
                                        onRefresh: () async {
                                          await getNotificationData();
                                        },
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero
                                              .copyWith(bottom: h * 0.12),
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemCount: controller
                                              .searchNotificationData.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            final notification = controller
                                                .searchNotificationData[index];

                                            return GestureDetector(
                                                onTap: () async {
                                                  if (notification.redirectId !=
                                                          null &&
                                                      notification.redirectId!
                                                          .isNotEmpty) {
                                                    if (notification.detailLine
                                                            ?.toLowerCase() ==
                                                        "wi") {
                                                      final seqNo =
                                                          notification.seq_no ??
                                                              "";
                                                      if (seqNo.isEmpty) {
                                                        errorSnackBar(
                                                          "Error",
                                                          "Invalid sequence number in notification.",
                                                        );
                                                        return;
                                                      }

                                                      final parts =
                                                          seqNo.split('/');
                                                      if (parts.length < 6) {
                                                        errorSnackBar(
                                                          "Error",
                                                          "Invalid sequence format in notification.",
                                                        );
                                                        return;
                                                      }

                                                      final towerName =
                                                          parts[2];
                                                      final floorOrFlatName =
                                                          parts[3];
                                                      final activityName =
                                                          parts[4];
                                                      final activityId =
                                                          parts[5];

                                                      ConstDataModel data =
                                                          ConstDataModel(
                                                        towerName: towerName,
                                                        flatFloorName:
                                                            floorOrFlatName,
                                                        data: notification,
                                                        screen: 'notification',
                                                        activityName:
                                                            activityName,
                                                        activityId: activityId,
                                                      );

                                                      await Get.toNamed(
                                                        Routes
                                                            .activityDetailsScreen,
                                                        arguments: {
                                                          "model": data
                                                        },
                                                      );
                                                    } else {
                                                      final ncIdString =
                                                          notification.ncId;
                                                      if (ncIdString == null ||
                                                          ncIdString.isEmpty) {
                                                        errorSnackBar("Error",
                                                            "Invalid NC ID.");
                                                        return;
                                                      }

                                                      final ncId = int.tryParse(
                                                          ncIdString);
                                                      if (ncId == null ||
                                                          ncId <= 0) {
                                                        errorSnackBar("Error",
                                                            "Invalid NC ID.");
                                                        return;
                                                      }

                                                      await notificationController
                                                          .getNcRoutingForNotification(
                                                              ncId);

                                                      if (notificationController
                                                              .ncRoutingResponse
                                                              .status ==
                                                          Status.COMPLETE) {
                                                        final ncRoutingData =
                                                            notificationController
                                                                    .ncRoutingResponse
                                                                    .data
                                                                as NcRoutingThroughNotificationModel;

                                                        Get.toNamed(
                                                          Routes
                                                              .generateNcCompleteDetailsScreen,
                                                          arguments: {
                                                            "screen":
                                                                "notification",
                                                            "id": ncId,
                                                            "ncRoutingData":
                                                                ncRoutingData,
                                                          },
                                                        );
                                                      } else {
                                                        errorSnackBar(
                                                            "Error",
                                                            notificationController
                                                                .ncRoutingResponse
                                                                .message
                                                                .toString());
                                                      }
                                                    }
                                                  }
                                                  ////=======================>
                                                },
                                                child: Container(
                                                  padding:
                                                      EdgeInsets.all(w * 0.02),
                                                  margin: EdgeInsets.only(
                                                      bottom: w * 0.038),
                                                  decoration: BoxDecoration(
                                                    color: containerColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xffE6E6E6)),
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Center(
                                                        child: Container(
                                                          height: h * 0.047,
                                                          width: h * 0.047,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: appColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: const Icon(
                                                            Icons
                                                                .notifications_none,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      (h * 0.01).addWSpace(),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            "${notification.title}"
                                                                .regularRobotoTextStyle(
                                                              textOverflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              fontSize: 14,
                                                              maxLine: 5,
                                                              fontColor: Colors
                                                                  .grey
                                                                  .shade700,
                                                            ),
                                                            "Sequence Number : ${notification.seq_no}"
                                                                .regularRobotoTextStyle(
                                                              fontSize: 14,
                                                              fontColor: Colors
                                                                  .grey
                                                                  .shade700,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      (h * 0.005).addWSpace(),
                                                      Builder(
                                                        builder: (context) {
                                                          String formattedDateTime = DateFormat(
                                                                  'dd MMM, hh:mm a')
                                                              .format(DateTime
                                                                      .parse(
                                                                          "${controller.searchNotificationData[index].notificationDt}")
                                                                  .add(const Duration(
                                                                      hours: 5,
                                                                      minutes:
                                                                          30)));

                                                          return Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: h *
                                                                        0.025),
                                                            child: formattedDateTime
                                                                .toString()
                                                                .boldRobotoTextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontColor:
                                                                        appColor),
                                                          );
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ));
                                          },
                                        ),
                                      ),
                              )
                            ],
                          );
                        } else if (controller
                                .getNotificationApiResponse.status ==
                            Status.ERROR) {
                          return const Center(child: Text('Server Error'));
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
          ),
        );
      },
    );
  }
}
