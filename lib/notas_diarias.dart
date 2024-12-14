import 'package:flutter/material.dart';
import 'servicos/autenticacao.dart'; // Importa o serviço de autenticação

class NotasDiariasPage extends StatefulWidget {
  // Mudança no nome da classe
  @override
  _NotasDiariasPageState createState() =>
      _NotasDiariasPageState(); // Mudança no nome da classe
}

class _NotasDiariasPageState extends State<NotasDiariasPage> {
  // Mudança no nome da classe
  int _selectedIndex = 0; // Índice da aba selecionada
  final AutenticacaoServico _authServico =
      AutenticacaoServico(); // Instância do serviço de autenticação

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Função para fazer o logout
  void _fazerLogout() async {
    await _authServico.deslogarUsuario(); // Chama o método de logout do serviço
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logout realizado com sucesso!")),
    );
    // Após o logout, redireciona para a tela de login
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(
          Icons.person,
          color: Colors.black,
        ),
        centerTitle: true,
        title: const Text(
          "Dez 2017",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          // Botão de logout na AppBar
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _fazerLogout, // Chama a função de logout
          ),
        ],
      ),
      body: Center(
        child: Container(
          color: const Color(0xFFE0E0E0), // Fundo cinza claro
          child: const Center(
            child: Icon(
              Icons.add,
              size: 50,
              color: Colors.black,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ação ao pressionar o botão
        },
        backgroundColor: Colors.purple,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFE1BEE7), // Fundo lilás claro
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black45,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.note_alt_outlined),
            label: "Notas diárias",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_emotions_outlined),
            label: "Diário do medo",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: "Hábitos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: "Maps",
          ),
        ],
      ),
    );
  }
}
