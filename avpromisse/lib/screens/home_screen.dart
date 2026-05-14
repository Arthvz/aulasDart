// lib/screens/home_screen.dart
// Tela principal – lista todos os compromissos do usuário logado

import 'package:flutter/material.dart';
import '../models/appointment.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../widgets/appointment_card.dart';
import 'appointment_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final dbService = DatabaseService();
    final user = authService.currentUser!;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Minha Agenda'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          // Exibe o e-mail do usuário
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                user.email ?? '',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          // Botão de logout
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Sair'),
                  content: const Text('Deseja encerrar a sessão?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Sair',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await authService.logout();
              }
            },
          ),
        ],
      ),

      // ── Lista de compromissos (atualiza em tempo real via Stream) ──
      body: StreamBuilder<List<Appointment>>(
        stream: dbService.getAppointments(user.uid),
        builder: (context, snapshot) {
          // Carregando dados
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Erro no Stream
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar dados: ${snapshot.error}'),
            );
          }

          final appointments = snapshot.data ?? [];

          // Estado vazio
          if (appointments.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Nenhum compromisso ainda.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Toque no + para adicionar.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Lista com os compromissos
          return ListView.builder(
            padding: const EdgeInsets.only(top: 12, bottom: 80),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];

              return AppointmentCard(
                appointment: appointment,
                // ── Editar ──
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AppointmentFormScreen(
                        appointment: appointment,
                      ),
                    ),
                  );
                },
                // ── Excluir (com confirmação) ──
                onDelete: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Excluir Compromisso'),
                      content: Text(
                        'Tem certeza que deseja excluir "${appointment.title}"?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Excluir',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await dbService.deleteAppointment(appointment.id!);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Compromisso excluído.'),
                        ),
                      );
                    }
                  }
                },
              );
            },
          );
        },
      ),

      // ── Botão flutuante para adicionar novo compromisso ──
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AppointmentFormScreen(),
            ),
          );
        },
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Novo'),
      ),
    );
  }
}
