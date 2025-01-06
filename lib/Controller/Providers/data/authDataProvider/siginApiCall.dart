import 'dart:developer';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/getUserProfile.dart';
import 'package:lisit_mobile_app/Controller/controller.dart';
import 'package:lisit_mobile_app/Screens/notificationPreferences/notificationPreferences.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';
import 'package:lisit_mobile_app/main.dart';
import 'package:lisit_mobile_app/services/googleSignin.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SiginApiCall extends ChangeNotifier {
  bool isLoading = false;

  var emailResponse = {};

  Future<bool> signInWithGoogle(context) async {
    isLoading = true;
    notifyListeners();
    var user = await GoogleSignInApi.login();

    if (user != null) {
      Map userData = {
        'displayName': user.displayName,
        'email': user.email,
        'id': user.id.toString(),
        'photoUrl': user.photoUrl,
        'serverAuthCode': user.serverAuthCode,
        'mobileFcmToken': fcmToken,
      };
      var response = await CallApi.postApi(context,
          isInsideData: true,
          parametersList: userData,
          isAdmin: false,
          endPoint: '/auth/google/callback');
      print('this is api response before condition: $response');

      if (response['success'] == true) {
        var user = response['user'];

        print(user['ReportedAdIds']);
        GetUserProfile().reportedAds =
            (user['ReportedAdIds'] as List).map((e) => e).toList();
        notifyListeners();
        print('these are the reported ads: ${GetUserProfile().reportedAds}');
        print(user);
        saveUserData(
          name: user['Name'],
          token: response['token'],
          email: user['Email'],
          userId: user['ID'].toString(),
          photoUrl: user['ProfilePicture'],
          accountType: user['SocialMedia'],
          isActive: user['IsActive'],
          isVerified: user['IsVerified'],
          phoneNumber: user['PhoneNumber'],
        );
        SaveUserNotificationPreferences(
            emailNotification: user['EmailNotify'],
            mobileNotification: user['MobileNotify'],
            fcmNotification: user['MobileFcmNotify']);
        notifyListeners();
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        print(
            'this google signIn api response message: ${response['success']}');
        isLoading = false;
        notifyListeners();
        return false;
      }
    } else {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithApple(context) async {
    isLoading = true;
    notifyListeners();
    final credential = await SignInWithApple.getAppleIDCredential(scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ]);

    Map<String, dynamic> decodedToken =
        JwtDecoder.decode("${credential.identityToken}");
    String? emailFromToken = decodedToken['email'];
    print(decodedToken);
    print(emailFromToken);
    print(credential.familyName);

    Map userData = {};
    if (credential.givenName != null || emailFromToken != null) {
      if (credential.givenName != null) {
        userData = {
          'firstName': credential.givenName,
          'lastName': credential.familyName,
          'email': credential.email,
          'Mobilefcmtoken': fcmToken,
        };
      } else {
        userData = {
          'email': emailFromToken,
          'Mobilefcmtoken': fcmToken,
        };
      }
      var response = await CallApi.postApi(context,
          isInsideData: true,
          parametersList: userData,
          isAdmin: false,
          endPoint: '/auth/apple/callback');
      print('this is api response before condition: $response');

      if (response['success'] == true) {
        var user = response['user'];

        print(user['ReportedAdIds']);
        GetUserProfile().reportedAds =
            (user['ReportedAdIds'] as List).map((e) => e).toList();
        notifyListeners();
        print('these are the reported ads: ${GetUserProfile().reportedAds}');
        print(user);
        saveUserData(
          name: user['Name'],
          token: response['token'],
          email: user['Email'],
          userId: user['ID'].toString(),
          photoUrl: user['ProfilePicture'],
          accountType: user['SocialMedia'],
          isActive: user['IsActive'],
          isVerified: user['IsVerified'],
          phoneNumber: user['PhoneNumber'],
        );
        SaveUserNotificationPreferences(
            emailNotification: user['EmailNotify'],
            mobileNotification: user['MobileNotify'],
            fcmNotification: user['MobileFcmNotify']);
        notifyListeners();
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        print(
            'this google signIn api response message: ${response['success']}');
        isLoading = false;
        notifyListeners();
        return false;
      }
    } else {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithFacebook(context) async {
    isLoading = true;
    notifyListeners();
    final LoginResult result = await FacebookAuth.instance
        .login(); // by default we request the email and the public profile

    // loginBehavior is only supported for Android devices, for ios it will be ignored
    // final result = await FacebookAuth.instance.login(
    //   permissions: ['email', 'public_profile', 'user_birthday', 'user_friends', 'user_gender', 'user_link'],
    //   loginBehavior: LoginBehavior
    //       .DIALOG_ONLY, // (only android) show an authentication dialog instead of redirecting to facebook app
    // );

    if (result.status == LoginStatus.success) {
      var _accessToken = result.accessToken;
      print(_accessToken?.token.toString());
      // get the user data
      // by default we get the userId, email,name and picture
      final userDataFb = await FacebookAuth.instance.getUserData();
      print(userDataFb);
      Map userData = {
        'name': userDataFb['name'],
        'pictureUrl': userDataFb['picture']['data']['url'],
        'email': userDataFb['email'],
        'Mobilefcmtoken': fcmToken,
      };
      var response = await CallApi.postApi(context,
          isInsideData: true,
          parametersList: userData,
          isAdmin: false,
          endPoint: '/auth/facebook/callback');
      print('this is api response before condition: $response');
      if (response['success'] == true) {
        var user = response['user'];

        print(user['ReportedAdIds']);
        GetUserProfile().reportedAds =
            (user['ReportedAdIds'] as List).map((e) => e).toList();
        notifyListeners();
        print('these are the reported ads: ${GetUserProfile().reportedAds}');
        print(user);
        saveUserData(
          name: user['Name'],
          token: response['token'],
          email: user['Email'],
          userId: user['ID'].toString(),
          photoUrl: user['ProfilePicture'],
          accountType: user['SocialMedia'],
          isActive: user['IsActive'],
          isVerified: user['IsVerified'],
          phoneNumber: user['PhoneNumber'],
        );
        SaveUserNotificationPreferences(
            emailNotification: user['EmailNotify'],
            mobileNotification: user['MobileNotify'],
            fcmNotification: user['MobileFcmNotify']);
        notifyListeners();
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        print(
            'this google signIn api response message: ${response['success']}');
        isLoading = false;
        notifyListeners();
        return false;
      }
    } else {
      print(result.status);
      print(result.message);
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithEmail(context,
      {required String email, required String password}) async {
    emailResponse.clear();
    isLoading = true;
    notifyListeners();
    log('fcm Token: ${Controller.getFcmToken()}');

    Map parameters = {
      'email': email.trim().toString(),
      'password': password.trim().toString(),
      'mobileFcmToken': fcmToken,
    };

    var response = await CallApi.postApi(context,
        parametersList: parameters,
        isAdmin: false,
        endPoint: '/auth/users/login',
        isInsideData: false);
    isLoading = false;
    notifyListeners();
    emailResponse = response;
    notifyListeners();

    print('in side function: $response');
    if (response is! String) {
      if (response['success'] == true) {
        var user = response['user'];
        print(user['ReportedAdIds']);
        GetUserProfile().reportedAds =
            (user['ReportedAdIds'] as List).map((e) => e).toList();
        notifyListeners();
        print('these are the reported ads: ${GetUserProfile().reportedAds}');
        saveUserData(
          name: user['Name'],
          token: response['token'],
          email: user['Email'],
          userId: user['ID'].toString(),
          photoUrl: user['ProfilePicture'],
          accountType: user['SocialMedia'],
          isActive: user['IsActive'],
          isVerified: user['IsVerified'],
          phoneNumber: user['PhoneNumber'],
        );
        SaveUserNotificationPreferences(
            emailNotification: user['EmailNotify'],
            mobileNotification: user['MobileNotify'],
            fcmNotification: user['MobileFcmNotify']);
        return true;
      } else {
        print('this  is error responseStatus: ${response['success']}');
        return false;
      }
    } else {
      return false;
    }
  }

  bool isChangePasswordLoading = false;

  Future changePassword(context,
      {required String oldPassword,
      required String newPassword,
      required String confirmPassword}) async {
    isChangePasswordLoading = true;
    notifyListeners();

    var response = await CallApi.patchApi(context,
        endPoint: '/user/profile/change-password',
        token: Controller.getUserToken(),
        body: {
          'confirm_password': confirmPassword,
          'new_password': newPassword,
          'current_password': oldPassword
        });

    isChangePasswordLoading = false;
    notifyListeners();

    return response;
  }

  saveUserData(
      {required String name,
      required String token,
      required String email,
      required String userId,
      required String photoUrl,
      required String accountType,
      required bool isActive,
      required bool isVerified,
      required String phoneNumber}) {
    print('save user Data is Called');
    Controller.saveLogin(isLogin: true);
    Controller.saveIsUserActive(isUserActive: isActive);
    Controller.saveIsUserVerified(isUserVerifend: isVerified);
    Controller.saveUserAccountType(userAccountType: accountType);
    Controller.saveUserPhotoUrl(userPhotoUrl: photoUrl);
    Controller.saveUserId(userId: userId);
    Controller.saveUserGmail(userGmail: email);
    Controller.saveUserToken(userToken: token);
    Controller.saveUserName(userName: name);
    Controller.saveUserPhoneNumber(userPhoneNumber: phoneNumber);
  }
}
