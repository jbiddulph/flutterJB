import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterjb/model/myfinds_model.dart';
import 'package:flutterjb/model/login_model.dart';
import 'package:flutterjb/model/profile_model.dart';
import 'package:flutterjb/model/register_model.dart';
import 'package:flutterjb/services/Storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String finalProfileId;
String finalProfileEmail;

class APIService {
  String url = "lookwhatfound.me";
  // Myfind
  final storage = new FlutterSecureStorage();
  Future<LoginResponseModel> login(LoginRequestModel loginRequestModel) async {
    String endpoint = "/api/auth/login";
    final response = await http.post(Uri.https(url, endpoint),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(loginRequestModel));

    if (response.statusCode == 200 || response.statusCode == 400) {
      return LoginResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  getToken() async {}

  Future<RegisterResponseModel> register(
      RegisterRequestModel registerRequestModel) async {
    String endpoint = "/api/auth/register";
    final response = await http.post(Uri.https(url, endpoint),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(registerRequestModel));

    if (response.statusCode == 200 || response.statusCode == 400) {
      return RegisterResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  // LOAD Profile
  Future<Profile> loadProfile() async {
    String endpoint = "/api/auth/profile";
    String newToken = await storage.read(key: 'token');
    String profileEmail = await storage.read(key: 'profileEmail');
    final response =
        await http.get(Uri.https(url, endpoint), headers: <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $newToken',
      'profileEmail': '$profileEmail'
    });
    if (response.statusCode == 200) {
      final SecureStorage secureStorage = SecureStorage();

      // secureStorage
      //     .readSecureData('profileId')
      //     .then((value) => {finalProfileId = value});
      secureStorage
          .readSecureData('profileEmail')
          .then((email) => {finalProfileEmail = email});
      print('email: ${finalProfileEmail}');
      final responseJson = jsonDecode(response.body);

      return Profile.fromJson(responseJson);
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  // GET Myfind
  Future<List<Myfinds>> fetchMyfinds() async {
    String endpoint = "/api/artworks";
    String newToken = await storage.read(key: 'token');
    final response =
        await http.get(Uri.https(url, endpoint), headers: <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $newToken',
    });
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Myfinds> posts = body
          .map(
            (dynamic item) => Myfinds.fromJson(item),
          )
          .toList();

      return posts;
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  // DELETE Myfind
  Future<void> deleteMyfinds(int id) async {
    String endpoint = "/api/artworks/$id";
    String newToken = await storage.read(key: 'token');
    final response =
        await http.delete(Uri.https(url, endpoint), headers: <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $newToken',
    });
    if (response.statusCode == 200) {
      print("DELETED");
    } else {
      throw "Unable to delete post.";
    }
  }

  Future<Myfinds> addNewMyfinds(MyfindsRequestModel myfindsRequestModel) async {
    String endpoint = "/api/artworks";
    String newToken = await storage.read(key: 'token');
    final response = await http.post(Uri.https(url, endpoint),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $newToken',
        },
        body: jsonEncode(myfindsRequestModel));
    print(myfindsRequestModel);

    if (response.statusCode == 200 || response.statusCode == 400) {
      if (json.decode(response.body)['token'] != null) {
        return Myfinds.fromJson(json.decode(response.body));
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}
