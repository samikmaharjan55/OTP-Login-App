// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:otp_verification/models/api_service.dart';
import 'package:otp_verification/otp_verify_page.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class LoginOTPPage extends StatefulWidget {
  const LoginOTPPage({Key? key}) : super(key: key);

  @override
  _LoginOTPPageState createState() => _LoginOTPPageState();
}

class _LoginOTPPageState extends State<LoginOTPPage> {
  String mobileNo = "";
  bool isAPICallProcess = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ProgressHUD(
          child: loginUI(),
          inAsyncCall: isAPICallProcess,
          opacity: .3,
          key: UniqueKey(),
        ),
      ),
    );
  }

  loginUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/image1.png",
          height: 100,
          fit: BoxFit.contain,
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Center(
            child: Text(
              "Login with a Mobile Number",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Center(
            child: Text(
          'Enter your mobile number we will send you OTP to Verify',
          style: TextStyle(fontSize: 14),
        )),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  height: 47,
                  width: 50,
                  margin: const EdgeInsets.fromLTRB(0, 10, 3, 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '+977',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 5,
                child: TextFormField(
                  maxLines: 1,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(6),
                    hintText: 'Mobile Number',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (String value) {
                    if (value.length > 9) {
                      mobileNo = value;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Center(
          child: FormHelper.submitButton(
            "Continue",
            () {
              if (mobileNo.length > 9) {
                setState(() {
                  isAPICallProcess = true;
                });
                APIService.otpLogin(mobileNo).then(
                  (response) async {
                    setState(() {
                      isAPICallProcess = false;
                    });

                    print(response.message);
                    print(response.data);

                    if (response.data != null) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OtpVerifyPage(
                            otpHash: response.data,
                            mobileNo: mobileNo,
                          ),
                        ),
                        (route) => false,
                      );
                    }
                  },
                );
              }
            },
            borderColor: HexColor("#78D0B1"),
            btnColor: HexColor("#78D0B1"),
            txtColor: HexColor("#000000"),
            borderRadius: 20,
          ),
        ),
      ],
    );
  }
}
