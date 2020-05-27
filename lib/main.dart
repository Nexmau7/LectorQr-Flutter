import 'package:flutter/material.dart';
import 'package:lector_qr_googlemaps_sqlite/rsc/pages/home_page.dart';
import 'package:lector_qr_googlemaps_sqlite/rsc/pages/mapa_pages.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        
      ),
      initialRoute: '/',
      routes: {
        '/' : (context)=> HomePage(),
        'mapa' : (context)=> MapaPeges(),
      },
    );
  }
}