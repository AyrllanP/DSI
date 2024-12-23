import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AutenticacaoServico {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  // Adicionar uma nota no Firestore
  Future<void> adicionarNota(String titulo, String texto) async {
    // Obtém o usuário autenticado
    User? user = _firebaseAuth.currentUser;

    if (user != null) {
      try {
        // Armazenar a nota do usuário no Firestore
        await _firestore
            .collection('Notas') // Coleção de notas
            .doc(user.uid) // Documento usando o ID do usuário
            .collection('usuario_notas') // Subcoleção de notas do usuário
            .add({
          'titulo': titulo,
          'texto': texto,
          'data': DateTime.now(), // Adiciona a data de criação da nota
        });
      } catch (e) {
        print("Erro ao adicionar nota: $e");
      }
    } else {
      print("Usuário não autenticado.");
    }
  }

  void setState(Null Function() param0) {}
}
