// To parse this JSON data, do
//
//     final safPostModel = safPostModelFromJson(jsonString);

import 'dart:convert';

SafPostModel safPostModelFromJson(String str) => SafPostModel.fromJson(json.decode(str));

String safPostModelToJson(SafPostModel data) => json.encode(data.toJson());

class SafPostModel {
    SafPostModel({
        this.checkoutRequestId,
        this.customerMessage,
        this.merchantRequestId,
        this.responseCode,
        this.responseDescription,
    });

    String checkoutRequestId;
    String customerMessage;
    String merchantRequestId;
    String responseCode;
    String responseDescription;

    factory SafPostModel.fromJson(Map<String, dynamic> json) => SafPostModel(
        checkoutRequestId: json["CheckoutRequestID"],
        customerMessage: json["CustomerMessage"],
        merchantRequestId: json["MerchantRequestID"],
        responseCode: json["ResponseCode"],
        responseDescription: json["ResponseDescription"],
    );

    Map<String, dynamic> toJson() => {
        "CheckoutRequestID": checkoutRequestId,
        "CustomerMessage": customerMessage,
        "MerchantRequestID": merchantRequestId,
        "ResponseCode": responseCode,
        "ResponseDescription": responseDescription,
    };
}
