import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:venkatesh_buildcon_app/Api/Apis/api_response.dart';
import 'package:venkatesh_buildcon_app/View/Screen/ApproverActivityList/checklist_as_per_type_screen.dart';
import 'package:venkatesh_buildcon_app/View/Constant/app_string.dart';
import 'package:venkatesh_buildcon_app/View/Screen/ApproverActivityList/checklist_type_controller.dart';
import 'package:venkatesh_buildcon_app/View/Utils/extension.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/app_bar.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/back_to_home_button.dart';

class ActivityTypeScreen extends StatelessWidget {
  final int patn_id;
  final String name;
  final int activity_id;

  ActivityTypeScreen(
      {required this.patn_id, required this.name, required this.activity_id});

  @override
  Widget build(BuildContext context) {
    final ActivityTypeScreenController controller =
        Get.put(ActivityTypeScreenController(activity_id: activity_id));

    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBarWidget(
        title: AppString.checklisttype.boldRobotoTextStyle(fontSize: 20),
      ),
      floatingActionButton: const CommonBackToHomeButton(),
      body: SafeArea(
        child: GetBuilder<ActivityTypeScreenController>(
          builder: (controller) {
            if (controller.activityTypeResponse.status == Status.LOADING) {
              return Center(child: CircularProgressIndicator());
            } else if (controller.activityTypeResponse.status ==
                Status.COMPLETE) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.activityTypes.isEmpty
                          ? SizedBox(
                              height: h * 0.45,
                              child: const Center(
                                  child: Text('No activity types available!')),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.only(top: h * 0.017),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: controller.activityTypes.length,
                              itemBuilder: (context, index) {
                                final activityTypes =
                                    controller.activityTypes[index];
                                return GestureDetector(
                                 
                                  onTap: () {
                                    final patnId = activityTypes
                                        .patn_id;
                                    final name = activityTypes.name ?? '';
                                    print("Tapped Activity Name: $name");

                                    Get.to(() => ChecklistAsPerTypeScreen(
                                        id: patnId, name: name));
                                  },
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          activityTypes.name ?? "No Name",
                                        ),
                                      ),
                                      Divider(
                                        thickness: 0.2,
                                        color: Color.fromARGB(255, 86, 86, 86),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: Text('Error fetching activity types!'));
            }
          },
        ),
      ),
    );
  }
}
