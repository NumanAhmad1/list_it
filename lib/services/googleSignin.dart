import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> login() async {
    try {
      final result = await _googleSignIn.signIn();
      final ggAuth = await result!.authentication;
      print('THIS IS iDTOKEN: ${ggAuth.idToken}');
      print('THIS IS TOKEN: ${ggAuth.accessToken}');
      return result;
    } catch (error) {
      print(error);
    }
    // return await _googleSignIn.signIn();
  }
}
