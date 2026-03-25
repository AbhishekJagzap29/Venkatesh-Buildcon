//EXISTING WORKING CODE
// import 'dart:developer';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:step_progress_indicator/step_progress_indicator.dart';
// import 'package:venkatesh_buildcon_app/Api/Apis/api_response.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/constructor_model.dart';
// import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_flat_floor_res_model.dart';
// import 'package:venkatesh_buildcon_app/View/Screen/CubeTestingScreen/cube_records_screen.dart';
// import 'package:venkatesh_buildcon_app/View/Screen/TowerScreen/tower_controller.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/app_color.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/app_string.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/responsive.dart';
// import 'package:venkatesh_buildcon_app/View/Utils/app_layout.dart';
// import 'package:venkatesh_buildcon_app/View/Utils/app_routes.dart';
// import 'package:venkatesh_buildcon_app/View/Widgets/app_bar.dart';
// import 'package:venkatesh_buildcon_app/View/Widgets/back_to_home_button.dart';
// import 'package:venkatesh_buildcon_app/View/Widgets/search_filter_row.dart';
// import 'package:venkatesh_buildcon_app/View/utils/extension.dart';

// class TowerDetailsScreen extends StatefulWidget {
//   const TowerDetailsScreen({super.key});

//   @override
//   State<TowerDetailsScreen> createState() => _TowerDetailsScreenState();
// }

// class _TowerDetailsScreenState extends State<TowerDetailsScreen> {
//   TowerController towerController = Get.put(TowerController());

//   @override
//   Widget build(BuildContext context) {
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;

//     return Container(
//       color: backGroundColor,
//       child: Scaffold(
//         floatingActionButton: const CommonBackToHomeButton(),
//         backgroundColor: backGroundColor,
//         appBar: AppBarWidget(
//             title: AppString.towerDetails.boldRobotoTextStyle(fontSize: 20)),
//         body: SafeArea(
//           child: GetBuilder<TowerController>(
//             builder: (controller) {
//               if (controller.getFlatFlorApiResponse.status == Status.LOADING) {
//                 return showCircular();
//               } else if (controller.getFlatFlorApiResponse.status ==
//                   Status.COMPLETE) {
//                 log('controller.flatFloorRes?.towerData!.progress==========>>>>>${controller.flatFloorRes?.towerData!.progress}');
//                 return Padding(
//                   padding: EdgeInsets.symmetric(horizontal: w * 0.06),
//                   child: SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         (h * 0.03).addHSpace(),
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                               vertical: h * 0.015, horizontal: w * 0.045),
//                           decoration: BoxDecoration(
//                             color: containerColor,
//                             border: Border.all(
//                               color: const Color(0xffE6E6E6),
//                             ),
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           child: Center(
//                             child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     SizedBox(
//                                       width: w * 0.55,
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           "${controller.flatFloorRes?.towerData!.towerName}"
//                                               .toString()
//                                               .boldRobotoTextStyle(
//                                                   fontSize: 22),
//                                           (h * 0.005).addHSpace(),
//                                           SizedBox(
//                                             width: w * 0.42,
//                                             child: AppString.projectAddress
//                                                 .regularBarlowTextStyle(
//                                                     fontSize: 12),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     CircularStepProgressIndicator(
//                                       totalSteps: 10,
//                                       stepSize: 10,
//                                       currentStep: controller
//                                               .flatFloorRes?.towerData?.progress
//                                               ?.toInt() ??
//                                           0,
//                                       padding: 0.05,
//                                       height: Responsive.isDesktop(context)
//                                           ? h * 0.13
//                                           : h * 0.1,
//                                       width: Responsive.isDesktop(context)
//                                           ? h * 0.13
//                                           : h * 0.1,
//                                       selectedColor: greenColor,
//                                       unselectedColor: const Color(0xffBCCCBF),
//                                       child: Center(
//                                         child:
//                                             "${controller.flatFloorRes?.towerData?.progress?.toInt()}%"
//                                                 .boldRobotoTextStyle(
//                                                     fontSize: 18),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Divider(
//                                   color: const Color(0xffE6E6E6),
//                                   thickness: 2,
//                                   height: h * 0.02,
//                                 ),
//                                 Row(
//                                   children: [
//                                     'Total Checklist             :  '
//                                         .boldRobotoTextStyle(fontSize: 12),
//                                     (controller.flatFloorRes?.towerData
//                                                 ?.towerTotalCount ??
//                                             '0')
//                                         .toString()
//                                         .regularRobotoTextStyle(fontSize: 10),
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     'Maker Submitted        :  '
//                                         .boldRobotoTextStyle(fontSize: 12),
//                                     (controller.flatFloorRes?.towerData
//                                                 ?.towerMakerCount ??
//                                             '0')
//                                         .toString()
//                                         .regularRobotoTextStyle(fontSize: 10),
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     'Checker Submitted    :  '
//                                         .boldRobotoTextStyle(fontSize: 12),
//                                     (controller.flatFloorRes?.towerData
//                                                 ?.towerCheckerCount ??
//                                             '0')
//                                         .toString()
//                                         .regularRobotoTextStyle(fontSize: 10),
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     'Approver Submitted  :  '
//                                         .boldRobotoTextStyle(fontSize: 12),
//                                     (controller.flatFloorRes?.towerData
//                                                 ?.towerApproverCount ??
//                                             '0')
//                                         .toString()
//                                         .regularRobotoTextStyle(fontSize: 10),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                               vertical: Responsive.isDesktop(context)
//                                   ? h * 0.028
//                                   : h * 0.014),
//                           child: SearchAndFilterRow(
//                             onChanged: (p0) {
//                               controller.searchData();
//                             },
//                             controller: controller.searchController,
//                             hintText: AppString.searchTower,
//                           ),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 controller.searchController.clear();
//                                 controller.selectFlatFloor(0);
//                               },
//                               child: Container(
//                                 height: Responsive.isDesktop(context)
//                                     ? h * 0.068
//                                     : h * 0.048,
//                                 width: w * 0.23,
//                                 decoration: BoxDecoration(
//                                   color: controller.select == 0
//                                       ? appColor
//                                       : containerColor,
//                                   borderRadius: const BorderRadius.only(
//                                     topLeft: Radius.circular(10),
//                                     bottomLeft: Radius.circular(10),
//                                   ),
//                                 ),
//                                 child: Center(
//                                   child: AppString.flat.boldRobotoTextStyle(
//                                       fontSize: 16,
//                                       fontColor: controller.select == 0
//                                           ? backGroundColor
//                                           : Colors.black),
//                                 ),
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 controller.searchController.clear();
//                                 controller.selectFlatFloor(1);
//                               },
//                               child: Container(
//                                 height: Responsive.isDesktop(context)
//                                     ? h * 0.068
//                                     : h * 0.048,
//                                 width: w * 0.23,
//                                 decoration: BoxDecoration(
//                                   borderRadius: const BorderRadius.only(
//                                     topRight: Radius.circular(10),
//                                     bottomRight: Radius.circular(10),
//                                   ),
//                                   color: controller.select == 1
//                                       ? appColor
//                                       : containerColor,
//                                 ),
//                                 child: Center(
//                                   child: AppString.floor.boldRobotoTextStyle(
//                                       fontSize: 16,
//                                       fontColor: controller.select == 1
//                                           ? backGroundColor
//                                           : Colors.black),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         controller.select == 0 &&
//                                 controller.listFlatData.isEmpty
//                             ? SizedBox(
//                                 height: h * 0.4,
//                                 child: const Center(
//                                   child: Text('No flat data available!'),
//                                 ),
//                               )
//                             : controller.select == 1 &&
//                                     controller.listFloorData.isEmpty
//                                 ? SizedBox(
//                                     height: h * 0.4,
//                                     child: const Center(
//                                       child: Text('No floor data available!'),
//                                     ),
//                                   )
//                                 : GridView.builder(
//                                     padding: EdgeInsets.symmetric(
//                                         vertical: Responsive.isDesktop(context)
//                                             ? h * 0.03
//                                             : h * 0.017),
//                                     physics:
//                                         const NeverScrollableScrollPhysics(),
//                                     gridDelegate:
//                                         SliverGridDelegateWithFixedCrossAxisCount(
//                                       crossAxisCount: 2,
//                                       childAspectRatio:
//                                           Responsive.isTablet(context)
//                                               ? w * 0.00322
//                                               // : w * 0.004,
//                                               : w * 0.00512,
//                                       crossAxisSpacing: w * 0.045,
//                                       mainAxisSpacing: h * 0.02,
//                                     ),
//                                     shrinkWrap: true,
//                                     itemCount: controller.select == 0
//                                         ? controller.flatLength
//                                         : controller.floorLength,
//                                     itemBuilder: (context, index) {
//                                       ListFloor responseData =
//                                           controller.select == 0
//                                               ? controller
//                                                   .searchListFlatData[index]
//                                               : controller
//                                                   .searchListFloorData[index];

//                                       double per = double.parse(
//                                           responseData.progress ?? "0.00");

//                                       final count = per < 20
//                                           ? 0
//                                           : per < 40
//                                               ? 1
//                                               : per < 60
//                                                   ? 2
//                                                   : per < 80
//                                                       ? 3
//                                                       : per == 100
//                                                           ? 5
//                                                           : 4;

//                                       return GestureDetector(
//                                         onTap: () {
//                                           final data = TowerIdDataModal(
//                                               id: responseData.floorId
//                                                   .toString(),
//                                               towerName: controller
//                                                   .flatFloorRes!
//                                                   .towerData!
//                                                   .towerName);

//                                           Get.toNamed(
//                                               controller.select == 0
//                                                   ? Routes.flatActivityScreen
//                                                   : Routes.floorActivityScreen,
//                                               arguments: {
//                                                 "model": data,
//                                                 "count": count,
//                                                 "progress":
//                                                     responseData.progress ??
//                                                         "0.00",
//                                                 "tower_data": controller
//                                                     .flatFloorRes?.towerData,
//                                                 "flat_floor_data": controller
//                                                             .select ==
//                                                         0
//                                                     ? controller
//                                                         .flatFloorRes
//                                                         ?.towerData
//                                                         ?.listFlatData![index]
//                                                     : controller
//                                                         .flatFloorRes
//                                                         ?.towerData
//                                                         ?.listFloorData![index],
//                                               });

//                                         },
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                             border: Border.all(
//                                               color: const Color(0xffE6E6E6),
//                                             ),
//                                             color: containerColor,
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                           ),
//                                           child: Center(
//                                             child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 (h * 0.015).addHSpace(),
//                                                 const Spacer(),
//                                                 '${responseData.name}'
//                                                     .toString()
//                                                     .boldRobotoTextStyle(
//                                                         fontSize: 16),
//                                                 const Spacer(),

//                                                 // Padding(
//                                                 //   padding: EdgeInsets.symmetric(
//                                                 //       horizontal: w * 0.02),
//                                                 //   child: IntrinsicHeight(
//                                                 //     child: Row(
//                                                 //       mainAxisAlignment:
//                                                 //           MainAxisAlignment
//                                                 //               .spaceEvenly,
//                                                 //       children: [
//                                                 //         Column(
//                                                 //           children: [
//                                                 //             'M'.boldRobotoTextStyle(
//                                                 //                 fontSize: 12),
//                                                 //             (responseData
//                                                 //                         .makerCount ??
//                                                 //                     '0')
//                                                 //                 .toString()
//                                                 //                 .regularRobotoTextStyle(
//                                                 //                     fontSize:
//                                                 //                         10),
//                                                 //           ],
//                                                 //         ),
//                                                 //         const VerticalDivider(
//                                                 //             color: Color(
//                                                 //                 0xffE6E6E6),
//                                                 //             thickness: 2,
//                                                 //             width: 0),
//                                                 //         Column(
//                                                 //           children: [
//                                                 //             'C'.boldRobotoTextStyle(
//                                                 //                 fontSize: 12),
//                                                 //             (responseData
//                                                 //                         .checkerCount ??
//                                                 //                     '0')
//                                                 //                 .toString()
//                                                 //                 .regularRobotoTextStyle(
//                                                 //                     fontSize:
//                                                 //                         10),
//                                                 //           ],
//                                                 //         ),
//                                                 //         const VerticalDivider(
//                                                 //             color: Color(
//                                                 //                 0xffE6E6E6),
//                                                 //             thickness: 2,
//                                                 //             width: 0),
//                                                 //         Column(
//                                                 //           children: [
//                                                 //             'A'.boldRobotoTextStyle(
//                                                 //                 fontSize: 12),
//                                                 //             (responseData
//                                                 //                         .approverCount ??
//                                                 //                     '0')
//                                                 //                 .toString()
//                                                 //                 .regularRobotoTextStyle(
//                                                 //                     fontSize:
//                                                 //                         10),
//                                                 //           ],
//                                                 //         ),
//                                                 //       ],
//                                                 //     ),
//                                                 //   ),
//                                                 // ),
//                                                 // const Spacer(),
//                                                 Padding(
//                                                   padding: EdgeInsets.symmetric(
//                                                           horizontal: h * 0.012)
//                                                       .copyWith(
//                                                           bottom: h * 0.015),
//                                                   child: StepProgressIndicator(
//                                                     totalSteps: 5,
//                                                     roundedEdges:
//                                                         const Radius.circular(
//                                                             10),
//                                                     currentStep: count,
//                                                     unselectedSize: h * 0.007,
//                                                     size: h * 0.007,
//                                                     selectedColor: greenColor,
//                                                     unselectedColor:
//                                                         lightGreyColor,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                         (controller.flatLength ==
//                                         controller.searchListFlatData.length &&
//                                     controller.select == 0) ||
//                                 (controller.floorLength ==
//                                         controller.searchListFloorData.length &&
//                                     controller.select == 1)
//                             ? const SizedBox()
//                             : Center(
//                                 child: controller.load
//                                     ? showCircular()
//                                     : TextButton(
//                                         onPressed: () {
//                                           if (controller.select == 0) {
//                                             controller.setFlatLength(false);
//                                           } else {
//                                             controller.setFloorLength(false);
//                                           }
//                                         },
//                                         child: "Load more"
//                                             .semiBoldBarlowTextStyle(
//                                                 fontColor: appColor),
//                                       ),
//                               ),
//                         (h * 0.1).addHSpace()
//                       ],
//                     ),
//                   ),
//                 );
//               } else if (controller.getFlatFlorApiResponse.status ==
//                   Status.ERROR) {
//                 return const Center(child: Text('Server Error'));
//               } else {
//                 return const Center(child: Text('Something went wrong'));
//               }

//               /// OFFLINE
//               /*return controller.loading
//                   ? showCircular()
//                   : Padding(
//                       padding: EdgeInsets.symmetric(horizontal: w * 0.06),
//                       child: SingleChildScrollView(
//                         physics: const BouncingScrollPhysics(),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             (h * 0.03).addHSpace(),
//                             Container(
//                               padding: EdgeInsets.symmetric(vertical: h * 0.015, horizontal: w * 0.06),
//                               decoration: BoxDecoration(
//                                 color: containerColor,
//                                 border: Border.all(
//                                   color: const Color(0xffE6E6E6),
//                                 ),
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                               child: Center(
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         "${controller.flatFloorRes?.towerData!.towerName}"
//                                             .toString()
//                                             .boldRobotoTextStyle(fontSize: 22),
//                                         (h * 0.005).addHSpace(),
//                                         SizedBox(
//                                           width: w * 0.42,
//                                           child:
//                                               AppString.projectAddress.regularBarlowTextStyle(fontSize: 12),
//                                         )
//                                       ],
//                                     ),
//                                     CircularStepProgressIndicator(
//                                       totalSteps: 10,
//                                       stepSize: 10,
//                                       currentStep: 9,
//                                       padding: 0.05,
//                                       height: Responsive.isDesktop(context) ? h * 0.13 : h * 0.1,
//                                       width: Responsive.isDesktop(context) ? h * 0.13 : h * 0.1,
//                                       selectedColor: greenColor,
//                                       unselectedColor: const Color(0xffBCCCBF),
//                                       child: Center(
//                                         child: '90%'.boldRobotoTextStyle(fontSize: 20),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.symmetric(
//                                   vertical: Responsive.isDesktop(context) ? h * 0.028 : h * 0.014),
//                               child: SearchAndFilterRow(
//                                 onChanged: (p0) {
//                                   controller.searchData();
//                                 },
//                                 controller: controller.searchController,
//                                 hintText: AppString.searchTower,
//                               ),
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     controller.searchController.clear();
//                                     controller.selectFlatFloor(0);
//                                   },
//                                   child: Container(
//                                     height: Responsive.isDesktop(context) ? h * 0.068 : h * 0.048,
//                                     width: w * 0.23,
//                                     decoration: BoxDecoration(
//                                       color: controller.select == 0 ? appColor : containerColor,
//                                       borderRadius: const BorderRadius.only(
//                                         topLeft: Radius.circular(10),
//                                         bottomLeft: Radius.circular(10),
//                                       ),
//                                     ),
//                                     child: Center(
//                                       child: AppString.flat.boldRobotoTextStyle(
//                                           fontSize: 16,
//                                           fontColor: controller.select == 0 ? backGroundColor : Colors.black),
//                                     ),
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     controller.searchController.clear();
//                                     controller.selectFlatFloor(1);
//                                   },
//                                   child: Container(
//                                     height: Responsive.isDesktop(context) ? h * 0.068 : h * 0.048,
//                                     width: w * 0.23,
//                                     decoration: BoxDecoration(
//                                       borderRadius: const BorderRadius.only(
//                                         topRight: Radius.circular(10),
//                                         bottomRight: Radius.circular(10),
//                                       ),
//                                       color: controller.select == 1 ? appColor : containerColor,
//                                     ),
//                                     child: Center(
//                                       child: AppString.floor.boldRobotoTextStyle(
//                                           fontSize: 16,
//                                           fontColor: controller.select == 1 ? backGroundColor : Colors.black),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             controller.select == 0 && controller.listFlatData.isEmpty
//                                 ? SizedBox(
//                                     height: h * 0.4,
//                                     child: const Center(
//                                       child: Text('No flat data available!'),
//                                     ),
//                                   )
//                                 : controller.select == 1 && controller.listFloorData.isEmpty
//                                     ? SizedBox(
//                                         height: h * 0.4,
//                                         child: const Center(
//                                           child: Text('No floor data available!'),
//                                         ),
//                                       )
//                                     : GridView.builder(
//                                         padding: EdgeInsets.symmetric(
//                                             vertical: Responsive.isDesktop(context) ? h * 0.03 : h * 0.017),
//                                         physics: const NeverScrollableScrollPhysics(),
//                                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                                           crossAxisCount: 2,
//                                           childAspectRatio:
//                                               Responsive.isTablet(context) ? w * 0.00322 : w * 0.00512,
//                                           crossAxisSpacing: w * 0.045,
//                                           mainAxisSpacing: h * 0.02,
//                                         ),
//                                         shrinkWrap: true,
//                                         itemCount: controller.select == 0
//                                             ? controller.flatLength
//                                             : controller.floorLength,
//                                         itemBuilder: (context, index) {
//                                           ListFloor responseData = controller.select == 0
//                                               ? controller.searchListFlatData[index]
//                                               : controller.searchListFloorData[index];

//                                           return GestureDetector(
//                                             onTap: () {
//                                               final data = TowerIdDataModal(
//                                                   id: responseData.floorId.toString(),
//                                                   towerName: controller.flatFloorRes!.towerData!.towerName);

//                                               Get.toNamed(
//                                                   controller.select == 0
//                                                       ? Routes.flatActivityScreen
//                                                       : Routes.floorActivityScreen,
//                                                   arguments: {"model": data});
//                                             },
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                 border: Border.all(
//                                                   color: const Color(0xffE6E6E6),
//                                                 ),
//                                                 color: containerColor,
//                                                 borderRadius: BorderRadius.circular(10),
//                                               ),
//                                               child: Center(
//                                                 child: Column(
//                                                   mainAxisAlignment: MainAxisAlignment.center,
//                                                   children: [
//                                                     (h * 0.015).addHSpace(),
//                                                     const Spacer(),
//                                                     '${responseData.name}'
//                                                         .toString()
//                                                         .boldRobotoTextStyle(fontSize: 16),
//                                                     const Spacer(),
//                                                     Padding(
//                                                       padding: EdgeInsets.symmetric(horizontal: h * 0.012)
//                                                           .copyWith(bottom: h * 0.015),
//                                                       child: StepProgressIndicator(
//                                                         totalSteps: 5,
//                                                         roundedEdges: const Radius.circular(10),
//                                                         currentStep: 2,
//                                                         unselectedSize: h * 0.007,
//                                                         size: h * 0.007,
//                                                         selectedColor: greenColor,
//                                                         unselectedColor: lightGreyColor,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                       ),
//                             (controller.flatLength == controller.searchListFlatData.length &&
//                                         controller.select == 0) ||
//                                     (controller.floorLength == controller.searchListFloorData.length &&
//                                         controller.select == 1)
//                                 ? const SizedBox()
//                                 : Center(
//                                     child: controller.load
//                                         ? showCircular()
//                                         : TextButton(
//                                             onPressed: () {
//                                               if (controller.select == 0) {
//                                                 controller.setFlatLength(false);
//                                               } else {
//                                                 controller.setFloorLength(false);
//                                               }
//                                             },
//                                             child: "Load more".semiBoldBarlowTextStyle(fontColor: appColor),
//                                           ),
//                                   ),
//                             (h * 0.1).addHSpace()
//                           ],
//                         ),
//                       ),
//                     );*/
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

//13/03/2026  UPDATE - CUBE TESTING MODULE INTEGRATION
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:venkatesh_buildcon_app/Api/Apis/api_response.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/constructor_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/get_flat_floor_res_model.dart';
import 'package:venkatesh_buildcon_app/View/Screen/CubeTestingScreen/cube_records_screen.dart';
import 'package:venkatesh_buildcon_app/View/Screen/TowerScreen/tower_controller.dart';
import 'package:venkatesh_buildcon_app/View/Constant/app_color.dart';
import 'package:venkatesh_buildcon_app/View/Constant/app_string.dart';
import 'package:venkatesh_buildcon_app/View/Constant/responsive.dart';
import 'package:venkatesh_buildcon_app/View/Utils/app_layout.dart';
import 'package:venkatesh_buildcon_app/View/Utils/app_routes.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/app_bar.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/back_to_home_button.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/search_filter_row.dart';
import 'package:venkatesh_buildcon_app/View/utils/extension.dart';

class TowerDetailsScreen extends StatefulWidget {
  const TowerDetailsScreen({super.key});

  @override
  State<TowerDetailsScreen> createState() => _TowerDetailsScreenState();
}

class _TowerDetailsScreenState extends State<TowerDetailsScreen> {
  TowerController towerController = Get.put(TowerController());
  //13/03/2026
  var cName = Get.arguments['cName'] ?? "";
  final bool isCubeTesting = (Get.arguments['cName'] ?? "") == "Cube Testing";

  @override
  void initState() {
    super.initState();
    if (isCubeTesting) {
      // Force floor view for Cube Testing
      towerController.selectFlatFloor(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      color: backGroundColor,
      child: Scaffold(
        floatingActionButton: const CommonBackToHomeButton(),
        backgroundColor: backGroundColor,
        appBar: AppBarWidget(
          title: AppString.towerDetails.boldRobotoTextStyle(fontSize: 20),
        ),
        body: SafeArea(
          child: GetBuilder<TowerController>(
            builder: (controller) {
              if (controller.getFlatFlorApiResponse.status == Status.LOADING) {
                return showCircular();
              } else if (controller.getFlatFlorApiResponse.status ==
                  Status.COMPLETE) {
                log('controller.flatFloorRes?.towerData!.progress==========>>>>>${controller.flatFloorRes?.towerData!.progress}');

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (h * 0.03).addHSpace(),

                        // Tower summary card (same for all modules)
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: h * 0.015,
                            horizontal: w * 0.045,
                          ),
                          decoration: BoxDecoration(
                            color: containerColor,
                            border: Border.all(color: const Color(0xffE6E6E6)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: w * 0.55,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          "${controller.flatFloorRes?.towerData!.towerName}"
                                              .toString()
                                              .boldRobotoTextStyle(
                                                  fontSize: 22),
                                          (h * 0.005).addHSpace(),
                                          SizedBox(
                                            width: w * 0.42,
                                            child: AppString.projectAddress
                                                .regularBarlowTextStyle(
                                                    fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ),
                                    CircularStepProgressIndicator(
                                      totalSteps: 10,
                                      stepSize: 10,
                                      currentStep: controller
                                              .flatFloorRes?.towerData?.progress
                                              ?.toInt() ??
                                          0,
                                      padding: 0.05,
                                      height: Responsive.isDesktop(context)
                                          ? h * 0.13
                                          : h * 0.1,
                                      width: Responsive.isDesktop(context)
                                          ? h * 0.13
                                          : h * 0.1,
                                      selectedColor: greenColor,
                                      unselectedColor: const Color(0xffBCCCBF),
                                      child: Center(
                                        child:
                                            "${controller.flatFloorRes?.towerData?.progress?.toInt()}%"
                                                .boldRobotoTextStyle(
                                                    fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: const Color(0xffE6E6E6),
                                  thickness: 2,
                                  height: h * 0.02,
                                ),
                                Row(
                                  children: [
                                    'Total Checklist             :  '
                                        .boldRobotoTextStyle(fontSize: 12),
                                    (controller.flatFloorRes?.towerData
                                                ?.towerTotalCount ??
                                            '0')
                                        .toString()
                                        .regularRobotoTextStyle(fontSize: 10),
                                  ],
                                ),
                                // ... other count rows (maker, checker, approver) ...
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: Responsive.isDesktop(context)
                                ? h * 0.028
                                : h * 0.014,
                          ),
                          child: SearchAndFilterRow(
                            onChanged: (p0) => controller.searchData(),
                            controller: controller.searchController,
                            hintText: AppString.searchTower,
                          ),
                        ),

                        // ── Hide tabs when in Cube Testing mode ────────────────────────
                        if (!isCubeTesting) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  controller.searchController.clear();
                                  controller.selectFlatFloor(0);
                                },
                                child: Container(
                                  height: Responsive.isDesktop(context)
                                      ? h * 0.068
                                      : h * 0.048,
                                  width: w * 0.23,
                                  decoration: BoxDecoration(
                                    color: controller.select == 0
                                        ? appColor
                                        : containerColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: Center(
                                    child: AppString.flat.boldRobotoTextStyle(
                                      fontSize: 16,
                                      fontColor: controller.select == 0
                                          ? backGroundColor
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.searchController.clear();
                                  controller.selectFlatFloor(1);
                                },
                                child: Container(
                                  height: Responsive.isDesktop(context)
                                      ? h * 0.068
                                      : h * 0.048,
                                  width: w * 0.23,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                    color: controller.select == 1
                                        ? appColor
                                        : containerColor,
                                  ),
                                  child: Center(
                                    child: AppString.floor.boldRobotoTextStyle(
                                      fontSize: 16,
                                      fontColor: controller.select == 1
                                          ? backGroundColor
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          (h * 0.015).addHSpace(),
                        ],

                        // ── Grid ───────────────────────────────────────────────────────
                        if (isCubeTesting && controller.searchListFloorData.isEmpty) ...[
                          SizedBox(
                            height: h * 0.4,
                            child: const Center(child: Text('No floor data available!')),
                          ),
                        ] else if (!isCubeTesting &&
                            controller.select == 0 &&
                            controller.searchListFlatData.isEmpty) ...[
                          SizedBox(
                            height: h * 0.4,
                            child: const Center(child: Text('No flat data available!')),
                          ),
                        ] else if (!isCubeTesting &&
                            controller.select == 1 &&
                            controller.searchListFloorData.isEmpty) ...[
                          SizedBox(
                            height: h * 0.4,
                            child: const Center(child: Text('No floor data available!')),
                          ),
                        ] else ...[
                          GridView.builder(
                            padding: EdgeInsets.symmetric(
                              vertical: Responsive.isDesktop(context)
                                  ? h * 0.03
                                  : h * 0.017,
                            ),
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: Responsive.isTablet(context)
                                  ? w * 0.00322
                                  : w * 0.00512,
                              crossAxisSpacing: w * 0.045,
                              mainAxisSpacing: h * 0.02,
                            ),
                            shrinkWrap: true,
                            itemCount: isCubeTesting
                                ? controller.searchListFloorData.length
                                : (controller.select == 0
                                    ? controller.searchListFlatData.length
                                    : controller.searchListFloorData.length),
                            itemBuilder: (context, index) {
                              ListFloor responseData = isCubeTesting
                                  ? controller.searchListFloorData[index]
                                  : (controller.select == 0
                                      ? controller.searchListFlatData[index]
                                      : controller.searchListFloorData[index]);

                              double per = double.parse(responseData.progress ?? "0.00");

                              final count = per < 20
                                  ? 0
                                  : per < 40
                                      ? 1
                                      : per < 60
                                          ? 2
                                          : per < 80
                                              ? 3
                                              : per == 100
                                                  ? 5
                                                  : 4;

                              return GestureDetector(
                                onTap: () {
                                  final data = TowerIdDataModal(
                                    id: responseData.floorId.toString(),
                                    towerName:
                                        controller.flatFloorRes!.towerData!.towerName,
                                  );

                                  if (isCubeTesting) {
                                    Get.to(
                                      () => CubeRecordsScreen(
                                        floorId: responseData.floorId!,
                                      ),
                                      arguments: {
                                        "floorId": responseData.floorId,
                                        "towerId": controller
                                            .flatFloorRes?.towerData?.towerId,
                                        "towerName": controller
                                            .flatFloorRes?.towerData?.towerName,
                                        "floorName": responseData.name,
                                      },
                                    );
                                  } else {
                                    Get.toNamed(
                                      controller.select == 0
                                          ? Routes.flatActivityScreen
                                          : Routes.floorActivityScreen,
                                      arguments: {
                                        "model": data,
                                        "count": count,
                                        "progress": responseData.progress ?? "0.00",
                                        "tower_data": controller.flatFloorRes?.towerData,
                                        "flat_floor_data": controller.select == 0
                                            ? controller.flatFloorRes?.towerData
                                                ?.listFlatData![index]
                                            : controller.flatFloorRes?.towerData
                                                ?.listFloorData![index],
                                      },
                                    );
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: const Color(0xffE6E6E6)),
                                    color: containerColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        (h * 0.015).addHSpace(),
                                        const Spacer(),
                                        '${responseData.name}'
                                            .toString()
                                            .boldRobotoTextStyle(fontSize: 16),
                                        const Spacer(),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: h * 0.012,
                                          ).copyWith(bottom: h * 0.015),
                                          child: StepProgressIndicator(
                                            totalSteps: 5,
                                            roundedEdges: const Radius.circular(10),
                                            currentStep: count,
                                            unselectedSize: h * 0.007,
                                            size: h * 0.007,
                                            selectedColor: greenColor,
                                            unselectedColor: lightGreyColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],

                        // ── Load more ──────────────────────────────────────────────────
                        if (isCubeTesting &&
                            controller.floorLength ==
                                controller.searchListFloorData.length) ...[
                          const SizedBox(),
                        ] else if (!isCubeTesting &&
                            ((controller.flatLength ==
                                        controller.searchListFlatData.length &&
                                    controller.select == 0) ||
                                (controller.floorLength ==
                                        controller.searchListFloorData.length &&
                                    controller.select == 1))) ...[
                          const SizedBox(),
                        ] else ...[
                          Center(
                            child: controller.load
                                ? showCircular()
                                : TextButton(
                                    onPressed: () {
                                      if (isCubeTesting || controller.select == 1) {
                                        controller.setFloorLength(false);
                                      } else {
                                        controller.setFlatLength(false);
                                      }
                                    },
                                    child: "Load more"
                                        .semiBoldBarlowTextStyle(fontColor: appColor),
                                  ),
                          ),
                        ],

                        (h * 0.1).addHSpace(),
                      ],
                    ),
                  ),
                );
              } else if (controller.getFlatFlorApiResponse.status ==
                  Status.ERROR) {
                return const Center(child: Text('Server Error'));
              } else {
                return const Center(child: Text('Something went wrong'));
              }
            },
          ),
        ),
      ),
    );
  }
}