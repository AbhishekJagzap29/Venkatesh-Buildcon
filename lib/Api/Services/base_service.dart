class ApiRouts {
  /// BASE URL

  /// TEST

  // static String databaseName = 'vb_db';
  // static String base = 'http://157.245.102.113:8069/';
  // static String basic = 'http://157.245.102.113:8069/';

  /// LIVE

  static String databaseName = 'VB';
  static String base = 'http://159.65.147.103:8069/';
  static String basic = 'http://159.65.147.103:8069/';
  static String baseUrl = '${base}session/auth';

  /// APIS
  static String loginAPI = '$baseUrl/login';
  static String registerAPI = '$baseUrl/signup';
  static String logOutAPI = '$baseUrl/logout';
  static String getAssignedProject = '$baseUrl/get/assigned/projects';
  static String changePassword = '$baseUrl/change_password';

  ///
  static String getMaterialInspection = '$baseUrl/get/material/inspection';
  static String projectDetails = '$baseUrl/get/project_info';
  static String towerInfoCheckList = '$baseUrl/get/checklist/tower';
  static String getFlatFloor = '$baseUrl/get/flat/floor';
  static String getFlatActivity = '$baseUrl/get/flat/activites';
  static String getFloorActivity = '$baseUrl/get/floor/activites';
  static String getCheckListByActivity = '$baseUrl/get/checklist';
  static String getMaterialInspectionCheckList = '$baseUrl/get/mi/checklist';
  static String createMaterialInspection =
      '$baseUrl/create/material/inspection';
  static String deleteMaterialInspection = '$baseUrl/delete/mi';
  static String replicateMaterialInspection = '$baseUrl/replicate/mi';

  ///----
  static String updateMaterialInspection = '$baseUrl/update/mi';
  static String updateCheckerData = '$baseUrl/checker/checklist/update';
  static String updateMakerData = '$baseUrl/maker/checklist/update';
  static String updateApproverData = '$baseUrl/approver/checklist/update';
  static String rejectMakerData = '$baseUrl/checker/checklist/reject';
  static String rejectCheckerData = '$baseUrl/approver/checklist/reject';
  static String oneSignal = '${base}onesignal/my_endpoint';
  static String notification = '${base}get/user/notifications';
  static String projectChecklistByAc = '${base}get/activity/details';

  // static String userLocation = '$baseUrl/update/user/location';

  /// NC

  static String ncProjectData = '$baseUrl/get/project/nc';
  static String ncTowerData = '$baseUrl/get/project/tower_floor/nc';
  static String ncFloorData = '$baseUrl/get/tower/floor/nc';
  static String ncFloorAcData = '$baseUrl/get/floor/activity/nc';
  static String ncFloorAcTypeData = '$baseUrl/get/floor/activity_type/nc';
  static String ncFloorChecklistData = '$baseUrl/get/floor/checklist/nc';
  static String ncFlatData = '$baseUrl/get/tower/flat/nc';
  static String ncFlatAcData = '$baseUrl/get/flat/activity/nc';
  static String ncFlatAcTypeData = '$baseUrl/get/flat/activity_type/nc';
  static String ncFlatChecklistData = '$baseUrl/get/flat/checklist/nc';

  static String duplicateActivity = '$baseUrl/duplicate/activities/create';
  static String deleteActivity = '$baseUrl/delete/activity';

  ///---
  static String updateMaker = '$baseUrl/maker/mi/update';
  static String updateChecker = '$baseUrl/checker/mi/update';
  static String updateApprover = '$baseUrl/approver/mi/update';
  static String rejectChecker = '$baseUrl/checker/mi/reject';
  static String rejectApprover = '$baseUrl/approver/mi/reject';

  ///Report
  static String getTower = '$baseUrl/get/towers';
  static String addCheckReport = '$baseUrl/create/training/report';
  static String getReport = '$baseUrl/get/training/report';

  /// approver checklist display
  static String approveractivity = '$baseUrl/activities';
  static String approveractivitytypes = '$baseUrl/activity/type_names';
  static String approveractivitytypechecklist = '$baseUrl/activity/checklist';

  /// generate nc by app
  static String ncGetProject = '$baseUrl/api/project/info';
  static String ncGetTower = '$baseUrl/api/tower/info';
  static String ncGetFloor = '$baseUrl/api/floor/info';
  static String ncGetFlat = '$baseUrl/api/flat/info';
  static String ncGetActivity = '$baseUrl/api/activities/info';
  static String ncGetActivityType = '$baseUrl/api/activity/type/info';
  static String ncGetActivityTypeChecklist =
      '$baseUrl/api/activity/checklist/info';
  static String ncsubmitbutton = '$baseUrl/api/nc/create';
  static String ncfetchalldata = '$baseUrl/api/nc/fetch_all';
  static String ncprojectresponsiblelist = '$baseUrl/api/users/list';
  static String ncclosestate = '$baseUrl/api/nc/submit';
  //27/11
  static String approverRejectNc = '$baseUrl/api/approver/nc/reject';
  //28//11
  static String approverCloseNc = '$baseUrl/api/approver/nc/close';

//// nc routing through notifcation
  static String ncRoutingThroughNotification = '$baseUrl/api/nc/fetch';

  /// WRITE THIS APIS OF CUBE TESTING
  /// ------------------ CUBE TESTING ------------------
  static String getCubeTestingList = '${basic}api/cube-testing/list';

  static String getSingleCubeTesting = '${basic}api/cube-testing/get';

  static String createCubeTesting = '${basic}api/cube-testing/create';

// use id after this

  static String updateCubeTesting = '${basic}api/cube-testing/update';
// use id after this

  // static String deleteCubeTesting = '${basic}api/cube-testing/delete';
  static String deleteCubeTesting = '${basic}api/cube-testing/delete/';
// use id after this

  static String searchCubeTesting = '${basic}api/cube-testing/search';
}
