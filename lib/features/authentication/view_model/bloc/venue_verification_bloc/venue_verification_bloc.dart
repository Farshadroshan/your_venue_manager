// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:image_picker/image_picker.dart';

// part 'venue_verification_event.dart';
// part 'venue_verification_state.dart';

// class VenueVerificationBloc extends Bloc<VenueVerificationEvent, VenueVerificationState> {
//   VenueVerificationBloc() : super(VenueVerificationInitial()) {
//     on<VenueVerificationEvent>((event, emit) {
//       // TODO: implement event handler
//     });
//   }
// }



import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:your_venue_manager/features/authentication/repository/venue_verification_repository.dart';

part 'venue_verification_event.dart';
part 'venue_verification_state.dart';

class VenueVerificationBloc extends Bloc<
    VenueVerificationEvent, VenueVerificationState> {
  final VenueVerificationRepository repository;
  final ImagePicker imagePicker;

  VenueVerificationBloc({
    required this.repository,
    ImagePicker? imagePicker,
  })  : imagePicker = imagePicker ?? ImagePicker(),
        super(const VenueVerificationState()) {
    on<PickVenueImagesEvent>(_pickImages);
    on<RemoveVenueImageEvent>(_removeImage);
    on<PickVenueDocumentEvent>(_pickDocument);
    on<RemoveVenueDocumentEvent>(_removeDocument);
    on<VenueTypeChangedEvent>(_changeVenueType);
    on<VenueLocationChangedEvent>(_changeLocation);
    on<SubmitVenueVerificationEvent>(
      _submitVerification,
    );
    on<ResetVenueVerificationEvent>(_reset);
  }

  Future<void> _pickImages(
    PickVenueImagesEvent event,
    Emitter<VenueVerificationState> emit,
  ) async {
    try {
      final List<XFile> pickedImages =
          await imagePicker.pickMultiImage(
        imageQuality: 85,
      );

      if (pickedImages.isEmpty) {
        return;
      }

      final Map<String, XFile> uniqueImages = {
        for (final image in state.selectedImages)
          image.path: image,
        for (final image in pickedImages)
          image.path: image,
      };

      final List<XFile> images =
          uniqueImages.values.toList();

      if (images.length > 8) {
        emit(
          state.copyWith(
            selectedImages: images.take(8).toList(),
            errorMessage:
                "You can select a maximum of 8 images.",
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          selectedImages: images,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          errorMessage:
              "Unable to select images: $error",
        ),
      );
    }
  }

  void _removeImage(
    RemoveVenueImageEvent event,
    Emitter<VenueVerificationState> emit,
  ) {
    final List<XFile> updatedImages =
        List<XFile>.from(state.selectedImages);

    if (event.index >= 0 &&
        event.index < updatedImages.length) {
      updatedImages.removeAt(event.index);
    }

    emit(
      state.copyWith(
        selectedImages: updatedImages,
        clearError: true,
      ),
    );
  }

  Future<void> _pickDocument(
    PickVenueDocumentEvent event,
    Emitter<VenueVerificationState> emit,
  ) async {
    try {
      final FilePickerResult? result =
          await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          "pdf",
          "jpg",
          "jpeg",
          "png",
        ],
        allowMultiple: false,
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final PlatformFile document = result.files.first;

      const int maximumSize = 10 * 1024 * 1024;

      if (document.size > maximumSize) {
        emit(
          state.copyWith(
            errorMessage:
                "Document size must be less than 10 MB.",
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          selectedDocument: document,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          errorMessage:
              "Unable to select document: $error",
        ),
      );
    }
  }

  void _removeDocument(
    RemoveVenueDocumentEvent event,
    Emitter<VenueVerificationState> emit,
  ) {
    emit(
      state.copyWith(
        removeDocument: true,
        clearError: true,
      ),
    );
  }

  void _changeVenueType(
    VenueTypeChangedEvent event,
    Emitter<VenueVerificationState> emit,
  ) {
    emit(
      state.copyWith(
        selectedVenueType: event.venueType,
        clearError: true,
      ),
    );
  }

  void _changeLocation(
    VenueLocationChangedEvent event,
    Emitter<VenueVerificationState> emit,
  ) {
    emit(
      state.copyWith(
        latitude: event.latitude,
        longitude: event.longitude,
        clearError: true,
      ),
    );
  }

  Future<void> _submitVerification(
    SubmitVenueVerificationEvent event,
    Emitter<VenueVerificationState> emit,
  ) async {
    if (state.selectedVenueType == null) {
      emit(
        state.copyWith(
          errorMessage: "Please select a venue type.",
        ),
      );
      return;
    }

    if (state.selectedImages.isEmpty) {
      emit(
        state.copyWith(
          errorMessage:
              "Please select at least one venue photo.",
        ),
      );
      return;
    }

    if (state.selectedDocument == null) {
      emit(
        state.copyWith(
          errorMessage:
              "Please upload a verification document.",
        ),
      );
      return;
    }

    if (state.latitude == null ||
        state.longitude == null) {
      emit(
        state.copyWith(
          errorMessage:
              "Please verify the venue location.",
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        submissionSuccess: false,
        clearError: true,
      ),
    );

    try {
      await repository.submitVerification(
        businessName: event.businessName,
        description: event.description,
        venueType: state.selectedVenueType!,
        businessAddress: event.businessAddress,
        capacity: event.capacity,
        pricePerDay: event.pricePerDay,
        businessManager: event.businessManager,
        venueLocationName: event.venueLocationName,
        latitude: state.latitude!,
        longitude: state.longitude!,
        selectedImages: state.selectedImages,
        selectedDocument: state.selectedDocument!,
      );

      emit(
        state.copyWith(
          isSubmitting: false,
          submissionSuccess: true,
          clearError: true,
        ),
      );
    } on VenueVerificationException catch (error) {
      emit(
        state.copyWith(
          isSubmitting: false,
          submissionSuccess: false,
          errorMessage: error.message,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isSubmitting: false,
          submissionSuccess: false,
          errorMessage:
              "Verification submission failed: $error",
        ),
      );
    }
  }

  void _reset(
    ResetVenueVerificationEvent event,
    Emitter<VenueVerificationState> emit,
  ) {
    emit(const VenueVerificationState());
  }
}