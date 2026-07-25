import 'package:cloud_firestore/cloud_firestore.dart';

class VenueVerificationModel {
  final String managerId;
  final String businessName;
  final String description;
  final String venueType;
  final String businessAddress;
  final int capacity;
  final double pricePerDay;
  final String businessManager;
  final String venueLocationName;
  final double latitude;
  final double longitude;
  final List<String> photoUrls;
  final List<String> photoPublicIds;
  final String documentUrl;
  final String documentPublicId;
  final String verificationStatus;

  const VenueVerificationModel({
    required this.managerId,
    required this.businessName,
    required this.description,
    required this.venueType,
    required this.businessAddress,
    required this.capacity,
    required this.pricePerDay,
    required this.businessManager,
    required this.venueLocationName,
    required this.latitude,
    required this.longitude,
    required this.photoUrls,
    required this.photoPublicIds,
    required this.documentUrl,
    required this.documentPublicId,
    required this.verificationStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      "managerId": managerId,
      "businessName": businessName,
      "description": description,
      "venueType": venueType,
      "businessAddress": businessAddress,
      "capacity": capacity,
      "pricePerDay": pricePerDay,
      "businessManager": businessManager,
      "venueLocationName": venueLocationName,

      "location": {
        "latitude": latitude,
        "longitude": longitude,
        "geoPoint": GeoPoint(latitude, longitude),
      },

      "photoUrls": photoUrls,
      "photoPublicIds": photoPublicIds,

      "documentUrl": documentUrl,
      "documentPublicId": documentPublicId,

      "verificationStatus": verificationStatus,
      "isActive": false,
    };
  }
}