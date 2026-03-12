import 'dart:io';

void main() {
  print('=== Contador de Elementos Repetidos ===');
  print('Digite 10 números inteiros:\n');

  List<int> numeros = [];
  int count = 1;

  while (numeros.length < 10) {
    stdout.write('Número ${count}: ');
    String? entrada = stdin.readLineSync();

    if (entrada == null || entrada.trim().isEmpty) {
      print('Entrada vazia. Digite um número inteiro.\n');
      continue;
    }

    entrada = entrada.trim();

    // Rejeita doubles explicitamente
    if (entrada.contains('.') || entrada.contains(',')) {
      print('Valor inválido! Digite apenas números inteiros, sem casas decimais.\n');
      continue;
    }

    // Rejeita qualquer coisa que não seja inteiro
    final int? valor = int.tryParse(entrada);
    if (valor == null) {
      print('Valor inválido! "$entrada" não é um número inteiro. Tente novamente.\n');
      continue;
    }

    numeros.add(valor);
    count++;
  }

  print('\n--- Resultado ---');
  print('Números digitados: $numeros\n');

  // Conta ocorrências usando Map
  Map<int, int> contagem = {};
  for (int n in numeros) {
    contagem[n] = (contagem[n] ?? 0) + 1;
  }

  // Exibe apenas os que aparecem mais de uma vez
  bool temRepetidos = false;
  print('Contagem de cada valor:');
  // Ordena as chaves para exibição organizada
  final chaves = contagem.keys.toList()..sort();
  for (int chave in chaves) {
    final qtd = contagem[chave]!;
    if (qtd > 1) {
      print('  Número $chave → aparece $qtd vezes (repetido)');
      temRepetidos = true;
    } else {
      print('  Número $chave → aparece $qtd vez');
    }
  }

  if (!temRepetidos) {
    print('\nNenhum número foi repetido.');
  } else {
    final totalRepetidos = contagem.values.where((v) => v > 1).length;
    print('\nTotal de valores distintos que se repetiram: $totalRepetidos');
  }

  print('\nPrograma encerrado.');
}
