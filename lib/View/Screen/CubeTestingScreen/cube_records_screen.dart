import 'package:flutter/material.dart';
import 'package:venkatesh_buildcon_app/Api/Repo/cube_testing_repo.dart';
import 'package:venkatesh_buildcon_app/View/Constant/app_color.dart';
import 'package:venkatesh_buildcon_app/View/Screen/CubeTestingScreen/cube_details_screen.dart';
import 'package:venkatesh_buildcon_app/View/Screen/CubeTestingScreen/cube_testing_form_screen.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/app_bar.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/back_to_home_button.dart';
import 'package:venkatesh_buildcon_app/View/utils/extension.dart';

class CubeRecordsScreen extends StatefulWidget {
  final int floorId;

  const CubeRecordsScreen({
    super.key,
    required this.floorId,
  });

  @override
  State<CubeRecordsScreen> createState() => _CubeRecordsScreenState();
}

class _CubeRecordsScreenState extends State<CubeRecordsScreen> {
  List records = [];
  bool isLoading = true;

  final CubeTestingRepository repo = CubeTestingRepository();

  Future<void> getCubeRecords() async {
    final data = await repo.getRecords(floorId: widget.floorId);

    if (!mounted) return;

    setState(() {
      records = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getCubeRecords();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backGroundColor,
      floatingActionButton: const CommonBackToHomeButton(),
      appBar: AppBarWidget(
        title: "Cube Testing Records".boldRobotoTextStyle(fontSize: 20),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.06),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : records.isEmpty
                    ? const Center(child: Text("No Cube Records Found"))
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 12),
                        itemCount: records.length,
                        itemBuilder: (context, index) {
                          final record = records[index];
                          final srNo = record["sr_no"]?.toString() ?? "";
                          final towerName =
                              record["tower_id"]?.toString() ?? "";

                          return GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CubeDetailsScreen(
                                    data: record,
                                    isEditable: false,
                                  ),
                                ),
                              );

                              if (result == true) {
                                getCubeRecords();
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: containerColor,
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: const Color(0xffE6E6E6)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  "Sr.No : $srNo"
                                      .boldRobotoTextStyle(fontSize: 16),
                                  const SizedBox(height: 6),
                                  "Tower Name : $towerName"
                                      .regularRobotoTextStyle(fontSize: 13),
                                  const SizedBox(height: 4),
                                  "Casting Date : ${record["date_casting"] ?? ""}"
                                      .regularRobotoTextStyle(fontSize: 13),
                                  const SizedBox(height: 4),
                                  "Test Date : ${record["date_testing"] ?? ""}"
                                      .regularRobotoTextStyle(fontSize: 13),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              heroTag: "addCubeRecord",
              backgroundColor: Colors.black,
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CubeTestingFormScreen(
                      floorId: widget.floorId,
                    ),
                  ),
                );

                if (result == true) {
                  getCubeRecords();
                }
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
