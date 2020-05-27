import 'package:flutter/material.dart';
import 'package:lector_qr_googlemaps_sqlite/rsc/bloc/patron_bloc.dart';
import 'package:lector_qr_googlemaps_sqlite/rsc/providers/base_de_datos_provider.dart';
import 'package:lector_qr_googlemaps_sqlite/rsc/utilidades/utilidades.dart'
    as utils;

class ListaDirecciones extends StatelessWidget {
  const ListaDirecciones({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final block = PatronBloc();
    block.obtenerDatos();
    return StreamBuilder(
      stream: block.streamCtrPaginasWeb,
      builder:
          (BuildContext context, AsyncSnapshot<List<ModeloEscaner>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final escaner = snapshot.data;

        if (escaner.length == 0) {
          return Center(
            child: Text('No hay registro de Datos'),
          );
        }

        return ListView.builder(
          itemCount: escaner.length,
          itemBuilder: (context, i) {
            return Dismissible(
              key: UniqueKey(),
              background: Container(color: Colors.red),
              onDismissed: (direction) {
                block.eliminaUnRegistro(escaner[i].id);
              },
              child: ListTile(
                leading: Icon(Icons.cloud_queue,
                    color: Theme.of(context).primaryColor),
                title: Text(escaner[i].valor),
                subtitle: Text('${escaner[i].id}'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () => utils.lanzarNavegador(escaner[i], context),
              ),
            );
          },
        );
      },
    );
  }
}
