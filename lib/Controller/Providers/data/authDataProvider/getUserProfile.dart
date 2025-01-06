import 'package:lisit_mobile_app/const/lib_all.dart';

class GetUserProfile extends ChangeNotifier {
  bool isLoading = false;
  String error = '';

  List reportedAds = [];
  getUserProfile(context) async {
    var response = await CallApi.getApi(context,
        token: Controller.getUserToken(),
        parametersMap: {},
        isAdmin: false,
        endPoint: '/user/profile');

    if (response is! String) {
      if (response is Map<String, dynamic>) {
        if (response['success'] == true) {
          print(response['data']['ReportedAdIds']);
          reportedAds = (response['data']['ReportedAdIds'] as List)
              .map((e) => e)
              .toList();
          print('reported ads: $reportedAds');
          print('user Profile is called');
          notifyListeners();

          await Controller.saveUserName(userName: response['data']['Name']);
          await Controller.saveUserPhotoUrl(
              userPhotoUrl: response['data']['ProfilePicture']);
          await Controller.saveIsUserActive(
              isUserActive: response['data']['IsActive']);
          notifyListeners();

          print('reported ads: $reportedAds');
        }
      }
    }
  }

  reportAd(context, {required Map<String, dynamic> userReportedMapData}) async {
    isLoading = false;
    notifyListeners();
    error = '';
    notifyListeners();

    var response = await CallApi.postApi(context,
        token: Controller.getUserToken(),
        isInsideData: true,
        parametersList: userReportedMapData,
        isAdmin: false,
        endPoint: '/vehicles/report-ad');

    if (response is! String) {
      if (response is Map<String, dynamic>) {
        if (response['success'] == true) {
          reportedAds = (response['data'] ?? [] as List).map((e) => e).toList();
          isLoading = false;
          notifyListeners();
        } else {
          isLoading = false;
          notifyListeners();
          error = response['message'];
          notifyListeners();
        }
      } else {
        isLoading = false;
        notifyListeners();
        error = 'Unable to process data';
        notifyListeners();
      }
    } else {
      isLoading = false;
      notifyListeners();
      error = response;
      notifyListeners();
    }
  }
}
