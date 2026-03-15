import 'dart:io';
import 'dart:math';

// ============================================================
// JOGO DA FORCA - Hangman Game
// ============================================================

/// Lista de palavras secretas para o jogo.
const List<String> palavras = [
  'ABACAXI',
  'ELEFANTE',
  'COMPUTADOR',
  'FLUTTER',
  'PROGRAMACAO',
  'CHOCOLATE',
  'UNIVERSO',
  'BORBOLETA',
  'DINOSSAURO',
  'TECLADO',
];

/// Desenhos ASCII da forca para cada estágio de erro (0 a 6).
const List<String> asciiArte = [
  // 0 erros
  '''
  ╔═══════╗
  ║       │
  ║
  ║
  ║
  ║
  ╚═══════════
  ''',
  // 1 erro
  '''
  ╔═══════╗
  ║       │
  ║       O
  ║
  ║
  ║
  ╚═══════════
  ''',
  // 2 erros
  '''
  ╔═══════╗
  ║       │
  ║       O
  ║       │
  ║
  ║
  ╚═══════════
  ''',
  // 3 erros
  '''
  ╔═══════╗
  ║       │
  ║       O
  ║      /│
  ║
  ║
  ╚═══════════
  ''',
  // 4 erros
  '''
  ╔═══════╗
  ║       │
  ║       O
  ║      /│\\
  ║
  ║
  ╚═══════════
  ''',
  // 5 erros
  '''
  ╔═══════╗
  ║       │
  ║       O
  ║      /│\\
  ║      /
  ║
  ╚═══════════
  ''',
  // 6 erros (enforcado!)
  '''
  ╔═══════╗
  ║       │
  ║       O
  ║      /│\\
  ║      / \\
  ║
  ╚═══════════
  ''',
];

/// Número máximo de erros permitidos.
const int maxErros = 6;

void main() {
  final random = Random();

  bool jogarNovamente = true;

  while (jogarNovamente) {
    // Sorteia uma palavra secreta da lista
    final palavraSecreta = palavras[random.nextInt(palavras.length)];

    // Conjunto de letras já tentadas
    final Set<String> letrasTentadas = {};

    // Conjunto de letras erradas
    final Set<String> letrasErradas = {};

    // Número de erros cometidos
    int erros = 0;

    // Flag de fim de jogo
    bool jogoAcabou = false;

    print('\n' * 2);
    print('╔══════════════════════════════════════════╗');
    print('║         🎯 JOGO DA FORCA 🎯             ║');
    print('╠══════════════════════════════════════════╣');
    print('║  Adivinhe a palavra letra por letra!     ║');
    print('║  Você tem $maxErros tentativas.                  ║');
    print('║                                          ║');
    print('║  💡 Digite "!" para chutar a palavra     ║');
    print('║     inteira (se errar, perde o jogo!)    ║');
    print('╚══════════════════════════════════════════╝');
    print('');

    while (!jogoAcabou) {
      // --- Exibe a forca em ASCII ---
      print(asciiArte[erros]);

      // --- Monta a palavra oculta com underscores ---
      final palavraExibida = palavraSecreta.split('').map((letra) {
        return letrasTentadas.contains(letra) ? letra : '_';
      }).join(' ');

      print('  Palavra: $palavraExibida');
      print('');

      if (letrasErradas.isNotEmpty) {
        print('  ❌ Erros: [${letrasErradas.join(', ')}]');
      }

      print('  ❤️  Tentativas restantes: ${maxErros - erros}');
      print('');

      // --- Verifica vitória ---
      if (_palavraCompleta(palavraSecreta, letrasTentadas)) {
        print('  ╔════════════════════════════════════╗');
        print('  ║  🎉 PARABÉNS! VOCÊ VENCEU! 🎉     ║');
        print('  ║  A palavra era: $palavraSecreta');
        print('  ╚════════════════════════════════════╝');
        jogoAcabou = true;
        break;
      }

      // --- Verifica derrota ---
      if (erros >= maxErros) {
        print('  ╔════════════════════════════════════╗');
        print('  ║  💀 VOCÊ PERDEU! 💀                ║');
        print('  ║  A palavra era: $palavraSecreta');
        print('  ╚════════════════════════════════════╝');
        jogoAcabou = true;
        break;
      }

      // --- Lê a entrada do jogador ---
      stdout.write('  Digite uma letra (ou "!" para chutar a palavra): ');
      final entrada = stdin.readLineSync()?.trim().toUpperCase() ?? '';

      // Limpa a tela (simula com linhas em branco)
      print('\n' * 3);

      // --- Chute da palavra inteira ---
      if (entrada == '!') {
        stdout.write('  🔤 Digite a palavra completa: ');
        final chute = stdin.readLineSync()?.trim().toUpperCase() ?? '';

        if (chute == palavraSecreta) {
          // Adiciona todas as letras como tentadas para mostrar a palavra completa
          letrasTentadas.addAll(palavraSecreta.split(''));
          print(asciiArte[erros]);
          final palavraFinal = palavraSecreta.split('').join(' ');
          print('  Palavra: $palavraFinal');
          print('');
          print('  ╔════════════════════════════════════╗');
          print('  ║  🎉 PARABÉNS! VOCÊ ACERTOU! 🎉    ║');
          print('  ║  A palavra era: $palavraSecreta');
          print('  ╚════════════════════════════════════╝');
          jogoAcabou = true;
        } else {
          // Errou o chute — perde o jogo!
          erros = maxErros;
          print(asciiArte[erros]);
          print('  ╔════════════════════════════════════╗');
          print('  ║  💀 CHUTE ERRADO! VOCÊ PERDEU! 💀 ║');
          print('  ║  A palavra era: $palavraSecreta');
          print('  ╚════════════════════════════════════╝');
          jogoAcabou = true;
        }
        break;
      }

      // --- Validação: deve ser exatamente 1 letra ---
      if (entrada.length != 1 || !RegExp(r'^[A-Z]$').hasMatch(entrada)) {
        print('  ⚠️  Entrada inválida! Digite apenas UMA letra de A a Z.');
        continue;
      }

      // --- Verifica se a letra já foi tentada ---
      if (letrasTentadas.contains(entrada) ||
          letrasErradas.contains(entrada)) {
        print('  ⚠️  Você já tentou a letra "$entrada". Tente outra!');
        continue;
      }

      // --- Processa a tentativa ---
      if (palavraSecreta.contains(entrada)) {
        letrasTentadas.add(entrada);
        print('  ✅ Boa! A letra "$entrada" está na palavra!');
      } else {
        letrasErradas.add(entrada);
        erros++;
        print(
            '  ❌ A letra "$entrada" NÃO está na palavra. (${maxErros - erros} tentativas restantes)');
      }
    }

    // --- Perguntar se quer jogar de novo ---
    print('');
    stdout.write('  🔄 Deseja jogar novamente? (S/N): ');
    final resposta = stdin.readLineSync()?.trim().toUpperCase() ?? 'N';
    jogarNovamente = resposta == 'S';
  }

  print('');
  print('  👋 Obrigado por jogar! Até a próxima!');
  print('');
}

/// Verifica se todas as letras da palavra foram adivinhadas.
bool _palavraCompleta(String palavra, Set<String> letrasTentadas) {
  return palavra.split('').every((letra) => letrasTentadas.contains(letra));
}
