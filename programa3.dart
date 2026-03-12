import 'dart:io';

void main() {
  print('=== Comparador de Listas ===');
  print('Digite números inteiros e pressione Enter após cada um.');
  print('Digite 0 para encerrar a lista.\n');

  List<int> lista1 = _lerLista(1);
  print('');
  List<int> lista2 = _lerLista(2);

  print('\n--- Resultado ---');
  print('Lista 1: $lista1 (${lista1.length} elemento(s))');
  print('Lista 2: $lista2 (${lista2.length} elemento(s))');
  print('');

  if (lista1.length > lista2.length) {
    print('A Lista 1 é MAIOR que a Lista 2.');
    print('(Lista 1 tem ${lista1.length} elementos, Lista 2 tem ${lista2.length} elementos)');
  } else if (lista1.length < lista2.length) {
    print('A Lista 1 é MENOR que a Lista 2.');
    print('(Lista 1 tem ${lista1.length} elementos, Lista 2 tem ${lista2.length} elementos)');
  } else {
    print('As listas têm o MESMO TAMANHO (${lista1.length} elemento(s)).');
    print('Ordenando e comparando...\n');

    List<int> ordenada1 = List.from(lista1)..sort();
    List<int> ordenada2 = List.from(lista2)..sort();

    print('Lista 1 ordenada: $ordenada1');
    print('Lista 2 ordenada: $ordenada2');
    print('');

    bool identicas = _saoIdenticas(ordenada1, ordenada2);
    if (identicas) {
      print('As listas são IDÊNTICAS após ordenação!');
    } else {
      print('As listas NÃO são idênticas após ordenação.');
      _mostrarDiferencas(ordenada1, ordenada2);
    }
  }

  print('\nPrograma encerrado.');
}

List<int> _lerLista(int numero) {
  List<int> lista = [];
  print('--- Lista $numero ---');
  print('(Digite 0 para encerrar)\n');

  while (true) {
    stdout.write('Lista $numero - Elemento ${lista.length + 1}: ');
    String? entrada = stdin.readLineSync();

    if (entrada == null || entrada.trim().isEmpty) {
      print('Entrada vazia. Digite um número inteiro.\n');
      continue;
    }

    entrada = entrada.trim();

    // Rejeita doubles
    if (entrada.contains('.') || entrada.contains(',')) {
      print('Valor inválido! Digite apenas números inteiros, sem casas decimais.\n');
      continue;
    }

    final int? valor = int.tryParse(entrada);
    if (valor == null) {
      print('Valor inválido! "$entrada" não é um número inteiro. Tente novamente.\n');
      continue;
    }

    if (valor == 0) {
      if (lista.isEmpty) {
        print('A lista não pode ser vazia! Digite pelo menos um elemento.\n');
        continue;
      }
      print('Lista $numero encerrada com ${lista.length} elemento(s).');
      break;
    }

    lista.add(valor);
    print('  Adicionado: $valor | Lista atual: $lista\n');
  }

  return lista;
}

bool _saoIdenticas(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

void _mostrarDiferencas(List<int> a, List<int> b) {
  print('Diferenças encontradas:');
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      print('  Posição ${i + 1}: Lista 1 tem ${a[i]}, Lista 2 tem ${b[i]}');
    }
  }
}