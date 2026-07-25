import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:your_venue_manager/features/authentication/model/cloudinary_asset.dart';
import 'package:your_venue_manager/features/authentication/model/venue_verification_model.dart';
import 'package:your_venue_manager/features/authentication/services/cloudinary_upload_service.dart';

class VenueVerificationException implements Exception {
  final String message;

  const VenueVerificationException(this.message);

  @override
  String toString() => message;
}

class VenueVerificationRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final CloudinaryUploadService _cloudinaryService;

  VenueVerificationRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    CloudinaryUploadService? cloudinaryService,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore =
            firestore ?? FirebaseFirestore.instance,
        _cloudinaryService =
            cloudinaryService ?? CloudinaryUploadService();

  Future<void> submitVerification({
    required String businessName,
    required String description,
    required String venueType,
    required String businessAddress,
    required int capacity,
    required double pricePerDay,
    required String businessManager,
    required String venueLocationName,
    required double latitude,
    required double longitude,
    required List<XFile> selectedImages,
    required PlatformFile selectedDocument,
  }) async {
    final User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      throw const VenueVerificationException(
        "No manager is currently logged in.",
      );
    }

    if (selectedImages.isEmpty) {
      throw const VenueVerificationException(
        "Please select at least one venue photo.",
      );
    }

    try {
      final List<CloudinaryAsset> uploadedImages = [];

      // Upload images one by one.
      for (final XFile image in selectedImages) {
        final Uint8List imageBytes =
            await image.readAsBytes();

        final CloudinaryAsset uploadedImage =
            await _cloudinaryService.uploadImage(
          bytes: imageBytes,
          fileName: image.name,
        );

        uploadedImages.add(uploadedImage);
      }

      final Uint8List documentBytes =
          await _readDocumentBytes(selectedDocument);

      final CloudinaryAsset uploadedDocument =
          await _cloudinaryService.uploadDocument(
        bytes: documentBytes,
        fileName: selectedDocument.name,
      );

      final VenueVerificationModel venue =
          VenueVerificationModel(
        managerId: currentUser.uid,
        businessName: businessName.trim(),
        description: description.trim(),
        venueType: venueType,
        businessAddress: businessAddress.trim(),
        capacity: capacity,
        pricePerDay: pricePerDay,
        businessManager: businessManager.trim(),
        venueLocationName: venueLocationName.trim(),
        latitude: latitude,
        longitude: longitude,
        photoUrls: uploadedImages
            .map((asset) => asset.secureUrl)
            .toList(),
        photoPublicIds: uploadedImages
            .map((asset) => asset.publicId)
            .toList(),
        documentUrl: uploadedDocument.secureUrl,
        documentPublicId: uploadedDocument.publicId,
        verificationStatus: "pending",
      );

      final DocumentReference<Map<String, dynamic>>
          venueReference = _firestore
              .collection("venues")
              .doc(currentUser.uid);

      final DocumentReference<Map<String, dynamic>>
          managerReference = _firestore
              .collection("managers")
              .doc(currentUser.uid);

      final WriteBatch batch = _firestore.batch();

      batch.set(
        venueReference,
        {
          ...venue.toMap(),
          "submittedAt": FieldValue.serverTimestamp(),
          "updatedAt": FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      batch.update(
        managerReference,
        {
          "venueSubmitted": true,
          "verificationStatus": "pending",
          "isVerified": false,
          "updatedAt": FieldValue.serverTimestamp(),
        },
      );

      await batch.commit();
    } on CloudinaryUploadException catch (error) {
      throw VenueVerificationException(error.message);
    } on FirebaseException catch (error) {
      throw VenueVerificationException(
        error.message ??
            "Venue information could not be saved.",
      );
    } on VenueVerificationException {
      rethrow;
    } catch (error) {
      throw VenueVerificationException(
        "Verification submission failed: $error",
      );
    }
  }

  Future<Uint8List> _readDocumentBytes(
    PlatformFile document,
  ) async {
    if (document.bytes != null) {
      return document.bytes!;
    }

    final String? filePath = document.path;

    if (filePath == null) {
      throw const VenueVerificationException(
        "The selected document could not be read.",
      );
    }

    return File(filePath).readAsBytes();
  }
}