import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:venkatesh_buildcon_app/Api/Apis/api_response.dart';
import 'package:venkatesh_buildcon_app/View/Constant/app_color.dart';
import 'package:venkatesh_buildcon_app/View/Constant/responsive.dart';
import 'package:venkatesh_buildcon_app/View/Screen/UnitHandover/unit_handover_categories_screen.dart';
import 'package:venkatesh_buildcon_app/View/Screen/UnitHandover/unit_handover_controller.dart';
import 'package:venkatesh_buildcon_app/View/Utils/app_layout.dart';
import 'package:venkatesh_buildcon_app/View/Utils/extension.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/app_bar.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/back_to_home_button.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/search_filter_row.dart';

class UnitHandoverLocationsScreen extends StatefulWidget {
  final int flatId;
  final String flatName;

  const UnitHandoverLocationsScreen({
    super.key,
    required this.flatId,
    required this.flatName,
  });

  @override
  State<UnitHandoverLocationsScreen> createState() =>
      _UnitHandoverLocationsScreenState();
}

class _UnitHandoverLocationsScreenState
    extends State<UnitHandoverLocationsScreen> {
  late final UnitHandoverController controller;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    controller = Get.put(UnitHandoverController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchUnitHandoverLocations(flatId: widget.flatId);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Color _getStateColor(String? state) {
    switch (state?.toLowerCase()) {
      case 'completed':
      case 'done':
      case 'pass':
        return greenColor;

      case 'draft':
      default:
        return const Color(0xFF3498DB);
    }
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
        title: (widget.flatName.isNotEmpty
                ? "${widget.flatName}"
                : "Unit Handover Locations")
            .boldRobotoTextStyle(fontSize: 20, fontColor: Colors.white),
      ),
      body: SafeArea(
        child: GetBuilder<UnitHandoverController>(
          builder: (cnt) {
            final response = cnt.getLocationsApiResponse;

            if (response.status == Status.LOADING) {
              return showCircular();
            }

            if (response.status == Status.ERROR) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      response.message ?? "Error fetching locations",
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
                        cnt.fetchUnitHandoverLocations(flatId: widget.flatId);
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
            final locations = data?.locations ?? [];
            final filteredLocations = locations.where((loc) {
              final name = (loc.locationName ?? 'Location').toLowerCase();
              return name.contains(searchQuery);
            }).toList();

            final totalLocations = data?.totalLocationCount ?? 0;
            final pendingLocationCount = data?.pendingLocationCount ?? 0;
            final submittedLocationCount = data?.submittedLocationCount ?? 0;

            final double progressVal = totalLocations > 0
                ? (submittedLocationCount / totalLocations) * 100
                : 0.0;

            final String progressStr = progressVal.toStringAsFixed(1);
            final int currentStep = (progressVal / 20).round().clamp(0, 5);

            return RefreshIndicator(
              onRefresh: () async {
                await cnt.fetchUnitHandoverLocations(flatId: widget.flatId);
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
                    // Flat Overview Summary Card
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
                                    (data?.flatName ?? widget.flatName)
                                        .boldRobotoTextStyle(fontSize: 26),
                                    (data?.towerName ??
                                            data?.projectName ??
                                            'Unit Handover')
                                        .regularBarlowTextStyle(fontSize: 12),
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
                                  'Total Locations                :  '
                                      .boldRobotoTextStyle(fontSize: 12),
                                  '$totalLocations'
                                      .regularRobotoTextStyle(fontSize: 10),
                                ],
                              ),
                              Row(
                                children: [
                                  'Pending Locations          :  '
                                      .boldRobotoTextStyle(fontSize: 12),
                                  '$pendingLocationCount '
                                      .regularRobotoTextStyle(fontSize: 10),
                                ],
                              ),
                              Row(
                                children: [
                                  'Submitted Locations     :  '
                                      .boldRobotoTextStyle(fontSize: 12),
                                  '$submittedLocationCount'
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
                        hintText: "Search Location",
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
                          child: "Locations".boldRobotoTextStyle(fontSize: 16),
                        ),
                        Expanded(child: 1.0.appDivider(color: Colors.black)),
                      ],
                    ),

                    (h * 0.015).addHSpace(),

                    // Locations List
                    if (filteredLocations.isEmpty)
                      SizedBox(
                        height: h * 0.3,
                        child: Center(
                          child: Text(
                            searchQuery.isNotEmpty
                                ? "No locations found for \"$searchQuery\""
                                : "No handover locations found!",
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
                        itemCount: filteredLocations.length,
                        separatorBuilder: (context, index) =>
                            (h * 0.012).addHSpace(),
                        itemBuilder: (context, index) {
                          final loc = filteredLocations[index];
                          // final stateColor = _getStateColor(loc.state);
                          return InkWell(
                            onTap: () {
                              Get.to(
                                () => UnitHandoverCategoriesScreen(
                                  handoverLocationId:
                                      loc.handoverLocationId ?? 0,
                                  locationName: loc.locationName ?? "Location",
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Location Container
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(w * 0.035),
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
                                          color: getColorFromString(loc.color),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      (w * 0.03).addWSpace(),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            (loc.locationName ?? "Location")
                                                .boldRobotoTextStyle(
                                              fontSize: 16,
                                              fontColor: Colors.black,
                                            ),
                                          ],
                                        ),
                                      ),
                                      (w * 0.01).addWSpace(),
                                    ],
                                  ),
                                ),

                                // Submitted Date
                                if (loc.submittedAt != null &&
                                    loc.submittedAt!.isNotEmpty &&
                                    loc.submittedAt!.toLowerCase() != "false")
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 4,
                                      right: 6,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        "Last Updated :"
                                            .semiBoldBarlowTextStyle(
                                                fontSize: 11),
                                        const SizedBox(width: 4),
                                        DateFormat('dd/MM/yyyy hh:mm')
                                            .format(
                                              DateTime.parse(loc.submittedAt!),
                                            )
                                            .regularRobotoTextStyle(
                                                fontSize: 11),
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
