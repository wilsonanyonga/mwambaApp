import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';


class HomeReq {
  // final String name;
  // final String email;
  // final String password;
  // final String phone;
  // final String userName;
  final String url = 'http://mwambabuilders.com/mwambaApp:5000/api/listHome';
  // static String client_id = 'Your_github_client_id';
  // static String client_secret = 'Your_github_client_secret';

  // final String query = "?client_id=${client_id}&client_secret=${client_secret}";

  HomeReq();

  // Future<http.Response> fetchUser() {
  //   return http.get(url + 'users/' + userName + query);
  // }

  // Future<http.Response> fetchFollowing() {
  //   return http.get(url + 'users/' + userName + '/following' + query);
  // }
  // var token = "adfasjdf";
  Future<http.Response> homeReq() async {
    // var data = {
    //   'name' : name,
    //   'email' : email,
    //   'password' : password,
    //   'phone' : phone
    // };
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // var token = sharedPreferences.getString("token");

    var headersAPI = {
      'Content-Type' : 'application/json',
      
    };

    return http.get(url, headers: headersAPI);

    // return http.post(url + 'users/following' + query);
  }
}