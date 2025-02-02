import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'notas_diarias_page.dart';
import 'package:projeto_dsi/mapas.dart';
import 'package:projeto_dsi/diario_medo.dart';
import 'package:projeto_dsi/habitos.dart';

class NotasDiariaPage extends StatefulWidget {
  @override
  _NotasDiariaPageState createState() => _NotasDiariaPageState();
}

class _NotasDiariaPageState extends State<NotasDiariaPage> {
  DateTime _selectedDate = DateTime.now();
  late String _formattedDate;
  bool _isDateSelected = false;
  final String? userEmail = FirebaseAuth.instance.currentUser?.email;

  @override
  void initState() {
    super.initState();
    _formattedDate = DateFormat('MMM yyyy').format(_selectedDate);
  }

  void _adicionarNota(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarNotaPage(),
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _formattedDate = DateFormat('MMM yyyy').format(_selectedDate);
        _isDateSelected = true;
      });
    }
  }

  void _removerFiltros() {
    setState(() {
      _isDateSelected = false;
      _formattedDate = DateFormat('MMM yyyy').format(DateTime.now());
    });
  }

  void _onItemTapped(int index) {
    Widget page;
    switch (index) {
      case 1:
        page = DiarioMedoPage();
        break;
      case 2:
        page = HabitosPage();
        break;
      case 3:
        page = MapasPage();
        break;
      default:
        return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.person, color: Colors.black),
          onPressed: () {},
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left, color: Colors.black),
              onPressed: () {},
            ),
            Text(
              _formattedDate,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.arrow_right, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.black),
            onPressed: _pickDate,
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: _removerFiltros,
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              showSearch(context: context, delegate: _SearchDelegate());
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notas')
            .where('emailUsuario', isEqualTo: userEmail)
            .where(
              'dataCriacao',
              isGreaterThanOrEqualTo: _isDateSelected
                  ? Timestamp.fromDate(DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                    ))
                  : null,
            )
            .where(
              'dataCriacao',
              isLessThan: _isDateSelected
                  ? Timestamp.fromDate(DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day + 1,
                    ))
                  : null,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'Nenhuma nota encontrada!',
                style: TextStyle(color: Colors.black45, fontSize: 16),
              ),
            );
          }

          final notas = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: notas.length,
            itemBuilder: (context, index) {
              final nota = notas[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(nota['titulo'] ?? 'Sem título'),
                  subtitle: Text(nota['nota'] ?? 'Sem conteúdo'),
                  trailing: Text(
                    nota['dataCriacao'] != null
                        ? DateFormat('dd/MM/yyyy')
                            .format((nota['dataCriacao'] as Timestamp).toDate())
                        : 'Sem data',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditarNotaPage(
                          idNota: nota.id,
                          titulo: nota['titulo'],
                          conteudo: nota['nota'],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _adicionarNota(context),
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Colors.black),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.purple.shade100,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Notas diárias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Diário do medo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Hábitos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Maps',
          ),
        ],
      ),
    );
  }
}

class _SearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Buscar por título...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    if (query.isEmpty) {
      return Center(child: Text('Digite um título para buscar.'));
    }

    final String? userEmail = FirebaseAuth.instance.currentUser?.email;

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('notas')
          .where('emailUsuario', isEqualTo: userEmail)
          .where('titulo', isGreaterThanOrEqualTo: query)
          .where('titulo', isLessThanOrEqualTo: query + '\uf8ff')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Nenhuma nota encontrada!'));
        }

        final notas = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: notas.length,
          itemBuilder: (context, index) {
            final nota = notas[index];
            return ListTile(title: Text(nota['titulo'] ?? 'Sem título'));
          },
        );
      },
    );
  }
}
