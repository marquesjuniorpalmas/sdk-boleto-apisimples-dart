
import 'caixa.dart';
import 'dart:convert';

void main() {
  // Criando uma instância de BoletoCaixa
  Map<String, dynamic> dadosBoleto = {
    'numeroDocumento': '27.030195.10',
    'dataVencimento': '08/04/2024',
    'dataDocumento': '08/04/2024',
    'dataProcessamento': '08/04/2024',
    'valorBoleto': '25000',
    'agencia':'1234',
    'conta':'123',
    'contaDv':'0',
    'contaCedente':'123456',
    'carteira':'CR',
    'nossoNumeroBoleto':'000000019'
  };
  
  // Exibindo detalhes do boleto
  BoletoCaixa boleto = BoletoCaixa.fromJson(dadosBoleto);
  String jsonString = jsonEncode(boleto.retornoBoleto());
  print(jsonString);
}