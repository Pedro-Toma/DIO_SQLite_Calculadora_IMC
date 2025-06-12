import 'dart:convert';
import 'dart:io';

class ConsoleUtils {

  static String lerString(){
    return stdin.readLineSync(encoding: utf8) ?? "";
  }

  static String lerStringComTexto(String texto){
    stdout.write(texto);
    String nome = lerString();
    if (nome == ""){
      return "Usuário Anônimo";
    }
    return nome;
  }

  static double? lerDoubleComTexto(String texto, String valorSaida, String tipo){
    stdout.write(texto);
    var value = "";
    do {
      value = lerString();
      try {
        if (value == valorSaida){
          return null;
        }
        return double.parse(value);
      } catch (e){
        print("Erro ao converter entrada para número decimal!");
        stdout.write("Digite outro valor para $tipo ou 'S' para sair: ");
      }
    } while(true);
  }

}