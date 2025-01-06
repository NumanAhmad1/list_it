import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // For storing cookies securely

import 'package:http/http.dart' as http;
import 'package:lisit_mobile_app/const/lib_all.dart';
import 'package:lisit_mobile_app/main.dart';

class CallApi {
  // static const String baseUrl = 'http://192.168.100.73:8081/api';
  // static const String baseUrlAdmin = 'http://192.168.100.73:8080/api';

  // static const String baseUrl = 'https://api.listit.mindzbase.tech/api';
  // static const String baseUrlAdmin =
  //     'https://api.listitadmin.mindzbase.tech/api';

  static String baseUrl = '${dotenv.env['baseUrl']}';
  static String baseUrlAdmin = '${dotenv.env['baseUrlAdmin']}';

  // static const String baseUrl = 'https://api.listit.ae/api';

  // static const String baseUrlAdmin = 'https://api.admin.listit.ae/api';

  static Future<bool> checkInternetConnection() async {
    bool connectivityCheck = false;
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 20));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        connectivityCheck = true;
      }
    } on SocketException catch (_) {
      print('not connected');
      connectivityCheck = false;
    }

    return connectivityCheck;
  }

  static Future refereshToken(context) async {
    var endPoint = "/protected"; // The endpoint to get CSRF token
    var response = await CallApi.getApi(context,
        parametersMap: {}, isAdmin: false, endPoint: endPoint);

    log("Response: $response");

    // Extract CSRF token from the response
    csrf = response['csrf_token'];
    log("CSRF Token: $csrf");

    // Store the CSRF token for future requests (optional)
    final storage = FlutterSecureStorage();
    await storage.write(key: 'csrf_token', value: csrf);

    if (Controller.getUserGmail() != null) {
      await postApi(context,
          isInsideData: true,
          parametersList: {
            "email": Controller.getUserGmail(),
            "mobileFcmToken": fcmToken
          },
          isAdmin: false,
          endPoint: '/auth/refresh-token');
    }
  }

  //Get api call

// Initialize secure storage to store cookies

  static Future<dynamic> getApi(
    context, {
    required Map<String, String> parametersMap,
    required bool isAdmin,
    String? token,
    required String endPoint,
  }) async {
    final storage = FlutterSecureStorage();
    String url = isAdmin ? baseUrlAdmin + endPoint : baseUrl + endPoint;

    // Retrieve stored cookies
    String? storedCookies = await storage.read(key: 'cookie');

    // Build the headers including cookies
    final header = {
      if (token != null) 'Authorization': "Bearer $token", "X-CSRF-Token": csrf,
      'Request-Source': Platform.isAndroid ? 'Android' : 'iOS',
      if (storedCookies != null)
        'Cookie': storedCookies, // Add cookies if available
    };

    // Function to append parameters to the URL
    String addToUrl(Map<String, String> parameters) {
      parameters.forEach((key, value) {
        if (!url.contains('?')) {
          url += '?$key=$value';
        } else {
          url += '&$key=$value';
        }
      });
      return url;
    }

    bool connection = await checkInternetConnection();
    if (connection) {
      try {
        // Make the GET request
        var response =
            await http.get(Uri.parse(addToUrl(parametersMap)), headers: header);

        debugPrint('=================================');
        debugPrint('EndPoint: $endPoint');
        debugPrint('Status Code: ${response.statusCode}');
        debugPrint('Request: ${response.request}');
        debugPrint('Response body: ${jsonDecode(response.body)}');

        // If cookies are present in the response headers, store them
        if (response.headers.containsKey('set-cookie')) {
          String? newCookies = response.headers['set-cookie'];
          if (newCookies != null) {
            log('New cookies from response: $newCookies');
            await storage.write(
                key: 'cookie', value: newCookies); // Store the cookies
          }
        }

        // Handle the response
        if (response.statusCode == 200 ||
            response.statusCode == 400 ||
            response.statusCode == 500) {
          debugPrint('Response is decoded');
          return jsonDecode(response.body);
        } else if (response.statusCode == 401) {
          // Logout the user if unauthorized
          Controller.logoutUser(context);
          return jsonDecode(response.body);
        } else {
          debugPrint(response.body);
          return "Unable to process request at the moment";
        }
      } catch (e) {
        debugPrint('Error in Catch');
        debugPrint("Error: ${e.toString()}");
        return e.toString();
      }
    } else {
      return 'No Internet Connection';
    }
  }

  // static getApi(context,
  //     {required Map<String, String> parametersMap,
  //     required bool isAdmin,
  //     String? token,
  //     required String endPoint}) async {
  //   String url = isAdmin ? baseUrlAdmin + endPoint : baseUrl + endPoint;

  //   final header = {
  //     if (token != null) 'Authorization': "Bearer $token",
  //     'Request-Source': Platform.isAndroid ? 'Android' : 'iOS'
  //   };
  //   // adding parameters in url
  //   String addToUrl(Map<String, String> parameters) {
  //     parameters.forEach((key, value) {
  //       if (!url.contains('?')) {
  //         url += '?$key=$value';
  //       } else {
  //         url += '&$key=$value';
  //       }
  //     });
  //     return url;
  //   }

  //   bool connection = await checkInternetConnection();
  //   if (connection) {
  //     try {
  //       var response =
  //           await http.get(Uri.parse(addToUrl(parametersMap)), headers: header);

  //       debugPrint('=================================');
  //       debugPrint('EndPoint: $endPoint');
  //       debugPrint('Status Code: ${response.statusCode}');
  //       debugPrint('Request:${response.request}');
  //       debugPrint('Response body: ${jsonDecode(response.body)}');

  //       if (response.statusCode == 200 ||
  //           response.statusCode == 400 ||
  //           response.statusCode == 500) {
  //         debugPrint('response is decoded');

  //         return jsonDecode(response.body);
  //         // } else if (response.statusCode == 404) {
  //         //   return jsonDecode(response.body);P
  //       } else if (response.statusCode == 401) {
  //         Controller.logoutUser(context);
  //         return jsonDecode(response.body);
  //       } else {
  //         debugPrint(response.body);

  //         return "Unable to process request at the moment";
  //       }
  //     } catch (e) {
  //       debugPrint('Error in Catch');
  //       debugPrint("error: ${e.toString()}");
  //       return e.toString();
  //     }
  //   } else {
  //     return 'No Internet Connection';
  //   }

  //   // var result = await http.get(Uri.parse(addToUrl(parametersMap)));
  // }

  //Post Api call

// Initialize secure storage to store cookies

  static Future<dynamic> postApi(
    context, {
    required bool isInsideData,
    required dynamic parametersList,
    required bool isAdmin,
    required String endPoint,
    String? token,
  }) async {
    final storage = FlutterSecureStorage();
    String url = isAdmin ? baseUrlAdmin + endPoint : baseUrl + endPoint;

    log("${parametersList}");

    // Retrieve stored cookies
    String? storedCookies = await storage.read(key: 'cookie');

    // Construct headers, including cookies if available
    final header = {
      if (token != null) 'Authorization': "Bearer $token", "X-CSRF-Token": csrf,
      'Request-Source': Platform.isAndroid ? 'Android' : 'iOS',
      if (storedCookies != null)
        'Cookie': storedCookies, // Include stored cookies
    };

    final body = isInsideData ? {"data": parametersList} : parametersList;

    // Convert the request body to JSON
    final String requestBodyJson = json.encode(body);

    bool connection = await checkInternetConnection();
    if (connection) {
      try {
        // Make the POST request
        var response = await http.post(Uri.parse(url),
            body: requestBodyJson, headers: header);

        debugPrint('=================================');
        debugPrint('EndPoint: $endPoint');
        debugPrint('Status Code: ${response.statusCode}');
        debugPrint('Request: ${response.request}');
        debugPrint('Response body: ${response.body}');

        // If cookies are present in the response headers, store them
        if (response.headers.containsKey('set-cookie')) {
          String? newCookies = response.headers['set-cookie'];
          if (newCookies != null) {
            log('New cookies from response: $newCookies');
            await storage.write(
                key: 'cookie', value: newCookies); // Store the cookies
          }
        }

        // Handle the response
        if (response.statusCode == 201 ||
            response.statusCode == 200 ||
            response.statusCode == 500) {
          debugPrint('Data sent successfully');
          return jsonDecode(response.body); // Return the decoded JSON data
        } else if (response.statusCode >= 400 && response.statusCode <= 410) {
          return jsonDecode(response.body);
        } else if (response.statusCode == 401) {
          // Logout the user if unauthorized
          Controller.logoutUser(context);
          return jsonDecode(response.body);
        } else {
          debugPrint(response.body);
          return "Unable to process request at the moment";
        }
      } catch (e) {
        debugPrint('Error in Catch');
        debugPrint("Error: ${e.toString()}");
        return "Error: ${e.toString()}";
      }
    } else {
      return 'No Internet Connection';
    }
  }

  // static Future<dynamic> postApi(context,
  //     {required bool isInsideData,
  //     required dynamic parametersList,
  //     required bool isAdmin,
  //     required String endPoint,
  //     String? token}) async {
  //   String url = isAdmin ? baseUrlAdmin + endPoint : baseUrl + endPoint;

  //   log("${parametersList}");

  //   final header = {
  //     if (token != null) 'Authorization': "Bearer $token",
  //     'Request-Source': Platform.isAndroid ? 'Android' : 'iOS'
  //   };
  //   final body = isInsideData ? {"data": parametersList} : parametersList;

  //   // Convert the request body to JSON
  //   final String requestBodyJson = json.encode(body);

  //   bool connection = await checkInternetConnection();
  //   if (connection) {
  //     try {
  //       var response = await http.post(Uri.parse(url),
  //           body: requestBodyJson, headers: header);

  //       debugPrint('=================================');
  //       debugPrint('EndPoint: $endPoint');
  //       debugPrint('Status Code: ${response.statusCode}');
  //       debugPrint('Request:${response.request}');
  //       debugPrint('Response body: ${response.body}');

  //       if (response.statusCode == 201 ||
  //           response.statusCode == 200 ||
  //           response.statusCode == 500) {
  //         debugPrint('Data sent successfully');
  //         return jsonDecode(response.body); // Return the decoded JSON data
  //       } else if (response.statusCode >= 400 && response.statusCode <= 410) {
  //         return jsonDecode(response.body);
  //       } else if (response.statusCode == 401) {
  //         Controller.logoutUser(context);
  //         return jsonDecode(response.body);
  //       } else {
  //         debugPrint(response.body);
  //         return "Unable to process request at the moment";
  //       }
  //     } catch (e) {
  //       debugPrint('Error in Catch');
  //       debugPrint("error: ${e.toString()}");
  //       return "Error: ${e.toString()}";
  //     }
  //   } else {
  //     return 'No Internet Connection';
  //   }
  // }

// Initialize secure storage to store cookies

  static Future<dynamic> patchApi(
    context, {
    required String endPoint,
    required Map<String, dynamic> body,
    String? token,
  }) async {
    final storage = FlutterSecureStorage();
    // Retrieve stored cookies
    String? storedCookies = await storage.read(key: 'cookie');
    log('csrfp:$csrf');
    // Construct headers, including cookies if available
    Map<String, String> headers = {
      if (token != null) 'Authorization': "Bearer $token", "X-CSRF-Token": csrf,
      'Request-Source': Platform.isAndroid ? 'Android' : 'iOS',
      if (storedCookies != null)
        'Cookie': storedCookies, // Include stored cookies
    };
    log('patchheader:$headers');
    bool connection = await checkInternetConnection();

    if (connection) {
      try {
        // Make the PATCH request
        var response = await http.patch(
          Uri.parse(baseUrl + endPoint),
          headers: headers,
          body: jsonEncode(body),
        );

        debugPrint('=================================');
        debugPrint('EndPoint: $endPoint');
        debugPrint('Status Code: ${response.statusCode}');
        debugPrint('Request: ${response.request}');
        debugPrint('Response body: ${response.body}');

        // If cookies are present in the response headers, store them
        if (response.headers.containsKey('set-cookie')) {
          String? newCookies = response.headers['set-cookie'];
          if (newCookies != null) {
            log('New cookies from response: $newCookies');
            await storage.write(
                key: 'cookie', value: newCookies); // Store the cookies
          }
        }

        // Handle the response
        if (response.statusCode == 200) {
          var result = jsonDecode(response.body);
          print('This is the result for patch call: $result');
          return result;
        } else if (response.statusCode == 401) {
          // Logout the user if unauthorized
          Controller.logoutUser(context);
          return jsonDecode(response.body);
        } else {
          print(jsonDecode(response.body));
          return jsonDecode(response.body);
        }
      } catch (e) {
        debugPrint('Error in Catch Patch Call');
        debugPrint("Error: ${e.toString()}");
        return "Error: ${e.toString()}";
      }
    } else {
      return 'No Internet Connection';
    }
  }

  // static patchApi(context,
  //     {required String endPoint,
  //     required Map<String, dynamic> body,
  //     String? token}) async {
  //   Map<String, String> headers = {
  //     if (token != null) 'Authorization': "Bearer $token",
  //     'Request-Source': Platform.isAndroid ? 'Android' : 'iOS'
  //   };

  //   bool connection = await checkInternetConnection();

  //   if (connection) {
  //     try {
  //       var response = await http.patch(Uri.parse(baseUrl + endPoint),
  //           headers: headers, body: jsonEncode(body));
  //       debugPrint('=================================');
  //       debugPrint('EndPoint: $endPoint');
  //       debugPrint('Status Code: ${response.statusCode}');
  //       debugPrint('Request:${response.request}');
  //       debugPrint('Response body: ${response.body}');

  //       if (response.statusCode == 200) {
  //         var result = jsonDecode(response.body);
  //         print('this is result for patch call: $result');
  //         return result;
  //       } else if (response.statusCode == 401) {
  //         Controller.logoutUser(context);
  //         return jsonDecode(response.body);
  //       } else {
  //         print(jsonDecode(response.body));
  //         return jsonDecode(response.body);
  //       }
  //     } catch (e) {
  //       debugPrint('Error in Catch Patch Call');
  //       debugPrint("error: ${e.toString()}");
  //       return "Error: ${e.toString()}";
  //     }
  //   } else {
  //     return 'No Internet Connection';
  //   }
  // }

// Initialize secure storage to store cookies

  static Future<dynamic> deleteApi(
    context, {
    required String endPoint,
    required Map<String, dynamic> body,
    String? token,
  }) async {
    final storage = FlutterSecureStorage();
    // Retrieve stored cookies
    String? storedCookies = await storage.read(key: 'cookie');

    // Construct headers, including cookies if available
    Map<String, String> headers = {
      if (token != null) 'Authorization': "Bearer $token", "X-CSRF-Token": csrf,
      'Request-Source': Platform.isAndroid ? 'Android' : 'iOS',
      if (storedCookies != null)
        'Cookie': storedCookies, // Include stored cookies
    };

    bool connection = await checkInternetConnection();

    if (connection) {
      try {
        // Make the DELETE request
        var response = await http.delete(
          Uri.parse(baseUrl + endPoint),
          headers: headers,
          body: jsonEncode(body),
        );

        debugPrint('=================================');
        debugPrint('EndPoint: $endPoint');
        debugPrint('Status Code: ${response.statusCode}');
        debugPrint('Request: ${response.request}');
        debugPrint('Response body: ${response.body}');

        // If cookies are present in the response headers, store them
        if (response.headers.containsKey('set-cookie')) {
          String? newCookies = response.headers['set-cookie'];
          if (newCookies != null) {
            log('New cookies from response: $newCookies');
            await storage.write(
                key: 'cookie', value: newCookies); // Store the cookies
          }
        }

        // Handle the response
        if (response.statusCode == 200) {
          var result = jsonDecode(response.body);
          print('This is the result for delete call: $result');
          return result;
        } else if (response.statusCode == 401) {
          // Logout the user if unauthorized
          Controller.logoutUser(context);
          return jsonDecode(response.body);
        } else {
          print(jsonDecode(response.body));
          return jsonDecode(response.body);
        }
      } catch (e) {
        debugPrint('Error in Catch delete Call');
        debugPrint("Error: ${e.toString()}");
        return "Error: ${e.toString()}";
      }
    } else {
      return 'No Internet Connection';
    }
  }

  // static deleteApi(context,
  //     {required String endPoint,
  //     required Map<String, dynamic> body,
  //     String? token}) async {
  //   Map<String, String> headers = {
  //     if (token != null) 'Authorization': "Bearer $token",
  //     'Request-Source': Platform.isAndroid ? 'Android' : 'iOS'
  //   };

  //   bool connection = await checkInternetConnection();

  //   if (connection) {
  //     try {
  //       var response = await http.delete(Uri.parse(baseUrl + endPoint),
  //           headers: headers, body: jsonEncode(body));
  //       debugPrint('=================================');
  //       debugPrint('EndPoint: $endPoint');
  //       debugPrint('Status Code: ${response.statusCode}');
  //       debugPrint('Request:${response.request}');
  //       debugPrint('Response body: ${response.body}');

  //       if (response.statusCode == 200) {
  //         var result = jsonDecode(response.body);
  //         print('this is result for delete call: $result');
  //         return result;
  //       } else if (response.statusCode == 401) {
  //         Controller.logoutUser(context);
  //         return jsonDecode(response.body);
  //       } else {
  //         print(jsonDecode(response.body));
  //         return jsonDecode(response.body);
  //       }
  //     } catch (e) {
  //       debugPrint('Error in Catch delete Call');
  //       debugPrint("error: ${e.toString()}");
  //       return "Error: ${e.toString()}";
  //     }
  //   } else {
  //     return 'No Internet Connection';
  //   }
  // }

// Initialize secure storage to store cookies

  static Future<dynamic> putApi(
    context, {
    required String endPoint,
    required Map<String, dynamic> body,
    String? token,
  }) async {
    final storage = FlutterSecureStorage();
    // Retrieve stored cookies
    String? storedCookies = await storage.read(key: 'cookie');

    // Construct headers, including cookies if available
    Map<String, String> headers = {
      if (token != null) 'Authorization': "Bearer $token", "X-CSRF-Token": csrf,
      'Request-Source': Platform.isAndroid ? 'Android' : 'iOS',
      if (storedCookies != null)
        'Cookie': storedCookies, // Include stored cookies
    };

    bool connection = await checkInternetConnection();

    if (connection) {
      try {
        // Make the PUT request
        var response = await http.put(
          Uri.parse(baseUrl + endPoint),
          headers: headers,
          body: jsonEncode(body),
        );

        debugPrint('=================================');
        debugPrint('EndPoint: $endPoint');
        debugPrint('Status Code: ${response.statusCode}');
        debugPrint('Request: ${response.request}');
        debugPrint('Response body: ${response.body}');

        // If cookies are present in the response headers, store them
        if (response.headers.containsKey('set-cookie')) {
          String? newCookies = response.headers['set-cookie'];
          if (newCookies != null) {
            log('New cookies from response: $newCookies');
            await storage.write(
                key: 'cookie', value: newCookies); // Store the cookies
          }
        }

        // Handle the response
        if (response.statusCode == 200) {
          var result = jsonDecode(response.body);
          print('This is the result for put call: $result');
          return result;
        } else if (response.statusCode == 401) {
          // Logout the user if unauthorized
          Controller.logoutUser(context);
          return jsonDecode(response.body);
        } else {
          print(jsonDecode(response.body));
          return jsonDecode(response.body);
        }
      } catch (e) {
        debugPrint('Error in Catch put Call');
        debugPrint("Error: ${e.toString()}");
        return "Error: ${e.toString()}";
      }
    } else {
      return 'No Internet Connection';
    }
  }

  // static putApi(context,
  //     {required String endPoint,
  //     required Map<String, dynamic> body,
  //     String? token}) async {
  //   Map<String, String> headers = {
  //     if (token != null) 'Authorization': "Bearer $token",
  //     'Request-Source': Platform.isAndroid ? 'Android' : 'iOS'
  //   };

  //   bool connection = await checkInternetConnection();

  //   if (connection) {
  //     try {
  //       var response = await http.put(Uri.parse(baseUrl + endPoint),
  //           headers: headers, body: jsonEncode(body));
  //       debugPrint('=================================');
  //       debugPrint('EndPoint: $endPoint');
  //       debugPrint('Status Code: ${response.statusCode}');
  //       debugPrint('Request:${response.request}');
  //       debugPrint('Response body: ${response.body}');

  //       if (response.statusCode == 200) {
  //         var result = jsonDecode(response.body);
  //         print('this is result for delete call: $result');
  //         return result;
  //       } else if (response.statusCode == 401) {
  //         Controller.logoutUser(context);
  //         return jsonDecode(response.body);
  //       } else {
  //         print(jsonDecode(response.body));
  //         return jsonDecode(response.body);
  //       }
  //     } catch (e) {
  //       debugPrint('Error in Catch delete Call');
  //       debugPrint("error: ${e.toString()}");
  //       return "Error: ${e.toString()}";
  //     }
  //   } else {
  //     return 'No Internet Connection';
  //   }
  // }
}
