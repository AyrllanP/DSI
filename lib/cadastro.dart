import 'package:flutter/material.dart';
import 'servicos/autenticacao.dart'; // Importe o serviço de autenticação
import 'utilidades/snackbar.dart'; // Importe a função SnackBar

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final AutenticacaoServico _authServico = AutenticacaoServico();

  // Validações continuam iguais
  String? validarNome(String? value) {
    if (value == null || value.isEmpty) {
      return "O nome não pode ser vazio";
    }
    if (value.length < 4) {
      return "O nome é muito curto";
    }
    return null;
  }

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

  String? validarSenha(String? value) {
    if (value == null || value.isEmpty) {
      return "A senha não pode ser vazia";
    }
    if (value.length < 4) {
      return "A senha precisa ter no mínimo 4 caracteres";
    }
    return null;
  }

  // Função para processar o cadastro
  void _processarCadastro() async {
    if (_formKey.currentState?.validate() ?? false) {
      String? erro = await _authServico.cadastrarUsuario(
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        senha: _senhaController.text.trim(),
      );

      if (erro != null) {
        // Exibe erro
        mostrarSnackBar(context: context, texto: erro);
      } else {
        // Sucesso
        mostrarSnackBar(
          context: context,
          texto: "Cadastro realizado com sucesso!",
          isErro: false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastro',
          style: TextStyle(fontSize: 16, color: Colors.black)
        ),
      ),
      body: 
      Column(
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
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                        border: UnderlineInputBorder(),
                      ),
                      validator: validarNome,
                    ),
                    // const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                        border: UnderlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: validarEmail,
                    ),
                    // const SizedBox(height: 20),
                    TextFormField(
                      controller: _senhaController,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                        border: UnderlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: validarSenha,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 186, 104, 200),
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                      ),
                      onPressed: _processarCadastro,
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
        ]
      )
    );
  }
}
