import 'dart:developer';
import 'package:get/get.dart';
import 'package:venkatesh_buildcon_app/Api/Apis/api_response.dart';
import 'package:venkatesh_buildcon_app/Api/Repo/unit_handover_repo.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/UnitHandover/submit_unit_handover_category_res_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/UnitHandover/unit_handover_activities_res_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/UnitHandover/unit_handover_categories_res_model.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/UnitHandover/unit_handover_locations_res_model.dart';

class UnitHandoverController extends GetxController {
  final UnitHandoverRepo _repo = UnitHandoverRepo();

  // LOCATIONS

  ApiResponse<UnitHandoverLocationsResModel> getLocationsApiResponse =
      ApiResponse.loading(
    message: 'Loading locations',
  );

  // CATEGORIES

  ApiResponse<UnitHandoverCategoriesResModel> getCategoriesApiResponse =
      ApiResponse.loading(
    message: 'Loading categories',
  );

  // ACTIVITIES

  ApiResponse<UnitHandoverActivitiesResModel> getActivitiesApiResponse =
      ApiResponse.loading(
    message: 'Loading activities',
  );

  // Used to identify the latest activity request.
  int _activityRequestId = 0;

  // RESET ACTIVITY RESPONSE

  void resetUnitHandoverCategoryActivities() {
    getActivitiesApiResponse = ApiResponse.loading(
      message: 'Loading activities',
    );

    update();
  }

  // FETCH LOCATIONS

  Future<void> fetchUnitHandoverLocations({
    required int flatId,
  }) async {
    getLocationsApiResponse = ApiResponse.loading(
      message: 'Loading locations',
    );

    update();

    try {
      final response = await _repo.getUnitHandoverLocations(
        flatId: flatId,
      );

      if (response != null &&
          (response.status == 'SUCCESS' || response.status == 'success')) {
        getLocationsApiResponse = ApiResponse.complete(response);
      } else {
        final String msg =
            response?.message ?? 'Failed to fetch handover locations';

        getLocationsApiResponse = ApiResponse.error(
          message: msg,
        );
      }
    } catch (e, stack) {
      log(
        'Error in fetchUnitHandoverLocations: $e',
        stackTrace: stack,
      );

      getLocationsApiResponse = ApiResponse.error(
        message: e.toString(),
      );
    }

    update();
  }

  // FETCH CATEGORIES

  Future<void> fetchUnitHandoverLocationCategories({
    required int handoverLocationId,
  }) async {
    getCategoriesApiResponse = ApiResponse.loading(
      message: 'Loading categories',
    );

    update();

    try {
      final response = await _repo.getUnitHandoverLocationCategories(
        handoverLocationId: handoverLocationId,
      );

      if (response != null &&
          (response.status == 'SUCCESS' || response.status == 'success')) {
        getCategoriesApiResponse = ApiResponse.complete(response);
      } else {
        final String msg = response?.message ?? 'Failed to fetch categories';

        getCategoriesApiResponse = ApiResponse.error(
          message: msg,
        );
      }
    } catch (e, stack) {
      log(
        'Error in fetchUnitHandoverLocationCategories: $e',
        stackTrace: stack,
      );

      getCategoriesApiResponse = ApiResponse.error(
        message: e.toString(),
      );
    }

    update();
  }

  // FETCH CATEGORY ACTIVITIES

  Future<void> fetchUnitHandoverCategoryActivities({
    required int handoverLocationId,
    int? categoryId,
  }) async {
    // Generate a unique ID for this API request.
    final int requestId = ++_activityRequestId;

    log(
      'GET UNIT HANDOVER CATEGORY ACTIVITIES CALLED '
      'with handover_location_id: $handoverLocationId, '
      'category_id: $categoryId',
    );

    // IMPORTANT:
    // Clear previous category immediately.
    getActivitiesApiResponse = ApiResponse.loading(
      message: 'Loading activities',
    );

    update();

    try {
      final response = await _repo.getUnitHandoverCategoryActivities(
        handoverLocationId: handoverLocationId,
        categoryId: categoryId,
      );

      if (requestId != _activityRequestId) {
        log(
          'Ignoring old category activity response '
          'for requestId: $requestId',
        );

        return;
      }

      if (response != null &&
          (response.status == 'SUCCESS' || response.status == 'success')) {
        getActivitiesApiResponse = ApiResponse.complete(response);

        log(
          'UNIT HANDOVER CATEGORY ACTIVITIES RESPONSE: '
          '$response',
        );
      } else {
        final String msg = response?.message ?? 'Failed to fetch activities';

        getActivitiesApiResponse = ApiResponse.error(
          message: msg,
        );
      }
    } catch (e, stack) {
      if (requestId != _activityRequestId) {
        return;
      }

      log(
        'Error in fetchUnitHandoverCategoryActivities: $e',
        stackTrace: stack,
      );

      getActivitiesApiResponse = ApiResponse.error(
        message: e.toString(),
      );
    }

    // Update only if this is still the latest request.
    if (requestId == _activityRequestId) {
      update();
    }
  }

  //// SUBMIT

  ApiResponse<SubmitUnitHandoverCategoryResModel> submitCategoryApiResponse =
      ApiResponse.initial();

  Future<bool> submitUnitHandoverCategory({
    required int handoverLocationId,
    int? categoryId,
    required List<Map<String, dynamic>> activityLines,
  }) async {
    submitCategoryApiResponse = ApiResponse.loading(
      message: 'Submitting category...',
    );

    update();

    try {
      final response = await _repo.submitUnitHandoverCategory(
        handoverLocationId: handoverLocationId,
        categoryId: categoryId,
        activityLines: activityLines,
      );

      if (response != null &&
          (response.status == 'SUCCESS' || response.status == 'success')) {
        submitCategoryApiResponse = ApiResponse.complete(response);

        update();

        // SUBMIT SUCCESS - ROUTE TO PREVIOUS SCREEN
        await Future.delayed(
          const Duration(milliseconds: 500),
        );

        Get.back(result: true);

        return true;
      } else {
        final String msg = response?.message ?? 'Failed to submit category';

        submitCategoryApiResponse = ApiResponse.error(
          message: msg,
        );

        update();

        return false;
      }
    } catch (e, stack) {
      log(
        'Error in submitUnitHandoverCategory: $e',
        stackTrace: stack,
      );

      submitCategoryApiResponse = ApiResponse.error(
        message: e.toString(),
      );

      update();

      return false;
    }
  }
}
