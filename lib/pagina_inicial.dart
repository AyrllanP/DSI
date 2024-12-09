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
      body: Container(
        color: const Color(0xFFF8EAF6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            Column(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.flight,
                      color: Colors.purple.shade200,
                      size: 50,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Mood Journey",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const Spacer(flex: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBA68C8),
                    minimumSize: const Size(120, 50),
                  ),
                  onPressed: () {},
                  child: const Text("Entrar",
                      style: TextStyle(fontSize: 16, color: Colors.black)),
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
