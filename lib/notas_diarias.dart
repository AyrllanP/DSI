import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:projeto_dsi/perfil.dart';
import 'notas_diarias_page.dart';
import 'package:projeto_dsi/mapas.dart';
import 'package:projeto_dsi/diario_medo.dart';
import 'package:projeto_dsi/habitos.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotasDiariaPage extends StatefulWidget {
  @override
  _NotasDiariaPageState createState() => _NotasDiariaPageState();
}

class _NotasDiariaPageState extends State<NotasDiariaPage> {
  final String? userEmail = FirebaseAuth.instance.currentUser?.email;
  String _keyword = ""; 
  bool _isSearching = false;

  void _updateKeyword(String keyword) {
    setState(() {
      _keyword = keyword;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _updateKeyword(""); 
      }
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
    Navigator.pushReplacementNamed(context, '/login');
  }

  // Lista de emojis e cores
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.person,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TelaPerfil()),
            );
          },
        ),
        centerTitle: true,
        title: _isSearching
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Pesquisar por palavra-chave...',
                        border: InputBorder.none,
                      ),
                      onChanged: _updateKeyword, 
                    ),
                  ),
                ],
              )
            : Text(
                'Notas Diárias',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search, 
              color: Colors.black,
            ),
            onPressed: _toggleSearch, 
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.black),
            onPressed: _logout,
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

          // Filtra os documentos localmente com base na palavra-chave
          final notas = snapshot.data!.docs.where((doc) {
            final titulo = doc['titulo']?.toString().toLowerCase() ?? '';
            final conteudo = doc['nota']?.toString().toLowerCase() ?? '';
            return titulo.contains(_keyword.toLowerCase()) ||
                   conteudo.contains(_keyword.toLowerCase());
          }).toList();

          // Ordena as notas pela data de criação (mais recente primeiro)
          notas.sort((a, b) {
            final Timestamp? dataA = a['dataCriacao'] as Timestamp?;
            final Timestamp? dataB = b['dataCriacao'] as Timestamp?;
            if (dataA == null || dataB == null) return 0; 
            return dataB.compareTo(dataA); 
          });

          if (notas.isEmpty) {
            return Center(
              child: Text(
                'Nenhum resultado encontrado.',
                style: TextStyle(color: Colors.black45, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: notas.length,
            itemBuilder: (context, index) {
              final nota = notas[index];
              final emojiIndex = nota['emojiSelecionado'] ?? 0;
              final emoji = _emojis[emojiIndex];
              final emojiColor = _emojiColors[emojiIndex];

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
                        content: Text("Tem certeza que deseja excluir esta nota?"),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text("Não"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
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
                    leading: Icon(
                      emoji,
                      color: emojiColor,
                      size: 36,
                    ),
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditarNotaPage()),
          );
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add, color: Colors.white),
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
            icon: Icon(FontAwesomeIcons.skull),
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