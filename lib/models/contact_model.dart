
import 'dart:convert';

ContactModel contactModelFromJson(String str) => ContactModel.fromJson(json.decode(str));

String contactModelToJson(ContactModel data) => json.encode(data.toJson());

class ContactModel {
  List<Datum> data;

  ContactModel({
    required this.data,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String name;
  String token;

  Datum({
    required this.name,
    required this.token,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    name: json["name"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "token": token,
  };
}
