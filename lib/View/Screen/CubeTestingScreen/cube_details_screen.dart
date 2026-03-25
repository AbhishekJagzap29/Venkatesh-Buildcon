import 'package:flutter/material.dart';
import 'package:venkatesh_buildcon_app/Api/Repo/cube_testing_repo.dart';
import 'package:venkatesh_buildcon_app/View/Constant/app_color.dart';
import 'package:venkatesh_buildcon_app/View/Constant/shared_prefs.dart';
import 'package:venkatesh_buildcon_app/View/Utils/app_layout.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/app_bar.dart';
import 'package:venkatesh_buildcon_app/View/utils/extension.dart';
import 'package:venkatesh_buildcon_app/View/Screen/CubeTestingScreen/cube_update_screen.dart';

class CubeDetailsScreen extends StatefulWidget {
  final int cubeId;

  const CubeDetailsScreen({super.key, required this.cubeId});

  @override
  State<CubeDetailsScreen> createState() => _CubeDetailsScreenState();
}

class _CubeDetailsScreenState extends State<CubeDetailsScreen> {
  final CubeTestingRepository repo = CubeTestingRepository();

  Map<String, dynamic>? record;

  bool isLoading = true;

  String get towerName {
    final dynamic name = record?["tower_name"] ?? record?["tower_id"];
    if (name == null || name.toString().trim().isEmpty) {
      return "NA";
    }
    return name.toString();
  }

  Future<void> getCubeDetails() async {
    final data = await repo.getSingleRecord(widget.cubeId);

    setState(() {
      record = data;
      isLoading = false;
    });
  }

  Future<void> deleteRecord() async {
    bool success = await repo.deleteCubeRecord(widget.cubeId);

    if (success) {
      if (!mounted) return;

      successSnackBar("Success", "Record deleted successfully");

      Navigator.pop(context, true);
    } else {
      errorSnackBar("Error", "Failed to delete record");
    }
  }

  void confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Record"),
        content: const Text("Are you sure you want to delete this record?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteRecord();
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCubeDetails();
  }

  @override
  Widget build(BuildContext context) {
    final bool isApprover =
        preferences.getString(SharedPreference.userType)!.toLowerCase() ==
            "approver";

    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBarWidget(
        title: "Cube Details".boldRobotoTextStyle(fontSize: 20),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  "Cube ID : ${record?["cube_id"]}"
                      .boldRobotoTextStyle(fontSize: 16),
                  const SizedBox(height: 10),
                  "Tower Name : $towerName"
                      .regularRobotoTextStyle(fontSize: 14),
                  const SizedBox(height: 6),
                  "Casting Date : ${record?["date_casting"]}"
                      .regularRobotoTextStyle(fontSize: 14),
                  const SizedBox(height: 6),
                  "Testing Date : ${record?["date_testing"]}"
                      .regularRobotoTextStyle(fontSize: 14),
                  const SizedBox(height: 6),
                  "Age : ${record?["age_days"]}"
                      .regularRobotoTextStyle(fontSize: 14),
                  const SizedBox(height: 6),
                  "Concrete Grade : ${record?["grade_concrete"]}"
                      .regularRobotoTextStyle(fontSize: 14),
                  const SizedBox(height: 6),
                               "Quantity : ${record?["quantity"]}"
                      .regularRobotoTextStyle(fontSize: 14),
                  const SizedBox(height: 6),
                   "Location : ${record?["location_structure"]}"
                      .regularRobotoTextStyle(fontSize: 14),
                  
                
                  const SizedBox(height: 6),
                  "Avg Strength : ${double.tryParse(record?["avg_strength"].toString() ?? "0")?.toStringAsFixed(2) ?? "0.00"}"
    .regularRobotoTextStyle(fontSize: 14),
                  const SizedBox(height: 20),
                  if (isApprover) ElevatedButton(
                    onPressed: () async {
                      // final result = await Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => CubeUpdateScreen(
                      //       record: record!, // ✅ PASS FULL DATA
                      //     ),
                      //   ),
                      // );
                      //21/03/2026
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CubeUpdateScreen(record: record!),
                        ),
                      );

                      if (result == true) {
                        Navigator.pop(context, true); //  go to records screen
                      }
//

                      if (result == true) {
                        getCubeDetails(); // refresh after update
                      }
                    },
                    child: const Text("Update Record"),
                  ),
                  if (isApprover) const SizedBox(height: 10),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.red,
                  //   ),
                  //   onPressed: () {
                  //     // DELETE API
                  //   },
                  //   child: const Text("Delete Record"),
                  // )
                  if (isApprover) ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: confirmDelete, // ✅ HERE
                    child: const Text("Delete Record"),
                  )
                ],
              ),
            ),
    );
  }
}
