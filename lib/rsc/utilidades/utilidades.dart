import 'package:lector_qr_googlemaps_sqlite/rsc/modelos/modelo_escaner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

lanzarNavegador(ModeloEscaner escaner, BuildContext context) async {
  if (escaner.tipo == 'http') {
    if (await canLaunch(escaner.valor)) {
      await launch(escaner.valor);
    } else {
      throw 'Could not launch ${escaner.valor}';
    }
  }else{
    Navigator.pushNamed(context, 'mapa',arguments: escaner);
  }
}
