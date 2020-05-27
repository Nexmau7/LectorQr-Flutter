
import 'dart:async';

import 'package:lector_qr_googlemaps_sqlite/rsc/modelos/modelo_escaner.dart';

class Validador{

  final validarGeo = StreamTransformer<List<ModeloEscaner>,List<ModeloEscaner>>.fromHandlers(
    handleData: (data, sink) {
      final escanerGeo = data.where((element) => element.tipo == 'geo').toList();
      sink.add(escanerGeo);
    },
  );

  final validarHttp = StreamTransformer<List<ModeloEscaner>,List<ModeloEscaner>>.fromHandlers(
    handleData: (data, sink) {
      final escanerHttp = data.where((element) => element.tipo == 'http').toList();
      sink.add(escanerHttp);
    },
  );
  

}