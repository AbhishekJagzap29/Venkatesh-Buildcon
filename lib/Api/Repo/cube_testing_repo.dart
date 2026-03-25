import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:venkatesh_buildcon_app/Api/ResponseModel/CubeTestingResponseModel/cube_testing_form_model.dart';
import 'package:venkatesh_buildcon_app/Api/Services/base_service.dart';
import 'package:venkatesh_buildcon_app/View/Utils/app_routes.dart';

class CubeTestingRepository {
  //14/03/26
  /// CREATE RECORD
  Future<CubeTestingModel?> createRecord(Map<String, dynamic> body) async {
    print("CREATE CUBE API CALLED");
    print("API URL: ${ApiRouts.createCubeTesting}");
    print("REQUEST BODY: $body");

    final response = await http.post(
      Uri.parse(ApiRouts.createCubeTesting),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      return CubeTestingModel.fromJson(jsonData);
    } else {
      print("API ERROR");
      return null;
    }
  }

  //13/03/26
  /// GET ALL RECORDS
//   Future<List<dynamic>> getRecords({int? floorId}) async {

//   print("GET CUBE RECORDS API CALLED");

//   final response = await http.post(
//     Uri.parse(ApiRouts.getCubeTestingList),
//     headers: {
//       "Content-Type": "application/json"
//     },
//     body: jsonEncode({
//       "floor_id": floorId
//     }),
//   );

//   print("Status Code: ${response.statusCode}");
//   print("Response: ${response.body}");

//   if (response.statusCode == 200) {

//     final data = jsonDecode(response.body);

//     if (data["status"] == "success") {

//       return data["data"] ?? [];

//     }
//   }

//   return [];
// }
  Future<List<dynamic>> getRecords({int? floorId}) async {
    print("GET CUBE RECORDS API CALLED");

    final response = await http.post(
      Uri.parse(ApiRouts.getCubeTestingList),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"floor_id": floorId}),
    );

    print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final result = data["result"]; // ✅ FIX HERE

      if (result["status"] == "success") {
        return result["data"] ?? []; // ✅ FIX HERE
      }
    }

    return [];
  }

  /// GET SINGLE RECORD
  Future<dynamic> getSingleRecord(int id) async {
    print("GET SINGLE RECORD API CALLED");

    final url = ApiRouts.getSingleCubeTesting;

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "jsonrpc": "2.0",
        "params": {
          "id": id, // ✅ PASS HERE
        }
      }),
    );

    print("URL: $url");
    print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["result"]["data"];
    }

    return null;
  }

  Future<bool> deleteCubeRecord(int id) async {
    final url = Uri.parse("${ApiRouts.deleteCubeTesting}$id");

    print("DELETE API CALLED");
    print("URL: $url");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({}), // required
    );

    print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["result"] != null && data["result"]["status"] == "success") {
        return true;
      }
    }

    return false;
  }

//21/03/2026
  /// UPDATE RECORD
  Future<bool> updateCubeRecord(int id, Map<String, dynamic> body) async {
    final url = Uri.parse("${ApiRouts.updateCubeTesting}/$id");
    print("UPDATE API CALLED");
    print("URL: $url");
    print("BODY: $body");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body), // ✅ DIRECT BODY (NO jsonrpc)
    );

    print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // ✅ backend returns direct status (no "result")
      // if (data["status"] == "success") {
      //   return true;
      // }
      if (data["result"] != null && data["result"]["status"] == "success") {
        return true;
      }
//
    }

    return false;
  }
}
