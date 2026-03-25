import 'dart:developer';
import 'package:get/get.dart';
import 'package:venkatesh_buildcon_app/Api/Apis/api_response.dart';
import 'package:venkatesh_buildcon_app/Api/Repo/project_repo.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/checklist_as_per_type_model.dart';

class ChecklistAsPerTypeScreenController extends GetxController {
  final int patn_id;

  ChecklistAsPerTypeScreenController({required this.patn_id});

  List<ActivityTypesChecklist> activityTypesChecklist = [];

  @override
  void onInit() {
    super.onInit();
    getActivityAsPerTypeChecklist();
  }

  ApiResponse _activityAsPerTypeChecklistResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get activityAsPerTypeChecklistResponse =>
      _activityAsPerTypeChecklistResponse;

  Future<void> getActivityAsPerTypeChecklist() async {
    _activityAsPerTypeChecklistResponse =
        ApiResponse.loading(message: 'Loading');
    update();

    try {
      var response = await ProjectRepo()
          .getapproveractivitytypechecklistRepo(patn_id);
      _activityAsPerTypeChecklistResponse = ApiResponse.complete(response);

      if (response.activityTypesChecklist != null) {
        activityTypesChecklist = response.activityTypesChecklist!;
      }
    } catch (e) {
      _activityAsPerTypeChecklistResponse =
          ApiResponse.error(message: e.toString());
      log("Error fetching activity types checklist: $e");
    }

    update();
  }
}
