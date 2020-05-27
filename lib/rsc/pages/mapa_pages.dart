import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:lector_qr_googlemaps_sqlite/rsc/modelos/modelo_escaner.dart';

class MapaPeges extends StatefulWidget {
  const MapaPeges({Key key}) : super(key: key);

  @override
  _MapaPegesState createState() => _MapaPegesState();
}

class _MapaPegesState extends State<MapaPeges> {
  String tipoMapa = 'streets';

  //Controlador del Mapa
  final _mapCtrl = MapController();

  @override
  Widget build(BuildContext context) {
    final ModeloEscaner escaner = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              _mapCtrl.move(escaner.getLatitudLongitud(), 15.0);
            },
          ),
        ],
      ),
      body: _crearFlutterMap(escaner),
      floatingActionButton: _botonCambiaEstiloMapa(context),
    );
  }

  _botonCambiaEstiloMapa(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        if (tipoMapa == 'streets') {
          tipoMapa = 'dark';
        } else if (tipoMapa == 'dark') {
          tipoMapa = 'light';
        } else if (tipoMapa == 'light') {
          tipoMapa = 'outdoors';
        } else if (tipoMapa == 'outdoors') {
          tipoMapa = 'satellite';
        } else {
          tipoMapa = 'streets';
        }
        setState(() {});
      },
    );
  }

  Widget _crearFlutterMap(ModeloEscaner escaner) {
    return FlutterMap(
      mapController: _mapCtrl,
      options: MapOptions(
        center: escaner.getLatitudLongitud(),
        zoom: 15.0,
      ),
      layers: [
        _crearMapa(),
        _crearMarcador(escaner),
      ],
    );
  }

  _crearMapa() {
    return TileLayerOptions(
        urlTemplate: 'https://api.mapbox.com/v4/'
            '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
        additionalOptions: {
          'accessToken':
              'pk.eyJ1Ijoia2xlcml0aCIsImEiOiJjanY2MjF4NGIwMG9nM3lvMnN3ZDM1dWE5In0.0SfmUpbW6UFj7ZnRdRyNAw',
          'id': 'mapbox.$tipoMapa',
        });
  }

  _crearMarcador(ModeloEscaner escaner) {
    return MarkerLayerOptions(markers: [
      Marker(
        height: 125.0,
        width: 125.0,
        point: escaner.getLatitudLongitud(),
        builder: (context) => Container(
          child: Icon(
            Icons.location_on,
            color: Theme.of(context).primaryColor,
            size: 70.0,
          ),
        ),
      )
    ]);
  }
}
