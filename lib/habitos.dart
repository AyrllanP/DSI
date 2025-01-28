import 'package:flutter/material.dart';
import 'package:projeto_dsi/diario_medo.dart';
import 'package:projeto_dsi/entrada_habitos.dart';
import 'package:projeto_dsi/mapas.dart';
import 'package:projeto_dsi/notas_diarias.dart';
import 'servicos/autenticacao.dart'; // Importa o serviço de autenticação
import 'package:table_calendar/table_calendar.dart'; // Para usar o calendário


class Habito {
  String nome;
  String descricao;
  String frequencia;
  List<String>? dias;

  Habito({
    required this.nome,
    required this.descricao,
    required this.frequencia,
    this.dias,
  });
}

class HabitosPage extends StatefulWidget {
  @override
  _HabitosPageState createState() => _HabitosPageState();


}

class _HabitosPageState extends State<HabitosPage> {
  int _selectedIndex = 2;
  final AutenticacaoServico _authServico =
      AutenticacaoServico(); // Instância do serviço de autenticação

  // para os hábitos
  final List<Habito> _habitos = [];

  // Tratar questões do calendário
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  // Função para fazer o logout
  void _fazerLogout() async {
    await _authServico.deslogarUsuario(); // Chama o método de logout do serviço
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logout realizado com sucesso!")),
    );
    // Após o logout, redireciona para a tela de login
    Navigator.pushReplacementNamed(context, '/login');
  }
  // Crud - Criar
  void _criarHabito() async {
    final resultado = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => const EntradaHabitosPage()
      ),
    );
    if (resultado != null){
      setState(() {
        _habitos.add(Habito(
          nome: resultado['habito'],
          descricao: resultado['descricao'] ?? '',
          frequencia: resultado['frequencia'] ?? 'Todos os dias',
          dias: resultado['dias'],
        ));
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hábito criado")),
      );
    }
  }
  // Crud - Editar
  void _editarHabito(int index) async{
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntradaHabitosPage(
          habito: _habitos[index].nome,
          descricao: _habitos[index].descricao,
          frequencia: _habitos[index].frequencia,
        ),
      ),
    );
    if (resultado != null) {
      setState(() {
        _habitos[index] = Habito(
          nome: resultado['habito'],
          descricao: resultado['descricao'] ?? '',
          frequencia: resultado['frequencia'] ?? 'Todos os dias',
          dias: resultado['dias'],
        );
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Hábito editado com sucesso!")),
      );
    }
  }
  // Crud - Deletar
  void _deletarHabito(int index) {
    setState(() {
      _habitos.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Hábito deletado com sucesso!")),
    );
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
          "Gerenciar hábitos",
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
      body: Column(
        children:[
          TableCalendar(
            locale: 'pt_BR',
            firstDay: DateTime(2020, 1, 1),
            lastDay: DateTime(2100, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay){
              setState((){
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.purple.shade200,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color:Colors.purple,
                shape:BoxShape.circle
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Crud - Ler
          Expanded(
            child: ListView.builder(
              itemCount: _habitos.length,
              itemBuilder: (context, index){
                final habito = _habitos[index];
                return Card(
                  child: ListTile(
                    title: Text(habito.nome),
                    subtitle: Text(habito.descricao),
                    onTap: () {
                      _editarHabito(index); // Abre o diálogo para editar a nota
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deletarHabito(index), // Deleta a nota
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),    
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _criarHabito(), // Abre o diálogo para adicionar uma nova nota
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
