import 'dart:io';
import 'package:path/path.dart'; //Importa la funcion join!
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

//Use export para que no tenga que importarlo en otros lados!
export 'package:lector_qr_googlemaps_sqlite/rsc/modelos/modelo_escaner.dart';
import 'package:lector_qr_googlemaps_sqlite/rsc/modelos/modelo_escaner.dart';

//CRUD BASE DE DATOS
class DBProvider {
  static Database _database;

//PATRON SINGLETON
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database> get dameDataBase async {
    if (_database != null) return _database;

    _database = await crearDataBase();

    return _database;
  }

  crearDataBase() async {
    Directory direccionDocumento = await getApplicationDocumentsDirectory();
    //path = recorrido o camino
    final recorrido = join(direccionDocumento.path, 'BaseDatosEscaner.db');
    //el join se usa para indicar donde se guardara la base datos.

    return await openDatabase(recorrido,
        version: 1, onOpen: (db) {}, //no se usa
        onCreate: (Database db, int version) async {
      //Crea la primer Tabla de la base de Datos.
      await db.execute('CREATE TABLE Escaner ('
          ' id INTEGER PRIMARY KEY,'
          ' tipo TEXT,'
          ' valor TEXT'
          ')');
    });
  }

  //INSERTAR REGISTROS O GUARDAR DATOS, las dos formas que se pueden hacer!!!!!!!

  //Forma 1
  agregarDatosFormaEscrita(ModeloEscaner agregaDato) async {
    //Esta funcion es un poco mas dificil porque se tiene que escribir con cuidado y en detalle las sentencia SQL
    final db = await dameDataBase; //Pide base de datos como comprobacion

    final resultadoSql = await db.rawInsert(
        //rawInset se tiene que agregar los datos en sentencia sql.
        "INSERT INTO Escaner (id, tipo, valor) "
        "VALUES ( ${agregaDato.id}, '${agregaDato.tipo}', '${agregaDato.valor}' )"); //Tipo y valor se manda con comillas simples porque son STRING
    return resultadoSql;
  }

  //Forma 2
  agregarDatosFormaAutomatica(ModeloEscaner agregaDato) async {
    //Esta funcion es relativamente facil porque solo agregas los datos en una Funcion.
    final db = await dameDataBase; //Pide base de datos como comprobacion.

    final resultadoSql = await db.insert(
        'Escaner', agregaDato.toJson()); //Esto es lo mismo que la Forma 1
    return resultadoSql;
  }

  // LEER O OBTENER INFORMACION - SELECT

  //Obtener datos por id
  Future<ModeloEscaner> getLeerDatosIdEscaner(int id) async {
    final db = await dameDataBase;

    // Asi me mostraria todo el Registro --->>  final resultadoSql = await db.query('Escaner');
    //query regresara una Lista de Maps, adelante se tiene que convertir.
    final resultadoSql = await db.query(
      'Escaner',
      where:
          'id = ?', //El signo de ? siginifica que sera un argumento que se especificara en el whereArgs.
      whereArgs: [id],
    );
    return resultadoSql.isNotEmpty
        ? ModeloEscaner.fromJson(resultadoSql.first)
        : null;
  }

  //Obtener todos los datos
  Future<List<ModeloEscaner>> getLeerTodosRegistros() async {
    final db = await dameDataBase;
    final resultadoSql = await db.query('Escaner');
    //Convertir Lista de Maps
    List<ModeloEscaner> lista = resultadoSql.isNotEmpty
        ? resultadoSql.map((e) => ModeloEscaner.fromJson(e)).toList()
        : [];

    return lista;
  }

  //Obtener todos los datos pero por TIPO! con RawQuery o la Sentencia Sql
  Future<List<ModeloEscaner>> getLeerTodosRegsTipo(String tipo) async {
    final db = await dameDataBase;
    final resultadoSql =
        await db.rawQuery("SELECT * FROM Escaner WHERE tipo='$tipo'");

    //Convertir Lista de Maps
    List<ModeloEscaner> lista = resultadoSql.isNotEmpty
        ? resultadoSql.map((e) => ModeloEscaner.fromJson(e)).toList()
        : [];

    return lista;
  }

  //Actualizar Registro

  Future<int> actualizarRegistro(ModeloEscaner agregaDato) async {
    final db = await dameDataBase;

    //Solo actualizara el Escaner con el que consida con el id que estamos mandando! por eso se necesita el id como argumento
    final respuestaSql = await db.update(
      'Escaner',
      agregaDato.toJson(),
      where: 'id=?',
      whereArgs: [agregaDato.id],
    );

    return respuestaSql;
  }

  //ELIMINAR REGISTROS

  Future<int> eliminarRegistros(int id) async {
    final db = await dameDataBase;

    //Esta Forma Borra todos los datos ----> final res = await db.delete('Escaner');
    final resultadoSql = await db.delete(
      'Escaner',
      where: 'id=?',
      whereArgs: [id],
    );

    return resultadoSql;
  }

  //Eliminar todos los registros.
  Future<int> eliminarTodosRegistros() async {
    final db = await dameDataBase;
    //Esta Forma Borra todos los datos ----> final res = await db.delete('Escaner');
    final resultadoSql = await db.rawDelete(" DELETE FROM Escaner ");
    return resultadoSql;
  }



}
