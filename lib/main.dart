import 'package:consulta_cep/screens/consulta_cep/cep_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Consulta CEP',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF503CC8),
        ),
        // primarySwatch: Color(0xFF00BCD4),
      ),
      home: CepScreen(),
    );
  }
}