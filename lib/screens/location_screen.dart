import 'dart:async';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key, this.locationWeather}) : super(key: key);

  final locationWeather;

  @override
  LocationScreenState createState() => LocationScreenState();
}

class LocationScreenState extends State<LocationScreen> {
  ///Data and UI vars
  WeatherModel weatherModel = WeatherModel();
  late int temperature;
  late int condition;
  late String city;
  late String weatherIcon;
  late String weatherMessage;

  ///Relocate to your current location var
  bool relocateIconLoad = false;

  ///Condition emoji animation vars
  Offset conditionOffset = const Offset(0, 0.075);
  bool conditionAnimationSwitch = true;

  ///Reloads the UI with the correct data
  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherIcon = '?';
        weatherMessage = 'Unable to get weather data';
        city = '';
        return;
      }
      double temp = weatherData['main']['temp'];
      temperature = temp.round();
      condition = weatherData['weather'][0]['id'];
      city = weatherData['name'];
      weatherIcon = weatherModel.getWeatherIcon(condition);
      weatherMessage = weatherModel.getWeatherMessage(temperature);
    });
  }

  ///Animates the hover effect of the condition emoji
  void animateConditionEmoji() {
    if (conditionAnimationSwitch) {
      setState(() => conditionOffset = const Offset(0, 0.04));
    } else {
      setState(() => conditionOffset = const Offset(0, 0.075));
    }

    ///Switch animation
    conditionAnimationSwitch ? conditionAnimationSwitch = false : conditionAnimationSwitch = true;
  }

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);

    ///Starts the animation of the Emoji
    Timer(const Duration(seconds: 1), () {
      animateConditionEmoji();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xff4B7EE7),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 10, left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ///Top row icon buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ///City Screen Button
                    TextButton(
                      onPressed: () async {
                        var typedCity = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const CityScreen();
                            },
                          ),
                        );
                        if (typedCity != null) {
                          var weather = await weatherModel.getCityWeather(typedCity);
                          updateUI(weather);
                        }
                      },
                      child: const Icon(
                        Icons.location_city,
                        size: 50.0,
                        color: Colors.white,
                      ),
                    ),

                    ///Relocate Button
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: !relocateIconLoad
                          ? Center(
                              child: TextButton(
                                onPressed: () async {
                                  setState(() => relocateIconLoad = true);

                                  var weather = await weatherModel.getLocationWeather();
                                  updateUI(weather);

                                  setState(() => relocateIconLoad = false);
                                },
                                child: const Icon(Icons.near_me, size: 50.0, color: Colors.white),
                              ),
                            )
                          : const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: CircularProgressIndicator(color: Colors.white),
                            ),
                    ),
                  ],
                ),

                ///Emoji & Temp
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ///Emoji
                    AnimatedSlide(
                      offset: conditionOffset,
                      duration: const Duration(seconds: 2),
                      curve: Curves.easeInOut,
                      onEnd: () {
                        animateConditionEmoji();
                      },
                      child: Text(
                        weatherIcon,
                        style: kConditionIconTextStyle,
                      ),
                    ),

                    ///Temp
                    Text(
                      city == '' ? '' : '$temperature°F',
                      style: kTempTextStyle,
                    ),
                  ],
                ),

                ///Message
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Text(
                        weatherMessage,
                        textAlign: TextAlign.center,
                        style: kTopMessageTextStyle,
                      ),
                      Text(
                        city == '' ? '' : "in $city",
                        textAlign: TextAlign.center,
                        style: kBottomMessageTextStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
