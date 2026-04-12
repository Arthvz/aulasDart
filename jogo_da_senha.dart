import 'dart:io';
import 'dart:math';

const String pinoPreto = '⚫';
const String pinoBranco = '⚪';
const String pinoErrado = '✖ ';

void main() {
  final random = Random();
  final senha = List.generate(4, (_) => random.nextInt(6) + 1);

  _exibirCabecalho();

  int tentativas = 0;
  const int maxTentativas = 10;

  while (tentativas < maxTentativas) {
    tentativas++;
    print('\n🔢 Tentativa $tentativas de $maxTentativas');
    stdout.write('Seu palpite (4 números de 1 a 6, separados por espaço): ');

    final entrada = stdin.readLineSync()?.trim() ?? '';
    final palpite = _validarEntrada(entrada);

    if (palpite == null) {
      tentativas--;
      continue;
    }

    final pinos = _calcularPinosPorPosicao(senha, palpite);
    _exibirFeedback(palpite, pinos);

    final pinosPretos = pinos.where((p) => p == pinoPreto).length;
    if (pinosPretos == 4) {
      print('\n╔══════════════════════════════════════╗');
      print('║  🎉 PARABÉNS! Senha descoberta!       ║');
      print(
        '║  Senha: ${senha.join('  ')}  em $tentativas tentativa(s)      ║',
      );
      print('╚══════════════════════════════════════╝');
      return;
    }
  }

  print('\n╔══════════════════════════════════════╗');
  print('║  💀 FIM DE JOGO! Tentativas esgotadas ║');
  print('║  A senha era: ${senha.join('  ')}               ║');
  print('╚══════════════════════════════════════╝');
}

void _exibirCabecalho() {
  print('╔══════════════════════════════════════╗');
  print('║        🎯  M A S T E R M I N D        ║');
  print('╠══════════════════════════════════════╣');
  print('║  Descubra a senha de 4 dígitos        ║');
  print('║  Cada dígito vai de 1 a 6             ║');
  print('║                                       ║');
  print('║  ⚫ → número CERTO no lugar CERTO     ║');
  print('║  ⚪ → número CERTO no lugar ERRADO    ║');
  print('║  ✖  → número NÃO está na senha        ║');
  print('╚══════════════════════════════════════╝');
}

List<int>? _validarEntrada(String entrada) {
  final partes = entrada.split(RegExp(r'\s+'));

  if (partes.length != 4) {
    print('❌ Digite exatamente 4 números separados por espaço.');
    return null;
  }

  final numeros = <int>[];
  for (final parte in partes) {
    final n = int.tryParse(parte);
    if (n == null) {
      print('❌ "$parte" não é um número válido. Use apenas dígitos de 1 a 6.');
      return null;
    }
    if (n < 1 || n > 6) {
      print('❌ O número $n está fora do intervalo (1 a 6).');
      return null;
    }
    numeros.add(n);
  }
  return numeros;
}

List<String> _calcularPinosPorPosicao(List<int> senha, List<int> palpite) {
  final resultado = List<String>.filled(4, '');

  final indicesRestantesSenha = <int>[];
  final indicesRestantesPalpite = <int>[];

  for (int i = 0; i < 4; i++) {
    if (palpite[i] == senha[i]) {
      resultado[i] = pinoPreto;
    } else {
      indicesRestantesSenha.add(i);
      indicesRestantesPalpite.add(i);
    }
  }

  final senhaRestante = [for (final i in indicesRestantesSenha) senha[i]];

  for (final i in indicesRestantesPalpite) {
    final digito = palpite[i];
    final idx = senhaRestante.indexOf(digito);
    if (idx != -1) {
      resultado[i] = pinoBranco;
      senhaRestante.removeAt(idx);
    } else {
      resultado[i] = pinoErrado;
    }
  }

  return resultado;
}

void _exibirFeedback(List<int> palpite, List<String> pinos) {
  String celula(String s) => s.padRight(4);

  final linhaPos = palpite
      .asMap()
      .entries
      .map((e) => celula('${e.key + 1}'))
      .join();
  final linhaNum = palpite.map((n) => celula('$n')).join();
  final linhaPin = pinos.map((p) => celula(p)).join();

  print('┌────────────────────────────────┐');
  print('│ Posição : $linhaPos│');
  print('│ Número  : $linhaNum│');
  print('│ Pino    : $linhaPin│');
  print('└────────────────────────────────┘');
}
