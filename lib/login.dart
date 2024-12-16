import 'package:flutter/material.dart';
import 'servicos/autenticacao.dart'; // Importa o serviço de autenticação
import 'utilidades/snackbar.dart'; // Importa o arquivo de configuração da SnackBar

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final AutenticacaoServico _authServico =
      AutenticacaoServico(); // Instância do serviço de autenticação

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

  // Função para realizar o login
  void _fazerLogin() async {
    String email = _emailController.text.trim();
    String senha = _senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      // Exibe a SnackBar com a cor vermelha (erro) se os campos estiverem vazios
      mostrarSnackBar(
        context: context,
        texto: "Preencha os campos",
        isErro: false,
      );
      return;
    }

    // Chama o método do serviço de autenticação
    String? erro = await _authServico.logarUsuarios(email: email, senha: senha);

    if (erro != null) {
      // Exibe a SnackBar com a cor vermelha (erro) caso haja erro no login
      mostrarSnackBar(
          context: context,
          texto:
              "Senha ou Email incorreto.Ou Usuário não cadastrado"); // caso queira ver o erro deixa assim : 'texto: erro'
    } else {
      // Exibe a SnackBar com a cor verde (sucesso) caso o login seja bem-sucedido
      mostrarSnackBar(
          context: context,
          texto: "Login realizado com sucesso!",
          isErro: false // Sucesso
          );
      // Navega para a tela de notas diárias
      Navigator.pushReplacementNamed(context, '/notas_diarias');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login",
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
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Campo Email
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: "Email"),
                    validator: validarEmail,
                  ),
                  // Campo Senha
                  TextFormField(
                    controller: _senhaController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Senha"),
                    validator: validarSenha,
                  ),
                  const SizedBox(height: 16.0),
                  // Botão de Login
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 186, 104, 200),
                        minimumSize: const Size(120, 50),),
                    onPressed:
                        _fazerLogin, // Chama a função de login ao pressionar o botão
                    child: const Text(
                      "Entrar",
                      style: TextStyle(
                        fontSize: 16, 
                        fontFamily: 'Roboto',
                        color: Colors.black)
                      ),
                  ),
                ],
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}
