import 'dart:async';

import 'package:lector_qr_googlemaps_sqlite/rsc/bloc/validador_mixin.dart';
import 'package:lector_qr_googlemaps_sqlite/rsc/providers/base_de_datos_provider.dart';

class PatronBloc with Validador{

  //Segunda Forma para Hacer el Singleton
  static final PatronBloc _singleton = PatronBloc._interno();

  factory PatronBloc(){
    return _singleton;
  }

  PatronBloc._interno();


  //Patron Bloc.... StreamController

  StreamController _controller = StreamController<List<ModeloEscaner>>.broadcast();

  //Envia Informacion
  Stream<List<ModeloEscaner>> get streamCtrMapas => _controller.stream.transform(validarGeo);
  Stream<List<ModeloEscaner>> get streamCtrPaginasWeb => _controller.stream.transform(validarHttp);


  cerrarBlock(){
    _controller?.close();
  }

  //Eventos del StreamController, (Todos los Sink a usar)

  agregarInformacionDB(ModeloEscaner agregaDato) async{

    DBProvider.db.agregarDatosFormaEscrita(agregaDato);
    obtenerDatos();

  }

  obtenerDatos() async{

    _controller.sink.add( await DBProvider.db.getLeerTodosRegistros() );

  }

  eliminaUnRegistro(int id)async{

    await DBProvider.db.eliminarRegistros(id);
    obtenerDatos();

  }

  eliminaTodoslosDatos()async{
    
    await DBProvider.db.eliminarTodosRegistros();
    obtenerDatos();

  }
 
}