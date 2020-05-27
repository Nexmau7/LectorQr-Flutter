import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lector_qr_googlemaps_sqlite/rsc/bloc/patron_bloc.dart';
import 'package:lector_qr_googlemaps_sqlite/rsc/pages/lista_direcciones.dart';
import 'package:lector_qr_googlemaps_sqlite/rsc/pages/lista_mapas.dart';
import 'package:lector_qr_googlemaps_sqlite/rsc/providers/base_de_datos_provider.dart';
import 'package:lector_qr_googlemaps_sqlite/rsc/utilidades/utilidades.dart'
    as utils;

import 'package:qrscan/qrscan.dart' as scanner;

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final block = PatronBloc();
  int seleccionado = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escaner QR'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: block.eliminaTodoslosDatos)
        ],
      ),
      body: _seleccionaPagina(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.filter_center_focus),
        onPressed: ()=>_lectorQR(context),
      ),
      bottomNavigationBar: _menuBajo(),
    );
  }

  Widget _menuBajo() {
    return BottomNavigationBar(
      currentIndex: seleccionado,
      onTap: (index) {
        setState(() {
          seleccionado = index;
        });
      },
      items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.map,
            ),
            title: Text('Mapas')),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.local_airport,
            ),
            title: Text('Direcciones')),
      ],
    );
  }

  Widget _seleccionaPagina() {
    if (seleccionado == 0) {
      return ListaMapas();
    } else {
      return ListaDirecciones();
    }
  }

  _lectorQR(BuildContext context) async {
    String datoEscaneado = '';

    try {
      datoEscaneado = await scanner.scan();
    } catch (e) {
      datoEscaneado = e.toString();
    }

    if (datoEscaneado != null) {
      final dato = ModeloEscaner(valor: datoEscaneado);
      block.agregarInformacionDB(dato);

      if (Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 750));
        utils.lanzarNavegador(dato,context);
      } else {
        utils.lanzarNavegador(dato,context);
      }
    }
  }
}
