import 'package:flutter/material.dart';

// light
ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: Theme.of(context).cardColor,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      // centerTitle: true,
      backgroundColor: Colors.white,
      titleTextStyle:
          TextStyle(color: Colors.black, fontFamily: 'Lato', fontSize: 20),
      iconTheme: IconThemeData(color: Colors.black),
    ),
    colorScheme: const ColorScheme.light(
      primary: Colors.black,
    ),
    textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Lato'),
    tabBarTheme: const TabBarTheme(labelColor: Colors.black),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 72,
      labelTextStyle:
          MaterialStateProperty.all(Theme.of(context).textTheme.labelLarge),
    ),
  );
}

// dark
ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      // centerTitle: true,
    ),
    colorScheme: const ColorScheme.dark(primary: Colors.white),
    textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Lato'),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 72,
      labelTextStyle: MaterialStateProperty.all(Theme.of(context)
          .textTheme
          .labelLarge!
          .copyWith(color: Colors.white)),
    ),
  );
}
