import 'package:flutter/material.dart';
<<<<<<< Updated upstream
// import 'package:flutter_downloader/flutter_downloader.dart';
=======
import 'package:flutter_downloader/flutter_downloader.dart';
>>>>>>> Stashed changes
import 'package:mwamba_app/constants.dart';
import 'package:mwamba_app/screens/product/products_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

<<<<<<< Updated upstream
import 'screens/details/components/body.dart';

void main() async {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => Counter())],
    child: MyApp(),
  ));
=======

void main() async {
  
  runApp(MyApp());
>>>>>>> Stashed changes
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Furniture app',
      theme: ThemeData(
        // We set Poppins as our default font
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        primaryColor: kPrimaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: kPrimaryColor),
      ),
      home: ProductsScreen(),
    );
  }
}
