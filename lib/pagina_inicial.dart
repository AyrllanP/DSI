import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'login.dart';
import 'cadastro.dart';
import 'notas_diarias.dart'; // Tela principal após login bem-sucedido
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting('pt_BR', null);

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
        '/cadastro': (context) => CadastroPage(),
        '/notas_diarias': (context) =>
            NotasDiariaPage(), // Rota para Notas Diárias
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
                    height: 75,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Mood\nJourney',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
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
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        color: Colors.black),
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black),
                    minimumSize: const Size(120, 50),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/cadastro');
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

class RoteadorTela extends StatelessWidget {
  const RoteadorTela({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Stream de autenticação
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          // Usuário logado, vai para a tela de Notas Diárias
          return NotasDiariaPage();
        } else {
          // Usuário não logado, vai para a tela inicial com os botões de login e cadastro
          return const MoodJourneyHome();
        }
      },
    );
  }
}
