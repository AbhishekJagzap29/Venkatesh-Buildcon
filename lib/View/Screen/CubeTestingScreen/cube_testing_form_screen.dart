import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:venkatesh_buildcon_app/Api/Repo/cube_testing_repo.dart';
import 'package:venkatesh_buildcon_app/View/Constant/app_color.dart';
import 'package:venkatesh_buildcon_app/View/Utils/app_layout.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/app_bar.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/back_to_home_button.dart';
import 'package:venkatesh_buildcon_app/View/utils/extension.dart';

class CubeTestingFormScreen extends StatefulWidget {
  final int floorId;

  const CubeTestingFormScreen({
    super.key,
    required this.floorId,
  });

  @override
  State<CubeTestingFormScreen> createState() => _CubeTestingFormScreenState();
}

class _CubeTestingFormScreenState extends State<CubeTestingFormScreen> {
  final TextEditingController srNoController = TextEditingController();
  final TextEditingController cubeIdController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  final TextEditingController weight1 = TextEditingController();
  final TextEditingController weight2 = TextEditingController();
  final TextEditingController weight3 = TextEditingController();

  final TextEditingController load1 = TextEditingController();
  final TextEditingController load2 = TextEditingController();
  final TextEditingController load3 = TextEditingController();

  final CubeTestingRepository cubeRepo = CubeTestingRepository();
  Map<String, String> sourceMap = {
    "inhouse": "In-house",
    "rmc": "RMC Plant",
  };

  Map<String, String> gradeMap = {
    // ✅ MOVE HERE
    "m20": "M20",
    "m25": "M25",
    "m30": "M30",
  };

  DateTime? castingDate;
  DateTime? testingDate;

  String grade = "m20";
  double gradeValue = 20;

  // String source = "In-house";
  String source = "inhouse";
  // String source = "in_house";   // ✅ backend key

  int ageDays = 0;

  double density1 = 0;
  double density2 = 0;
  double density3 = 0;

  double strength1 = 0;
  double strength2 = 0;
  double strength3 = 0;

  double avgStrength = 0;
  double strengthPercent = 0;

  void calculateAge() {
    if (castingDate != null && testingDate != null) {
      ageDays = testingDate!.difference(castingDate!).inDays;
    }
  }

  void calculateValues() {
    double w1 = double.tryParse(weight1.text) ?? 0;
    double w2 = double.tryParse(weight2.text) ?? 0;
    double w3 = double.tryParse(weight3.text) ?? 0;

    double l1 = double.tryParse(load1.text) ?? 0;
    double l2 = double.tryParse(load2.text) ?? 0;
    double l3 = double.tryParse(load3.text) ?? 0;

    density1 = w1 / 0.003375;
    density2 = w2 / 0.003375;
    density3 = w3 / 0.003375;

    strength1 = l1 / 22.5;
    strength2 = l2 / 22.5;
    strength3 = l3 / 22.5;

    avgStrength = (strength1 + strength2 + strength3) / 3;
    strengthPercent = (avgStrength / gradeValue) * 100;

    setState(() {});
  }

  Future<void> submitCubeRecord() async {
    print("Submit button clicked");

    /// VALIDATION
    if (srNoController.text.isEmpty ||
        cubeIdController.text.isEmpty ||
        quantityController.text.isEmpty ||
        locationController.text.isEmpty) {
      errorSnackBar("Validation", "Please fill all required fields");

      return;
    }

    if (castingDate == null || testingDate == null) {
      errorSnackBar("Validation", "Please select casting and testing date");
      return;
    }

    Map<String, dynamic> body = {
      "sr_no": srNoController.text.trim(),
      "floor_id": widget.floorId,
      "cube_id": cubeIdController.text.trim(),
      "date_casting": DateFormat("yyyy-MM-dd").format(castingDate!),
      "date_testing": DateFormat("yyyy-MM-dd").format(testingDate!),
      "grade_concrete": grade,
      // "grade_value": gradeValue.toInt(),
      // "quantity": int.tryParse(quantityController.text) ?? 0,
      "grade_value": gradeValue, // ✅ double
      "quantity": double.tryParse(quantityController.text) ?? 0.0,
      "location_structure": locationController.text.trim(),
      "concrete_source": source,
      "age_days": ageDays,
      "weight1": double.tryParse(weight1.text) ?? 0,
      "weight2": double.tryParse(weight2.text) ?? 0,
      "weight3": double.tryParse(weight3.text) ?? 0,
      "density1": density1,
      "density2": density2,
      "density3": density3,
      "load1": double.tryParse(load1.text) ?? 0,
      "load2": double.tryParse(load2.text) ?? 0,
      "load3": double.tryParse(load3.text) ?? 0,
      "strength1": strength1,
      "strength2": strength2,
      "strength3": strength3,
      "avg_strength": avgStrength,
      "strength_percent": strengthPercent
    };
    try {
      var response = await cubeRepo.createRecord(body);

      if (response != null) {
        successSnackBar("Success", "Cube Record Created Successfully");

        Navigator.pop(context);
      } else {
        errorSnackBar("Error", "Failed to create record");
      }
    } catch (e) {
      print("Error while submitting cube record: $e");

      errorSnackBar("Error", "Something went wrong");
    }
  }

  Widget textField(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label:",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[400]!),
          ),
          child: TextField(
            controller: controller,
            keyboardType: type,
            onChanged: (v) => calculateValues(),
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildDateField(String label, DateTime? date, Function() onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label:",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[400]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date != null
                      ? DateFormat('dd MMM yyyy').format(date)
                      : "Select Date",
                ),
                const Icon(Icons.calendar_today, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget dropdownField(String label, String value, List<String> items,
      Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label:",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[400]!),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: items.map((e) {
              return DropdownMenuItem(
                value: e,
                // child: Text(sourceMap[e] ?? e),  // ✅ show label
                child: Text(sourceMap[e] ?? gradeMap[e] ?? e),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Future pickDate(bool casting) async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (casting) {
          castingDate = picked;
        } else {
          testingDate = picked;
        }

        calculateAge();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backGroundColor,
      floatingActionButton: const CommonBackToHomeButton(),
      appBar: AppBarWidget(
        title: "Cube Testing Form".boldRobotoTextStyle(fontSize: 20),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: w * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            textField("Sr. No", srNoController, type: TextInputType.text),
            textField("Cube ID", cubeIdController),
            buildDateField(
                "Date of Casting", castingDate, () => pickDate(true)),
            // dropdownField("Grade of Concrete", grade, ["M20", "M25", "M30"],
            //     (v) {
            //   setState(() {
            //     grade = v!;
            //     gradeValue = double.parse(v.replaceAll("M", ""));
            //   });
            // }),

            dropdownField(
              "Grade of Concrete",
              grade,
              gradeMap.keys.toList(), // ✅ keys
              (v) {
                setState(() {
                  grade = v!; // ✅ will be m20/m25/m30
                  gradeValue = double.parse(gradeMap[v]!.replaceAll("M", ""));
                });
              },
            ),
            "Grade Value : $gradeValue N/mm²"
                .regularRobotoTextStyle(fontSize: 14),
            const SizedBox(height: 16),
            textField("Quantity (m³)", quantityController,
                type: TextInputType.number),
            textField("Location / Structure", locationController),
            // dropdownField(
            //     "Concrete Source",
            //     source,
            //     ["In-house", "RMC Plant A"],
            //     (v) => setState(() => source = v!)),
            // Map<String, String> sourceMap = {"in_house": "In-house","rmc": "RMC Plant A",};
            dropdownField(
              "Concrete Source",
              source,
              sourceMap.keys.toList(), // keys list
              (v) => setState(() => source = v!),
            ),
            buildDateField(
                "Date of Testing", testingDate, () => pickDate(false)),
            "Age (Days): $ageDays".boldRobotoTextStyle(fontSize: 16),
            const SizedBox(height: 25),
            "Weight of Cube (kg)".boldRobotoTextStyle(fontSize: 18),
            textField("Cube 1 Weight", weight1, type: TextInputType.number),
            textField("Cube 2 Weight", weight2, type: TextInputType.number),
            textField("Cube 3 Weight", weight3, type: TextInputType.number),
            "Cube 1 Density : ${density1.toStringAsFixed(2)} Kg/m³"
                .regularRobotoTextStyle(fontSize: 14),
            "Cube 2 Density : ${density2.toStringAsFixed(2)} Kg/m³"
                .regularRobotoTextStyle(fontSize: 14),
            "Cube 3 Density : ${density3.toStringAsFixed(2)} Kg/m³"
                .regularRobotoTextStyle(fontSize: 14),
            const SizedBox(height: 20),
            "Load (kN)".boldRobotoTextStyle(fontSize: 18),
            textField("Cube 1 Load", load1, type: TextInputType.number),
            textField("Cube 2 Load", load2, type: TextInputType.number),
            textField("Cube 3 Load", load3, type: TextInputType.number),
            "Cube 1 Strength : ${strength1.toStringAsFixed(2)} N/mm²"
                .regularRobotoTextStyle(fontSize: 14),
            "Cube 2 Strength : ${strength2.toStringAsFixed(2)} N/mm²"
                .regularRobotoTextStyle(fontSize: 14),
            "Cube 3 Strength : ${strength3.toStringAsFixed(2)} N/mm²"
                .regularRobotoTextStyle(fontSize: 14),
            const SizedBox(height: 20),
            "Average Strength : ${avgStrength.toStringAsFixed(2)} N/mm²"
                .boldRobotoTextStyle(fontSize: 16),
            const SizedBox(height: 8),
            "Compressive Strength % : ${strengthPercent.toStringAsFixed(2)} %"
                .boldRobotoTextStyle(fontSize: 16),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: submitCubeRecord,
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
