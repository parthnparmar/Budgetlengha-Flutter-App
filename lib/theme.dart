import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kPrimary = Color(0xFFa83f39);
const kAccent = Color(0xFFff9800);
const kDark = Color(0xFF333333);
const kLight = Color(0xFFf9f9f9);

ThemeData appTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: kPrimary,
      primary: kPrimary,
      secondary: kAccent,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: kDark,
      foregroundColor: Colors.white,
      titleTextStyle: GoogleFonts.josefinSans(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    useMaterial3: true,
  );
}
