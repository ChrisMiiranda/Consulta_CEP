import 'package:consulta_cep/screens/historico/historico_body.dart';
import 'package:flutter/material.dart';

class HistoricoScreen extends StatelessWidget {
  static String routeName = "/historico";

  const HistoricoScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: const Text("Voltar", style: TextStyle(color: Colors.white, fontSize: 14)),
      ),
      body: const HistoricoBody(),
    );
  }
}
