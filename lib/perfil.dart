import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaPerfil(),
    );
  }
}

class TelaPerfil extends StatefulWidget {
  @override
  _TelaPerfilState createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  final TextEditingController _novaSenhaController = TextEditingController();
  final TextEditingController _senhaAtualController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
  }

  void _carregarUsuario() async {
    await Future.delayed(Duration(seconds: 2)); // Garante que o Firebase inicializou
    User? user = _auth.currentUser;
    setState(() {
      _user = user;
    });
    print('Usuário logado: ${_user?.email}');
  }

  void _alterarSenha() async {
    if (_novaSenhaController.text.isEmpty || _senhaAtualController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    try {
      print('Reautenticando usuário...');
      print('Reautenticando com email: ${_user!.email} e senha: ${_senhaAtualController.text}');

      // Reautenticar o usuário
      AuthCredential credential = EmailAuthProvider.credential(
        email: _user!.email!,
        password: _senhaAtualController.text,
      );
      await _user!.reauthenticateWithCredential(credential);
      print('Reautenticação bem-sucedida.');

      // Alterar a senha
      print('Alterando senha...');
      print('Nova senha: ${_novaSenhaController.text}');
      await _user!.updatePassword(_novaSenhaController.text);
      print('Senha alterada com sucesso.');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Senha alterada com sucesso!')),
      );

      // Limpar os campos após a alteração da senha
      _senhaAtualController.clear();
      _novaSenhaController.clear();
    } on FirebaseAuthException catch (e) {
      print('Erro ao alterar senha: ${e.code} - ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao alterar senha: ${e.message}')),
      );
    } catch (e) {
      print('Erro desconhecido: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro desconhecido: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Perfil",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          )
,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://picsum.photos/150', // Link alternativo
              ),
              onBackgroundImageError: (exception, stackTrace) {
                print('Erro ao carregar a imagem: $exception');
              },
              child: Text('Erro ao carregar'), // Texto exibido em caso de erro
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              controller: TextEditingController(text: _user?.displayName ?? 'Nome não disponível'),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              controller: TextEditingController(text: _user?.email ?? 'Email não disponível'),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Senha Atual',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              controller: _senhaAtualController,
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nova Senha',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              controller: _novaSenhaController,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _alterarSenha,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                shape: RoundedRectangleBorder( // Borda arredondada
                  borderRadius: BorderRadius.circular(10), // Raio da borda
                ),
              ),
              child: Text('Alterar Senha'),
            ),
          ],
        ),
      ),
    );
  }
}