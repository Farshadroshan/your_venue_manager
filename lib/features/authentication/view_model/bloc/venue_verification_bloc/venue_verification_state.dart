part of 'venue_verification_bloc.dart';

// sealed class VenueVerificationState extends Equatable {
//   const VenueVerificationState();
  
//   @override
//   List<Object> get props => [];
// }

// final class VenueVerificationInitial extends VenueVerificationState {}

// part of 'venue_verification_bloc.dart';

class VenueVerificationState extends Equatable {
  final List<XFile> selectedImages;
  final PlatformFile? selectedDocument;
  final String? selectedVenueType;
  final double? latitude;
  final double? longitude;
  final bool isSubmitting;
  final bool submissionSuccess;
  final String? errorMessage;

  const VenueVerificationState({
    this.selectedImages = const [],
    this.selectedDocument,
    this.selectedVenueType,
    this.latitude,
    this.longitude,
    this.isSubmitting = false,
    this.submissionSuccess = false,
    this.errorMessage,
  });

  VenueVerificationState copyWith({
    List<XFile>? selectedImages,
    PlatformFile? selectedDocument,
    bool removeDocument = false,
    String? selectedVenueType,
    double? latitude,
    double? longitude,
    bool? isSubmitting,
    bool? submissionSuccess,
    String? errorMessage,
    bool clearError = false,
  }) {
    return VenueVerificationState(
      selectedImages:
          selectedImages ?? this.selectedImages,
      selectedDocument: removeDocument
          ? null
          : selectedDocument ?? this.selectedDocument,
      selectedVenueType:
          selectedVenueType ?? this.selectedVenueType,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submissionSuccess:
          submissionSuccess ?? this.submissionSuccess,
      errorMessage:
          clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        selectedImages,
        selectedDocument?.name,
        selectedDocument?.size,
        selectedVenueType,
        latitude,
        longitude,
        isSubmitting,
        submissionSuccess,
        errorMessage,
      ];
}