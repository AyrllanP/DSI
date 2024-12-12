import 'package:flutter/material.dart';
import 'cadastro.dart'; // Importe a nova página
import 'login.dart';

void main() {
  runApp(const MoodJourneyApp());
}

class MoodJourneyApp extends StatelessWidget {
  const MoodJourneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const MoodJourneyHome(),
        '/login': (context) => LoginPage(),
        '/cadastro': (context) =>
            const CadastroPage(), // Rota para a página de cadastro
      },
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
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 120,
                  ),
                  const SizedBox(height: 20),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 186, 104, 200),
                    minimumSize: const Size(120, 50),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text(
                    'Entrar',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black),
                    minimumSize: const Size(120, 50),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context,
                        '/cadastro'); // Navega para a página de cadastro
                  },
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
