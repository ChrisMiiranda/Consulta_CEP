import 'package:consulta_cep/screens/consulta_cep/cep_body.dart';
import 'package:flutter/material.dart';

class CepScreen extends StatelessWidget {
  static String routeName = "/nova-forma-pagamento";

  const CepScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultar CEP'),
      ),
      body: const CepBody(),
    );
  }
}