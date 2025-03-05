import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart'; 
import 'habitos.dart';

class TelaPerfil extends StatefulWidget {
  @override
  _TelaPerfilState createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  Map<int, int> _emojiCounts = {}; 

  // Para monitoramento de humor
  final List<IconData> _emojis = [
    Icons.sentiment_dissatisfied,
    Icons.sentiment_satisfied,
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_neutral,
    Icons.sentiment_very_satisfied,
  ];

  final List<Color> _emojiColors = [
    Colors.red.shade300,
    Colors.green.shade300,
    Colors.red.shade900,
    Colors.blue.shade300,
    Colors.green.shade800,
  ];

  Map<String, bool> _habitosStatus = {}; // Armazenar hábitos dos ultimos 7 dias para monitoramento de hábitos

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
    _carregarDadosEmojis();
    _carregarStatusHabitos();
  }

  void _carregarUsuario() async {
    await Future.delayed(Duration(seconds: 2));
    User? user = _auth.currentUser;
    setState(() {
      _user = user;
    });
    print('Usuário logado: ${_user?.email}');
  }

  // Para monitoramento de humor
  void _carregarDadosEmojis() async {
    final userEmail = _auth.currentUser?.email;
    if (userEmail == null) return;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('notas')
        .where('emailUsuario', isEqualTo: userEmail)
        .get();

    final emojiCounts = <int, int>{};
    for (int i = 0; i < _emojis.length; i++) {
      emojiCounts[i] = 0; 
    }

    for (final doc in querySnapshot.docs) {
      final emojiIndex = doc['emojiSelecionado'] ?? 0;
      if (emojiCounts.containsKey(emojiIndex)) {
        emojiCounts[emojiIndex] = (emojiCounts[emojiIndex] ?? 0) + 1;
      }
    }

    setState(() {
      _emojiCounts = emojiCounts;
    });
  }

  // Para monitorar hábito dos ultimos 7 dias
  void _carregarStatusHabitos() async {
  final userEmail = _auth.currentUser?.email;
  if (userEmail == null) return;

  final DateTime now = DateTime.now();
  final DateTime startDate = now.subtract(Duration(days: 6));

  final querySnapshot = await FirebaseFirestore.instance
      .collection('Habitos')
      .doc(_auth.currentUser!.uid)
      .collection('usuario_habitos')
      .get();

  final Map<String, bool> habitosStatus = {};

  for (int i = 0; i < 7; i++) {
    final DateTime date = startDate.add(Duration(days: i));
    final String dateKey = DateFormat('yyyy-MM-dd').format(date);

    final List<Habito> habitosDoDia = [];

    for (final doc in querySnapshot.docs) {
      final Habito habito = Habito.fromFirestore(doc);
      if (_deveRealizarHabitoNoDia(habito, date)) {
        habitosDoDia.add(habito);
      }
    }

    bool todosConcluidos = true;
    for (final habito in habitosDoDia) {
      if (!habito.statusDiario.containsKey(dateKey) || !habito.statusDiario[dateKey]!) {
        todosConcluidos = false;
        break;
      }
    }

    habitosStatus[dateKey] = todosConcluidos;
  }

  setState(() {
    _habitosStatus = habitosStatus;
  });
}

bool _deveRealizarHabitoNoDia(Habito habito, DateTime date) {
  if (habito.frequencia == "Todos os dias") {
    return true;
  } else if (habito.dias != null) {
    final String diaSemana = _obterDiaSemana(date);
    return habito.dias!.contains(diaSemana);
  }
  return false;
}

String _obterDiaSemana(DateTime date) {
  List<String> diasSemana = ["dom", "seg", "ter", "qua", "qui", "sex", "sáb"];
  return diasSemana[date.weekday % 7];
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Perfil",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.purple.shade50,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.purple,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.purple.shade50,
                    ),
                  ),
                ),
              ),
              Padding(
                
                padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text(
                        'Informações do usuário',
                      style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Nome de usuário:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      _user?.displayName ?? 'Usuário',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Email:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      _user?.email ?? 'email@usuario.com',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Monitoramento de Hábitos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ),
              _buildHabitosStatus(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Monitoramento de Humor',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ),
              Container(
                height: 200,
                padding: const EdgeInsets.all(16.0),
                child: BarChart(
                  BarChartData(
                    barGroups: List.generate(_emojis.length, (index) {
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: _emojiCounts[index]?.toDouble() ?? 0.0,
                            color: Colors.purple, // Mantém as barras roxas
                            width: 16,
                          ),
                        ],
                      );
                    }),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            return Icon(
                              _emojis[index],
                              color: _emojiColors[index],
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                  ),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHabitosStatus() {
    final DateTime now = DateTime.now();
    final DateTime startDate = now.subtract(Duration(days: 6));

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (index) {
          final DateTime date = startDate.add(Duration(days: index));
          final String dateKey = DateFormat('yyyy-MM-dd').format(date);
          final bool status = _habitosStatus[dateKey] ?? false;

          return Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: status ? Colors.lightGreenAccent : Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(height: 5),
              Text(
                DateFormat('dd/MM').format(date),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}