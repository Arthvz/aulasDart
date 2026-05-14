// lib/models/appointment.dart
// Modelo de dados de um compromisso

class Appointment {
  final String? id;        // ID gerado pelo Firestore (null antes de salvar)
  final String title;      // Título do compromisso
  final String description; // Descrição/observação
  final DateTime dateTime; // Data e hora do compromisso
  final String userId;     // ID do usuário dono do compromisso

  Appointment({
    this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.userId,
  });

  // Converte o objeto para Map (para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'userId': userId,
    };
  }

  // Cria um Appointment a partir de um Map (dados vindos do Firestore)
  factory Appointment.fromMap(Map<String, dynamic> map, String id) {
    return Appointment(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dateTime: DateTime.parse(map['dateTime']),
      userId: map['userId'] ?? '',
    );
  }

  // Cria uma cópia do compromisso com campos alterados (útil na edição)
  Appointment copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dateTime,
    String? userId,
  }) {
    return Appointment(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      userId: userId ?? this.userId,
    );
  }
}
