// To parse this JSON data, do
//
//     final safVerifyModel = safVerifyModelFromJson(jsonString);

import 'dart:convert';

SafVerifyModel safVerifyModelFromJson(String str) => SafVerifyModel.fromJson(json.decode(str));

String safVerifyModelToJson(SafVerifyModel data) => json.encode(data.toJson());

class SafVerifyModel {
    SafVerifyModel({
        this.responseCode,
        this.responseDescription,
        this.merchantRequestId,
        this.checkoutRequestId,
        this.resultCode,
        this.resultDesc,
    });

    String responseCode;
    String responseDescription;
    String merchantRequestId;
    String checkoutRequestId;
    String resultCode;
    String resultDesc;

    factory SafVerifyModel.fromJson(Map<String, dynamic> json) => SafVerifyModel(
        responseCode: json["ResponseCode"],
        responseDescription: json["ResponseDescription"],
        merchantRequestId: json["MerchantRequestID"],
        checkoutRequestId: json["CheckoutRequestID"],
        resultCode: json["ResultCode"],
        resultDesc: json["ResultDesc"],
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "ResponseDescription": responseDescription,
        "MerchantRequestID": merchantRequestId,
        "CheckoutRequestID": checkoutRequestId,
        "ResultCode": resultCode,
        "ResultDesc": resultDesc,
    };
}
