import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:venkatesh_buildcon_app/Api/Apis/api_response.dart';
import 'package:venkatesh_buildcon_app/View/Constant/app_color.dart';
import 'package:venkatesh_buildcon_app/View/Constant/app_string.dart';
import 'package:venkatesh_buildcon_app/View/Constant/responsive.dart';
import 'package:venkatesh_buildcon_app/View/Screen/UnitHandover/checkpoint_form_screen.dart';
import 'package:venkatesh_buildcon_app/View/Screen/UnitHandover/unit_handover_controller.dart';
import 'package:venkatesh_buildcon_app/View/Utils/app_layout.dart';
import 'package:venkatesh_buildcon_app/View/Utils/extension.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/app_bar.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/back_to_home_button.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/search_filter_row.dart';

class UnitHandoverCategoriesScreen extends StatefulWidget {
  final int handoverLocationId;
  final String locationName;

  const UnitHandoverCategoriesScreen({
    super.key,
    required this.handoverLocationId,
    required this.locationName,
  });

  @override
  State<UnitHandoverCategoriesScreen> createState() =>
      _UnitHandoverCategoriesScreenState();
}

class _UnitHandoverCategoriesScreenState
    extends State<UnitHandoverCategoriesScreen> {
  late final UnitHandoverController controller;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    controller = Get.put(UnitHandoverController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchUnitHandoverLocationCategories(
        handoverLocationId: widget.handoverLocationId,
      );
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backGroundColor,
      floatingActionButton: const CommonBackToHomeButton(),
      appBar: AppBarWidget(
        backGroundColor: const Color(0xFF3498DB),
        title: (widget.locationName.isNotEmpty
                ? widget.locationName
                : "Location Categories")
            .boldRobotoTextStyle(fontSize: 20, fontColor: Colors.white),
      ),
      body: SafeArea(
        child: GetBuilder<UnitHandoverController>(
          builder: (cnt) {
            final response = cnt.getCategoriesApiResponse;

            if (response.status == Status.LOADING) {
              return showCircular();
            }

            if (response.status == Status.ERROR) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      response.message ?? "Error fetching categories",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontFamily: 'Barlow',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    (h * 0.02).addHSpace(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3498DB),
                      ),
                      onPressed: () {
                        cnt.fetchUnitHandoverLocationCategories(
                          handoverLocationId: widget.handoverLocationId,
                        );
                      },
                      child: "Retry".boldRobotoTextStyle(
                        fontSize: 14,
                        fontColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }

            final data = response.data?.data;
            final categories = data?.categories ?? [];
            final filteredCategories = categories.where((cat) {
              final name = (cat.categoryName ?? 'Uncategorized').toLowerCase();
              return name.contains(searchQuery);
            }).toList();

            final totalCategories = categories.length;
            final submittedCount =
                categories.where((cat) => cat.submitted == true).length;
            final pendingCount = totalCategories - submittedCount;
            final totalActivities = categories.fold<int>(
                0, (sum, cat) => sum + (cat.activityCount ?? 0));

            final double progressVal = totalCategories > 0
                ? (submittedCount / totalCategories) * 100
                : 0.0;
            final String progressStr = progressVal.toStringAsFixed(1);
            final int currentStep = (progressVal / 20).round().clamp(0, 5);

            return RefreshIndicator(
              onRefresh: () async {
                await cnt.fetchUnitHandoverLocationCategories(
                  handoverLocationId: widget.handoverLocationId,
                );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.04,
                  vertical: h * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location Summary Card
                    Container(
                      padding: EdgeInsets.only(
                        left: w * 0.06,
                        right: w * 0.06,
                        top: h * 0.03,
                        bottom: h * 0.025,
                      ),
                      decoration: BoxDecoration(
                        color: containerColor,
                        border: Border.all(
                          color: const Color(0xffE6E6E6),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    (data?.locationName ?? widget.locationName)
                                        .boldRobotoTextStyle(fontSize: 26),
                                    // 'Location Categories'
                                    //     .regularBarlowTextStyle(fontSize: 12),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  '$progressStr%'
                                      .boldRobotoTextStyle(fontSize: 30),
                                  5.0.addHSpace(),
                                  StepProgressIndicator(
                                    totalSteps: 5,
                                    roundedEdges: const Radius.circular(10),
                                    currentStep: currentStep,
                                    unselectedSize: h * 0.007,
                                    size: h * 0.007,
                                    selectedColor: greenColor,
                                    unselectedColor: lightGreyColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          (h * 0.01).addHSpace(),
                          Column(
                            children: [
                              Divider(
                                color: const Color(0xffE6E6E6),
                                thickness: 2,
                                height: h * 0.02,
                              ),
                              Row(
                                children: [
                                  'Total Activities                :  '
                                      .boldRobotoTextStyle(fontSize: 12),
                                  '$totalCategories'
                                      .regularRobotoTextStyle(fontSize: 10),
                                ],
                              ),
                              Row(
                                children: [
                                  'Pending Activities          :  '
                                      .boldRobotoTextStyle(fontSize: 12),
                                  '$pendingCount'
                                      .regularRobotoTextStyle(fontSize: 10),
                                ],
                              ),
                              Row(
                                children: [
                                  'Submitted Activities     :  '
                                      .boldRobotoTextStyle(fontSize: 12),
                                  '$submittedCount'
                                      .regularRobotoTextStyle(fontSize: 10),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Responsive.isDesktop(context)
                            ? h * 0.028
                            : h * 0.016,
                      ),
                      child: SearchAndFilterRow(
                        isFilter: true,
                        controller: searchController,
                        hintText: "Search Activity",
                        onChanged: (val) {
                          setState(() {
                            searchQuery = val.trim().toLowerCase();
                          });
                        },
                      ),
                    ),

                    Row(
                      children: [
                        Expanded(child: 1.0.appDivider(color: Colors.black)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: "Activities".boldRobotoTextStyle(fontSize: 16),
                        ),
                        Expanded(child: 1.0.appDivider(color: Colors.black)),
                      ],
                    ),

                    (h * 0.015).addHSpace(),

                    // Categories List
                    if (filteredCategories.isEmpty)
                      SizedBox(
                        height: h * 0.3,
                        child: Center(
                          child: Text(
                            searchQuery.isNotEmpty
                                ? "No categories found for \"$searchQuery\""
                                : "No activity categories found!",
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Barlow',
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredCategories.length,
                        separatorBuilder: (context, index) =>
                            (h * 0.012).addHSpace(),
                        itemBuilder: (context, index) {
                          final cat = filteredCategories[index];

                          String formattedSubmittedAt = '';

                          if (cat.submitted == true &&
                              cat.submittedAt != null &&
                              cat.submittedAt!.isNotEmpty &&
                              cat.submittedAt!.toLowerCase() != 'false') {
                            try {
                              final submittedDate =
                                  DateTime.parse(cat.submittedAt!);

                              formattedSubmittedAt =
                                  DateFormat('dd/MM/yyyy hh:mm ')
                                      .format(submittedDate);
                            } catch (e) {
                              formattedSubmittedAt = '';
                            }
                          }

                          return InkWell(
                            onTap: () {
                              Get.to(
                                () => ChecklistFormScreen(
                                  handoverLocationId: widget.handoverLocationId,
                                  categoryId: cat.categoryId,
                                  categoryName:
                                      cat.categoryName ?? "Checklist Form",
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Category / Activity Container
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(w * 0.038),
                                  decoration: BoxDecoration(
                                    color: containerColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: const Color(0xffE6E6E6),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                          left: 4,
                                          right: 4,
                                        ),
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color:
                                              (cat.color ?? '').toLowerCase() ==
                                                      'red'
                                                  ? redColor
                                                  : (cat.color ?? '')
                                                              .toLowerCase() ==
                                                          'yellow'
                                                      ? yellowColor
                                                      : greenColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      (w * 0.03).addWSpace(),
                                      Expanded(
                                        child: (cat.categoryName ??
                                                "Uncategorized")
                                            .boldRobotoTextStyle(
                                          fontSize: 16,
                                          fontColor: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Submitted At - Outside container, bottom right
                                if (formattedSubmittedAt.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 4,
                                      right: 4,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AppString.lastUpdateTime
                                            .semiBoldBarlowTextStyle(
                                          fontSize: 10,
                                        ),
                                        const SizedBox(width: 4),
                                        formattedSubmittedAt
                                            .regularRobotoTextStyle(
                                          fontSize: 10,
                                        ),
                                      ],
                                    ),
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
          },
        ),
      ),
    );
  }
}
