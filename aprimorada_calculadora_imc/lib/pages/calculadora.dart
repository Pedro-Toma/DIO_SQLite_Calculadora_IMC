import 'package:aprimorada_calculadora_imc/repository/registros_repository.dart';
import 'package:flutter/material.dart';

import '../models/imc_model.dart';

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {

  RegistrosRepository registrosRepository = RegistrosRepository();

  var pesoController = TextEditingController();
  var alturaController = TextEditingController();
  var _registros = <IMCModel>[];

  @override
  void initState(){
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    _registros = await registrosRepository.obterRegistros();
    setState(() {});
  }

  void adicionar(double peso, double altura) async {
    double imc = IMCModel.calcularIMC(peso, altura);
    String classificacao = IMCModel.calcularClassificacao(imc);
    String data = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    IMCModel calculo = IMCModel(0, peso, altura, imc, classificacao, data);
    await registrosRepository.salvar(calculo);
    await carregarDados();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            pesoController.text = "";
            alturaController.text = "";
            showDialog(
              context: context, 
              builder: (BuildContext bc) {
                return AlertDialog(
                  title: Text("Insira seus dados",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  content: Wrap(
                    children: [
                      Text("Peso (em kg)",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      TextField(
                        controller: pesoController,
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      Text("Altura (em m)",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      TextField(
                        controller: alturaController,
                      )
                    ]
                  ),
                  actions: [
                    TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text("Cancelar",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        )
                      )
                    ),
                    TextButton(
                      onPressed: () {
                        double? pesoDouble = double.tryParse(pesoController.text);
                        double? alturaDouble = double.tryParse(alturaController.text);
                        
                        String mensagemErro;

                        pesoDouble == null && alturaDouble == null ? 
                          mensagemErro = "Peso e altura inválidos!" :
                          pesoDouble == null ? 
                            mensagemErro = "Peso Inválido!" :
                            mensagemErro = "Altura Inválida!"
                          ;

                        if (pesoDouble == null || alturaDouble == null){
                          showDialog(
                            context: context, 
                            builder: (BuildContext bc) {
                              return AlertDialog(
                                title: Text("ERRO!",
                                  style: TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                                content: Text(mensagemErro,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Ok",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      )
                                    )
                                  )
                                ]
                              );
                            }
                          );
                        } else {
                          adicionar(pesoDouble, alturaDouble);
                          Navigator.pop(context);
                        }
                      },
                      child: Text("Calcular",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        )
                      )
                    )
                  ],
                );
              }
            );
          }
        ),
        body: Container(
          color: const Color.fromARGB(255, 169, 241, 251),
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
          child: Column(
            children: [
              Text("Calculadora de IMC",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700
                )
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: _registros.length,
                  itemBuilder: (BuildContext bd, int index) {
                    var dado = _registros[index];
                    return Dismissible(
                      onDismissed: (DismissDirection dismissDirection) async {
                        registrosRepository.remover(dado.id);
                        await carregarDados();
                        setState(() {});
                      },
                      key: Key(dado.id.toString()),
                      child: ListTile(
                        title: Text("IMC: ${dado.imc.toStringAsFixed(2)} | ${dado.classificacao}",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700
                          )
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("Peso: ${dado.peso} kg",
                                  style: TextStyle(
                                    fontSize: 20,
                                  )
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Altura: ${dado.altura} m",
                                  style: TextStyle(
                                    fontSize: 20,
                                  )
                                ),
                              ],
                            ),
                            Text(dado.data,
                              style: TextStyle(
                                fontSize: 20,
                              )
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(thickness: 1, color: Colors.black),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}