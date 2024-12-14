import 'package:firebase_auth/firebase_auth.dart';

class AutenticacaoServico {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Cadastro de usuário
  Future<String?> cadastrarUsuario({
    required String nome,
    required String email,
    required String senha,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      // Atualiza o nome do usuário
      await userCredential.user!.updateDisplayName(nome);
      return null; // Sem erro
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        return "O usuário já está cadastrado.";
      }
      return "Erro desconhecido.";
    }
  }

  // Login de usuário
  Future<String?> logarUsuarios({
    required String email,
    required String senha,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: senha);
      return null; // Sucesso
    } on FirebaseAuthException catch (e) {
      print('Erro capturado: $e');
      return e.message; // Retorna a mensagem de erro
    }
  }

  // Logout de usuário
  Future<void> deslogarUsuario() async {
    await _firebaseAuth.signOut();
  }

  void setState(Null Function() param0) {}
}
