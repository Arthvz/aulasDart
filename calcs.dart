import 'dart:io';
import 'dart:math';

// =============================================================================
// AVALIADOR DE EXPRESSOES MATEMATICAS
// Suporta: + - * / ^ % () e funcoes: sqrt() log() abs() sin() cos() tan()
// =============================================================================

class Avaliador {
  late String _expr;
  late int _pos;

  double avaliar(String expressao) {
    _expr = expressao.replaceAll(' ', '');
    _pos = 0;
    final resultado = _parseExpressao();
    if (_pos != _expr.length) {
      throw FormatException('Expressao invalida perto de: ${_expr.substring(_pos)}');
    }
    return resultado;
  }

  // Nivel 1: + e -
  double _parseExpressao() {
    double valor = _parseTermo();
    while (_pos < _expr.length && (_atual() == '+' || _atual() == '-')) {
      final op = _consumir();
      final direita = _parseTermo();
      valor = op == '+' ? valor + direita : valor - direita;
    }
    return valor;
  }

  // Nivel 2: * / %
  double _parseTermo() {
    double valor = _parsePotencia();
    while (_pos < _expr.length &&
        (_atual() == '*' || _atual() == '/' || _atual() == '%')) {
      final op = _consumir();
      final direita = _parsePotencia();
      if (op == '*') {
        valor = valor * direita;
      } else if (op == '/') {
        if (direita == 0) throw ArgumentError('Divisao por zero.');
        valor = valor / direita;
      } else {
        valor = valor % direita;
      }
    }
    return valor;
  }

  // Nivel 3: ^ (associatividade direita)
  double _parsePotencia() {
    double base = _parseUnario();
    if (_pos < _expr.length && _atual() == '^') {
      _consumir();
      final exp = _parsePotencia();
      base = pow(base, exp).toDouble();
    }
    return base;
  }

  // Nivel 4: unario - e +
  double _parseUnario() {
    if (_pos < _expr.length && _atual() == '-') {
      _consumir();
      return -_parsePrimario();
    }
    if (_pos < _expr.length && _atual() == '+') {
      _consumir();
    }
    return _parsePrimario();
  }

  // Nivel 5: numeros, parenteses, funcoes
  double _parsePrimario() {
    if (_pos < _expr.length && _atual() == '(') {
      _consumir();
      final valor = _parseExpressao();
      if (_pos >= _expr.length || _atual() != ')') {
        throw FormatException('Parentese de fechamento ausente.');
      }
      _consumir();
      return valor;
    }
    if (_pos < _expr.length && _expr[_pos].contains(RegExp(r'[a-zA-Z]'))) {
      return _parseFuncao();
    }
    return _parseNumero();
  }

  double _parseFuncao() {
    final inicio = _pos;
    while (_pos < _expr.length && _expr[_pos].contains(RegExp(r'[a-zA-Z]'))) {
      _pos++;
    }
    final nome = _expr.substring(inicio, _pos);
    if (_pos >= _expr.length || _atual() != '(') {
      throw FormatException('Funcao "$nome" sem parenteses.');
    }
    _consumir();
    final arg = _parseExpressao();
    if (_pos >= _expr.length || _atual() != ')') {
      throw FormatException('Parentese de fechamento ausente em "$nome".');
    }
    _consumir();
    switch (nome.toLowerCase()) {
      case 'sqrt': return sqrt(arg);
      case 'log':  return log(arg);
      case 'abs':  return arg.abs();
      case 'sin':  return sin(arg);
      case 'cos':  return cos(arg);
      case 'tan':  return tan(arg);
      default: throw ArgumentError('Funcao desconhecida: "$nome".');
    }
  }

  double _parseNumero() {
    final inicio = _pos;
    bool temPonto = false;
    while (_pos < _expr.length &&
        (_expr[_pos].contains(RegExp(r'[0-9]')) ||
            (!temPonto && _expr[_pos] == '.'))) {
      if (_expr[_pos] == '.') temPonto = true;
      _pos++;
    }
    if (_pos == inicio) {
      throw FormatException(
          'Caractere inesperado: "${_pos < _expr.length ? _expr[_pos] : "fim da expressao"}"');
    }
    return double.parse(_expr.substring(inicio, _pos));
  }

  String _atual() => _expr[_pos];
  String _consumir() => _expr[_pos++];
}

// =============================================================================
// CALCULADORA UNIVERSAL
// =============================================================================

final Map<String, double Function(List<double>)> operacoes = {
  'soma': (p) {
    _minParams(p, 2, 'soma');
    return p.reduce((a, b) => a + b);
  },
  'subtracao': (p) {
    _minParams(p, 2, 'subtracao');
    return p.reduce((a, b) => a - b);
  },
  'multiplicacao': (p) {
    _minParams(p, 2, 'multiplicacao');
    return p.reduce((a, b) => a * b);
  },
  'divisao': (p) {
    _minParams(p, 2, 'divisao');
    double r = p[0];
    for (int i = 1; i < p.length; i++) {
      if (p[i] == 0) throw ArgumentError('Divisao por zero no parametro ${i + 1}.');
      r /= p[i];
    }
    return r;
  },
  'potencia': (p) {
    _exactParams(p, 2, 'potencia');
    return pow(p[0], p[1]).toDouble();
  },
  'raiz': (p) {
    _exactParams(p, 1, 'raiz');
    if (p[0] < 0) throw ArgumentError('Raiz quadrada de numero negativo.');
    return sqrt(p[0]);
  },
  'modulo': (p) {
    _exactParams(p, 2, 'modulo');
    return p[0] % p[1];
  },
  'media': (p) {
    _minParams(p, 1, 'media');
    return p.reduce((a, b) => a + b) / p.length;
  },
  'maximo': (p) {
    _minParams(p, 1, 'maximo');
    return p.reduce(max);
  },
  'minimo': (p) {
    _minParams(p, 1, 'minimo');
    return p.reduce(min);
  },
  'fatorial': (p) {
    _exactParams(p, 1, 'fatorial');
    int n = p[0].toInt();
    if (n < 0) throw ArgumentError('Fatorial de numero negativo e indefinido.');
    int r = 1;
    for (int i = 2; i <= n; i++) r *= i;
    return r.toDouble();
  },
  'log': (p) {
    _exactParams(p, 1, 'log');
    if (p[0] <= 0) throw ArgumentError('Logaritmo apenas para numeros positivos.');
    return log(p[0]);
  },
};

void _minParams(List<double> p, int min, String nome) {
  if (p.length < min) {
    throw ArgumentError(
        '"$nome" exige ao menos $min parametro(s). Recebeu ${p.length}.');
  }
}

void _exactParams(List<double> p, int qtd, String nome) {
  if (p.length != qtd) {
    throw ArgumentError(
        '"$nome" exige exatamente $qtd parametro(s). Recebeu ${p.length}.');
  }
}

void menuCalculadoraUniversal() {
  _titulo('CALCULADORA UNIVERSAL');
  print('Operacoes disponiveis:');
  for (final f in operacoes.keys) print('  $f');
  print('  expressao');
  print('');
  print('Para operacoes de lista (soma, subtracao, multiplicacao, divisao,');
  print('media, maximo, minimo), informe quantos parametros quiser.');
  print('');

  final avaliador = Avaliador();

  while (true) {
    stdout.write('Funcao (ou "sair"): ');
    final entrada = stdin.readLineSync()?.trim().toLowerCase() ?? '';

    if (entrada == 'sair') {
      print('Voltando ao menu principal.\n');
      break;
    }

    if (entrada == 'expressao') {
      stdout.write('Expressao (ex: 2+3*4, sqrt(16)^2, (10-3)*2): ');
      final linha = stdin.readLineSync()?.trim() ?? '';
      if (linha.isEmpty) { print('Expressao vazia.\n'); continue; }
      try {
        print('Resultado: ${_fmt(avaliador.avaliar(linha))}\n');
      } catch (e) {
        print('Erro: $e\n');
      }
      continue;
    }

    if (!operacoes.containsKey(entrada)) {
      print('Operacao "$entrada" nao encontrada.\n');
      continue;
    }

    stdout.write('Parametros (separados por espaco): ');
    final linha = stdin.readLineSync()?.trim() ?? '';
    final params = <double>[];
    bool erroConversao = false;

    for (final token in linha.split(RegExp(r'\s+'))) {
      if (token.isEmpty) continue;
      final v = double.tryParse(token);
      if (v == null) {
        print('"$token" nao e um numero valido.\n');
        erroConversao = true;
        break;
      }
      params.add(v);
    }
    if (erroConversao) continue;

    try {
      print('Resultado: ${_fmt(operacoes[entrada]!(params))}\n');
    } catch (e) {
      print('Erro: $e\n');
    }
  }
}

// =============================================================================
// CALCULADORA DE RAIZES
// =============================================================================

void menuCalculadoraRaizes() {
  _titulo('CALCULADORA DE RAIZES');
  print('Informe os coeficientes da equacao:');
  print('  1o grau: bx + c = 0        -> dois valores:  b  c');
  print('  2o grau: ax^2 + bx + c = 0 -> tres valores:  a  b  c');
  print('');

  while (true) {
    stdout.write('Coeficientes (ou "sair"): ');
    final linha = stdin.readLineSync()?.trim() ?? '';

    if (linha.toLowerCase() == 'sair') {
      print('Voltando ao menu principal.\n');
      break;
    }

    final tokens =
        linha.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();

    if (tokens.length < 2 || tokens.length > 3) {
      print('Informe 2 ou 3 coeficientes.\n');
      continue;
    }

    final coefs = <double>[];
    bool erro = false;
    for (final t in tokens) {
      final v = double.tryParse(t);
      if (v == null) {
        print('"$t" nao e um numero valido.\n');
        erro = true;
        break;
      }
      coefs.add(v);
    }
    if (erro) continue;

    if (coefs.length == 2) {
      final b = coefs[0], c = coefs[1];
      print('Equacao de 1o grau: ${_fmt(b)}x + ${_fmt(c)} = 0');
      if (b == 0) {
        print(c == 0
            ? 'Equacao identicamente nula (infinitas solucoes).'
            : 'Equacao impossivel (sem solucao).');
      } else {
        print('Raiz: x = ${_fmt(-c / b)}');
      }
    } else {
      final a = coefs[0], b = coefs[1], c = coefs[2];
      print('Equacao de 2o grau: ${_fmt(a)}x^2 + ${_fmt(b)}x + ${_fmt(c)} = 0');
      if (a == 0) {
        print('(a = 0, reduzida a 1o grau)');
        if (b == 0) {
          print(c == 0 ? 'Equacao identicamente nula.' : 'Equacao impossivel.');
        } else {
          print('Raiz: x = ${_fmt(-c / b)}');
        }
      } else {
        final delta = b * b - 4 * a * c;
        print('Delta = ${_fmt(delta)}');
        if (delta > 0) {
          final x1 = (-b + sqrt(delta)) / (2 * a);
          final x2 = (-b - sqrt(delta)) / (2 * a);
          print('Duas raizes reais distintas:');
          print('  x1 = ${_fmt(x1)}');
          print('  x2 = ${_fmt(x2)}');
        } else if (delta == 0) {
          print('Raiz dupla: x = ${_fmt(-b / (2 * a))}');
        } else {
          final real = -b / (2 * a);
          final img  = sqrt(-delta) / (2 * a);
          print('Raizes complexas conjugadas:');
          print('  x1 = ${_fmt(real)} + ${_fmt(img)}i');
          print('  x2 = ${_fmt(real)} - ${_fmt(img)}i');
        }
      }
    }
    print('');
  }
}

// =============================================================================
// MENU PRINCIPAL
// =============================================================================

void main() {
  _titulo('CALCULADORA GERAL');

  while (true) {
    print('1 - Calculadora Universal');
    print('2 - Calculadora de Raizes');
    print('0 - Sair');
    stdout.write('Opcao: ');

    final opcao = stdin.readLineSync()?.trim() ?? '';
    print('');

    switch (opcao) {
      case '1':
        menuCalculadoraUniversal();
        break;
      case '2':
        menuCalculadoraRaizes();
        break;
      case '0':
        print('Encerrando o programa.');
        exit(0);
      default:
        print('Opcao invalida. Digite 1, 2 ou 0.\n');
    }
  }
}

// =============================================================================
// UTILITARIOS
// =============================================================================

void _titulo(String texto) {
  print('--- $texto ---\n');
}

String _fmt(double v) {
  if (v == v.truncateToDouble()) return v.toInt().toString();
  return double.parse(v.toStringAsFixed(8)).toString();
}