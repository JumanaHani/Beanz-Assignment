import 'package:beanz_assessment/core/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;


class AppTheme {
  static String get defaultFontFamily => "GelixMedium";

  static double get smallFontSize =>
      ui.PlatformDispatcher.instance.textScaleFactor * 12;
  static double get mediumFontSize =>
      ui.PlatformDispatcher.instance.textScaleFactor * 14;
  static double get largeFontSize =>
      ui.PlatformDispatcher.instance.textScaleFactor * 18;

  static ThemeData get defaultTheme => ThemeData(
        datePickerTheme: DatePickerThemeData(
            headerHeadlineStyle: TextStyle(
              fontSize: mediumFontSize,
              fontFamily: defaultFontFamily,
              color: fontColor,
            ),
            weekdayStyle: TextStyle(
              fontSize: mediumFontSize,
              fontFamily: defaultFontFamily,
              color: fontColor,
            ),
            dayStyle: TextStyle(
              fontSize: mediumFontSize,
              fontFamily: defaultFontFamily,
              color: fontColor,
            ),
            headerHelpStyle: TextStyle(
              fontSize: mediumFontSize,
              fontFamily: defaultFontFamily,
              color: fontColor,
            )),
        primarySwatch: Colors.blue,
        fontFamily: defaultFontFamily,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
          accentColor: primaryColor,
          backgroundColor: whiteColor,
        ),
        scaffoldBackgroundColor: whiteColor,
        dividerColor: greyColor!,
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        dividerTheme: DividerThemeData(
          thickness: 1,
          color: greyColor,
        ),
        textTheme: TextTheme(
          titleMedium: TextStyle(
            fontFamily: defaultFontFamily,
            fontSize: mediumFontSize,
            color: fontColor,
          ),
          bodyMedium: TextStyle(
            fontFamily: defaultFontFamily,
            fontSize: mediumFontSize,
            color: fontColor,
          ),
          bodyLarge: TextStyle(
            fontFamily: defaultFontFamily,
            fontSize: largeFontSize,
            color: fontColor,
          ),
        ),
        tabBarTheme: TabBarTheme(
          labelPadding: EdgeInsets.zero,
          indicatorColor: secondaryColor,
          labelColor: secondaryColor,
          unselectedLabelColor: blackColor,
          labelStyle: TextStyle(
            fontFamily: defaultFontFamily,
            fontSize: mediumFontSize,
            color: fontColor,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: defaultFontFamily,
            fontSize: mediumFontSize,
            color: fontColor,
          ),
        ),
        appBarTheme: AppBarTheme(
            iconTheme: const IconThemeData(color: blackColor),
            centerTitle: true,
            elevation: 0,
            titleTextStyle: TextStyle(
                fontFamily: defaultFontFamily,
                fontSize: largeFontSize,
                color: blackColor,
                fontWeight: FontWeight.bold)),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: greyColor, width: 0.7),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: greyColor, width: 0.7),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: greyColor, width: 0.7),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: greyColor, width: 0.7),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: errorColor, width: 0.7),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: errorColor, width: 0.7),
          ),
          filled: true,
          labelStyle: TextStyle(fontSize: mediumFontSize, color: fontColor),
          hintStyle:
              TextStyle(fontSize: mediumFontSize, color: greyColor),
          errorStyle: TextStyle(fontSize: mediumFontSize, color: errorColor),
          fillColor: greyColor,
          alignLabelWithHint: true,
          contentPadding: const EdgeInsets.all(8.0),
          floatingLabelStyle: const TextStyle(color: secondaryColor),
        ),
        listTileTheme: ListTileThemeData(
          titleTextStyle: TextStyle(
            fontFamily: defaultFontFamily,
            fontSize: mediumFontSize,
            color: fontColor,
          ),
          subtitleTextStyle: TextStyle(
            fontFamily: defaultFontFamily,
            fontSize: smallFontSize,
            color: fontColor,
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: greyColor,
            selectionColor: secondaryColor,
            selectionHandleColor: secondaryColor),
      );
}
