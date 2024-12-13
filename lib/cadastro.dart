import 'package:flutter/material.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  // Função de validação para o campo de nome
  String? validarNome(String? value) {
    if (value == null || value.isEmpty) {
      return "O nome não pode ser vazio";
    }
    if (value.length < 4) {
      return "O nome é muito curto";
    }
    return null;
  }

  // Função de validação para o campo de email
  String? validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "O email não pode ser vazio";
    }
    if (value.length < 5) {
      return "Email inválido";
    }
    if (!value.contains('@')) {
      return "O email não é válido";
    }
    return null;
  }

  // Função de validação para o campo de senha
  String? validarSenha(String? value) {
    if (value == null || value.isEmpty) {
      return "A senha não pode ser vazia";
    }
    if (value.length < 4) {
      return "A senha precisa ter no mínimo 4 caracteres";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centraliza os campos na tela
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Campo Nome
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    border: UnderlineInputBorder(),
                  ),
                  validator: validarNome,
                ),
                SizedBox(height: 20), // Espaço entre os campos

                // Campo Email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    border: UnderlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: validarEmail,
                ),
                SizedBox(height: 20), // Espaço entre os campos

                // Campo Senha
                TextFormField(
                  controller: _senhaController,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    border: UnderlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: validarSenha,
                ),
                SizedBox(height: 30), // Espaço entre os campos e o botão

                // Botão de Cadastro
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromARGB(255, 186, 104, 200), // Cor do botão
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Processar os dados (por exemplo, fazer cadastro)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Cadastro realizado com sucesso')),
                      );
                    }
                  },
                  child: const Text(
                    'Cadastrar',
                    style: TextStyle(fontSize: 16, color: Colors.black),
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
