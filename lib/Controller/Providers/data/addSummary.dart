import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lisit_mobile_app/Controller/Services/callApi.dart';
import 'package:lisit_mobile_app/Models/addSummaryModel.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';
import 'package:http/http.dart' as http;

import '../../../main.dart';

class AddSummary extends ChangeNotifier {
  bool isLoading = false;
  bool iserrorsubmissionloading = false;
  List<String> imagesName = [];
  bool isImageUploading = false;

  Future postAddSummary(int firstCategoryId, int lastCategoryId, context,
      List<AddSummaryModel> selectedValueList) async {
    isLoading = true;
    notifyListeners();
    List<Map<String, dynamic>> jsonDataList =
        selectedValueList.map((model) => model.toJson()).toList();

    var response = await CallApi.postApi(
      context,
      isInsideData: true,
      parametersList: {
        "baseCategoryId": firstCategoryId,
        "categoryId": lastCategoryId,
        "data": jsonDataList,
      },
      endPoint: '/vehicles/summary-cat',
      isAdmin: false,
    );

    isLoading = false;
    notifyListeners();

    if (response != null && response is Map<String, dynamic>) {
      log(response.toString());
      print("this is response message: ${response['message']}");
      return response['message'];
    } else {
      // Handle the case where the response is not as expected
      return 'Unexpected response format';
    }
  }

// Initialize secure storage for storing cookies

  Future<String> uploadNewPhotos() async {
    imagesName.clear();
    log('upload image is clicked');

    // Pick multiple images
    List<XFile> files = await ImagePicker().pickMultiImage();
    isImageUploading = true;
    notifyListeners();

    log(isImageUploading.toString());

    if (files.isNotEmpty) {
      final storage = FlutterSecureStorage();
      // Retrieve CSRF token (assuming the getCSRF() method gets and stores it)
      // await CallApi.getCSRF(); // Assuming CallApi.getCSRF() stores the CSRF token in a variable

      // Retrieve stored cookies
      String? storedCookies = await storage.read(key: 'cookie');

      var request = http.MultipartRequest(
        "POST",
        Uri.parse('${CallApi.baseUrl}/files/upload'),
      );

      // Adding headers, including CSRF token and cookies
      request.headers.addAll({
        'Request-Source': Platform.isAndroid ? 'Android' : 'iOS',
        'X-CSRF-Token': csrf, // Include CSRF token
        if (storedCookies != null)
          'Cookie': storedCookies, // Include stored cookies
      });

      // Add files to the request
      for (int i = 0; i < files.length; i++) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'files',
            files[i].path,
          ),
        );
      }

      try {
        final response = await request.send();

        // If cookies are present in the response headers, store them
        if (response.headers.containsKey('set-cookie')) {
          String? newCookies = response.headers['set-cookie'];
          if (newCookies != null) {
            log('New cookies from response: $newCookies');
            await storage.write(
                key: 'cookie', value: newCookies); // Store the cookies
          }
        }

        // Process the response
        if (response.statusCode == 201) {
          print('Images uploaded successfully');
          final jsonResponse = await response.stream.bytesToString();
          print('this is the response for image upload: $jsonResponse');
          final decodedResponse = json.decode(jsonResponse);
          print('this is the decoded response: ${decodedResponse['data']}');

          isImageUploading = false;
          notifyListeners();

          // Update imagesName list
          imagesName = files.map((e) => e.name).toList();
          log('when 201 ${isImageUploading.toString()}');

          return decodedResponse['data'];
        } else {
          print('Failed to upload images. Status code: ${response.statusCode}');

          isImageUploading = false;
          notifyListeners();
          log('when failed ${isImageUploading.toString()}');
        }
      } catch (e) {
        print('Error uploading images: $e');

        isImageUploading = false;
        notifyListeners();
        log('when exception ${isImageUploading.toString()}');
      }
    } else {
      isImageUploading = false;
      notifyListeners();
      return '';
    }

    isImageUploading = false;
    notifyListeners();
    return '';
  }

  // Future<String> uploadNewPhotos() async {
  //   imagesName.clear();
  //   log('upload image is clicked');
  //   List<XFile> files = await ImagePicker().pickMultiImage();
  //   isImageUploading = true;
  //   notifyListeners();

  //   log(isImageUploading.toString());

  //   if (files.isNotEmpty) {
  //     var request = http.MultipartRequest(
  //       "POST",
  //       Uri.parse('${CallApi.baseUrl}/files/upload'),
  //     );

  //     request.headers
  //         .addAll({'Request-Source': Platform.isAndroid ? 'Android' : 'iOS'});
  //     for (int i = 0; i < files.length; i++) {
  //       request.files.add(
  //         await http.MultipartFile.fromPath(
  //           'files',
  //           files[i].path,
  //         ),
  //       );
  //     }

  //     try {
  //       final response = await request.send();
  //       if (response.statusCode == 201) {
  //         print('Images uploaded successfully');
  //         final jsonResponse = await response.stream.bytesToString();
  //         print('this is the response for imageUpoad: $jsonResponse');
  //         final decodedResponse = json.decode(jsonResponse);
  //         print('this is the decoded response: ${decodedResponse['data']}');
  //         isImageUploading = false;
  //         notifyListeners();
  //         imagesName = files.map((e) => e.name).toList();
  //         log('when 201 ${isImageUploading.toString()}');
  //         return decodedResponse['data'];
  //       } else {
  //         print('Failed to upload images. Status code: ${response.statusCode}');
  //         isImageUploading = false;
  //         notifyListeners();
  //         log('when failed ${isImageUploading.toString()}');
  //       }
  //     } catch (e) {
  //       print('Error uploading images: $e');
  //       isImageUploading = false;
  //       notifyListeners();
  //       log('when exception ${isImageUploading.toString()}');
  //     }
  //   } else {
  //     isImageUploading = false;
  //     notifyListeners();
  //     return '';
  //   }

  //   isImageUploading = false;
  //   notifyListeners();
  //   return '';
  // }

  uploadImage() async {
    log('upload image is clicked');
    XFile? files = await ImagePicker().pickImage(source: ImageSource.gallery);
    isImageUploading = true;
    notifyListeners();

    log(isImageUploading.toString());

    if (files != null) {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse('${CallApi.baseUrl}/files/upload'),
      );

      request.headers
          .addAll({'Request-Source': Platform.isAndroid ? 'Android' : 'iOS'});
      request.files.add(
        await http.MultipartFile.fromPath(
          'files',
          files.path,
        ),
      );

      try {
        final response = await request.send();
        if (response.statusCode == 201) {
          print('Images uploaded successfully');
          final jsonResponse = await response.stream.bytesToString();
          print('this is the response for imageUpoad: $jsonResponse');
          final decodedResponse = json.decode(jsonResponse);
          print('this is the decoded response: ${decodedResponse['data']}');
          isImageUploading = false;
          notifyListeners();
          log('when 201 ${isImageUploading.toString()}');
          return decodedResponse['data'];
        } else {
          print('Failed to upload images. Status code: ${response.statusCode}');
          isImageUploading = false;
          notifyListeners();
          log('when failed ${isImageUploading.toString()}');
        }
      } catch (e) {
        print('Error uploading images: $e');
        isImageUploading = false;
        notifyListeners();
        log('when exception ${isImageUploading.toString()}');
      }
    } else {
      isImageUploading = false;
      notifyListeners();
      return '';
    }

    isImageUploading = false;
    notifyListeners();
    return '';
  }

  editAdSubmission(context,
      {required Map<String, dynamic> body, required String id}) async {
    // log('this is body: $body');
    iserrorsubmissionloading = true;
    notifyListeners();
    var response = await CallApi.putApi(context,
        endPoint: '/vehicles/summary/$id',
        body: body,
        token: Controller.getUserToken());
    iserrorsubmissionloading = false;
    notifyListeners();
    return response;
  }
}
