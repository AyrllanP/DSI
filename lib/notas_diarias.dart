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

  Future<void> _deletarNota(String idNota) async {
    await FirebaseFirestore.instance.collection('notas').doc(idNota).delete();
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(
        context, '/login'); // Navega de volta para a página de login
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
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: _removerFiltros,
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.black), // Ícone de logout
            onPressed: _logout, // Função de logout
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notas')
            .where('emailUsuario', isEqualTo: userEmail)
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
              return Dismissible(
                key: Key(nota.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirmar exclusão"),
                        content:
                            Text("Tem certeza que deseja excluir esta nota?"),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("Não"),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text("Sim"),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (direction) {
                  _deletarNota(nota.id);
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(nota['titulo'] ?? 'Sem título'),
                    subtitle: Text(nota['nota'] ?? 'Sem conteúdo'),
                    trailing: Text(
                      nota['dataCriacao'] != null
                          ? DateFormat('dd/MM/yyyy').format(
                              (nota['dataCriacao'] as Timestamp).toDate())
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
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _adicionarNota(context),
        backgroundColor: Colors.purple,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.purple.shade100,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.note), label: 'Notas diárias'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Diário do medo'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Hábitos'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Maps'),
        ],
      ),
    );
  }
}
