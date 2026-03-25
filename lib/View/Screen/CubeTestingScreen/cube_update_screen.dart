import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:venkatesh_buildcon_app/View/Constant/app_color.dart';
import 'package:venkatesh_buildcon_app/View/Utils/app_layout.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/app_bar.dart';
import 'package:venkatesh_buildcon_app/View/Widgets/back_to_home_button.dart';
import 'package:venkatesh_buildcon_app/View/utils/extension.dart';
import 'package:venkatesh_buildcon_app/Api/Repo/cube_testing_repo.dart';

class CubeUpdateScreen extends StatefulWidget {
  final Map<String, dynamic> record;

  const CubeUpdateScreen({
    super.key,
    required this.record,
  });

  @override
  State<CubeUpdateScreen> createState() => _CubeUpdateScreenState();
}

class _CubeUpdateScreenState extends State<CubeUpdateScreen> {
  final CubeTestingRepository repo = CubeTestingRepository();
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

  Map<String, String> sourceMap = {
    "inhouse": "In-house",
    "rmc": "RMC Plant",
  };

  Map<String, String> gradeMap = {
    "m20": "M20",
    "m25": "M25",
    "m30": "M30",
  };

  DateTime? castingDate;
  DateTime? testingDate;

  String grade = "m20";
  double gradeValue = 20;
  String source = "inhouse";

  int ageDays = 0;

  double density1 = 0;
  double density2 = 0;
  double density3 = 0;

  double strength1 = 0;
  double strength2 = 0;
  double strength3 = 0;

  double avgStrength = 0;
  double strengthPercent = 0;

  ///  PREFILL DATA
  @override
  void initState() {
    super.initState();

    final r = widget.record;

    srNoController.text = r["sr_no"]?.toString() ?? "";
    cubeIdController.text = r["cube_id"] ?? "";
    quantityController.text = r["quantity"]?.toString() ?? "";
    locationController.text = r["location_structure"] ?? "";

    weight1.text = r["weight1"]?.toString() ?? "";
    weight2.text = r["weight2"]?.toString() ?? "";
    weight3.text = r["weight3"]?.toString() ?? "";

    load1.text = r["load1"]?.toString() ?? "";
    load2.text = r["load2"]?.toString() ?? "";
    load3.text = r["load3"]?.toString() ?? "";

    if (r["date_casting"] != null) {
      castingDate = DateTime.parse(r["date_casting"]);
    }

    if (r["date_testing"] != null) {
      testingDate = DateTime.parse(r["date_testing"]);
    }

    grade = r["grade_concrete"] ?? "m20";
    source = r["concrete_source"] ?? "inhouse";
    gradeValue = (r["grade_value"] is num)
        ? (r["grade_value"] as num).toDouble()
        : double.tryParse(r["grade_value"]?.toString() ?? "") ??
            double.tryParse(grade.replaceAll(RegExp(r'[^0-9.]'), "")) ??
            20;

    calculateAge();
    calculateValues();
  }

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

  // void onUpdateClick() {
  //   print("Updated data ready");
  //   Navigator.pop(context, true);
  // }
//
  Future<void> onUpdateClick() async {
    print("Update button clicked");

    if (srNoController.text.isEmpty ||
        cubeIdController.text.isEmpty ||
        quantityController.text.isEmpty ||
        locationController.text.isEmpty) {
      errorSnackBar(
  "Validation",
  "Please fill all required fields",
);
      return;
    }

    if (castingDate == null || testingDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select dates")),
      );
      return;
    }

    /// ✅ CREATE BODY (same as create API)
    Map<String, dynamic> body = {
      "sr_no": srNoController.text.trim(),
      "cube_id": cubeIdController.text.trim(),
      "date_casting": DateFormat("yyyy-MM-dd").format(castingDate!),
      "date_testing": DateFormat("yyyy-MM-dd").format(testingDate!),
      "grade_concrete": grade,
      // "grade_value": gradeValue,
      // "quantity": double.tryParse(quantityController.text) ?? 0.0,
      "grade_value": gradeValue.toInt(),
      "quantity": double.tryParse(quantityController.text)?.toInt() ?? 0,
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
      "strength_percent": strengthPercent,
    };

    try {
      ///  CALL UPDATE API
      bool success = await repo.updateCubeRecord(
        widget.record["id"], 
        body,
      );

      if (success) {
       successSnackBar(
  "Success",
  "Record Updated Successfully",
);

       Navigator.pop(context, true); 
       
      } else {
       errorSnackBar(
  "Error",
  "Update Failed",
);
      }
    } catch (e) {
      print("UPDATE ERROR: $e");

      errorSnackBar("Error", "Something went wrong");
    }
  }

//
  Widget textField(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label:",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800])),
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
            decoration: const InputDecoration(border: InputBorder.none),
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
        Text("$label:",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800])),
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
                Text(date != null
                    ? DateFormat('dd MMM yyyy').format(date)
                    : "Select Date"),
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
        Text("$label:",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800])),
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
        title: "Update Cube Record".boldRobotoTextStyle(fontSize: 20),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: w * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            textField("Sr. No", srNoController),
            textField("Cube ID", cubeIdController),
            buildDateField(
                "Date of Casting", castingDate, () => pickDate(true)),
            dropdownField(
              "Grade of Concrete",
              grade,
              gradeMap.keys.toList(),
              (v) {
                setState(() {
                  grade = v!;
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
            dropdownField("Concrete Source", source, sourceMap.keys.toList(),
                (v) => setState(() => source = v!)),
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
              onTap: onUpdateClick,
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "Update",
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
