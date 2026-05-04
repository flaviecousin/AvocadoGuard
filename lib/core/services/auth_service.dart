// Importations des bibliothèques de Firebase et Firestore
import 'package:cloud_firestore/cloud_firestore.dart'; // pour accéder à la base de données
import 'package:firebase_auth/firebase_auth.dart'; // pour l'authentification

class AuthService {
  // Classe pour gérer les opérations d'authentification des utilisateurs:
  // connexion, déconnexion, inscription, réinitialisation mot de passe et email
  final FirebaseAuth _auth = FirebaseAuth.instance; // Variable permettant d'interagir avec Firebase Auth

  // Inscription d'un nouvel utilisateur avec création du profil sur Firebase
  Future<String?> register(String email, String password, String role) async {
    try {
      // Crée le compte Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(  // ← credential ajouté
        email: email,
        password: password,
      );
      // Sauvegarde le profil de l'utilisateur dans Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid) // Identifiant unique de l'utilisateur
          .set({
            'email': email,
            'role': role,  // ← maintenant accessible
            'darkMode':false, // Préférence du thème par défaut (thème clair)
            'locale':'fr', // Langue par défaut
            'createdAt': DateTime.now().toIso8601String(),
          }, SetOptions(merge: true)); // Merge : pour ne pas écraser les champs existants
      return null; // Retour null en cas de succès
    } on FirebaseAuthException catch (e) {
      // Gestion des erreurs Firebase Auth
      switch (e.code) {
        case 'email-already-in-use':
          return 'Cet email est déjà utilisé';
        case 'weak-password':
          return 'Mot de passe trop faible';
        case 'invalid-email':
          return 'Email invalide';
        default:
          return 'Erreur : ${e.message}';
      }
    }
  }

  // Connexion
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // retourne null en cas de succès
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'Aucun compte avec cet email';
        case 'wrong-password':
          return 'Mot de passe incorrect';
        case 'invalid-email':
          return 'Email invalide';
        default:
          return 'Erreur : ${e.message}';
      }
    }
  }

  // Déconnexion de l'utilisateur déjà connecté
  Future<void> logout() async => await _auth.signOut();

  // Retourne l'utilisateur déjà connecté (null si déconnecté)
  User? get currentUser => _auth.currentUser;

  // Vérifie si un utilisateur est connecté
  bool get isLoggedIn => _auth.currentUser != null;

  // Réinitialisation mot de passe
  Future<String?> resetPassword(String email) async {
    // Permet d'envoyer un mail de réinitialisatoin de mot de passe
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null; // retourne null en cas de succès
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'Aucun compte avec cet email';
        case 'invalid-email':
          return 'Email invalide';
        default:
          return 'Erreur : ${e.message}';
      }
    }
  }

  // Réinitialisation de l'email
  Future<String?> updateEmail(String newEmail) async {
    // Permet à Firebase Auth d'envoyer un email de vérification avant de mettre à jour l'adresse mail
    // Le changement n'est effectif que si l'utilisateur valide
    try {
      await _auth.currentUser!.verifyBeforeUpdateEmail(newEmail);
      return null; // retourne null en cas de succès
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email': return 'Email invalide';
        case 'email-already-in-use': return 'Email déjà utilisé';
        default: return 'Erreur : ${e.message}';
      }
    }
  }
}