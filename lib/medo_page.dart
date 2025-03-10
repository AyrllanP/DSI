import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MedoPage extends StatefulWidget {
  final String? idMedo;
  final String? medo;
  final String? preocupacao;
  final String? prevenir;
  final String? corrigir;
  final String? beneficios;

  MedoPage({
    this.idMedo,
    this.medo,
    this.preocupacao,
    this.prevenir,
    this.corrigir,
    this.beneficios,
  });

  @override
  _MedoPageState createState() => _MedoPageState();
}

class _MedoPageState extends State<MedoPage> {
  late TextEditingController _medoController;
  late TextEditingController _preocupacaoController;
  late TextEditingController _prevenirController;
  late TextEditingController _corrigirController;
  late TextEditingController _beneficiosController;
  final user = FirebaseAuth.instance.currentUser;

  bool get _isEditMode => widget.idMedo != null;

  @override
  void initState() {
    super.initState();
    _medoController = TextEditingController(text: widget.medo ?? '');
    _preocupacaoController =
        TextEditingController(text: widget.preocupacao ?? '');
    _prevenirController = TextEditingController(text: widget.prevenir ?? '');
    _corrigirController = TextEditingController(text: widget.corrigir ?? '');
    _beneficiosController =
        TextEditingController(text: widget.beneficios ?? '');
  }

  @override
  void dispose() {
    _medoController.dispose();
    _preocupacaoController.dispose();
    _prevenirController.dispose();
    _corrigirController.dispose();
    _beneficiosController.dispose();
    super.dispose();
  }

  void _salvarMedo() async {
    final medoData = {
      'medo': _medoController.text,
      'preocupacao': _preocupacaoController.text,
      'prevenir': _prevenirController.text,
      'corrigir': _corrigirController.text,
      'beneficios': _beneficiosController.text,
      'userId': user?.uid,
    };

    if (_isEditMode) {
      await FirebaseFirestore.instance
          .collection('medos')
          .doc(widget.idMedo)
          .update(medoData);
    } else {
      await FirebaseFirestore.instance.collection('medos').add(medoData);
    }

    Navigator.pop(context);
  }

  Widget _buildInputCard(
      String title, String hintText, TextEditingController controller,
      {bool isRed = false, bool isGray = false}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isRed
            ? Colors.red.shade100
            : isGray
                ? Colors.grey.shade200
                : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: isRed ? Border.all(color: Colors.red) : null,
      ),
      child: Row(
        children: [
          if (isRed) ...[
            Icon(FontAwesomeIcons.skull, color: Colors.red),
            SizedBox(width: 10),
          ],
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_isEditMode ? 'Editar Medo' : 'Novo Medo'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribui espaço entre os elementos
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  _buildInputCard("DESCREVA SEU MEDO:", "Descreva seu medo ...", _medoController, isRed: true),
                  SizedBox(height: 10),
                  _buildInputCard("IDENTIFIQUE SUA PREOCUPAÇÃO:", "Do que você tem medo que pode acontecer...", _preocupacaoController, isGray: true),
                  SizedBox(height: 10),
                  _buildInputCard("COMO PREVENIR:", "O que você pode fazer para evitar que sua preocupação aconteça...", _prevenirController, isGray: true),
                  SizedBox(height: 10),
                  _buildInputCard("COMO CORRIGIR:", "O que você pode fazer se sua preocupação realmente acontecer...", _corrigirController, isGray: true),
                  SizedBox(height: 10),
                  _buildInputCard("QUAIS OS BENEFÍCIOS DO SUCESSO:", "O que vai acontecer de bom quando você superar o medo...", _beneficiosController, isGray: true),
                ],
              ),
            ),
          ),

          // Alinhando os botões ao final da página
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: Colors.black,
                  child: Icon(Icons.close, color: Colors.white),
                ),
                FloatingActionButton(
                  onPressed: _salvarMedo,
                  backgroundColor: Colors.black,
                  child: Icon(Icons.check, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
