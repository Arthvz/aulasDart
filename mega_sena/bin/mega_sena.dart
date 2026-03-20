import 'dart:math';

void main() {
  // Mapa com os 10 tipos de jogos possíveis (6 a 15 números)
  final Map<int, Set<int>> jogos = {};

  final random = Random();

  // Gera um volante para cada tipo de aposta (6 a 15 números)
  for (int quantidadeNumeros = 6; quantidadeNumeros <= 15; quantidadeNumeros++) {
    final Set<int> volante = {};

    // Usa a propriedade do Set de não permitir duplicatas
    while (volante.length < quantidadeNumeros) {
      volante.add(random.nextInt(60) + 1); // Números de 1 a 60
    }

    jogos[quantidadeNumeros] = volante;
  }

  // Imprime o cabeçalho
  print('╔══════════════════════════════════════════════════════════╗');
  print('║              🍀 MEGA-SENA - VOLANTES 🍀                ║');
  print('╠══════════════════════════════════════════════════════════╣');

  // Imprime cada volante com os números ordenados
  jogos.forEach((quantidade, numeros) {
    final numerosOrdenados = numeros.toList()..sort();

    // Formata os números com dois dígitos
    final numerosFormatados =
        numerosOrdenados.map((n) => n.toString().padLeft(2, '0')).join(' - ');

    print('║                                                          ║');
    print(
      '║  Aposta com $quantidade números:${quantidade < 10 ? ' ' : ''}                                    ║',
    );
    print('║  $numerosFormatados');
    print('║                                                          ║');

    if (quantidade < 15) {
      print('╠══════════════════════════════════════════════════════════╣');
    }
  });

  print('╚══════════════════════════════════════════════════════════╝');

  // Resumo
  print('');
  print('📊 Resumo dos jogos:');
  print('   Total de volantes gerados: ${jogos.length}');
  print('   Tipos de aposta: 6 a 15 números');
  print('   Faixa de números: 01 a 60');
}
