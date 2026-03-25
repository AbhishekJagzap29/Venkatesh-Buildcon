import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:venkatesh_buildcon_app/Api/Apis/api_response.dart';
import 'package:venkatesh_buildcon_app/View/Constant/app_string.dart';
import 'package:venkatesh_buildcon_app/View/Screen/ApproverActivityList/checklist_type_screen.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/app_bar.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/back_to_home_button.dart';
import 'package:venkatesh_buildcon_app/View/Screen/ApproverActivityList/checklist_data_screen_controller.dart';
import 'package:venkatesh_buildcon_app/View/Utils/extension.dart';

class ChecklistDataScreen extends StatefulWidget {
  const ChecklistDataScreen({Key? key}) : super(key: key);

  @override
  _ChecklistDataScreenState createState() => _ChecklistDataScreenState();
}

class _ChecklistDataScreenState extends State<ChecklistDataScreen> {
  ChecklistDataScreenController controller =
      Get.put(ChecklistDataScreenController());
  String searchQuery = "";

  @override
  void initState() {
    controller.getActivityChecklist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBarWidget(
        title: AppString.checklistdata.boldRobotoTextStyle(fontSize: 20),
      ),
      floatingActionButton: const CommonBackToHomeButton(),
      body: SafeArea(
        child: GetBuilder<ChecklistDataScreenController>(
          builder: (controller) {
            if (controller.activityChecklistResponse.status == Status.LOADING) {
              return const Center(child: CircularProgressIndicator());
            } else if (controller.activityChecklistResponse.status ==
                Status.COMPLETE) {
              final filteredList = controller.checklistDataApprover
                  .where((item) => (item.name ?? "")
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()))
                  .toList();

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: w * 0.06, vertical: h * 0.02),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search here',
                          hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16), 
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(12), 
                            borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1), 
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 2), 
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1), 
                          ),
                          prefixIcon: const Icon(Icons.search,
                              color: Colors.grey),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 10), 
                          fillColor: Colors.white,
                          filled: true, 
                        ),
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black), 
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          filteredList.isEmpty
                              ? SizedBox(
                                  height: h * 0.45,
                                  child: const Center(
                                      child:
                                          Text('No checklist data available!')),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.only(top: h * 0.017),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: filteredList.length,
                                  itemBuilder: (context, index) {
                                    final checklistDataApprover =
                                        filteredList[index];
                                    return GestureDetector(
                                      onTap: () {
                                        final activityId =
                                            checklistDataApprover.activity_id;
                                        final name = checklistDataApprover.name;
                                        print("Tapped Activity Name: $name");

                                        if (activityId != null &&
                                            activityId != 0) {
                                          Get.to(() => ActivityTypeScreen(
                                              patn_id: activityId, name: '', activity_id: activityId,));
                                        } else {
                                          print(
                                              "Activity ID is null or empty!");
                                        }
                                      },
                                      child: Column(
                                        children: [
                                          ListTile(
                                            title: Text(
                                              checklistDataApprover.name ??
                                                  "No Name",
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 0.2,
                                            color:
                                                Color.fromARGB(255, 86, 86, 86),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                  child: Text('Error fetching checklist data!'));
            }
          },
        ),
      ),
    );
  }
}

































// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:venkatesh_buildcon_app/Api/Apis/api_response.dart';
// import 'package:venkatesh_buildcon_app/View/Constant/app_string.dart';
// import 'package:venkatesh_buildcon_app/View/Screen/ApproverActivityList/checklist_type_screen.dart';
// import 'package:venkatesh_buildcon_app/View/Widgets/app_bar.dart';
// import 'package:venkatesh_buildcon_app/View/Widgets/back_to_home_button.dart';
// import 'package:venkatesh_buildcon_app/View/Screen/ApproverActivityList/checklist_data_screen_controller.dart';
// import 'package:venkatesh_buildcon_app/View/Utils/extension.dart';

// class ChecklistDataScreen extends StatefulWidget {
//   const ChecklistDataScreen({Key? key}) : super(key: key);

//   @override
//   _ChecklistDataScreenState createState() => _ChecklistDataScreenState();
// }

// class _ChecklistDataScreenState extends State<ChecklistDataScreen> {
//   ChecklistDataScreenController controller =
//       Get.put(ChecklistDataScreenController());

//   @override
//   void initState() {
//     controller.getActivityChecklist();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.of(context).size.width;
//     final h = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBarWidget(
//         title: AppString.checklistdata.boldRobotoTextStyle(fontSize: 20),
//       ),
//       floatingActionButton: const CommonBackToHomeButton(),
//       body: SafeArea(
//         child: GetBuilder<ChecklistDataScreenController>(
//           builder: (controller) {
//             if (controller.activityChecklistResponse.status == Status.LOADING) {
//               return Center(child: CircularProgressIndicator());
//             } else if (controller.activityChecklistResponse.status ==
//                 Status.COMPLETE) {
//               // return SingleChildScrollView(
//               //   physics: BouncingScrollPhysics(),
//               //   child: Column(
//               //     children: [
//               //       Padding(
//               //         padding: EdgeInsets.symmetric(horizontal: w * 0.06),
//               //         child: Column(
//               //           crossAxisAlignment: CrossAxisAlignment.start,
//               //           children: [
                
//                  return SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: w * 0.06),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           controller.checklistDataApprover.isEmpty
//                               ? SizedBox(
//                                   height: h * 0.45,
//                                   child: const Center(
//                                       child:
//                                           Text('No checklist data available!')),
//                                 )

//                               : ListView.builder(
//                                   padding: EdgeInsets.only(top: h * 0.017),
//                                   physics: NeverScrollableScrollPhysics(),
//                                   shrinkWrap: true,
//                                   itemCount:
//                                       controller.checklistDataApprover.length,
//                                   itemBuilder: (context, index) {
//                                     final checklistDataApprover =
//                                         controller.checklistDataApprover[index];
//                                     return  GestureDetector(
//                                       onTap: () {
//                                         final activityId =
//                                             checklistDataApprover.activity_id;
//                                          final name = checklistDataApprover.name;
//                                         print(
//                                             "Tapped Activity Name: $name");

//                                         if (activityId != null &&
//                                             activityId != 0) {
//                                           Get.to(() => ActivityTypeScreen(
//                                               patn_id: activityId,
//                                               name: ''));
//                                         } else {
//                                           print(
//                                               "Activity ID is null or empty!");
//                                         }
//                                       },
//                                       child: Column(
//                                         children: [
//                                           ListTile(
//                                             title: Text(
//                                               checklistDataApprover.name ??
//                                                   "No Name",
//                                             ),
//                                           ),
//                                           Divider(
//                                             thickness: 1,
//                                             color:
//                                                 Color.fromARGB(255, 86, 86, 86),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   },
//                                 ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             } else {
//               return Center(child: Text('Error fetching checklist data!'));
//             }
//           },
//         ),
//       ),
//     );
//   }
// }




