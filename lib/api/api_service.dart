import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterjb/model/finds_model.dart';
import 'package:flutterjb/model/login_model.dart';
import 'package:flutterjb/model/profile_model.dart';
import 'package:flutterjb/model/register_model.dart';
import 'package:flutterjb/services/Storage.dart';
import 'package:flutterjb/utils/user_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String finalProfileId;
String finalProfileEmail;

class APIService {
  String url = "lookwhatfound.me";
  // POST Login
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

  // POST a new User
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

  // GET Profile
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
      final profilename = await UserSecureStorage.getProfileName() ?? '';
      final profileemail = await UserSecureStorage.getProfileEmail() ?? '';
      final profileid = await UserSecureStorage.getProfileId() ?? '';
      print('Name: ${profilename}');
      print('Email: ${profileemail}');
      print('ID: ${profileid}');
      final responseJson = jsonDecode(response.body);

      return Profile.fromJson(responseJson);
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  // GET My Finds
  Future<List<Finds>> fetchMyfinds() async {
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
      List<Finds> posts = body
          .map(
            (dynamic item) => Finds.fromJson(item),
          )
          .toList();

      return posts;
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  // GET All Finds
  Future<List<Finds>> fetchAllfinds() async {
    String endpoint = "/api/allartworks";
    String newToken = await storage.read(key: 'token');
    final response =
        await http.get(Uri.https(url, endpoint), headers: <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $newToken',
    });
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Finds> posts = body
          .map(
            (dynamic item) => Finds.fromJson(item),
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

  // POST new MyFinds
  Future<Finds> addNewMyfinds(FindsRequestModel findsRequestModel) async {
    String endpoint = "/api/artworks";
    String newToken = await storage.read(key: 'token');
    final response = await http.post(Uri.https(url, endpoint),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $newToken',
        },
        body: jsonEncode(findsRequestModel));
    print(findsRequestModel);

    if (response.statusCode == 200 || response.statusCode == 400) {
      if (json.decode(response.body)['token'] != null) {
        return Finds.fromJson(json.decode(response.body));
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}
