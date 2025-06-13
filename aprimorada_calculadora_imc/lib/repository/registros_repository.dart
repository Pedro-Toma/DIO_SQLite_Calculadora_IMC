import 'package:aprimorada_calculadora_imc/models/imc_model.dart';
import 'package:aprimorada_calculadora_imc/repository/sqlite_database.dart';

class RegistrosRepository {

  Future<List<IMCModel>> obterRegistros() async {

    List<IMCModel> registros = [];

    var db = await SQLiteDatabase().obterDatabase();
    var result = await db.rawQuery(
      'SELECT id, peso, altura, imc, classificacao, data FROM registros'
    );

    for (var registro in result){
      registros.add(IMCModel(
        int.parse(registro['id'].toString()),
        double.parse(registro['peso'].toString()),
        double.parse(registro['altura'].toString()),
        double.parse(registro['imc'].toString()),
        registro['classificacao'].toString(),
        registro['data'].toString()
        )
      );
    }

    return registros;
  }

  Future<void> salvar(IMCModel imcModel) async {
    var db = await SQLiteDatabase().obterDatabase();
    await db.rawInsert('INSERT INTO registros (peso, altura, imc, classificacao, data) values(?,?,?,?,?)',
      [
        imcModel.peso,
        imcModel.altura,
        imcModel.imc,
        imcModel.classificacao,
        imcModel.data
      ]
    );
  }

  Future<void> atualizar(IMCModel imcModel) async {
    var db = await SQLiteDatabase().obterDatabase();
    await db.rawInsert('UPDATE registros SET peso = ?, altura = ?, imc = ? , classificacao = ? , data = ?  WHERE id = ?',
      [
        imcModel.peso,
        imcModel.altura,
        imcModel.imc,
        imcModel.classificacao,
        imcModel.data,
        imcModel.id
      ]
    );
  }  

  Future<void> remover(int id) async {
    var db = await SQLiteDatabase().obterDatabase();
    await db.rawInsert('DELETE FROM registros WHERE id = ?',
      [
        id
      ]
    );
  }  

}