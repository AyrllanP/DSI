import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MedoPage extends StatefulWidget {
  @override
  _MedoPageState createState() => _MedoPageState();
}

class _MedoPageState extends State<MedoPage> {
  final TextEditingController _medoController = TextEditingController();

  Widget _buildInputCard(String title, String hintText) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.black54),
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Envolve tudo para evitar overflow
        child: Padding(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.skull, color: Colors.red),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _medoController,
                        decoration: InputDecoration(
                          hintText: "Descreva seu medo ...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              _buildInputCard("IDENTIFIQUE SUA PREOCUPAÇÃO:",
                  "Do que você tem medo que pode acontecer..."),
              _buildInputCard("COMO PREVENIR:",
                  "O que você pode fazer para evitar que sua preocupação aconteça..."),
              _buildInputCard("COMO CORRIGIR:",
                  "O que você pode fazer se sua preocupação realmente acontecer..."),
              _buildInputCard("QUAIS OS BENEFÍCIOS DO SUCESSO:",
                  "O que vai acontecer de bom quando você superar o medo..."),
              SizedBox(height: 20), // Adiciona espaço antes dos botões
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, size: 30),
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
                      icon: Icon(Icons.check_circle, size: 30),
                      onPressed: () {
                        // Adicionar funcionalidade de salvar
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
