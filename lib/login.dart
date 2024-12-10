import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  // Para o formulário
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginPage({super.key});

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
                  // Imagem do logo
                  Image.asset(
                    'assets/logo.png',
                    height: 80,
                  ),
                  const SizedBox(height: 20),
                  // Nome do app
                  const Text(
                    'Mood\nJourney',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF221736),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Inputs de texto
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Nome de usuário ou email:',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Color(0xFF221736),
                          ),
                        ),
                        const SizedBox(height: 8), 
                        SizedBox(
                            width: 300, 
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: "Digite seu nome",
                                border: OutlineInputBorder(),
                              ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Insira seu nome de usuário ou email';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16), 

                        const Text(
                          'Senha:',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Color(0xFF221736),
                          ),
                        ),
                        const SizedBox(height: 8), // Espaço entre label e campo
                        SizedBox(
                            width: 300,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: "Digite sua senha",
                                border: OutlineInputBorder(),
                              ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Insira sua senha';
                              }
                              return null;
                            },
                          )
                        ),

                        const SizedBox(height: 20), // Espaço entre os campos

                        
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFBA68C8),
                            minimumSize: const Size(120, 50),
                          ),
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Processando...')),
                              );
                            }
                          },
                          child: const Text(
                            "Enviar",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
