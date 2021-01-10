// To parse this JSON data, do
//
//     final homeModel = homeModelFromJson(jsonString);

import 'dart:convert';

HomeModel homeModelFromJson(String str) => HomeModel.fromJson(json.decode(str));

String homeModelToJson(HomeModel data) => json.encode(data.toJson());

class HomeModel {
    HomeModel({
        this.code,
        this.result,
    });

    int code;
    List<Result> result;

    factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
        code: json["code"],
        result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
    };
}

class Result {
    Result({
        this.basic,
        this.basicAmount,
        this.description,
        this.id,
        this.image,
        this.name,
        this.plan,
        this.planAmount,
        this.premium,
        this.premiumAmount,
        this.sample,
        this.uploadName,
    });

    String basic;
    int basicAmount;
    String description;
    int id;
    String image;
    String name;
    String plan;
    int planAmount;
    String premium;
    int premiumAmount;
    String sample;
    String uploadName;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        basic: json["basic"],
        basicAmount: json["basic_amount"],
        description: json["description"],
        id: json["id"],
        image: json["image"],
        name: json["name"],
        plan: json["plan"],
        planAmount: json["plan_amount"],
        premiumAmount: json["premium_amount"],
        sample: json["sample"],
        uploadName: json["upload_name"],
    );

    Map<String, dynamic> toJson() => {
        "basic": basic,
        "basic_amount": basicAmount,
        "description": description,
        "id": id,
        "image": image,
        "name": name,
        "plan_amount": planAmount,
        "premium_amount": premiumAmount,
        "sample": sample,
        "upload_name": uploadName,
    };
}
