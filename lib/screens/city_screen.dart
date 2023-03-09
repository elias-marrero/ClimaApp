import 'dart:async';

import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({Key? key}) : super(key: key);

  @override
  CityScreenState createState() => CityScreenState();
}

class CityScreenState extends State<CityScreen> {
  String cityName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xff4B7EE7),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ///Back Button
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      size: 30.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              ///Search Textfield and Button
              Column(
                children: [
                  ///Search TextField
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      style: const TextStyle(
                        color: Color(0xff4B7EE7),
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        filled: true,
                        fillColor: Colors.white,
                        icon: Icon(
                          Icons.location_city,
                          color: Colors.white,
                          size: 30,
                        ),
                        hintText: 'Enter City Name',
                        hintStyle: TextStyle(
                          color: Color(0xff4B7EE7),
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        cityName = value;
                      },
                    ),
                  ),

                  ///Search Button
                  OutlinedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();

                      Timer(const Duration(seconds: 1), () {});

                      Navigator.pop(context, cityName);
                    },
                    style: OutlinedButton.styleFrom(
                      primary: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        'Get Weather',
                        style: kButtonTextStyle,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
