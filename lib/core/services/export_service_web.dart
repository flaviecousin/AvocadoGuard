// Importations des bibliothèques nécessaires
import 'dart:convert'; // pour pouvoir encoder le contenu CSV en bytes UTF-8
import 'dart:js_interop'; // pour pouvoir convertir les objets Dart en objets JavaScript
import 'package:web/web.dart' as web; // Pour la manipulation des fichiers sur navigateurs web

void exportCsv(String csv, String filename) {
  // Fonction permettant de télécharger un fichier CSV depuis un navigateur web
  final bytes = utf8.encode(csv); // conversion du contenu CSV (String) en liste de bytes encodés en UTF-8
  final blob = web.Blob( // Crée un objet Blob (fichier en mémoire dans le navigateur)
    [bytes.buffer.toJS].toJS,
    // bytes.buffer : les bytes bruts en mémoire
    // .toJS : convertit le buffer Dart en objet JavaScrupt lisible par le navigateur
    // [].toJS : convertit la liste Dart en tableau JavaScript
    web.BlobPropertyBag(type: 'text/csv;charset=utf-8'),  // Précise au navigateur que le fichier CSV est en encodé en UTF-8
  );
  final url = web.URL.createObjectURL(blob); // Génère une URL temporaire pointant vers le Blob en mémoire
  (web.document.createElement('a') as web.HTMLAnchorElement)
  // Crée un élément <a> (lien HTML) invisible dans le DOM
  // et le caste en HTMLAnchorElement pour accéder à ses propriétés
    ..href = url // pointe le lien vers l'url temporaire du Blob
    ..setAttribute('download', filename) // force le navigateur à télécharger le fichier avec le nom donné, sans ça le navigateur ouvrirait uniquement le document sans le télécharger
    ..click(); // déclenche le clic // simule un clic sur le lien => déclenche le téléchargement
  web.URL.revokeObjectURL(url); // libère la mémoire en supprimant l'url temporaire du Blob
}