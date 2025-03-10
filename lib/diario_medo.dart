import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_dsi/habitos.dart';
import 'package:projeto_dsi/mapas.dart';
import 'package:projeto_dsi/notas_diarias.dart';
import 'medo_page.dart';
import 'perfil.dart';

class DiarioMedoPage extends StatefulWidget {
  @override
  _DiarioMedoPageState createState() => _DiarioMedoPageState();
}

class _DiarioMedoPageState extends State<DiarioMedoPage> {
  final user = FirebaseAuth.instance.currentUser;
  int _selectedIndex = 1; // Índice inicial para "Diário do Medo"
  String _keyword = ""; // Variável para armazenar a palavra-chave
  bool _isSearching = false;
  // Método para atualizar a palavra-chave
  void _updateKeyword(String keyword) {
    setState(() {
      _keyword = keyword;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _updateKeyword(""); // Limpa a palavra-chave ao fechar a pesquisa
      }
    });
  }
  
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NotasDiariaPage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DiarioMedoPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HabitosPage()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MapasPage()),
        );
        break;
    }
  }

  Future<void> _deleteMedo(String idMedo) async {
    try {
      await FirebaseFirestore.instance.collection('medos').doc(idMedo).delete();
    } catch (e) {
      print("Erro ao excluir: $e");
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

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
              MaterialPageRoute(
                builder: (context) => TelaPerfil(),
              ),
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
                onChanged: _updateKeyword, // Atualiza a palavra-chave ao digitar
              ),
            ),
          ],
        ): Text(
                'Diário do Medo',
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('medos')
            .where('userId', isEqualTo: user?.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Nenhum medo cadastrado.'));
          }

          // Filtra os documentos localmente com base na palavra-chave
          final filteredDocs = snapshot.data!.docs.where((doc) {
            final medo = doc['medo']?.toString().toLowerCase() ?? '';
            final preocupacao = doc['preocupacao']?.toString().toLowerCase() ?? '';
            final prevenir = doc['prevenir']?.toString().toLowerCase() ?? '';
            final corrigir = doc['corrigir']?.toString().toLowerCase() ?? '';
            final beneficios = doc['beneficios']?.toString().toLowerCase() ?? '';

            // Verifica se a palavra-chave está em qualquer um dos campos
            return medo.contains(_keyword.toLowerCase()) ||
                   preocupacao.contains(_keyword.toLowerCase()) ||
                   prevenir.contains(_keyword.toLowerCase()) ||
                   corrigir.contains(_keyword.toLowerCase()) ||
                   beneficios.contains(_keyword.toLowerCase());
          }).toList();

          if (filteredDocs.isEmpty) {
            return Center(child: Text('Nenhum resultado encontrado.'));
          }

          return ListView.builder(
            itemCount: filteredDocs.length,
            itemBuilder: (context, index) {
              var medo = filteredDocs[index];
              return Dismissible(
                key: Key(medo.id),
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
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                  _deleteMedo(medo.id); // Deleta a nota após confirmação
                                },
                                child: const Text("Sim"),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.skull,
                      color: Colors.red,
                      size: 30,
                    ),
                    title: Text(
                      medo['medo'] ?? 'Sem título',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Preocupação: ${medo['preocupacao'] ?? 'Nenhuma'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          ),
                        Text(
                          'Prevenir: ${medo['prevenir'] ?? 'Nenhuma'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          ),
                        Text(
                          'Corrigir: ${medo['corrigir'] ?? 'Nenhuma'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          ),
                        Text(
                          'Benefícios: ${medo['beneficios'] ?? 'Sem benefício'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MedoPage(
                            idMedo: medo.id,
                            medo: medo['medo'],
                            preocupacao: medo['preocupacao'],
                            prevenir: medo['prevenir'],
                            corrigir: medo['corrigir'],
                            beneficios: medo['beneficios'],
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
            MaterialPageRoute(builder: (context) => MedoPage()),
          );
        },
        backgroundColor: Colors.purple,
        child: Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.purple.shade100,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
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