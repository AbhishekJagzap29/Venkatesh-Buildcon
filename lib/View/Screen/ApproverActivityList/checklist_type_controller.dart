
import 'package:get/get.dart';
import 'package:venkatesh_buildcon_app/Api/Apis/api_response.dart';
import 'package:venkatesh_buildcon_app/Api/Repo/project_repo.dart';
import 'package:venkatesh_buildcon_app/Api/ResponseModel/checklist_type_model.dart';

class ActivityTypeScreenController extends GetxController {
  final int activity_id;

  ActivityTypeScreenController({required this.activity_id});

  List<ActivityType> activityTypes = [];
  ActivityTypeResponseModel? checklistTypeRes;
  

  @override
  void onInit() {
    super.onInit();
    getActivityTypes();
  }

ApiResponse _activityTypeResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get activityTypeResponse => _activityTypeResponse;

  Future<void> getActivityTypes() async {
    _activityTypeResponse = ApiResponse.loading(message: 'Loading');
    update();

    try {
      checklistTypeRes = await ProjectRepo()
          .getapproveractivitytypesRepo({'activity_id': activity_id});
      _activityTypeResponse = ApiResponse.complete(checklistTypeRes);

      if (checklistTypeRes?.activityTypes != null) {
        activityTypes = checklistTypeRes!.activityTypes!;
      }
    } catch (e) {
      _activityTypeResponse = ApiResponse.error(message: e.toString());
    }
    update();
  }
}










//   ApiResponse _activityTypeResponse =
//       ApiResponse.initial(message: 'Initialization');
//   ApiResponse get activityTypeResponse => _activityTypeResponse;

//   Future<void> getActivityTypes() async {
//     _activityTypeResponse = ApiResponse.loading(message: 'Loading');
//     update();

//     try {
//       var response = await ProjectRepo()
//           .getapproveractivitytypesRepo({'activity_id': activity_id});
//       _activityTypeResponse = ApiResponse.complete(response);

//       if (response.activityTypes != null) {
//         activityTypes = response.activityTypes!;
//       }
//     } catch (e) {
//       _activityTypeResponse = ApiResponse.error(message: e.toString());
//     }
//     update();
//   }
// }
