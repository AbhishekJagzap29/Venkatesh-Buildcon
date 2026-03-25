import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:venkatesh_buildcon_app/View/Constant/app_assets.dart';
import 'package:venkatesh_buildcon_app/View/Constant/app_color.dart';
import 'package:venkatesh_buildcon_app/View/Constant/app_string.dart';
import 'package:venkatesh_buildcon_app/View/Constant/responsive.dart';
import 'package:venkatesh_buildcon_app/View/Utils/extension.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/app_bar.dart';

class ShowOfflineDataScreen extends StatefulWidget {
  const ShowOfflineDataScreen({super.key});

  @override
  State<ShowOfflineDataScreen> createState() => _ShowOfflineDataScreenState();
}

class _ShowOfflineDataScreenState extends State<ShowOfflineDataScreen> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      color: backGroundColor,
      child: Scaffold(
        backgroundColor: backGroundColor,
        appBar: AppBarWidget(
            title:
                AppString.projectsChecklist.boldRobotoTextStyle(fontSize: 20)),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.06),
          child: Column(
            children: [
              (h * 0.03).addHSpace(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(w * 0.035),
                        margin: EdgeInsets.only(bottom: h * 0.025),
                        decoration: BoxDecoration(
                          color: containerColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xffE6E6E6),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Center(
                                  child: Container(
                                    height: Responsive.isDesktop(context)
                                        ? h * 0.37
                                        : Responsive.isTablet(context)
                                            ? h * 0.275
                                            : h * 0.25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: networkImageShimmer(
                                      h: h * 0.25,
                                      w: w,
                                      url:
                                          "controller.projectDetailsRes?.projectData?.imageUrl}"
                                              .toString(),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  child: Padding(
                                    padding: const EdgeInsets.all(7),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: CircleAvatar(
                                        backgroundColor: greenColor,
                                        radius: 8,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: h * 0.017, bottom: h * 0.012),
                                child: StepProgressIndicator(
                                  totalSteps: 5,
                                  roundedEdges: const Radius.circular(10),
                                  currentStep: 3, //controller.count,
                                  unselectedSize: h * 0.007,
                                  size: h * 0.007,
                                  selectedColor: greenColor,
                                  unselectedColor: lightGreyColor,
                                )),
                            "controller.projectDetailsRes?.projectData?.projectName}"
                                .toString()
                                .boldRobotoTextStyle(fontSize: 14),
                            AppString.locationName.regularRobotoTextStyle(
                                fontSize: 13, fontColor: greyTextColor)
                          ],
                        ),
                      ),
                      // if (controller.projectDetailsRes?.projectData
                      //         ?.checklistData?.isEmpty ??
                      //     false)
                      //   SizedBox(
                      //     height: h * 0.2,
                      //     child: const Center(
                      //       child: Text('No Data!'),
                      //     ),
                      //   )
                      // else
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(bottom: h * 0.03),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: Responsive.isDesktop(context) ? 3 : 2,
                          childAspectRatio: Responsive.isDesktop(context)
                              ? w * 0.0012
                              : Responsive.isTablet(context)
                                  ? w * 0.0018
                                  : w * 0.00365,
                          crossAxisSpacing: Responsive.isDesktop(context)
                              ? w * 0.04
                              : Responsive.isTablet(context)
                                  ? w * 0.06
                                  : w * 0.075,
                          mainAxisSpacing: Responsive.isDesktop(context)
                              ? h * 0.05
                              : h * 0.03,
                        ),
                        shrinkWrap: true,
                        itemCount: 2,
                        // controller.projectDetailsRes
                        //         ?.projectData?.checklistData?.length ??
                        //     0,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // preferences.putString(
                              //     SharedPreference.projectId, controller.projectId);
                              // Get.toNamed(Routes.projectDetailsScreen,
                              //     arguments: {
                              //       'cId':
                              //           "${controller.projectDetailsRes?.projectData?.checklistData![index].checklistId}"
                              //               .toString(),
                              //       'pId': controller.projectId,
                              //       'pName': controller.projectName,
                              //       "cName":
                              //           "${controller.projectDetailsRes?.projectData?.checklistData![index].name}"
                              //     });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xffE6E6E6),
                                ),
                                color: containerColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                      width: Responsive.isDesktop(context)
                                          ? w * 0.23
                                          : w * 0.365,
                                      height: Responsive.isDesktop(context)
                                          ? h * 0.18
                                          : Responsive.isTablet(context)
                                              ? h * 0.12
                                              : h * 0.08,
                                      child: networkImageShimmer(
                                        radius: 10,
                                        fit: BoxFit.cover,
                                        h: h * 0.25,
                                        w: w,
                                        url:
                                            "controller.projectDetailsRes?.projectData?.checklistData?[index].image}"
                                                .toString(),
                                      )),
                                  "controller.projectDetailsRes?.projectData?.checklistData![index].name}"
                                      .toString()
                                      .semiBoldBarlowTextStyle(
                                        maxLine: 1,
                                        fontSize: 14,
                                        textOverflow: TextOverflow.ellipsis,
                                      ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
