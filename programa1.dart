import 'dart:io';

void main() {
  print('=== Conversor de Data para Extenso ===\n');

  while (true) {
    stdout.write('Digite a data no formato DD/MM/AAAA: ');
    String? entrada = stdin.readLineSync();

    if (entrada == null || entrada.trim().isEmpty) {
      print('Entrada inválida. Tente novamente.\n');
      continue;
    }

    entrada = entrada.trim();

    // Valida o formato DD/MM/AAAA
    final regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!regex.hasMatch(entrada)) {
      print('Formato inválido! Use DD/MM/AAAA (ex: 10/01/1967).\n');
      continue;
    }

    final partes = entrada.split('/');
    final dia = int.parse(partes[0]);
    final mes = int.parse(partes[1]);
    final ano = int.parse(partes[2]);

    // Valida dia
    if (dia < 1 || dia > 31) {
      print('Dia inválido! O dia deve estar entre 01 e 31.\n');
      continue;
    }

    // Valida mês
    if (mes < 1 || mes > 12) {
      print('Mês inválido! O mês deve estar entre 01 e 12.\n');
      continue;
    }

    // Valida ano
    if (ano < 1) {
      print('Ano inválido!\n');
      continue;
    }

    // Valida dias por mês
    final diasNoMes = _diasDoMes(mes, ano);
    if (dia > diasNoMes) {
      print('Data inválida! O mês ${_nomeMes(mes)} de $ano tem apenas $diasNoMes dias.\n');
      continue;
    }

    final resultado = '$dia de ${_nomeMes(mes)} de $ano';
    print('\nData por extenso: $resultado\n');

    stdout.write('Deseja converter outra data? (s/n): ');
    String? resposta = stdin.readLineSync();
    if (resposta?.toLowerCase() != 's') break;
    print('');
  }

  print('\nPrograma encerrado.');
}

String _nomeMes(int mes) {
  const meses = [
    '', 'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
  ];
  return meses[mes];
}

int _diasDoMes(int mes, int ano) {
  const dias = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  if (mes == 2 && _anoBissexto(ano)) return 29;
  return dias[mes];
}

bool _anoBissexto(int ano) {
  return (ano % 4 == 0 && ano % 100 != 0) || (ano % 400 == 0);
}