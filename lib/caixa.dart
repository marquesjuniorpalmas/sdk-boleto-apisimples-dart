class BoletoCaixa {
  late String _numeroDocumento;
  late String _dataVencimento;
  late String _dataDocumento;
  late String _dataProcessamento;
  late dynamic _valorBoleto; 
  late dynamic _agencia;
  late dynamic _conta;
  late dynamic _contaDv;
  late dynamic _contaCedente;
  late String _carteira;
  late dynamic _nossoNumeroBoleto;

  late String _nossoNumeroInicial1 = "000";
  late String _nossoNumeroConst1 = "1";
  late String _nossoNumeroInicial2 = "000";
  late String _nossoNumeroConst2 = "4";
  late dynamic _codigoBanco = "104";
  late dynamic _codigoBancoDv = __geraCodigoBanco(this._codigoBanco);
  late dynamic _numMoeda = '9';
  late dynamic _fatorVencimento = __fatorVencimento(this._dataVencimento);
  late dynamic _contaCedenteDv;
  late dynamic _campoLivre;
  late dynamic _dvCampoLivre;
  late dynamic _campoLivreDv;
  late dynamic _nNum;
  late dynamic _nossoNumero;
  late dynamic _dv;
  late dynamic _linha;
  
  // Construtor
  BoletoCaixa.fromJson(Map<String, dynamic> json) {
    _numeroDocumento = json['numeroDocumento'];
    _dataVencimento = json['dataVencimento'];
    _dataDocumento = json['dataDocumento'];
    _dataProcessamento = json['dataProcessamento'];
    _valorBoleto = __strPadLeft(json['valorBoleto'], 10, '0');
    _agencia = __strPadLeft(json['agencia'], 4, '0');
    _conta = __strPadLeft(json['conta'], 5, '0');
    _contaDv = __strPadLeft(json['contaDv'], 1, '0');
    _contaCedente = __strPadLeft(json['contaCedente'], 6, '0');
    _carteira = json['carteira'];
    _contaCedenteDv = __digitoVerificadorCedente(__strPadLeft(json['contaCedente'], 6, '0'));
    _campoLivre = this._contaCedente.toString()+this._contaCedenteDv.toString()+__strPadLeft(this._nossoNumeroInicial1, 3, '0').toString()+__strPadLeft(this._nossoNumeroConst1, 1, '0').toString()+__strPadLeft(this._nossoNumeroInicial2, 3, '0').toString()+__strPadLeft(this._nossoNumeroConst2, 1, '0').toString()+__strPadLeft(json['nossoNumeroBoleto'], 9, '0').toString();
    _dvCampoLivre = __digitoVerificadorNossoNumero(this._campoLivre);
    _campoLivreDv = this._campoLivre.toString()+this._dvCampoLivre.toString();
    _nNum = __strPadLeft(this._nossoNumeroConst1, 1, '0').toString()+__strPadLeft(this._nossoNumeroConst2, 1, '0').toString()+__strPadLeft(this._nossoNumeroInicial1, 3, '0').toString()+__strPadLeft(this._nossoNumeroInicial2, 3, '0').toString()+__strPadLeft(json['nossoNumeroBoleto'], 9, '0').toString();
    _nossoNumero = this._nNum.toString()+__digitoVerificadorNossoNumero(this._nNum.toString()).toString();
    _dv = __digitoVerificadorBarra(this._codigoBanco.toString()+this._numMoeda.toString()+this._fatorVencimento.toString()+this._valorBoleto.toString()+this._campoLivre.toString()+this._campoLivreDv.toString()).toString();
    _linha = this._codigoBanco.toString()+this._numMoeda.toString()+this._dv.toString()+this._fatorVencimento.toString()+this._valorBoleto.toString()+this._campoLivre.toString()+this._campoLivreDv.toString();
  }
  
  // Getters
  String get numeroDocumento => _numeroDocumento;
  String get dataVencimento => _dataVencimento;
  String get dataDocumento => _dataDocumento;
  String get dataProcessamento => _dataProcessamento;
  dynamic get valorBoleto => _valorBoleto;
  dynamic get agencia => _agencia;
  dynamic get conta => _conta;
  dynamic get contaDv => _contaDv;
  dynamic get contaCedente => _contaCedente;
  String get carteira => _carteira;
  dynamic get nossoNumeroBoleto => _nossoNumeroBoleto;

  set numeroDocumento(String numeroDocumento) => _numeroDocumento = numeroDocumento;
  set dataVencimento(String dataVencimento) => _dataVencimento = dataVencimento;
  set dataDocumento(String dataDocumento) => _dataDocumento = dataDocumento;
  set dataProcessamento(String dataProcessamento) => _dataProcessamento = dataProcessamento;
  set valorBoleto(dynamic valorBoleto) => _valorBoleto = valorBoleto;
  set agencia(dynamic agencia) => _agencia = agencia;
  set conta(dynamic conta) => _conta = conta;
  set contaDv(dynamic contaDv) => _contaDv = contaDv;
  set contaCedente(dynamic contaCedente) => _contaCedente = contaCedente;
  set carteira(String carteira) => _carteira = carteira;
  set nossoNumeroBoleto(dynamic nossoNumeroBoleto) => _nossoNumeroBoleto = nossoNumeroBoleto;

  Map<String, dynamic> retornoBoleto() {
    Map<String, dynamic> arr = {
      'codigo_barras': this._linha.toString(),
      'linha_digitavel': __montaLinhaDigitavel(this._linha.toString()),
      'agencia_codigo': this.agencia,
      'nosso_numero': this._nossoNumero.toString(),
      'codigo_banco': this._codigoBanco.toString(),
    };

    return arr;
  }

  int __modulo11(String num, {int base = 9, int r = 0}) {
    int soma = 0;
    int fator = 2;
    List<int> numeros = List.filled(num.length + 1, 0);
    List<int> parcial = List.filled(num.length + 1, 0);

    for (int i = num.length; i > 0; i--) {
      numeros[i] = int.parse(num.substring(i - 1, i));
      parcial[i] = numeros[i] * fator;
      soma += parcial[i];
      if (fator == base) {
        fator = 1;
      }
      fator++;
    }

    if (r == 0) {
      soma *= 10;
      int digito = soma % 11;
      if (digito == 10) {
        digito = 0;
      }
      return digito;
    } else if (r == 1) {
      int resto = soma % 11;
      return resto;
    }
    return -1; // Retornar um valor padrão se nenhum caso de retorno for atingido
  }

  int __digitoVerificadorBarra(String numero) {
    int resto2 = __modulo11(numero, base: 9, r: 1);
    int dv = (resto2 == 0 || resto2 == 1 || resto2 == 10) ? 1 : 11 - resto2;
    return dv;
  }

  int __digitoVerificadorNossoNumero(String numero) {
    int resto2 = __modulo11(numero, base: 9, r: 1);
    int digito = 11 - resto2;
    int dv = digito == 10 || digito == 11 ? 0 : digito;
    return dv;
  }

  int __digitoVerificadorCedente(String numero) {
    int resto2 = __modulo11(numero, base: 9, r: 1);
    int digito = 11 - resto2;
    if (digito == 10 || digito == 11) digito = 0;
    int dv = digito;
    return dv;
  }

  String __geraCodigoBanco(String numero) {
    String parte1 = numero.substring(0, 3);
    String parte2 = __modulo11(parte1).toString();
    return '$parte1-$parte2';
  }

  int __dateToDays(int year, int month, int day) {
    int century = int.parse(year.toString().substring(0, 2));
    year = int.parse(year.toString().substring(2, 4));

    if (month > 2) {
      month -= 3;
    } else {
      month += 9;
      if (year > 0) {
        year--;
      } else {
        year = 99;
        century--;
      }
    }

    return ((146097 * century ~/ 4) +
            (1461 * year ~/ 4) +
            (153 * month + 2) ~/ 5 +
            day +
            1721119)
        .floor();
  }
  int __fatorVencimento(String data) {
    if (data.isNotEmpty) {
      List<String> dataSplit = data.split("/");
      int ano = int.parse(dataSplit[2]);
      int mes = int.parse(dataSplit[1]);
      int dia = int.parse(dataSplit[0]);
      int referencia = __dateToDays(1997, 10, 07);
      int dataConvertida = __dateToDays(ano, mes, dia);
      int res = (referencia - dataConvertida).abs();
      return res;
    } else {
      return 0000;
    }
  }

  String __strPadLeft(String input, int length, String padChar) {
    if (input.length >= length) {
      return input;
    }
    return padChar * (length - input.length) + input;
  }

  String __montaLinhaDigitavel(String codigo) {

    // 1. Campo - composto pelo código do banco, código da moéda, as cinco primeiras posições
    // do campo livre e DV (modulo10) deste campo
    String p1 = codigo.substring(0, 4);
    String p2 = codigo.substring(19, 24);
    String p3Campo1 = __modulo10("$p1$p2");
    String p4 = "$p1$p2$p3Campo1";
    String p5 = p4.substring(0, 5);
    String p6 = p4.substring(5);
    String campo1 = "$p5.$p6";

    // 2. Campo - composto pelas posiçoes 6 a 15 do campo livre
    // e livre e DV (modulo10) deste campo
    String p1Campo2 = codigo.substring(24, 34);
    String p2Campo2 = __modulo10(p1Campo2);
    String p3Campo2 = "$p1Campo2$p2Campo2";
    String p4Campo2 = p3Campo2.substring(0, 5);
    String p5Campo2 = p3Campo2.substring(5);
    String campo2 = "$p4Campo2.$p5Campo2";

    // 3. Campo composto pelas posicoes 16 a 25 do campo livre
    // e livre e DV (modulo10) deste campo
    String p1Campo3 = codigo.substring(34, 44);
    String p2Campo3 = __modulo10(p1Campo3);
    String p3Campo3 = "$p1Campo3$p2Campo3";
    String p4Campo3 = p3Campo3.substring(0, 5);
    String p5Campo3 = p3Campo3.substring(5);
    String campo3 = "$p4Campo3.$p5Campo3";

    // 4. Campo - digito verificador do codigo de barras
    String campo4 = codigo.substring(4, 5);

    // 5. Campo composto pelo fator vencimento e valor nominal do documento, sem
    // indicacao de zeros a esquerda e sem edicao (sem ponto e virgula). Quando se
    // tratar de valor zerado, a representacao deve ser 000 (tres zeros).
    String p6Campo5 = codigo.substring(5, 9);
    String p7Campo5 = codigo.substring(9, 19);
    String campo5 = "$p6Campo5$p7Campo5";

    return "$campo1 $campo2 $campo3 $campo4 $campo5";
  }

  String __modulo10(String codigo) {
    List<int> multiplicadores = [2, 1];
    int soma = 0;
    for (int i = 0; i < codigo.length; i++) {
      int algarismo = int.parse(codigo.substring(i, i + 1));
      int multiplicador = multiplicadores[i % 2];
      int produto = algarismo * multiplicador;
      soma += produto > 9 ? produto - 9 : produto;
    }
    int resto = soma % 10;
    int dv = resto == 0 ? 0 : 10 - resto;
    return dv.toString();
  }
}
