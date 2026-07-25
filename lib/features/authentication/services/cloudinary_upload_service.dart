import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:your_venue_manager/core/config/cloudinary_config.dart';
import 'package:your_venue_manager/features/authentication/model/cloudinary_asset.dart';
import 'package:your_venue_manager/features/authentication/widgets/document_upload_row.dart';

class CloudinaryUploadException implements Exception {
  final String message;

  const CloudinaryUploadException(this.message);

  @override
  String toString() => message;
}

class CloudinaryUploadService {
  final String cloudName;
  final String imageUploadPreset;
  final String documentUploadPreset;

  CloudinaryUploadService({
    String? cloudName,
    String? imageUploadPreset,
    String? documentUploadPreset,
  })
    // : cloudName = cloudName ??
    //           const String.fromEnvironment(
    //             'CLOUDINARY_CLOUD_NAME',
    //           ),
    //       imageUploadPreset = imageUploadPreset ??
    //           const String.fromEnvironment(
    //             'CLOUDINARY_IMAGE_PRESET',
    //           ),
    //       documentUploadPreset = documentUploadPreset ??
    //           const String.fromEnvironment(
    //             'CLOUDINARY_DOCUMENT_PRESET',
    //           );
    : cloudName = cloudName ?? CloudinaryConfig.cloudName,
       imageUploadPreset =
           imageUploadPreset ?? CloudinaryConfig.imageUploadPreset,
       documentUploadPreset =
           documentUploadPreset ?? CloudinaryConfig.documentUploadPreset;

  Future<CloudinaryAsset> uploadImage({
    required Uint8List bytes,
    required String fileName,
  }) {
    return _uploadFile(
      bytes: bytes,
      fileName: fileName,
      resourceType: 'image',
      uploadPreset: imageUploadPreset,
    );
  }

  Future<CloudinaryAsset> uploadDocument({
    required Uint8List bytes,
    required String fileName,
  }) {
    return _uploadFile(
      bytes: bytes,
      fileName: fileName,
      resourceType: 'raw',
      uploadPreset: documentUploadPreset,
    );
  }

  Future<CloudinaryAsset> _uploadFile({
    required Uint8List bytes,
    required String fileName,
    required String resourceType,
    required String uploadPreset,
  }) async {
    _validateConfiguration(uploadPreset);

    final Uri uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/'
      '$cloudName/$resourceType/upload',
    );

    final http.MultipartRequest request = http.MultipartRequest('POST', uri);

    request.fields['upload_preset'] = uploadPreset;

    request.files.add(
      http.MultipartFile.fromBytes('file', bytes, filename: fileName),
    );

    try {
      final http.StreamedResponse streamedResponse = await request.send();

      final http.Response response = await http.Response.fromStream(
        streamedResponse,
      );

      final dynamic decodedResponse = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : null;

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final String errorMessage = _extractErrorMessage(decodedResponse);

        throw CloudinaryUploadException(errorMessage);
      }

      if (decodedResponse is! Map<String, dynamic>) {
        throw const CloudinaryUploadException(
          'Invalid response received from Cloudinary.',
        );
      }

      final String? secureUrl = decodedResponse['secure_url']?.toString();

      final String? publicId = decodedResponse['public_id']?.toString();

      if (secureUrl == null || publicId == null) {
        throw const CloudinaryUploadException(
          'Cloudinary did not return the uploaded file details.',
        );
      }

      return CloudinaryAsset(
        secureUrl: secureUrl,
        publicId: publicId,
        resourceType:
            decodedResponse['resource_type']?.toString() ?? resourceType,
        originalFilename:
            decodedResponse['original_filename']?.toString() ?? fileName,
      );
    } on CloudinaryUploadException {
      rethrow;
    } on FormatException {
      throw const CloudinaryUploadException(
        'Invalid response received from Cloudinary.',
      );
    } catch (error) {
      throw CloudinaryUploadException('Upload failed: $error');
    }
  }

  String _extractErrorMessage(dynamic decodedResponse) {
    const String defaultMessage = 'Cloudinary upload failed.';

    if (decodedResponse is! Map<String, dynamic>) {
      return defaultMessage;
    }

    final dynamic errorData = decodedResponse['error'];

    if (errorData is! Map<String, dynamic>) {
      return defaultMessage;
    }

    return errorData['message']?.toString() ?? defaultMessage;
  }

  void _validateConfiguration(String uploadPreset) {
    if (cloudName.isEmpty) {
      throw const CloudinaryUploadException(
        'Cloudinary cloud name is missing.',
      );
    }

    if (uploadPreset.isEmpty) {
      throw const CloudinaryUploadException(
        'Cloudinary upload preset is missing.',
      );
    }
  }
}
