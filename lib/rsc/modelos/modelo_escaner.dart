import 'package:latlong/latlong.dart';

class ModeloEscaner {
    int id;
    String tipo;
    String valor;

    ModeloEscaner({
        this.id,
        this.tipo,
        this.valor,
    }){
      if(this.valor.contains('http')){
        this.tipo = 'http';
      }else{
        this.tipo = 'geo';
      }
    }

    factory ModeloEscaner.fromJson(Map<String, dynamic> json) => ModeloEscaner(
        id: json["id"],
        tipo: json["tipo"],
        valor: json["valor"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tipo": tipo,
        "valor": valor,
    };

    LatLng getLatitudLongitud(){
      final lalo = valor.substring(4).split(',');
      final latitud = double.parse(lalo[0]);
      final longitud = double.parse(lalo[1]);

      return LatLng(latitud,longitud);
    }
}
