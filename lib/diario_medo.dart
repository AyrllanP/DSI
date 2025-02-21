import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'medo_page.dart';
import 'perfil.dart'; // Adicione essa linha no topo do arquivo diario_medo.dart

class DiarioMedoPage extends StatefulWidget {
  @override
  _DiarioMedoPageState createState() => _DiarioMedoPageState();
}

class _DiarioMedoPageState extends State<DiarioMedoPage> {
  final user = FirebaseAuth.instance.currentUser;
  int _selectedIndex = 1; // Índice inicial para "Diário do Medo"

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Aqui você pode adicionar a navegação para outras páginas conforme necessário.
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
          icon: Icon(
            Icons.person,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TelaPerfil()), // Substitua TelaPerfil pela sua tela de perfil
            );
          },
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Diário dos Medos',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.black), // Ícone de logout
            onPressed: _logout, // Função de logout
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
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var medo = snapshot.data!.docs[index];
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
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                  _deleteMedo(medo
                                      .id); // Deleta a nota após confirmação
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
                      color: Colors.red, // Caveira vermelha
                      size: 30,
                    ),
                    title: Text(medo['medo'] ?? 'Sem título'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Preocupação: ${medo['preocupacao'] ?? 'Nenhuma'}'),
                        Text('Prevenir: ${medo['prevenir'] ?? 'Nenhuma'}'),
                        Text('Corrigir: ${medo['corrigir'] ?? 'Nenhuma'}'),
                        Text(
                            'Benefícios: ${medo['beneficios'] ?? 'Sem benefício'}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
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
