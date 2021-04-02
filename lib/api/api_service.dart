import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterjb/model/artwork_model.dart';
import 'package:flutterjb/model/login_model.dart';
import 'package:flutterjb/model/register_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class APIService {
  String url = "choosapi.test:80";
  final storage = new FlutterSecureStorage();
  Future<LoginResponseModel> login(LoginRequestModel loginRequestModel) async {
    String endpoint = "/api/auth/login";
    final response = await http.post(
      Uri.http(url, endpoint),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(loginRequestModel)
    );
    

    if(response.statusCode == 200 || response.statusCode == 400) {
      return LoginResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  getToken() async {
  }

  Future<RegisterResponseModel> register(RegisterRequestModel registerRequestModel) async {
    String endpoint = "/api/auth/register";
    final response = await http.post(
      Uri.http(url, endpoint),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      
      body: jsonEncode(registerRequestModel)
    );
    

    if(response.statusCode == 200 || response.statusCode == 400) {
      return RegisterResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception(response.body);
      
    }
  }

  // GET Artwork
  Future<List<Artwork>> fetchArtwork() async {
    String endpoint = "/api/artworks";
    String newToken = await storage.read(key: 'token');
  final response = await http.get(Uri.http(url, endpoint),
    headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $newToken',
      });
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      List<Artwork> posts = body
        .map(
          (dynamic item) => Artwork.fromJson(item),
        )
        .toList();

      return posts;
    } else {
      throw "Unable to retrieve posts.";
    }
  }
}