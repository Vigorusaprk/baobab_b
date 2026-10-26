import 'package:baobab_business/core/merchant/media_upload_service.dart';
import 'package:baobab_business/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Champ photo : montre l'image actuelle et permet d'en envoyer une depuis
/// la galerie ou l'appareil photo. Remplace la saisie d'une URL.
class ImageUploadField extends StatefulWidget {
  final String businessId;
  final MediaKind kind;
  final String? value; // URL actuelle
  final ValueChanged<String?> onChanged;
  const ImageUploadField({
    super.key,
    required this.businessId,
    required this.value,
    required this.onChanged,
    this.kind = MediaKind.offer,
  });

  @override
  State<ImageUploadField> createState() => _ImageUploadFieldState();
}

class _ImageUploadFieldState extends State<ImageUploadField> {
  final _service = MediaUploadService();
  bool _busy = false;
  String? _error;

  Future<void> _pick(ImageSource source) async {
    setState(() { _busy = true; _error = null; });
    try {
      final url = await _service.pickAndUpload(
        businessId: widget.businessId, kind: widget.kind, source: source);
      if (url != null) widget.onChanged(url);
    } catch (e) {
      _error = e.toString(); // message serveur déjà lisible (taille, type…)
    }
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final url = widget.value;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: _busy
            ? const Center(child: CircularProgressIndicator())
            : (url == null || url.isEmpty)
                ? const Center(child: Icon(Icons.image_outlined, size: 40, color: Colors.black38))
                : Image.network(url, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Center(child: Icon(Icons.broken_image_outlined))),
      ),
      const SizedBox(height: 8),
      Wrap(spacing: 8, children: [
        OutlinedButton.icon(
          onPressed: _busy ? null : () => _pick(ImageSource.gallery),
          icon: const Icon(Icons.photo_library_outlined), label: const Text('Galerie')),
        OutlinedButton.icon(
          onPressed: _busy ? null : () => _pick(ImageSource.camera),
          icon: const Icon(Icons.photo_camera_outlined), label: const Text('Photo')),
        if (url != null && url.isNotEmpty)
          TextButton(onPressed: () => widget.onChanged(null), child: const Text('Retirer')),
      ]),
      if (_error != null)
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(_error!, style: const TextStyle(color: AppColors.error, fontSize: 12)),
        ),
    ]);
  }
}
