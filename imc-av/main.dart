import 'package:flutter/material.dart';

void main() {
  runApp(const IMCApp());
}

class IMCApp extends StatelessWidget {
  const IMCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de IMC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D8C),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2E7D8C), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
      home: const IMCCalculatorPage(),
    );
  }
}

class IMCCalculatorPage extends StatefulWidget {
  const IMCCalculatorPage({super.key});

  @override
  State<IMCCalculatorPage> createState() => _IMCCalculatorPageState();
}

class _IMCCalculatorPageState extends State<IMCCalculatorPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _pesoController = TextEditingController();
  final _alturaController = TextEditingController();

  double? _imc;
  String? _classificacao;
  Color? _corClassificacao;
  IconData? _iconClassificacao;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _pesoController.dispose();
    _alturaController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _calcularIMC() {
    if (!_formKey.currentState!.validate()) return;

    final peso = double.tryParse(
      _pesoController.text.replaceAll(',', '.'),
    );
    final altura = double.tryParse(
      _alturaController.text.replaceAll(',', '.'),
    );

    if (peso == null || altura == null || peso <= 0 || altura <= 0) {
      _mostrarErro('Por favor, insira valores válidos.');
      return;
    }

    if (altura > 3.0) {
      _mostrarErro('Altura parece inválida. Use metros (ex: 1.75).');
      return;
    }

    if (peso > 500) {
      _mostrarErro('Peso parece inválido. Verifique o valor inserido.');
      return;
    }

    final imc = peso / (altura * altura);

    String classificacao;
    Color cor;
    IconData icone;

    if (imc < 18.5) {
      classificacao = 'Abaixo do peso';
      cor = const Color(0xFF2196F3);
      icone = Icons.arrow_downward_rounded;
    } else if (imc < 25.0) {
      classificacao = 'Peso normal';
      cor = const Color(0xFF4CAF50);
      icone = Icons.check_circle_rounded;
    } else if (imc < 30.0) {
      classificacao = 'Sobrepeso';
      cor = const Color(0xFFFF9800);
      icone = Icons.warning_rounded;
    } else {
      classificacao = 'Obesidade';
      cor = const Color(0xFFF44336);
      icone = Icons.dangerous_rounded;
    }

    setState(() {
      _imc = imc;
      _classificacao = classificacao;
      _corClassificacao = cor;
      _iconClassificacao = icone;
    });

    _animationController.reset();
    _animationController.forward();
  }

  void _limparCampos() {
    _pesoController.clear();
    _alturaController.clear();
    setState(() {
      _imc = null;
      _classificacao = null;
      _corClassificacao = null;
      _iconClassificacao = null;
    });
    _animationController.reset();
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(mensagem)),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  String? _validarPeso(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o peso';
    }
    final v = double.tryParse(value.replaceAll(',', '.'));
    if (v == null || v <= 0) return 'Peso inválido';
    return null;
  }

  String? _validarAltura(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe a altura';
    }
    final v = double.tryParse(value.replaceAll(',', '.'));
    if (v == null || v <= 0) return 'Altura inválida';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF2E7D8C),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Calculadora de IMC',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1A5F6E), Color(0xFF2E7D8C)],
                  ),
                ),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 48),
                    child: Icon(
                      Icons.monitor_weight_outlined,
                      size: 56,
                      color: Colors.white24,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Card de entrada
                        Card(
                          elevation: 0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Insira seus dados',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1A1A2E),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                if (isWide)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildCampoPeso(),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: _buildCampoAltura(),
                                      ),
                                    ],
                                  )
                                else
                                  Column(
                                    children: [
                                      _buildCampoPeso(),
                                      const SizedBox(height: 16),
                                      _buildCampoAltura(),
                                    ],
                                  ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: ElevatedButton.icon(
                                        onPressed: _calcularIMC,
                                        icon: const Icon(
                                            Icons.calculate_rounded,
                                            color: Colors.white),
                                        label: const Text(
                                          'Calcular IMC',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF2E7D8C),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          elevation: 2,
                                        ),
                                      ),
                                    ),
                                    if (_imc != null) ...[
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: _limparCampos,
                                          icon: const Icon(Icons.refresh_rounded,
                                              size: 18),
                                          label: const Text('Limpar'),
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Resultado
                        if (_imc != null) ...[
                          const SizedBox(height: 20),
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: _buildResultado(),
                            ),
                          ),
                        ],

                        // Tabela de referência
                        const SizedBox(height: 20),
                        _buildTabelaReferencia(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampoPeso() {
    return TextFormField(
      controller: _pesoController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: _validarPeso,
      decoration: InputDecoration(
        labelText: 'Peso (kg)',
        hintText: 'Ex: 70',
        prefixIcon: const Icon(Icons.monitor_weight_outlined,
            color: Color(0xFF2E7D8C)),
        labelStyle: const TextStyle(color: Color(0xFF2E7D8C)),
      ),
    );
  }

  Widget _buildCampoAltura() {
    return TextFormField(
      controller: _alturaController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: _validarAltura,
      decoration: InputDecoration(
        labelText: 'Altura (m)',
        hintText: 'Ex: 1.75',
        prefixIcon:
            const Icon(Icons.height_rounded, color: Color(0xFF2E7D8C)),
        labelStyle: const TextStyle(color: Color(0xFF2E7D8C)),
      ),
    );
  }

  Widget _buildResultado() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: _corClassificacao!.withOpacity(0.3), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_iconClassificacao, color: _corClassificacao, size: 28),
                const SizedBox(width: 8),
                const Text(
                  'Resultado',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: _corClassificacao!.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    _imc!.toStringAsFixed(2).replaceAll('.', ','),
                    style: TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      color: _corClassificacao,
                      letterSpacing: -1,
                    ),
                  ),
                  const Text(
                    'IMC',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: _corClassificacao,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                _classificacao!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabelaReferencia() {
    final categorias = [
      {
        'label': 'Abaixo do peso',
        'range': '< 18,5',
        'color': const Color(0xFF2196F3),
        'icon': Icons.arrow_downward_rounded,
      },
      {
        'label': 'Peso normal',
        'range': '18,5 – 24,9',
        'color': const Color(0xFF4CAF50),
        'icon': Icons.check_circle_rounded,
      },
      {
        'label': 'Sobrepeso',
        'range': '25,0 – 29,9',
        'color': const Color(0xFFFF9800),
        'icon': Icons.warning_rounded,
      },
      {
        'label': 'Obesidade',
        'range': '≥ 30,0',
        'color': const Color(0xFFF44336),
        'icon': Icons.dangerous_rounded,
      },
    ];

    return Card(
      elevation: 0,
      color: Colors.white,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tabela de Referência',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 12),
            ...categorias.map((cat) {
              final isAtual = _classificacao == cat['label'];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isAtual
                      ? (cat['color'] as Color).withOpacity(0.12)
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: isAtual
                      ? Border.all(
                          color: (cat['color'] as Color).withOpacity(0.5),
                          width: 1.5)
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(cat['icon'] as IconData,
                        color: cat['color'] as Color, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        cat['label'] as String,
                        style: TextStyle(
                          fontWeight: isAtual
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isAtual
                              ? cat['color'] as Color
                              : const Color(0xFF444444),
                        ),
                      ),
                    ),
                    Text(
                      cat['range'] as String,
                      style: TextStyle(
                        color: isAtual
                            ? cat['color'] as Color
                            : Colors.grey.shade600,
                        fontWeight: isAtual
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                    if (isAtual) ...[
                      const SizedBox(width: 6),
                      Icon(Icons.arrow_left_rounded,
                          color: cat['color'] as Color, size: 20),
                    ]
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
