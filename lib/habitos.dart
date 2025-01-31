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
  Map<String, bool> statusDiario;

  Habito({
    required this.nome,
    required this.descricao,
    required this.frequencia,
    this.dias,
    Map<String, bool>? statusDiario,
  }): statusDiario = statusDiario ?? {};
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
        const SnackBar(content: Text("Hábito editado")),
      );
    }
  }
  // Crud - Deletar
  void _deletarHabito(int index) {
    setState(() {
      _habitos.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Hábito deletado")),
    );
  }
  // Identificar frequência do hábito
  List<Habito> _getHabitosDoDia(DateTime day){
    String diaSemana = _obterDiaSemana(day);

    return _habitos.where((habito) {
      if (habito.frequencia == "Todos os dias"){
        return true;
      } else if (habito.dias != null && habito.dias!.contains(diaSemana)){
        return true;
      }
      return false;
    }).toList();
  }

  String _obterDiaSemana(DateTime date){
    List<String> diasSemana = ["dom", "seg", "ter", "qua", "qui", "sex", "sáb"];
    return diasSemana[date.weekday % 7];
  }

  // Filtrar hábitos

  List<Habito> _getHabitosDoDiaSelecionado(){
    String diaSemana = _obterDiaSemana(_selectedDay);

    return _habitos.where((habito) {
      if (habito.frequencia == "Todos os dias"){
        return true;
      } else if (habito.dias != null && habito.dias!.contains(diaSemana)){
        return true;
      }
      return false;
    }).toList();
  }

  // Barra de navegação
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
            eventLoader: _getHabitosDoDia,
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
              itemCount: _getHabitosDoDiaSelecionado().length,
              itemBuilder: (context, index){
                final habito = _getHabitosDoDiaSelecionado()[index];
                final String dataAtual = _selectedDay.toIso8601String().split("T")[0];

                return Dismissible(
                  key: Key(habito.nome),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon (Icons.delete, color: Colors.white,),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context, 
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: const Text("Confirmar exclusão"),
                          content: Text("Tem certeza que deseja excluir o hábito?"),
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
                      }
                    );
                  },
                  onDismissed: (direction){
                    _deletarHabito(index);
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(habito.nome),
                      subtitle: Text(habito.descricao),
                      onTap: () {
                        _editarHabito(index); 
                      },
                      trailing: Checkbox(
                          value: habito.statusDiario.containsKey(dataAtual) ? habito.statusDiario[dataAtual]! : false,
                          onChanged: (bool? value){
                            setState(() {
                              habito.statusDiario[dataAtual] = value ?? false;
                            });
                          },
                        ), 
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
            _criarHabito(), 
        backgroundColor: Colors.purple,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFE1BEE7), 
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
