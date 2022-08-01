
import 'package:huawei_account/huawei_account.dart';
import 'package:http/http.dart' as http;

class UserRepositoryHMS{
  final helper = AccountAuthParamsHelper();
  UserRepositoryHMS();



  Future<AuthAccount> signInWithHMSCore() async {
// Create an AccountAuthParamsHelper.

    // http.Response response = await http.Client().get(Uri.parse('http://google.com'));
    //
    // if (response.statusCode == 200) {
    // print('co ket noi ${response.statusCode}');
    // }else{
    //   print('khong ket noi ${response.statusCode}');
    // }
// Set options you want to request
    helper.setAuthorizationCode();
    try {
      // The sign-in is successful, and the user's ID information and authorization code are obtained.
      AuthAccount account =await AccountAuthService.signIn(helper);
      print("Kết quả đăng nhập: ${account.displayName} ");
      // AuthAccount account1 = await AccountAuthManager.getAuthResult();
      // print('check dang nhap: ${await account1.displayName}');
      return await AccountAuthService.silentSignIn();
    } on Exception catch (e) {
      print(e.toString()+'loi hms');
      return await AccountAuthService.silentSignIn();
    }


  }
  Future<void> signOutHMS()async {
    await AccountAuthService.signOut();
  }


  Future<bool> isSignInHMS() async{
    AuthAccount  _id = await AccountAuthManager.getAuthResult();
    print("lấy thôgn tin: ${_id.displayName} |email:  ${_id.email} |ID: ${_id.unionId}");
    return await (_id.displayName == null ? false : true);

// Set options you want to request
//     helper.setAccessToken();
//     // final helper = AccountAuthParamsHelper();
//     // helper
//     //   ..setProfile()
//     //   ..setAccessToken();
//     // await AccountAuthService.signIn(helper);
//     AuthAccount account1 =await AccountAuthService.silentSignIn();
//     print('sing in: $account1');
//     return await account1.displayName != null;

  }
  Future<AuthAccount> getUserHMS() async{
    return (await AccountAuthManager.getAuthResult());
  }

}