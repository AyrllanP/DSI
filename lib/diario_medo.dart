import 'package:flutter/material.dart';
import 'package:projeto_dsi/habitos.dart';
import 'package:projeto_dsi/mapas.dart';
import 'package:projeto_dsi/notas_diarias.dart';
import 'servicos/autenticacao.dart'; // Importa o serviço de autenticação

class DiarioMedo {
  
}

class DiarioMedoPage extends StatefulWidget {
  @override
  _DiarioMedoPageState createState() => _DiarioMedoPageState();


}

class _DiarioMedoPageState extends State<DiarioMedoPage> {
  int _selectedIndex = 1;
  final AutenticacaoServico _authServico =
      AutenticacaoServico(); // Instância do serviço de autenticação

  // Função para fazer o logout
  void _fazerLogout() async {
    await _authServico.deslogarUsuario(); // Chama o método de logout do serviço
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logout realizado com sucesso!")),
    );
    // Após o logout, redireciona para a tela de login
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _onItemTapped(int index){
    switch (index) {
      case 0:
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder:(context) => NotasDiariasPage()),
      );
        break;

      case 1:
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder:(context) => DiarioMedoPage()),
      );
        break;
      
      case 2:
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder:(context) => HabitosPage()),
      );
        break;

      case 3: 
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder:(context) => MapasPage()),
      );
        break;
    }
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
      body: const Center(
        child: Text('Diário do Medo')
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
