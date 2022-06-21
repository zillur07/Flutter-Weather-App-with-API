// import 'dart:convert';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:jiffy/jiffy.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:geolocator/geolocator.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }

//     position = await Geolocator.getCurrentPosition();
//     setState(() {
//       latitude = position.latitude;
//       longitude = position.longitude;
//     });
//     ////
//     fetchWeather();
//     /////
//     print('my latitude is $latitude, and longitude is $longitude');
//   }

//   late Position position;
//   double? latitude;
//   double? longitude;

//   fetchWeather() async {
//     var weatherResponce = await http.get(
//       Uri.parse(
//           'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=261c3b80023491fad5250970cf0e9dbb'),
//     );

//     var forcastResponce = await http.get(
//       Uri.parse(
//           'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=metric&appid=d934c6303bb835f2480c9774e5e3c7ca'),
//     );

//     setState(() {
//       weatherMap = Map<String, dynamic>.from(jsonDecode(weatherResponce.body));
//       forcastMap = Map<String, dynamic>.from(jsonDecode(forcastResponce.body));
//     });

//     print(weatherResponce.body);
//     print(forcastResponce.body);
//   }

//   Map<String, dynamic>? weatherMap;
//   Map<String, dynamic>? forcastMap;

//   @override
//   void initState() {
//     _determinePosition();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.black87,

//         body: forcastMap != null
//             ? Container(
//                 width: double.infinity,
//                 height: double.infinity,
//                 padding: EdgeInsets.all(20),
//                 child: Column(
//                   children: [
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: Column(
//                         children: [
//                           Text(
//                             '${Jiffy('${forcastMap!["list"][0]["dt_txt"]}').format('MMM do yy')} , ${Jiffy('${forcastMap!["list"][0]["dt_txt"]}').format('hh:mm a')}',
//                             style: TextStyle(
//                               fontSize: 17,
//                               color: Colors.white,
//                             ),
//                           ),
//                           Text(
//                             '${weatherMap!["name"]}',
//                             style: TextStyle(
//                               fontSize: 17,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Center(
//                       child: Column(
//                         children: [
//                           Image.asset(
//                             'img/Weather-icon.png',
//                             height: 100,
//                             fit: BoxFit.cover,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Text(
//                       '${forcastMap!["list"][0]["main"]["temp"]} °',
//                       style: GoogleFonts.angkor(
//                         textStyle: Theme.of(context).textTheme.headline4,
//                         fontSize: 42,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Container(
//                       alignment: Alignment.centerLeft,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Feels like ${weatherMap!["main"]["feels_like"]} °',
//                             style: TextStyle(fontSize: 16, color: Colors.white),
//                           ),
//                           Text(
//                             '${forcastMap!["list"][0]["weather"][0]["description"]}',
//                             style: TextStyle(fontSize: 16, color: Colors.white),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Center(
//                       child: Row(
//                         children: [
//                           Text(
//                             'Pressure ${forcastMap!["list"][0]["main"]["pressure"]}',
//                             style: TextStyle(fontSize: 16, color: Colors.white),
//                           ),
//                           SizedBox(
//                             width: 15,
//                           ),
//                           Text(
//                             'Humidity ${forcastMap!["list"][0]["main"]["humidity"]}',
//                             style: TextStyle(fontSize: 16, color: Colors.white),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Text(
//                       'Sunrise ${Jiffy("${DateTime.fromMillisecondsSinceEpoch(weatherMap!["sys"]["sunset"] * 1000)}").format("h:mm:a")}, Sunrise ${Jiffy("${DateTime.fromMillisecondsSinceEpoch(weatherMap!["sys"]["sunrise"] * 1000)}").format("h:mm a")}',
//                       style: TextStyle(fontSize: 16, color: Colors.white),
//                     ),
//                     Text(
//                       'Sunset 9:29 AM',
//                       style: TextStyle(fontSize: 16, color: Colors.white),
//                     ),
//                   ],
//                 ),
//               )
//             : Center(child: CircularProgressIndicator()),
//         // : Center(child: CircularProgressIndicator()),
//       ),
//     );
//   }
// }
