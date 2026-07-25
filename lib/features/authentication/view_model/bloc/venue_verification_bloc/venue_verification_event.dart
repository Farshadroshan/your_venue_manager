part of 'venue_verification_bloc.dart';

// sealed class VenueVerificationEvent extends Equatable {
//   const VenueVerificationEvent();

//   @override
//   List<Object> get props => [];
// }

// part of 'venue_verification_bloc.dart';

sealed class VenueVerificationEvent extends Equatable {
  const VenueVerificationEvent();

  @override
  List<Object?> get props => [];
}

final class PickVenueImagesEvent
    extends VenueVerificationEvent {
  const PickVenueImagesEvent();
}

final class RemoveVenueImageEvent
    extends VenueVerificationEvent {
  final int index;

  const RemoveVenueImageEvent({
    required this.index,
  });

  @override
  List<Object?> get props => [index];
}

final class PickVenueDocumentEvent
    extends VenueVerificationEvent {
  const PickVenueDocumentEvent();
}

final class RemoveVenueDocumentEvent
    extends VenueVerificationEvent {
  const RemoveVenueDocumentEvent();
}

final class VenueTypeChangedEvent
    extends VenueVerificationEvent {
  final String? venueType;

  const VenueTypeChangedEvent({
    required this.venueType,
  });

  @override
  List<Object?> get props => [venueType];
}

final class VenueLocationChangedEvent
    extends VenueVerificationEvent {
  final double latitude;
  final double longitude;

  const VenueLocationChangedEvent({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [
        latitude,
        longitude,
      ];
}

final class SubmitVenueVerificationEvent
    extends VenueVerificationEvent {
  final String businessName;
  final String description;
  final String businessAddress;
  final int capacity;
  final double pricePerDay;
  final String businessManager;
  final String venueLocationName;

  const SubmitVenueVerificationEvent({
    required this.businessName,
    required this.description,
    required this.businessAddress,
    required this.capacity,
    required this.pricePerDay,
    required this.businessManager,
    required this.venueLocationName,
  });

  @override
  List<Object?> get props => [
        businessName,
        description,
        businessAddress,
        capacity,
        pricePerDay,
        businessManager,
        venueLocationName,
      ];
}

final class ResetVenueVerificationEvent
    extends VenueVerificationEvent {
  const ResetVenueVerificationEvent();
}
