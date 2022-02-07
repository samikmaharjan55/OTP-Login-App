// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:otp_verification/models/api_service.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class OtpVerifyPage extends StatefulWidget {
  final String? mobileNo;
  final String? otpHash;

  const OtpVerifyPage({Key? key, this.mobileNo, this.otpHash})
      : super(key: key);

  @override
  _OtpVerifyPageState createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  String _otpCode = "";
  final int _otpCodeLength = 4;
  bool isAPICallProcess = false;
  late FocusNode myFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFocusNode = FocusNode();
    myFocusNode.requestFocus();

    SmsAutoFill().listenForCode.call();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ProgressHUD(
          child: verifyOtpUI(),
          inAsyncCall: isAPICallProcess,
          opacity: .3,
          key: UniqueKey(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    myFocusNode.dispose();
    super.dispose();
  }

  verifyOtpUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/image2.png',
          height: 100,
          fit: BoxFit.contain,
        ),
        const Padding(
          padding: EdgeInsets.only(
            top: 20,
          ),
          child: Text(
            "OTP Verification",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            "Enter OTP code sent to your mobile \n+977-${widget.mobileNo}",
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: PinFieldAutoFill(
            decoration: UnderlineDecoration(
              textStyle: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              colorBuilder: FixedColorBuilder(Colors.black.withOpacity(.3)),
            ),
            currentCode: _otpCode,
            codeLength: _otpCodeLength,
            onCodeChanged: (code) {
              if (code!.length == _otpCodeLength) {
                _otpCode = code;
                FocusScope.of(context).requestFocus((FocusNode()));
              }
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: FormHelper.submitButton(
            "Verify",
            () {
              setState(() {
                isAPICallProcess = true;
              });
              APIService.verifyOTP(
                widget.mobileNo!,
                widget.otpHash!,
                _otpCode,
              ).then(
                (response) async {
                  setState(() {
                    isAPICallProcess = false;
                  });

                  print(response.message);
                  print(response.data);

                  if (response.data != null) {
                    FormHelper.showSimpleAlertDialog(
                        context, 'Shopping App', response.message, "OK", () {
                      Navigator.pop(context);
                    });
                  } else {}
                },
              );
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
