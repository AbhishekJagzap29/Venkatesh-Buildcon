import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:venkatesh_buildcon_app/View/Constant/app_color.dart';
import 'package:venkatesh_buildcon_app/View/Constant/app_string.dart';
import 'package:venkatesh_buildcon_app/View/Constant/responsive.dart';
import 'package:venkatesh_buildcon_app/View/Screen/BottomBarScreen/Report/report_controller.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/app_bar.dart';
import 'package:venkatesh_buildcon_app/View/utils/extension.dart';

class ReportDetailScreen extends StatefulWidget {
  const ReportDetailScreen({super.key});

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  ReportController reportController = Get.put(ReportController());

  @override
  void initState() {
    // TODO: implement initState
    reportController.selectedTowerData = Get.arguments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      color: backGroundColor,
      child: GetBuilder<ReportController>(
        builder: (controller) {
          return Scaffold(
            backgroundColor: backGroundColor,
            appBar: AppBarWidget(
              title: controller.selectedTowerData!.trainerName
                  .toString()
                  .capitalizeFirst
                  ?.boldRobotoTextStyle(fontSize: 20),
            ),
            body: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        (h * 0.03).addHSpace(),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: w * 0.06, vertical: w * 0.026),
                          decoration: BoxDecoration(
                              color: containerColor,
                              border:
                                  Border.all(color: const Color(0xffE6E6E6)),
                              borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: controller
                                        .selectedTowerData!.topicOfTraining
                                        .toString()
                                        .boldRobotoTextStyle(fontSize: 18),
                                  ),
                                  Builder(
                                    builder: (context) {
                                      String formattedDateTime = DateFormat(
                                              'dd MMM,yyyy')
                                          .format(DateTime.parse(
                                              "${controller.selectedTowerData!.trainingDatedOn}"));

                                      return formattedDateTime
                                          .toString()
                                          .boldRobotoTextStyle(
                                              fontSize: 10,
                                              fontColor: appColor);
                                    },
                                  )
                                ],
                              ),
                              (h * 0.007).addHSpace(),
                              buildRow(
                                  title: "Project Name : ",
                                  subTitle:
                                      "${controller.selectedTowerData!.projectName}"),
                              (h * 0.007).addHSpace(),
                              buildRow(
                                  title: "Tower Name : ",
                                  subTitle:
                                      "${controller.selectedTowerData!.towerName}"),
                              (h * 0.007).addHSpace(),
                              buildRow(
                                  title: "Location : ",
                                  subTitle:
                                      "${controller.selectedTowerData!.location}"),
                              (h * 0.007).addHSpace(),
                              buildRow(
                                  title: "Training Date : ",
                                  subTitle:
                                      "${DateFormat('dd-MM-yyyy').format(controller.selectedTowerData!.trainingDatedOn!)}"),
                              (h * 0.007).addHSpace(),
                              buildRow(
                                  title: "Topic of Training : ",
                                  subTitle:
                                      "${controller.selectedTowerData!.topicOfTraining}"),
                              (h * 0.007).addHSpace(),
                              buildRow(
                                  title: "Start Time : ",
                                  subTitle:
                                      "${controller.selectedTowerData!.trainingStartTime}"),
                              (h * 0.007).addHSpace(),
                              buildRow(
                                  title: "End Time : ",
                                  subTitle:
                                      "${controller.selectedTowerData!.trainingEndTime}"),
                              (h * 0.007).addHSpace(),
                              buildRow(
                                  title: "Total Duration: ",
                                  subTitle:
                                      "${controller.selectedTowerData!.totalDuration}"),
                              (h * 0.007).addHSpace(),
                              buildRow(
                                  title: "Total Manhours: ",
                                  subTitle:
                                      "${controller.selectedTowerData!.totalManhours}"),
                              (h * 0.007).addHSpace(),
                              buildRow(
                                  title: "Description: ",
                                  subTitle:
                                      "${controller.selectedTowerData!.description}"),
                              (h * 0.007).addHSpace(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  "Training given to: "
                                      .toString()
                                      .boldRobotoTextStyle(
                                        fontSize: 13,
                                      ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: controller.selectedTowerData!
                                          .trainingGivenTo?.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return "${index + 1}. ${controller.selectedTowerData!.trainingGivenTo?[index]}"
                                            .toString()
                                            .regularRobotoTextStyle(
                                                fontSize: 13);
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),

                        /// OVERALL IMAGE GRID VIEW
                        controller.selectedTowerData!.overallImages!.isEmpty
                            ? const SizedBox()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (h * 0.03).addHSpace(),
                                  AppString.overAllImage
                                      .boldRobotoTextStyle(fontSize: 18)
                                      .paddingOnly(bottom: h * 0.01),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade100,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: EdgeInsets.symmetric(
                                        vertical: h * 0.02,
                                        horizontal: w * 0.02),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        overallImageGridView(
                                            controller, h, context, w)
                                      ],
                                    ),
                                  ),
                                  (h * 0.03).addHSpace()
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Row buildRow({String? title, String? subTitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title!.boldRobotoTextStyle(
          fontSize: 13,
        ),
        Expanded(
          child: subTitle!.toString().regularRobotoTextStyle(fontSize: 13),
        ),
      ],
    );
  }

  /// OVERALL IMAGE GRIDVIEW

  Widget overallImageGridView(
      ReportController controller, double h, BuildContext context, double w) {
    return GridView.builder(
      itemCount: controller.selectedTowerData?.overallImages?.length ?? 0,
      physics: const NeverScrollableScrollPhysics(),
      padding:
          const EdgeInsets.symmetric(horizontal: 2).copyWith(top: h * 0.015),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: Responsive.isDesktop(context) ? 4 : 3,
          crossAxisSpacing: w * 0.04,
          mainAxisSpacing: h * 0.018,
          childAspectRatio: 1.2),
      itemBuilder: (context, index1) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: blackColor, width: 1.2),
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: NetworkImage(
                        controller.selectedTowerData!.overallImages![index1]),
                    fit: BoxFit.fill),
              ),
            ),
            Positioned(
              bottom: 1,
              left: 1.1,
              right: 1.1,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        insetPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        backgroundColor: Colors.white,
                        child: Container(
                          height: h * 0.65,
                          // width: Responsive.isDesktop(context) ? w * 0.6 : w,
                          decoration: BoxDecoration(
                            border: Border.all(color: blackColor, width: 1.2),
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: NetworkImage(controller
                                  .selectedTowerData!.overallImages![index1]),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                height: h * 0.052,
                                width: h * 0.052,
                                margin: const EdgeInsets.all(10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: blackColor),
                                ),
                                child: const Icon(Icons.close,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: appColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Icon(Icons.remove_red_eye,
                      size:
                          Responsive.isDesktop(context) ? h * 0.037 : h * 0.025,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
