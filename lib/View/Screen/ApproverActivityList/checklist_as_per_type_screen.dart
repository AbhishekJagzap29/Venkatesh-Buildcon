// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:venkatesh_buildcon_app/Api/Apis/api_response.dart';
import 'package:venkatesh_buildcon_app/View/Constant/app_string.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/app_bar.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/back_to_home_button.dart';
import 'package:venkatesh_buildcon_app/View/Utils/extension.dart';
import 'checklist_As_per_type_screen_controller.dart';


class  ChecklistAsPerTypeScreen extends StatelessWidget {
  final int id;
  final String name;

  ChecklistAsPerTypeScreen( {required this.id,required this.name});

  @override
  Widget build(BuildContext context) {
    final ChecklistAsPerTypeScreenController controller =
        Get.put(ChecklistAsPerTypeScreenController(patn_id: id));
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBarWidget(
        title: AppString.checklistdata.boldRobotoTextStyle(fontSize: 20),
      ),
      floatingActionButton: const CommonBackToHomeButton(),
      body: SafeArea(
        child: GetBuilder<ChecklistAsPerTypeScreenController>(
          builder: (controller) {
            if (controller.activityAsPerTypeChecklistResponse.status ==
                Status.LOADING) {
              return Center(child: CircularProgressIndicator());
            } else if (controller.activityAsPerTypeChecklistResponse.status ==
                Status.COMPLETE) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          controller.activityTypesChecklist.isEmpty
                              ? SizedBox(
                                  height: h * 0.45,
                                  child: const Center(
                                      child:
                                          Text('No checklist data available!')),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.only(top: h * 0.017),
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount:
                                      controller.activityTypesChecklist.length,
                                  itemBuilder: (context, index) {
                                    final activityTypesChecklist = controller
                                        .activityTypesChecklist[index];
                                    return Column(
                                      children: [
                                        ListTile(
                                           title: Text(
                                            activityTypesChecklist
                                                   .name ??
                                              'No name available'),
                                        ),
                                        Divider(
                                          thickness: 0.2, color:Color.fromARGB(255, 86, 86, 86),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                          SizedBox(height: h * 0.035),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('Error loading data'));
            }
          },
        ),
      ),
    );
  }
}
