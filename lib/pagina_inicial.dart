import 'package:flutter/material.dart';

void main() {
  runApp(const MoodJourneyApp());
}

class MoodJourneyApp extends StatelessWidget {
  const MoodJourneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MoodJourneyHome(),
    );
  }
}

class MoodJourneyHome extends StatelessWidget {
  const MoodJourneyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Conteúdo principal no centro
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Imagem do logo
                  Image.asset(
                    'assets/logo.png',
                    height: 120,
                  ),
                  const SizedBox(height: 20), // Espaço
                  // Nome do app
                  const Text(
                    'Mood\nJourney',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF221736),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Botões na parte inferior
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                   style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBA68C8),
                    minimumSize: const Size(120, 50),
                  ),
                  onPressed: () {
                    // Ação para o botão da esquerda
                  },
                  child: const Text(
                    'Entrar',
                    style: TextStyle(fontSize: 16, color: Colors.black)
                  ),
                  
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black),
                    minimumSize: const Size(120, 50),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Cadastro",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
