// To parse this JSON data, do
//
//     final putModel = putModelFromJson(jsonString);

import 'dart:convert';

PutModel putModelFromJson(String str) => PutModel.fromJson(json.decode(str));

String putModelToJson(PutModel data) => json.encode(data.toJson());

class PutModel {
    PutModel({
        this.code,
        this.error,
    });

    int code;
    String error;

    factory PutModel.fromJson(Map<String, dynamic> json) => PutModel(
        code: json["code"],
        error: json["error"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "error": error,
    };
}
