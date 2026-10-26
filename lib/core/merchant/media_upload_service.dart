import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// À quoi sert la photo : décide du sous-dossier de stockage.
enum MediaKind {
  cover('cover'),
  offer('offers');

  final String folder;
  const MediaKind(this.folder);
}

/// Envoie les photos d'un commerce vers le bucket `merchant-media`.
///
/// Le chemin décide du droit d'écrire : `<business_id>/<dossier>/<horodatage>.<ext>`.
/// Une policy Storage n'autorise l'écriture que si le premier segment est un
/// commerce dont l'appelant est du personnel actif.
/// On envoie des octets (pas un chemin de fichier) pour que ça marche aussi sur le web.
class MediaUploadService {
  static const String bucket = 'merchant-media';
  static const double _maxSide = 1600; // réduit avant envoi : économise le réseau
  static const int _quality = 82;

  final ImagePicker _picker = ImagePicker();
  SupabaseClient get _client => Supabase.instance.client;

  /// Choisit une image, la réduit puis l'envoie. Rend l'URL publique,
  /// ou `null` si l'utilisateur ferme le sélecteur sans rien choisir.
  Future<String?> pickAndUpload({
    required String businessId,
    required MediaKind kind,
    ImageSource source = ImageSource.gallery,
  }) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: _maxSide,
      maxHeight: _maxSide,
      imageQuality: _quality,
    );
    if (picked == null) return null;

    final ext = _extension(picked.name, picked.mimeType);
    final path = '$businessId/${kind.folder}/'
        '${DateTime.now().millisecondsSinceEpoch}.$ext';

    await _client.storage.from(bucket).uploadBinary(
          path,
          await picked.readAsBytes(),
          fileOptions: FileOptions(contentType: _contentType(ext), upsert: true),
        );
    return _client.storage.from(bucket).getPublicUrl(path);
  }

  /// Extension fiable : le nom du fichier d'abord, sinon le type MIME.
  static String _extension(String name, String? mime) {
    final raw = name.contains('.') ? name.split('.').last.toLowerCase() : '';
    if (raw == 'png' || raw == 'webp') return raw;
    if (raw == 'jpg' || raw == 'jpeg') return 'jpg';
    if (mime == 'image/png') return 'png';
    if (mime == 'image/webp') return 'webp';
    return 'jpg';
  }

  static String _contentType(String ext) => switch (ext) {
        'png' => 'image/png',
        'webp' => 'image/webp',
        _ => 'image/jpeg',
      };
}
