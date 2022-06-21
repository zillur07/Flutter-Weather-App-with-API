import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class HomePage2 extends StatefulWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  State<HomePage2> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage2> {
  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    position = await Geolocator.getCurrentPosition();
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
    fetchWeather();
    print("my latitude is $latitude, and longitude is $longitude");
  }

  fetchWeather() async {
    var weatherResponce = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&exclude=hourly%2Cdaily&appid=cc93193086a048993d938d8583ede38a&fbclid=IwAR1rg9BHqDzqxJia8bplKeuzaNLUVMWNCsfmGjp1-IHI0hpsrGe7Hnq5FMI"));

    var forcastResponce = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=metric&appid=d934c6303bb835f2480c9774e5e3c7ca"));
    setState(() {
      weatherMap = Map<String, dynamic>.from(jsonDecode(weatherResponce.body));
      forcastMap = Map<String, dynamic>.from(jsonDecode(forcastResponce.body));
    });
    print(weatherResponce.body);
    print(forcastResponce.body);
  }

  Map<String, dynamic>? weatherMap;
  Map<String, dynamic>? forcastMap;

  late Position position;
  double? latitude;
  double? longitude;

  @override
  void initState() {
    _determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: forcastMap != null
          ? Stack(
              alignment: Alignment.bottomRight,
              children: [
                Image.asset(
                  'img/bg.jpg',
                  width: double.infinity,
                  fit: BoxFit.cover,
                  height: double.infinity,
                ),
                Positioned(
                  top: 50,
                  left: 25,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${Jiffy('${forcastMap!["list"][0]["dt_txt"]}').format('MMM do yy')} , ${Jiffy('${forcastMap!["list"][0]["dt_txt"]}').format('hh:mm a')}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        '${weatherMap!["name"]} ',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 140,
                  left: 50,
                  child: Column(
                    children: [
                      Image.asset(
                        'img/w4.png',
                        height: 150,
                      ),
                      Text(
                        '${forcastMap!["list"][0]["main"]["temp"]} °',
                        style: GoogleFonts.angkor(
                          textStyle: Theme.of(context).textTheme.headline4,
                          fontSize: 42,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 360,
                  left: 10,
                  right: 10,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 5,
                                    right: 5,
                                    top: 15,
                                  ),
                                  height: 70,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Feels like ${weatherMap!["main"]["feels_like"]} °',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      Text(
                                        '${forcastMap!["list"][0]["weather"][0]["description"]}',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 5,
                                    right: 5,
                                    top: 15,
                                  ),
                                  height: 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Pressure ${forcastMap!["list"][0]["main"]["pressure"]}',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      Text(
                                        'Humidity ${forcastMap!["list"][0]["main"]["humidity"]}',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      Text(
                                        'Sunrise ${Jiffy("${DateTime.fromMillisecondsSinceEpoch(weatherMap!["sys"]["sunset"] * 1000)}").format("h:mm a")}',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      Text(
                                        'Sunrise ${Jiffy("${DateTime.fromMillisecondsSinceEpoch(weatherMap!["sys"]["sunrise"] * 1000)}").format("h:mm a")}',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: forcastMap!.length,
                    itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.only(right: 10, bottom: 40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.blue.withOpacity(0.4),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${Jiffy("${forcastMap!["list"][index]["dt_txt"]}").format("EEE")} ,${Jiffy("${forcastMap!["list"][index]["dt_txt"]}").format("h:mm")} °',
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                          Image.asset(
                            'img/w5.webp',
                            height: 120,
                          ),
                          Text(
                            '${forcastMap!["list"][index]["main"]["temp_min"]}/${forcastMap!["list"][index]["main"]["temp_max"]} °',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          Text(
                            '${forcastMap!["list"][index]["weather"][0]["description"]}',
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
