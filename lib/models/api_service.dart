import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:otp_verification/models/config.dart';
import 'package:otp_verification/models/otp_login_response_model.dart';

class APIService {
  static var client = http.Client();

  static Future<OtpLoginResponseModel> otpLogin(String mobileNo) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var url = Uri.http(Config.apiURL, Config.otpLoginAPI);

    var response = await client.post(url,
        headers: requestHeaders,
        body: jsonEncode(
          {"phone": mobileNo},
        ));

    return otpLoginResponseJSON(response.body);
  }

  static Future<OtpLoginResponseModel> verifyOTP(
    String mobileNo,
    String otpHash,
    String otpCode,
  ) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var url = Uri.http(Config.apiURL, Config.otpVerifyAPI);

    var response = await client.post(url,
        headers: requestHeaders,
        body: jsonEncode(
          {
            "phone": mobileNo,
            "otp": otpCode,
            "hash": otpHash,
          },
        ));

    return otpLoginResponseJSON(response.body);
  }
}
