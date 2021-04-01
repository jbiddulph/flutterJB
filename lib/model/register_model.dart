class RegisterResponseModel {
  final String token;
  final String error;

  RegisterResponseModel({this.token, this.error});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(token: json["token"] != null ? json["token"]: "", error: json["error"] != null ? json["error"]: "");
  }
}

class RegisterRequestModel {
  String name;
  String email;
  String password;
  String password_confirmation;

  RegisterRequestModel({this.name, this.email, this.password, this.password_confirmation});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "name": name, "email": email.trim(), "password": password.trim(), "password_confirmation": password_confirmation.trim(),
    };

    return map;
  }
}