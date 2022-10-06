import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:consulta_cep/components/alert.dart';
import 'package:consulta_cep/components/input_decoration_custom.dart';
import 'package:consulta_cep/components/input_style.dart';
import 'package:consulta_cep/models/Historico.dart';
import 'package:consulta_cep/screens/historico/historico_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:search_cep/search_cep.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CepBody extends StatefulWidget {
  const CepBody({super.key});

  @override
  _CepBodyState createState() => _CepBodyState();
}

class _CepBodyState extends State<CepBody> {
  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];
  final _cep = TextEditingController();
  final _endereco = TextEditingController();
  final _numCasa = TextEditingController();
  final _complemento = TextEditingController();
  final _bairro = TextEditingController();
  final _cidade = TextEditingController();
  final _estado = TextEditingController();
  final List<Historico>? ceps = [];

  String? cep;
  String? complemento;
  String? numCasa;
  String? endereco;
  String? bairro;
  String? cidade;
  String? estado;
  Future? _futureCep;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKeys[0],
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background-map.png"),
            opacity: .5,
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                const Text('Seja Bem Vindo\nCarlos!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        letterSpacing: .5,
                        fontWeight: FontWeight.w300)),
                SizedBox(height: MediaQuery.of(context).size.height * 0.16),
                SizedBox(
                  width: 290,
                  child: buildCEPFormField(),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                SizedBox(
                  width: 290,
                  height: MediaQuery.of(context).size.height * 0.056,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF503CC8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                    ),
                    onPressed: () {
                      if (formKeys[0].currentState!.validate()) {
                        _futureCep = _buscarCep();
                        showModalBottomSheet<void>(
                          isScrollControlled: true,
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return _listCamposEndereco();
                          },
                        );
                      }
                    },
                    child: const Text(
                      'Confirmar',
                      style: TextStyle(
                        fontFamily: "FormulaCondensed",
                        letterSpacing: 1.5,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: SizedBox(
                    child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                          side: const BorderSide(
                              color: Color(0xFF503CC8), width: 2),
                        ),
                        color: Colors.transparent,
                        onPressed: () {
                          Navigator.pushNamed(context, HistoricoScreen.routeName,
                              arguments: ceps);
                        },
                        child: const Text(
                          'Histórico de Pesquisas',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: "FormulaCondensed",
                              letterSpacing: 1.5),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildCEPFormField() {
    return TextFormField(
      autofocus: false,
      scrollPadding: const EdgeInsets.all(100),
      textInputAction: TextInputAction.done,
      controller: _cep,
      keyboardType:
          Platform.isAndroid ? TextInputType.number : TextInputType.datetime,
      style: const CamposInput(textColor: Colors.white),
      decoration: const CustomInputDecoration("Digite o cep",
          prefixIcon: Icon(Icons.location_on_outlined, color: Colors.white)),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CepInputFormatter(),
      ],
      onChanged: (newValue) => cep = newValue,
      validator: (value) {
        if (value!.isEmpty || value.length < 10) {
          String text = "Cep inválido";
          return text;
        } else {
          return null;
        }
      },
    );
  }

  TextFormField buildEnderecoFormField(endereco) {
    _endereco.text = endereco;
    return TextFormField(
      readOnly: true,
      controller: _endereco,
      keyboardType: TextInputType.text,
      style: const CamposInput(textColor: Colors.white),
      decoration:
          const CustomInputDecoration("Endereço", borderColor: Colors.white),
      onChanged: (newValue) => endereco = newValue,
      validator: (value) {
        if (value!.isEmpty) {
          String text = "Endereço não pode ser vázio";
          return text;
        } else {
          return null;
        }
      },
    );
  }

  TextFormField buildNumCasaFormField(endereco) {
    return TextFormField(
      autofocus: false,
      controller: _numCasa,
      textInputAction: TextInputAction.next,
      keyboardType:
          (Platform.isIOS) ? TextInputType.datetime : TextInputType.number,
      onChanged: (newValue) => numCasa = newValue,
      validator: (value) {
        if (value!.isEmpty) {
          String text = "Número não pode ser vázio";
          return text;
        } else {
          return null;
        }
      },
      style: const CamposInput(textColor: Colors.white),
      decoration: const CustomInputDecoration("Nº", borderColor: Colors.white),
    );
  }

  TextFormField buildComplementoFormField() {
    return TextFormField(
      textInputAction: TextInputAction.go,
      controller: _complemento,
      keyboardType: TextInputType.text,
      onChanged: (newValue) => complemento = newValue,
      style: const CamposInput(textColor: Colors.white),
      decoration:
          const CustomInputDecoration("Complemento", borderColor: Colors.white),
    );
  }

  TextFormField buildBairroFormField(bairro) {
    _bairro.text = bairro ?? "";
    return TextFormField(
      readOnly: true,
      controller: _bairro,
      keyboardType: TextInputType.text,
      style: const CamposInput(textColor: Colors.white),
      decoration:
          const CustomInputDecoration("Bairro", borderColor: Colors.white),
      onChanged: (newValue) => bairro = newValue,
      validator: (value) {
        if (value!.isEmpty) {
          String text = "Bairro não pode ser vázio";
          return text;
        } else {
          return null;
        }
      },
    );
  }

  TextFormField buildCidadeFormField(cidade) {
    _cidade.text = cidade ?? "";
    return TextFormField(
      readOnly: true,
      controller: _cidade,
      keyboardType: TextInputType.text,
      style: const CamposInput(textColor: Colors.white),
      decoration:
          const CustomInputDecoration("Cidade", borderColor: Colors.white),
      onChanged: (newValue) => cidade = newValue,
      validator: (value) {
        if (value!.isEmpty) {
          String text = "Cidade não pode ser vázio";
          return text;
        } else {
          return null;
        }
      },
    );
  }

  TextFormField buildEstadoFormField(uf) {
    _estado.text = uf ?? "";
    return TextFormField(
      readOnly: true,
      controller: _estado,
      style: const CamposInput(textColor: Colors.white),
      decoration:
          const CustomInputDecoration("Estado", borderColor: Colors.white),
      onChanged: (newValue) => uf = newValue,
      validator: (value) {
        if (value!.isEmpty) {
          String text = "Estado não pode ser vázio";
          return text;
        } else {
          return null;
        }
      },
    );
  }

  _listCamposEndereco() {
    return FutureBuilder(
      future: _futureCep,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            width: 100,
            height: 350,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.0,
            ),
          );
        }
        var cepInfos = snapshot.data;
        if(cepInfos == "CEP inexistente.") {
          Future.delayed(Duration.zero, () {
            Navigator.pop(context);
            return alertOK(context, "Erro ao buscar CEP. Certifique-se de que você digitou corretamente.");
          });
          return Container();
        }
        return Form(
          key: formKeys[1],
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
                height: 350,
                decoration: const BoxDecoration(
                  color: Color(0xFF181818),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40.0),
                      bottomRight: Radius.circular(0),
                      topLeft: Radius.circular(40.0),
                      bottomLeft: Radius.circular(0)),
                ),
                child: Column(
                  children: [
                    SingleChildScrollView(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.40,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                "Informações do cep",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(
                                  top: 10, left: 30, right: 30),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 40),
                                          child: buildEnderecoFormField(
                                              cepInfos?.logradouro),
                                        ),
                                      ),
                                      Expanded(
                                        child: buildNumCasaFormField(
                                            cepInfos?.logradouro),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 40),
                                          child: buildComplementoFormField(),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: buildBairroFormField(
                                            cepInfos?.bairro),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 40),
                                          child: buildCidadeFormField(
                                              cepInfos?.localidade),
                                        ),
                                      ),
                                      Expanded(
                                        child:
                                            buildEstadoFormField(cepInfos?.uf),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 15, left: 30),
                                    child: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(35),
                                          side: const BorderSide(
                                              color: Color(0xFF503CC8),
                                              width: 2),
                                        ),
                                        color: Colors.transparent,
                                        onPressed: () => {
                                              Navigator.pop(context),
                                              _cep.text = '',
                                              _numCasa.text = '',
                                            },
                                        child: const Text(
                                          'Voltar',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontFamily: "FormulaCondensed",
                                              letterSpacing: 1),
                                        )),
                                  ),
                                  MaterialButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(35),
                                        side: const BorderSide(
                                            color: Color(0xFF503CC8), width: 2),
                                      ),
                                      color: const Color(0xFF503CC8),
                                      disabledColor: const Color(0xFF503CC8),
                                      child: const Text(
                                        'Visualizar no mapa',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontFamily: "FormulaCondensed",
                                            letterSpacing: 1),
                                      ),
                                      onPressed: () {
                                        String url =
                                            ('https://www.google.com.br/maps/place/' +
                                                    cepInfos?.logradouro
                                                        .replaceAll(' ', '+') +
                                                    ',+' +
                                                    _numCasa.text +
                                                    '+-+' +
                                                    cepInfos?.bairro
                                                        .replaceAll(' ', '+') +
                                                    '+-+' +
                                                    cepInfos?.localidade
                                                        .replaceAll(' ', '+') +
                                                    '+-+' +
                                                    cepInfos?.uf +
                                                    '+-+' +
                                                    cep!.replaceAll('.', ''))
                                                .trim();
                                        saveCepListValue(url);
                                        _launchUrl(Uri.parse(url));
                                      }),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
                  ],
                )),
          ),
        );
      },
    );
  }

  Future _buscarCep() async {
    final viaCepSearchCep = ViaCepSearchCep();
    final infoCepJSON = await viaCepSearchCep.searchInfoByCep(
        cep: cep!.replaceAll('.', '').replaceAll('-', ''));
    if(infoCepJSON.fold((_) => null, (data) => data) == null) {
      return infoCepJSON.fold((l) => l.errorMessage, (r) => r);
    } else {
      return infoCepJSON.fold((_) => null, (data) => data);
    }
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  saveCepListValue(url) {
    ceps?.add(Historico(_cep.text, _endereco.text, _numCasa.text, _bairro.text,
        _cidade.text, _estado.text, url));
  }
}
