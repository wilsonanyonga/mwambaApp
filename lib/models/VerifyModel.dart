// To parse this JSON data, do
//
//     final verifyModel = verifyModelFromJson(jsonString);

import 'dart:convert';

VerifyModel verifyModelFromJson(String str) => VerifyModel.fromJson(json.decode(str));

String verifyModelToJson(VerifyModel data) => json.encode(data.toJson());

class VerifyModel {
    VerifyModel({
        this.code,
        this.result,
    });

    int code;
    String result;

    factory VerifyModel.fromJson(Map<String, dynamic> json) => VerifyModel(
        code: json["code"],
        result: json["result"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "result": result,
    };
}
