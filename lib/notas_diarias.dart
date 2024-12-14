import 'package:flutter/material.dart';
import 'servicos/autenticacao.dart'; // Importa o serviço de autenticação

class Nota {
  String titulo;
  DateTime data;
  String texto;

  Nota({required this.titulo, required this.data, required this.texto});
}

class NotasDiariasPage extends StatefulWidget {
  @override
  _NotasDiariasPageState createState() => _NotasDiariasPageState();
}

class _NotasDiariasPageState extends State<NotasDiariasPage> {
  int _selectedIndex = 0; // Índice da aba selecionada
  final AutenticacaoServico _authServico =
      AutenticacaoServico(); // Instância do serviço de autenticação

  List<Nota> _notas = []; // Lista para armazenar as notas

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

  // Função para adicionar ou editar uma nota
  void _adicionarOuEditarNota([Nota? notaEditada]) async {
    final nota = await showDialog<Nota>(
      context: context,
      builder: (BuildContext context) {
        return DialogAdicionarNota(notaEditada: notaEditada);
      },
    );

    if (nota != null) {
      if (notaEditada == null) {
        setState(() {
          _notas.add(nota); // Adiciona a nova nota
        });
      } else {
        setState(() {
          int index = _notas.indexOf(notaEditada);
          _notas[index] = nota; // Atualiza a nota editada
        });
      }
    }
  }

  // Função para excluir uma nota
  void _deletarNota(Nota nota) {
    setState(() {
      _notas.remove(nota); // Remove a nota da lista
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Nota excluída com sucesso!")),
    );
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
      body: _notas.isEmpty
          ? const Center(child: Text('Nenhuma nota cadastrada.'))
          : ListView.builder(
              itemCount: _notas.length,
              itemBuilder: (context, index) {
                final nota = _notas[index];
                return Card(
                  child: ListTile(
                    title: Text(nota.titulo),
                    subtitle: Text('${nota.data.toLocal()} - ${nota.texto}'),
                    onTap: () {
                      _adicionarOuEditarNota(
                          nota); // Abre o diálogo para editar a nota
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deletarNota(nota), // Deleta a nota
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _adicionarOuEditarNota(), // Abre o diálogo para adicionar uma nova nota
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

class DialogAdicionarNota extends StatefulWidget {
  final Nota? notaEditada;

  DialogAdicionarNota({this.notaEditada});

  @override
  _DialogAdicionarNotaState createState() => _DialogAdicionarNotaState();
}

class _DialogAdicionarNotaState extends State<DialogAdicionarNota> {
  final _tituloController = TextEditingController();
  final _textoController = TextEditingController();
  DateTime _dataSelecionada = DateTime.now();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.notaEditada != null) {
      _tituloController.text = widget.notaEditada!.titulo;
      _textoController.text = widget.notaEditada!.texto;
      _dataSelecionada = widget.notaEditada!.data;
    }
  }

  // Função para salvar a nota
  void _salvarNota() {
    if (_formKey.currentState!.validate()) {
      final novaNota = Nota(
        titulo: _tituloController.text,
        data: _dataSelecionada,
        texto: _textoController.text,
      );

      Navigator.of(context)
          .pop(novaNota); // Retorna a nova ou editada nota para o pai
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text(widget.notaEditada == null ? 'Adicionar Nota' : 'Editar Nota'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Campo para o título
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O título não pode ser vazio';
                  }
                  return null;
                },
              ),
              // Seletor de data
              ListTile(
                title: Text(
                    'Data: ${_dataSelecionada.toLocal().toString().split(' ')[0]}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? novaData = await showDatePicker(
                    context: context,
                    initialDate: _dataSelecionada,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (novaData != null && novaData != _dataSelecionada) {
                    setState(() {
                      _dataSelecionada = novaData;
                    });
                  }
                },
              ),
              // Campo para o texto
              TextFormField(
                controller: _textoController,
                decoration: InputDecoration(labelText: 'Texto'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O texto não pode ser vazio';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cancela
          },
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _salvarNota,
          child: Text(widget.notaEditada == null ? 'Salvar' : 'Atualizar'),
        ),
      ],
    );
  }
}
