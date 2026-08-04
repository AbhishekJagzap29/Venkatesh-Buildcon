import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:venkatesh_buildcon_app/Api/ResponseModel/CubeTestingResponseModel/cube_testing_form_model.dart';
import 'package:venkatesh_buildcon_app/Api/Services/base_service.dart';
import 'package:venkatesh_buildcon_app/View/Constant/shared_prefs.dart';
import 'package:venkatesh_buildcon_app/View/Utils/app_routes.dart';

class CubeTestingRepository {
  int _loggedInUserId() {
    return int.tryParse(preferences.getString(SharedPreference.userId) ?? "0") ??
        0;
  }

  /// CREATE RECORD
  Future<CubeTestingModel?> createRecord(Map<String, dynamic> body) async {
    final requestBody = Map<String, dynamic>.from(body);
    requestBody["user_id"] ??= _loggedInUserId();

    log("=== CREATE CUBE API CALLED ===");
    log("API URL: ${ApiRouts.createCubeTesting}");
    log("REQUEST BODY: ${jsonEncode(requestBody)}");

    print("CREATE CUBE API CALLED");
    print("API URL: ${ApiRouts.createCubeTesting}");
    print("REQUEST BODY: $requestBody");

    try {
      final response = await http.post(
        Uri.parse(ApiRouts.createCubeTesting),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      log("Status Code: ${response.statusCode}");
      log("Response Body: ${response.body}");

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Map<String, dynamic>? modelJson;

        if (data is Map<String, dynamic>) {
          if (data["error"] != null) {
            log("API ERROR: ${data["error"]}");
            print("API ERROR: ${data["error"]}");
            return null;
          }

          if (data["result"] != null && data["result"] is Map<String, dynamic>) {
            final result = data["result"] as Map<String, dynamic>;
            if (result["data"] != null && result["data"] is Map<String, dynamic>) {
              modelJson = result["data"] as Map<String, dynamic>;
            } else {
              modelJson = result;
            }
          } else {
            modelJson = data;
          }
        }

        if (modelJson != null) {
          log("PARSED CUBE DATA: ${jsonEncode(modelJson)}");
          final isSuccess = modelJson["status"] == "success" ||
              modelJson["record_id"] != null ||
              modelJson["id"] != null;
          if (isSuccess) {
            return CubeTestingModel.fromJson(modelJson);
          } else {
            log("CREATE CUBE FAILED: ${modelJson["message"] ?? modelJson["status"]}");
            print("CREATE CUBE FAILED");
          }
        }
      } else {
        log("API ERROR: Status Code ${response.statusCode}");
        print("API ERROR");
      }
    } catch (e, s) {
      log("CREATE CUBE RECORD EXCEPTION: $e");
      log("STACKTRACE: $s");
      print("CREATE CUBE RECORD EXCEPTION: $e");
    }

    return null;
  }

  //fetch all records
  Future<List<dynamic>> getRecords({int? floorId}) async {
    log("=== GET CUBE RECORDS API CALLED ===");
    log("API URL: ${ApiRouts.getCubeTestingList}");
    log("REQUEST BODY: ${jsonEncode({"floor_id": floorId})}");

    print("GET CUBE RECORDS API CALLED");

    try {
      final response = await http.post(
        Uri.parse(ApiRouts.getCubeTestingList),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"floor_id": floorId}),
      );

      log("Status Code: ${response.statusCode}");
      log("Response: ${response.body}");

      print("Status Code: ${response.statusCode}");
      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final result = data["result"];

        if (result != null && result["status"] == "success") {
          return result["data"] ?? [];
        }
      }
    } catch (e, s) {
      log("GET RECORDS EXCEPTION: $e");
      log("STACKTRACE: $s");
    }

    return [];
  }

  /// GET SINGLE RECORD
  Future<dynamic> getSingleRecord(int id) async {
    log("=== GET SINGLE RECORD API CALLED ===");

    final url = ApiRouts.getSingleCubeTesting;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "id": id,
        }),
      );

      log("URL: $url");
      log("Sent ID: $id");
      log("Status Code: ${response.statusCode}");
      log("Response: ${response.body}");

      print("URL: $url");
      print("Sent ID: $id");
      print("Status Code: ${response.statusCode}");
      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["result"] != null && data["result"]["status"] == "success") {
          return data["result"]["data"];
        } else if (data["result"] != null) {
          log("ERROR: ${data["result"]["message"]}");
          print("ERROR: ${data["result"]["message"]}");
        }
      }
    } catch (e, s) {
      log("GET SINGLE RECORD EXCEPTION: $e");
      log("STACKTRACE: $s");
    }

    return null;
  }

  Future<bool> deleteCubeRecord(int id) async {
    final url = Uri.parse("${ApiRouts.deleteCubeTesting}$id");
    final requestBody = {
      "user_id": _loggedInUserId(),
    };

    log("=== DELETE API CALLED ===");
    log("URL: $url");
    log("BODY: ${jsonEncode(requestBody)}");

    print("DELETE API CALLED");
    print("URL: $url");
    print("BODY: $requestBody");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      log("Status Code: ${response.statusCode}");
      log("Response: ${response.body}");

      print("Status Code: ${response.statusCode}");
      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["result"] != null && data["result"]["status"] == "success") {
          return true;
        }
      }
    } catch (e, s) {
      log("DELETE CUBE RECORD EXCEPTION: $e");
      log("STACKTRACE: $s");
    }

    return false;
  }

  /// UPDATE RECORD
  Future<bool> updateCubeRecord(int id, Map<String, dynamic> body) async {
    final url = Uri.parse("${ApiRouts.updateCubeTesting}/$id");
    final requestBody = Map<String, dynamic>.from(body);
    requestBody["user_id"] ??= _loggedInUserId();

    log("=== UPDATE API CALLED ===");
    log("URL: $url");
    log("BODY: ${jsonEncode(requestBody)}");

    print("UPDATE API CALLED");
    print("URL: $url");
    print("BODY: $requestBody");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      log("Status Code: ${response.statusCode}");
      log("Response: ${response.body}");

      print("Status Code: ${response.statusCode}");
      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["error"] != null) {
          log("UPDATE API ERROR: ${data["error"]}");
          print("UPDATE API ERROR: ${data["error"]}");
          return false;
        }

        if (data["status"] == "success") {
          return true;
        }

        if (data["result"] != null && data["result"]["status"] == "success") {
          return true;
        }
      }
    } catch (e, s) {
      log("UPDATE CUBE RECORD EXCEPTION: $e");
      log("STACKTRACE: $s");
    }

    return false;
  }
}
