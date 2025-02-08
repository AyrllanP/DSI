import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditarNotaPage extends StatefulWidget {
  final String? idNota;
  final String? titulo;
  final String? conteudo;

  EditarNotaPage({this.idNota, this.titulo, this.conteudo});

  @override
  _EditarNotaPageState createState() => _EditarNotaPageState();
}

class _EditarNotaPageState extends State<EditarNotaPage> {
  late TextEditingController _tituloController;
  late TextEditingController _conteudoController;
  late bool _isEditMode;
  late String _dataNota;

  int _emojiIndex = 0;

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
  void initState() {
    super.initState();
    _isEditMode = widget.idNota != null;
    _tituloController = TextEditingController(text: widget.titulo ?? '');
    _conteudoController = TextEditingController(text: widget.conteudo ?? '');
    _dataNota = DateFormat('dd/MM/yyyy').format(DateTime.now());

    if (_isEditMode) {
      FirebaseFirestore.instance
          .collection('notas')
          .doc(widget.idNota)
          .get()
          .then((doc) {
        if (doc.exists) {
          setState(() {
            _emojiIndex = doc['emojiSelecionado'] ?? 0;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _conteudoController.dispose();
    super.dispose();
  }

  void _mudarEmoji(int delta) {
    setState(() {
      _emojiIndex = (_emojiIndex + delta) % _emojis.length;
      if (_emojiIndex < 0) {
        _emojiIndex = _emojis.length - 1;
      }
    });
  }

  Future<void> _salvarNota() async {
    String titulo = _tituloController.text.trim();
    String conteudo = _conteudoController.text.trim();
    User? usuarioAtual = FirebaseAuth.instance.currentUser;

    if (titulo.isEmpty || conteudo.isEmpty || usuarioAtual == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    try {
      if (_isEditMode) {
        await FirebaseFirestore.instance
            .collection('notas')
            .doc(widget.idNota)
            .update({
          'titulo': titulo,
          'nota': conteudo,
          'dataAtualizacao': FieldValue.serverTimestamp(),
          'emojiSelecionado': _emojiIndex,
        });
      } else {
        await FirebaseFirestore.instance.collection('notas').add({
          'titulo': titulo,
          'nota': conteudo,
          'dataCriacao': FieldValue.serverTimestamp(),
          'emojiSelecionado': _emojiIndex,
          'emailUsuario':
              usuarioAtual.email, // Associa a nota ao usuário autenticado
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(_isEditMode ? 'Nota atualizada!' : 'Nota criada!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar nota. Tente novamente.')),
      );
    }
  }

  Future<void> _excluirNota() async {
    try {
      if (widget.idNota != null) {
        await FirebaseFirestore.instance
            .collection('notas')
            .doc(widget.idNota)
            .delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nota excluída com sucesso!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir nota. Tente novamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: () => _mudarEmoji(-1),
                  ),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: Icon(
                      _emojis[_emojiIndex],
                      key: ValueKey<int>(_emojiIndex),
                      color: _emojiColors[_emojiIndex],
                      size: 60,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_right),
                    onPressed: () => _mudarEmoji(1),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _dataNota,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _tituloController,
                        decoration: InputDecoration(
                          labelText: 'Título',
                          border: UnderlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _conteudoController,
                        decoration: InputDecoration(
                          hintText: 'Digite sua nota diária ...',
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    onPressed: () => Navigator.pop(context),
                    backgroundColor: Colors.black,
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                  FloatingActionButton(
                    onPressed: _salvarNota,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.check, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
