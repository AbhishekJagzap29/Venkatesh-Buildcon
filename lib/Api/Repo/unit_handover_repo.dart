import 'dart:developer';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/UnitHandover/submit_unit_handover_category_res_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/UnitHandover/unit_handover_activities_res_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/UnitHandover/unit_handover_categories_res_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/UnitHandover/unit_handover_locations_res_model.dart';
import 'package:venkatesh_buildcon_app/Api/Services/api_service.dart';
import 'package:venkatesh_buildcon_app/Api/Services/base_service.dart';
import 'package:venkatesh_buildcon_app/View/Constant/shared_prefs.dart';

class UnitHandoverRepo {
  Map<String, String> get header => {
        'Content-Type': 'application/json',
        'Cookie':
            'Cookie_1=value; ${preferences.getString(SharedPreference.sessionId)}'
      };

  /// POST /unit_handover/flat/locations
  Future<UnitHandoverLocationsResModel?> getUnitHandoverLocations({
    required int flatId,
  }) async {
    try {
      log("GET UNIT HANDOVER LOCATIONS API CALLED with flat_id: $flatId");
      log("URL: ${ApiRouts.unitHandoverLocations}");

      var response = await APIService().getResponse(
        url: ApiRouts.unitHandoverLocations,
        apiType: APIType.aPost,
        body: {"flat_id": flatId},
        header: header,
      );

      log("UNIT HANDOVER LOCATIONS RESPONSE: $response");

      if (response != null) {
        return UnitHandoverLocationsResModel.fromJson(response);
      }
    } catch (e, stack) {
      log("Error in getUnitHandoverLocations: $e", stackTrace: stack);
    }
    return null;
  }

  /// POST /unit_handover/location/categories
  Future<UnitHandoverCategoriesResModel?> getUnitHandoverLocationCategories({
    required int handoverLocationId,
  }) async {
    try {
      log("GET UNIT HANDOVER LOCATION CATEGORIES CALLED with handover_location_id: $handoverLocationId");
      log("URL: ${ApiRouts.unitHandoverLocationCategories}");

      var response = await APIService().getResponse(
        url: ApiRouts.unitHandoverLocationCategories,
        apiType: APIType.aPost,
        body: {"handover_location_id": handoverLocationId},
        header: header,
      );

      log("UNIT HANDOVER LOCATION CATEGORIES RESPONSE: $response");

      if (response != null) {
        return UnitHandoverCategoriesResModel.fromJson(response);
      }
    } catch (e, stack) {
      log("Error in getUnitHandoverLocationCategories: $e", stackTrace: stack);
    }
    return null;
  }

  /// POST /unit_handover/location/category/activities
  Future<UnitHandoverActivitiesResModel?> getUnitHandoverCategoryActivities({
    required int handoverLocationId,
    int? categoryId,
  }) async {
    try {
      log("GET UNIT HANDOVER CATEGORY ACTIVITIES CALLED with handover_location_id: $handoverLocationId, category_id: $categoryId");
      log("URL: ${ApiRouts.unitHandoverCategoryActivities}");

      Map<String, dynamic> reqBody = {
        "handover_location_id": handoverLocationId,
      };
      if (categoryId != null && categoryId != 0) {
        reqBody["category_id"] = categoryId;
      }

      var response = await APIService().getResponse(
        url: ApiRouts.unitHandoverCategoryActivities,
        apiType: APIType.aPost,
        body: reqBody,
        header: header,
      );

      log("UNIT HANDOVER CATEGORY ACTIVITIES RESPONSE: $response");

      if (response != null) {
        return UnitHandoverActivitiesResModel.fromJson(response);
      }
    } catch (e, stack) {
      log("Error in getUnitHandoverCategoryActivities: $e", stackTrace: stack);
    }
    return null;
  }

  /// POST /unit_handover/location/category/submit
  Future<SubmitUnitHandoverCategoryResModel?> submitUnitHandoverCategory({
    required int handoverLocationId,
    int? categoryId,
    required List<Map<String, dynamic>> activityLines,
  }) async {
    try {
      log("SUBMIT UNIT HANDOVER CATEGORY CALLED with handover_location_id: $handoverLocationId, category_id: $categoryId");
      log("URL: ${ApiRouts.submitUnitHandoverCategory}");

      Map<String, dynamic> reqBody = {
        "handover_location_id": handoverLocationId,
        "activity_lines": activityLines,
      };
      if (categoryId != null && categoryId != 0) {
        reqBody["category_id"] = categoryId;
      }

      var response = await APIService().getResponse(
        url: ApiRouts.submitUnitHandoverCategory,
        apiType: APIType.aPost,
        body: reqBody,
        header: header,
      );

      log("SUBMIT UNIT HANDOVER CATEGORY RESPONSE: $response");

      if (response != null) {
        return SubmitUnitHandoverCategoryResModel.fromJson(response);
      }
    } catch (e, stack) {
      log("Error in submitUnitHandoverCategory: $e", stackTrace: stack);
    }
    return null;
  }
}
