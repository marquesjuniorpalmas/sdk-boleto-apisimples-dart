
import 'bb.dart';
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
    'convenio':'3128557', 
    'contrato':'999999',
    'carteira':'17',
    'formatacaoConvenio':'7', 
    'formatacaoNossoNumero':'2',
    'nossoNumeroBoleto':'31285570000000001',
    'nServico':'21'
  };
  
  // Exibindo detalhes do boleto
  BoletoBB boleto = BoletoBB.fromJson(dadosBoleto);
  String jsonString = jsonEncode(boleto.retornoBoleto());
  print(jsonString);
}