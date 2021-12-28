import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/Home.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      textTheme: GoogleFonts.neutonTextTheme(),
    ),
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}
