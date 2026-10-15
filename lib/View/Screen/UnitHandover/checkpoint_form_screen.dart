import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:venkatesh_buildcon_app/Api/Apis/api_response.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/UnitHandover/unit_handover_activities_res_model.dart';
import 'package:venkatesh_buildcon_app/View/Constant/app_color.dart';
import 'package:venkatesh_buildcon_app/View/Constant/app_string.dart';
import 'package:venkatesh_buildcon_app/View/Constant/responsive.dart';
import 'package:venkatesh_buildcon_app/View/Screen/UnitHandover/unit_handover_controller.dart';
import 'package:venkatesh_buildcon_app/View/Utils/app_layout.dart';
import 'package:venkatesh_buildcon_app/View/Utils/extension.dart';

class CheckpointFormItem {
  final int id;
  final int? lineId;
  final String question;
  final int? sequence;
  String? value;

  CheckpointFormItem({
    required this.id,
    this.lineId,
    required this.question,
    this.sequence,
    this.value,
  });
}

class ChecklistFormScreen extends StatefulWidget {
  final int handoverLocationId;
  final int? categoryId;
  final String categoryName;

  const ChecklistFormScreen({
    super.key,
    required this.handoverLocationId,
    this.categoryId,
    this.categoryName = "Checklist Form",
  });

  @override
  State<ChecklistFormScreen> createState() => _ChecklistFormScreenState();
}

class _ChecklistFormScreenState extends State<ChecklistFormScreen> {
  final ScrollController scrollController = ScrollController();

  late final UnitHandoverController controller;

  List<CheckpointFormItem> checkpoints = [];

  bool isDataInitialized = false;
  bool isCategorySubmitted = false;

  @override
  void initState() {
    super.initState();

    controller = Get.isRegistered<UnitHandoverController>()
        ? Get.find<UnitHandoverController>()
        : Get.put(UnitHandoverController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _fetchActivities();
    });
  }

  void _fetchActivities() {
    if (!mounted) return;

    setState(() {
      checkpoints = [];
      isDataInitialized = false;
      isCategorySubmitted = false;
    });

    controller.fetchUnitHandoverCategoryActivities(
      handoverLocationId: widget.handoverLocationId,
      categoryId: widget.categoryId,
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _populateCheckpoints(List<HandoverActivityLine> activityLines) {
    // Don't populate anything if API has not returned data.
    if (activityLines.isEmpty) {
      return;
    }

    // Don't populate the same data again.
    if (isDataInitialized) {
      return;
    }

    checkpoints = activityLines.map((line) {
      String? initVal;

      /*
       * Your API log shows:
       *
       * status: false
       * status_label: false
       *
       * If your model converts status into String,
       * this will handle the String values.
       */

      if (line.status != null) {
        final String status = line.status.toString().toLowerCase();

        if (status == 'ok' ||
            status == 'yes' ||
            status == 'pass' ||
            status == 'completed' ||
            status == 'done' ||
            status == 'true') {
          initVal = 'ok';
        } else if (status == 'not_ok' ||
            status == 'no' ||
            status == 'fail' ||
            status == 'failed' ||
            status == 'false') {
          initVal = 'not_ok';
        }
      }

      return CheckpointFormItem(
        id: line.activityId ?? 0,
        lineId: line.lineId,
        question: line.activityName ?? '',
        sequence: line.sequence,
        value: initVal,
      );
    }).toList();

    // Check submitted status only from current API response.
    isCategorySubmitted = activityLines.any(
      (line) => line.categorySubmitted == true,
    );

    isDataInitialized = true;
  }

  Future<void> _onSubmit() async {
    hideKeyBoard(context);

    if (isCategorySubmitted) {
      errorSnackBar(
        "Already Submitted",
        "This category has already been submitted.",
      );
      return;
    }

    final int answeredCount = checkpoints
        .where(
          (item) => item.value != null,
        )
        .length;

    if (answeredCount < checkpoints.length) {
      errorSnackBar(
        "Incomplete Form",
        "Please select OK or Not OK for all checkpoints before submitting.",
      );
      return;
    }

    final List<Map<String, dynamic>> activityLinesPayload =
        checkpoints.map((item) {
      return {
        "line_id": item.lineId,
        "status": item.value,
      };
    }).toList();

    final bool success = await controller.submitUnitHandoverCategory(
      handoverLocationId: widget.handoverLocationId,
      categoryId: widget.categoryId,
      activityLines: activityLinesPayload,
    );

    if (!mounted) return;

    if (success) {
      successSnackBar(
        "Success",
        "Category submitted successfully!",
      );

      // Refresh categories
      await controller.fetchUnitHandoverLocationCategories(
        handoverLocationId: widget.handoverLocationId,
      );

      Future.delayed(
        const Duration(milliseconds: 600),
        () {
          if (!mounted) return;

          // Go back to previous screen
          Get.back(result: true);
        },
      );
    } else {
      final String errorMsg =
          controller.submitCategoryApiResponse.message ?? "Submission failed";

      errorSnackBar(
        "Error",
        errorMsg,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color(0xFF3498DB),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: (widget.categoryName.isNotEmpty
                ? widget.categoryName
                : "Checklist Form")
            .boldRobotoTextStyle(
          fontSize: 20,
          fontColor: Colors.white,
        ),
      ),
      body: GestureDetector(
        onTap: () => hideKeyBoard(context),
        child: GetBuilder<UnitHandoverController>(
          builder: (cnt) {
            final response = cnt.getActivitiesApiResponse;

            // LOADING

            if (response.status == Status.LOADING) {
              return showCircular();
            }

            // ERROR

            if (response.status == Status.ERROR) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      response.message ?? "Error fetching category activities",
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
                        setState(() {
                          checkpoints.clear();
                          isDataInitialized = false;
                          isCategorySubmitted = false;
                        });

                        controller.resetUnitHandoverCategoryActivities();

                        controller.fetchUnitHandoverCategoryActivities(
                          handoverLocationId: widget.handoverLocationId,
                          categoryId: widget.categoryId,
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

            // GET CURRENT ACTIVITY DATA

            final activityLines = response.data?.data?.activityLines ?? [];

            _populateCheckpoints(activityLines);

            // NO DATA

            if (checkpoints.isEmpty) {
              return SizedBox(
                height: h * 0.6,
                child: const Center(
                  child: Text(
                    "No activities found for this category!",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Barlow',
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            }

            final bool isSubmitting =
                cnt.submitCategoryApiResponse.status == Status.LOADING;

            // --------------------------------------------------
            // FORM
            // --------------------------------------------------

            return SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.04,
                vertical: h * 0.02,
              ),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ------------------------------------------------
                  // CHECKPOINT LIST
                  // ------------------------------------------------

                  ListView.separated(
                    itemCount: checkpoints.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) =>
                        (h * 0.012).addHSpace(),
                    itemBuilder: (context, index) {
                      final checkpoint = checkpoints[index];

                      final bool isSelected = checkpoint.value != null;

                      return Container(
                        decoration: BoxDecoration(
                          color: containerColor,
                          border: Border.all(
                            color: const Color(0xffE6E6E6),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: h * 0.012,
                          horizontal: w * 0.03,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // QUESTION
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  CupertinoIcons.arrow_right_square_fill,
                                  color: Colors.black,
                                  size: 20,
                                ).paddingOnly(
                                  top: h * 0.002,
                                ),
                                (w * 0.02).addWSpace(),
                                Expanded(
                                  child: checkpoint.question
                                      .regularBarlowTextStyle(
                                    fontSize: 16,
                                    maxLine: 5,
                                    textOverflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),

                            (h * 0.006).addHSpace(),

                            // OK / NOT OK
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: w * 0.04,
                              ),
                              child: Row(
                                children: [
                                  // OK
                                  InkWell(
                                    onTap: isCategorySubmitted
                                        ? null
                                        : () {
                                            setState(() {
                                              checkpoint.value = "ok";
                                            });
                                          },
                                    child: Row(
                                      children: [
                                        Radio<String>(
                                          activeColor: const Color(0xFF3498DB),
                                          value: "ok",
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          visualDensity: VisualDensity.compact,
                                          groupValue: checkpoint.value,
                                          onChanged: isCategorySubmitted
                                              ? null
                                              : (val) {
                                                  setState(() {
                                                    checkpoint.value = val;
                                                  });
                                                },
                                        ),
                                        const Text(
                                          "Ok",
                                          style: TextStyle(
                                            fontFamily: 'Barlow',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  (w * 0.12).addWSpace(),

                                  // NOT OK

                                  InkWell(
                                    onTap: isCategorySubmitted
                                        ? null
                                        : () {
                                            setState(() {
                                              checkpoint.value = "not_ok";
                                            });
                                          },
                                    child: Row(
                                      children: [
                                        Radio<String>(
                                          activeColor: const Color(0xFF3498DB),
                                          value: "not_ok",
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          visualDensity: VisualDensity.compact,
                                          groupValue: checkpoint.value,
                                          onChanged: isCategorySubmitted
                                              ? null
                                              : (val) {
                                                  setState(() {
                                                    checkpoint.value = val;
                                                  });
                                                },
                                        ),
                                        const Text(
                                          "Not Ok",
                                          style: TextStyle(
                                            fontFamily: 'Barlow',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  (h * 0.03).addHSpace(),

                  // ------------------------------------------------
                  // SUBMITTED / SUBMIT BUTTON
                  // ------------------------------------------------

                  if (isCategorySubmitted)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: h * 0.03,
                      ),
                      child: Container(
                        height: Responsive.isDesktop(context)
                            ? h * 0.078
                            : h * 0.058,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3498DB),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: AppString.submitted.boldRobotoTextStyle(
                          fontSize: 15,
                          fontColor: Colors.white,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: h * 0.03,
                      ),
                      child: MaterialButton(
                        onPressed: isSubmitting ? null : _onSubmit,
                        color: Colors.black,
                        disabledColor: Colors.grey,
                        elevation: 2,
                        minWidth: double.infinity,
                        height: Responsive.isDesktop(context)
                            ? h * 0.078
                            : h * 0.058,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: isSubmitting
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : AppString.submit.boldRobotoTextStyle(
                                  fontSize: 16,
                                  fontColor: backGroundColor,
                                ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
