library flipper_login;

import 'package:flutter/material.dart';
import 'package:stacked/stacked_annotations.dart';

import 'button_view.dart';
import 'otp_view.form.dart';

@FormView(fields: [
  FormTextField(name: 'otp'),
])
class OtpView extends StatelessWidget with $OtpView {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 410.0,
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 40),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.fromLTRB(2.5, 0, 2.5, 0),
                      child: const Text(
                        'Enter',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(2.5, 0, 2.5, 0),
                      child: const Text(
                        'Otp Received',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w900),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(2.5, 0, 2.5, 0),
                      child: const Text(
                        '',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ]),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 40),
              child: Form(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: otpController,
                          decoration: const InputDecoration(
                            hintText: 'Otp Received by SMS',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Container(
            //   child: const Text(
            //     'Otp',
            //     textAlign: TextAlign.center,
            //     style: TextStyle(color: Colors.grey),
            //   ),
            // ),
            Container(
              child: ButtonView(
                'Verify',
                () {
                  // model.saveData();
                },
                Colors.white,
                Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
