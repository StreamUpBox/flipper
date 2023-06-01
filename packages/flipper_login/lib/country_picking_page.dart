import 'package:flipper_routing/app.router.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class CountryPicker extends StatefulWidget {
  const CountryPicker({super.key});

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  bool termsAndCondValue = false;
  String pickedCountry = 'RW';
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Positioned(
                top: 8,
                left: 0,
                child: IconButton(
                  // minWidth: 10,
                  onPressed: () {
                    final _routerService = locator<RouterService>();
                    _routerService.clearStackAndShow(AuthOptionPageRoute());
                  },
                  icon: Image.asset('assets/fav.png',
                      height: 110, width: 110, package: 'flipper_login'),
                  color: Colors.black,
                ),
              ),
              Positioned(
                top: 45,
                right: 30,
                child: Text("Sign In",
                    style: GoogleFonts.poppins(
                        fontSize: 28, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(20.0), // add padding here
                child: Column(
                  children: <Widget>[
                    SizedBox(height: screenHeight * 0.15),
                    Text('Select the country where your business is located',
                        style: GoogleFonts.poppins(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: screenHeight * 0.03),
                    SizedBox(
                      width: 400,
                      height: 60,
                      child: CountryCodePicker(
                        hideSearch: true,
                        alignLeft: false,
                        onChanged: (element) => {
                          pickedCountry = element.code.toString(),
                          print(pickedCountry)
                        },
                        initialSelection: pickedCountry,
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: true,
                        textStyle: GoogleFonts.poppins(
                            fontSize: 20, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                              'I agree to flipper’s Seller Agreement and Privacy Policy.',
                              style: GoogleFonts.poppins(fontSize: 20)),
                        ),
                        Checkbox(
                          value: termsAndCondValue,
                          onChanged: (bool? value) {
                            setState(() {
                              termsAndCondValue = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.1),
                    Wrap(children: <Widget>[
                      Text(
                          'This app is protected by reCAPTCHA Enterprise and Google Privacy Policy and Terms of Service apply.',
                          style: GoogleFonts.poppins(fontSize: 18)),
                    ]),
                    SizedBox(height: screenHeight * 0.1),
                    SizedBox(
                      width: 368,
                      height: 68,
                      child: OutlinedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.resolveWith<OutlinedBorder>(
                            (states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.0),
                                side: BorderSide(color: Color(0xFF01B8E4))),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFF01B8E4)),
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Color(0xFF01B8E4);
                              }
                              if (states.contains(MaterialState.focused) ||
                                  states.contains(MaterialState.pressed)) {
                                return Color(0xFF01B8E4);
                              }
                              return null; // Defer to the widget's default.
                            },
                          ),
                        ),
                        onPressed: () async {
                          if (termsAndCondValue) {
                            //Navigate to signinpage.dart
                            final _routerService = locator<RouterService>();
                            _routerService.clearStackAndShow(
                                PhoneInputScreenRoute(
                                    countryCode: pickedCountry));
                          } else {
                            final snackBar = SnackBar(
                              content: const Text(
                                  'Accept terms and conditions to continue.'),
                              action: SnackBarAction(
                                label: 'Okay',
                                onPressed: () {
                                  // Some code to undo the change.
                                },
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        child: Text(
                          "Continue",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}