import 'package:flutter_dotenv/flutter_dotenv.dart';

final class CloudinaryConfig {
  CloudinaryConfig._();

  static String get cloudName {
    return _readRequiredValue('CLOUDINARY_CLOUD_NAME');
  }

  static String get imageUploadPreset {
    return _readRequiredValue('CLOUDINARY_IMAGE_PRESET');
  }

  static String get documentUploadPreset {
    return _readRequiredValue('CLOUDINARY_DOCUMENT_PRESET');
  }

  static String _readRequiredValue(String key) {
    final String? value = dotenv.env[key]?.trim();

    if (value == null || value.isEmpty) {
      throw StateError(
        'Missing environment configuration: $key',
      );
    }

    return value;
  }
}