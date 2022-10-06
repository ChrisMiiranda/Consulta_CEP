import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/Historico.dart';

class HistoricoBody extends StatefulWidget {
  const HistoricoBody({super.key});

  @override
  _HistoricoBody createState() => _HistoricoBody();
}

class _HistoricoBody extends State<HistoricoBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final historico = ModalRoute.of(context)!.settings.arguments as List<Historico>;

    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.width * 0.11),
          const Text(("Histórico de Pesquisas"),
              textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w300, fontSize: 24, letterSpacing: 1, color: Colors.white, fontFamily: 'FormulaCondensed')),
          SizedBox(height: MediaQuery.of(context).size.width * 0.15),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFF181818),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.7,
            margin: const EdgeInsets.only(left: 25, right: 25),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      _listViewTransacoes(historico, context),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(height: MediaQuery.of(context).size.width * 0.06),
        ],
      ),
    );
  }

  _listViewTransacoes(historico, context) {
    if (historico == null || historico.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.63,
        alignment: Alignment.center,
        child: Text(
          "Nenhum histórico até o momento :)\n\n Faça sua primeira consulta!",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
              fontWeight: FontWeight.w300,
              letterSpacing: .5,
              fontSize: MediaQuery.of(context).size.height * 0.015,
        ),
      ),
      );
    } else {
      int itemCount = historico.length;

      return Container(
        margin: const EdgeInsets.only(top: 30),
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.63,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: itemCount,
          controller: _scrollController,
          itemBuilder: (context, index) {

            Historico h = historico[index];
            return Padding(
              padding: const EdgeInsets.only(right: 15, left: 15, bottom: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        h.cep,
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: .3,
                            fontSize: MediaQuery.of(context).size.height * 0.015,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'N° ${h.numCasa}',
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: .3,
                          fontSize: MediaQuery.of(context).size.height * 0.015,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  _mostraMapa(Uri.parse(h.url))
                  ],
              ),
            );
          },
        ),
      );
    }
  }

  _mostraMapa(Uri url) {
      return Column(
        children: [
          InkWell(
            child: const Text(
                'Ver no Mapa',
                style: TextStyle(
                  color: Color(0xFF00CC4B),
                  fontSize: 10,
                  decoration: TextDecoration.underline,
                  letterSpacing: 1,
                ),
              ),
            onTap: () => {
              _launchUrl(url)
            },
          ),
        ],
      );
    }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}
