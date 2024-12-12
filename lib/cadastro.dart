import 'package:flutter/material.dart';

class CadastroPage extends StatelessWidget {
  const CadastroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(
            255, 250, 247, 250), // Cor de fundo lilás claro em toda a tela
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo e título
                Column(
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 120,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Mood Journey",
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
                const SizedBox(height: 32),

                // Campos de entrada e botão de cadastro
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Campo de Nome de Usuário
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Nome de usuário:",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Campo de E-mail
                      TextField(
                        decoration: InputDecoration(
                          labelText: "E-mail:",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Campo de Senha
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Senha:",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: const Icon(Icons.visibility_off),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Checkbox "Aceito os termos de uso"
                      Row(
                        children: [
                          Checkbox(
                            value:
                                false, // Pode ser gerenciado por um StatefulWidget
                            onChanged: (bool? value) {},
                          ),
                          const Text("Aceito os termos de uso"),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Botão "Cadastrar-se"
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFBA68C8),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          // Lógica de cadastro
                        },
                        child: const Text(
                          "Cadastrar-se",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
