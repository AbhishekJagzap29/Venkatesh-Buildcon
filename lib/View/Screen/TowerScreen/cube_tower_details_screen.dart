// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:step_progress_indicator/step_progress_indicator.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/app_color.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/app_string.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/responsive.dart';
// import 'package:venkatesh_buildcon_app/View/Screen/CubeTestingScreen/cube_records_screen.dart';
// import 'package:venkatesh_buildcon_app/View/Utils/app_layout.dart';
// import 'package:venkatesh_buildcon_app/View/Widgets/app_bar.dart';
// import 'package:venkatesh_buildcon_app/View/Widgets/back_to_home_button.dart';
// import 'package:venkatesh_buildcon_app/View/utils/extension.dart';

// class CubeTowerDetailsScreen extends StatefulWidget {
//   const CubeTowerDetailsScreen({super.key});

//   @override
//   State<CubeTowerDetailsScreen> createState() => _CubeTowerDetailsScreenState();
// }

// class _CubeTowerDetailsScreenState extends State<CubeTowerDetailsScreen> {
//   /// Dummy floor data
//   List floors = [
//     {"name": "1st", "progress": 2},
//     {"name": "2nd", "progress": 1},
//     {"name": "3rd", "progress": 3},
//     {"name": "4th", "progress": 0},
//     {"name": "5th", "progress": 4},
//     {"name": "6th", "progress": 2},
//   ];

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
//           title: AppString.towerDetails.boldRobotoTextStyle(fontSize: 20),
//         ),
//         body: SafeArea(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: w * 0.06),
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   (h * 0.03).addHSpace(),

//                   /// HEADER CARD
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                         vertical: h * 0.015, horizontal: w * 0.045),
//                     decoration: BoxDecoration(
//                       color: containerColor,
//                       border: Border.all(color: const Color(0xffE6E6E6)),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Column(
//                       children: [
//                         /// TOP ROW
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             SizedBox(
//                               width: w * 0.55,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   "A BUILDING FINISHING"
//                                       .boldRobotoTextStyle(fontSize: 22),
//                                   (h * 0.005).addHSpace(),
//                                   SizedBox(
//                                     width: w * 0.42,
//                                     child: AppString.projectAddress
//                                         .regularBarlowTextStyle(fontSize: 12),
//                                   )
//                                 ],
//                               ),
//                             ),

//                             /// PROGRESS CIRCLE
//                             CircularStepProgressIndicator(
//                               totalSteps: 10,
//                               stepSize: 10,
//                               currentStep: 0,
//                               padding: 0.05,
//                               height: Responsive.isDesktop(context)
//                                   ? h * 0.13
//                                   : h * 0.1,
//                               width: Responsive.isDesktop(context)
//                                   ? h * 0.13
//                                   : h * 0.1,
//                               selectedColor: greenColor,
//                               unselectedColor: const Color(0xffBCCCBF),
//                               child: Center(
//                                 child: "0%".boldRobotoTextStyle(fontSize: 18),
//                               ),
//                             ),
//                           ],
//                         ),

//                         Divider(
//                           color: const Color(0xffE6E6E6),
//                           thickness: 2,
//                           height: h * 0.02,
//                         ),

//                         /// STATS
//                         Row(
//                           children: [
//                             'Total Checklist             :  '
//                                 .boldRobotoTextStyle(fontSize: 12),
//                             '120'.regularRobotoTextStyle(fontSize: 10),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             'Maker Submitted        :  '
//                                 .boldRobotoTextStyle(fontSize: 12),
//                             '20'.regularRobotoTextStyle(fontSize: 10),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             'Checker Submitted    :  '
//                                 .boldRobotoTextStyle(fontSize: 12),
//                             '10'.regularRobotoTextStyle(fontSize: 10),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             'Approver Submitted  :  '
//                                 .boldRobotoTextStyle(fontSize: 12),
//                             '5'.regularRobotoTextStyle(fontSize: 10),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),

//                   /// SEARCH
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                         vertical: Responsive.isDesktop(context)
//                             ? h * 0.028
//                             : h * 0.014),
//                     child: TextField(
//                       decoration: InputDecoration(
//                         hintText: "Search Floor",
//                         filled: true,
//                         fillColor: containerColor,
//                         prefixIcon: const Icon(Icons.search),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                   ),

//                   /// FLOOR TITLE
//                   Center(
//                     child: Container(
//                       height:
//                           Responsive.isDesktop(context) ? h * 0.068 : h * 0.048,
//                       width: w * 0.23,
//                       decoration: BoxDecoration(
//                         color: appColor,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Center(
//                         child: AppString.floor.boldRobotoTextStyle(
//                             fontSize: 16, fontColor: backGroundColor),
//                       ),
//                     ),
//                   ),

//                   /// GRID
//                   GridView.builder(
//                       padding: EdgeInsets.symmetric(
//                           vertical: Responsive.isDesktop(context)
//                               ? h * 0.03
//                               : h * 0.017),
//                       physics: const NeverScrollableScrollPhysics(),
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         childAspectRatio: Responsive.isTablet(context)
//                             ? w * 0.00322
//                             : w * 0.00512,
//                         crossAxisSpacing: w * 0.045,
//                         mainAxisSpacing: h * 0.02,
//                       ),
//                       shrinkWrap: true,
//                       itemCount: floors.length,
//                       itemBuilder: (context, index) {
//                         final floor = floors[index];

//                         return GestureDetector(
//                           // onTap: () {
//                           //   Get.to(() => const CubeRecordsScreen());
//                           // },
//                           onTap: () {
//   Get.to(() => CubeRecordsScreen(
//         projectId: 1,
//         towerId: 1,
//         floorId: index + 1,
//         flatId: 1,
//       ));
// },
// //
//                           child: Container(
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: const Color(0xffE6E6E6),
//                               ),
//                               color: containerColor,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Center(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   const Spacer(),
//                                   '${floor["name"]}'
//                                       .boldRobotoTextStyle(fontSize: 16),
//                                   const Spacer(),
//                                   Padding(
//                                     padding: EdgeInsets.symmetric(
//                                             horizontal: h * 0.012)
//                                         .copyWith(bottom: h * 0.015),
//                                     child: StepProgressIndicator(
//                                       totalSteps: 5,
//                                       roundedEdges: const Radius.circular(10),
//                                       currentStep: floor["progress"],
//                                       unselectedSize: h * 0.007,
//                                       size: h * 0.007,
//                                       selectedColor: greenColor,
//                                       unselectedColor: lightGreyColor,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       }),

//                   (h * 0.1).addHSpace(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
