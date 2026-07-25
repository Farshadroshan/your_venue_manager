import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:your_venue_manager/core/colors/app_colors.dart';
import 'package:your_venue_manager/features/authentication/view/account_pending_verification_screen.dart';
import 'package:your_venue_manager/features/authentication/view/location_picker_screen.dart';

import 'package:your_venue_manager/features/authentication/view_model/bloc/venue_verification_bloc/venue_verification_bloc.dart';
import 'package:your_venue_manager/features/authentication/widgets/add_photo_tile.dart';
import 'package:your_venue_manager/features/authentication/widgets/card_container.dart';
import 'package:your_venue_manager/features/authentication/widgets/document_upload_row.dart';
import 'package:your_venue_manager/features/authentication/widgets/labeled_dropdown.dart';
import 'package:your_venue_manager/features/authentication/widgets/labeled_input.dart';
import 'package:your_venue_manager/features/authentication/widgets/map_grid_painter.dart';
import 'package:your_venue_manager/features/authentication/widgets/primary_button.dart';
import 'package:your_venue_manager/features/authentication/widgets/progress_badge.dart';
import 'package:your_venue_manager/features/authentication/widgets/upload_button.dart';

 

class VenueVerificationScreen extends StatefulWidget {
  const VenueVerificationScreen({super.key});

  @override
  State<VenueVerificationScreen> createState() =>
      _VenueVerificationScreenState();
}

class _VenueVerificationScreenState
    extends State<VenueVerificationScreen> {
  final TextEditingController _businessNameController =
      TextEditingController();

  final TextEditingController _descriptionController =
      TextEditingController();

  final TextEditingController _businessAddressController =
      TextEditingController();

  final TextEditingController _capacityController =
      TextEditingController();

  final TextEditingController _priceController =
      TextEditingController();

  final TextEditingController _managerController =
      TextEditingController();

  final TextEditingController _locationController =
      TextEditingController();

  final ValueNotifier<String?> _venueType =
      ValueNotifier<String?>(null);

  @override
  void initState() {
    super.initState();

    // When the custom dropdown value changes,
    // update the BLoC state.
    _venueType.addListener(_onVenueTypeChanged);
  }

  void _onVenueTypeChanged() {
    if (!mounted) {
      return;
    }

    context.read<VenueVerificationBloc>().add(
          VenueTypeChangedEvent(
            venueType: _venueType.value,
          ),
        );
  }

  @override
  void dispose() {
    _venueType.removeListener(_onVenueTypeChanged);
    _venueType.dispose();

    _businessNameController.dispose();
    _descriptionController.dispose();
    _businessAddressController.dispose();
    _capacityController.dispose();
    _priceController.dispose();
    _managerController.dispose();
    _locationController.dispose();

    super.dispose();
  }

  Future<void> _openLocationPicker(
    VenueVerificationState state,
  ) async {
    final LatLng? selectedLocation =
        await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (_) => LocationPickerScreen(
          initialLatitude: state.latitude,
          initialLongitude: state.longitude,
        ),
      ),
    );

    if (selectedLocation == null || !mounted) {
      return;
    }

    context.read<VenueVerificationBloc>().add(
          VenueLocationChangedEvent(
            latitude: selectedLocation.latitude,
            longitude: selectedLocation.longitude,
          ),
        );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  void _submitVerification() {
    FocusScope.of(context).unfocus();

    if (_businessNameController.text.trim().isEmpty) {
      _showMessage('Please enter the business name.');
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      _showMessage('Please enter the venue description.');
      return;
    }

    if (_venueType.value == null) {
      _showMessage('Please select a venue type.');
      return;
    }

    if (_businessAddressController.text.trim().isEmpty) {
      _showMessage('Please enter the business address.');
      return;
    }

    final int? capacity = int.tryParse(
      _capacityController.text.trim(),
    );

    if (capacity == null || capacity <= 0) {
      _showMessage('Please enter a valid venue capacity.');
      return;
    }

    final double? price = double.tryParse(
      _priceController.text.trim(),
    );

    if (price == null || price <= 0) {
      _showMessage('Please enter a valid price per day.');
      return;
    }

    if (_managerController.text.trim().isEmpty) {
      _showMessage('Please enter the business manager name.');
      return;
    }

    if (_locationController.text.trim().isEmpty) {
      _showMessage('Please enter the venue location name.');
      return;
    }

    context.read<VenueVerificationBloc>().add(
          SubmitVenueVerificationEvent(
            businessName:
                _businessNameController.text.trim(),
            description:
                _descriptionController.text.trim(),
            businessAddress:
                _businessAddressController.text.trim(),
            capacity: capacity,
            pricePerDay: price,
            businessManager:
                _managerController.text.trim(),
            venueLocationName:
                _locationController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
        VenueVerificationBloc,
        VenueVerificationState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
        }

        if (state.submissionSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const AccountPendingVerificationScreen(),
            ),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: _buildAppBar(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleBlock(),

                const SizedBox(height: 16),

                _buildHeroImage(),

                const SizedBox(height: 24),

                _buildSectionHeader(
                  icon: Icons.storefront_outlined,
                  title: 'BUSINESS INFORMATION',
                ),

                const SizedBox(height: 12),

                _buildBusinessInfoCard(),

                const SizedBox(height: 24),

                _buildSectionHeader(
                  icon: Icons.description_outlined,
                  title: 'DOCUMENT UPLOAD',
                ),

                const SizedBox(height: 12),

                _buildDocumentUploadCard(state),

                const SizedBox(height: 24),

                _buildSectionHeader(
                  icon: Icons.photo_library_outlined,
                  title: 'VENUE PHOTOS',
                ),

                const SizedBox(height: 12),

                _buildVenuePhotosSection(state),

                const SizedBox(height: 24),

                _buildSectionHeader(
                  icon: Icons.location_on_outlined,
                  title: 'LOCATION VERIFICATION',
                ),

                const SizedBox(height: 12),

                _buildMapCard(state),

                const SizedBox(height: 28),

                _buildSubmitSection(state),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          size: 18,
          color: AppColors.textPrimary,
        ),
        onPressed: () {
          Navigator.maybePop(context);
        },
      ),
      title: const Text(
        'Your Venue Manager',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTitleBlock() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Venue Verification',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Verify your business and venue information to start '
            'accepting bookings. This ensures a safe and premium '
            'environment for both hosts and guests.',
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF20232E),
                    Color(0xFF0B0D14),
                  ],
                ),
              ),
              child: const Opacity(
                opacity: 0.5,
                child: Icon(
                  Icons.storefront,
                  size: 90,
                  color: Colors.white24,
                ),
              ),
            ),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    AppColors.goldLight,
                    AppColors.gold,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.5),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.gold,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessInfoCard() {
    return CardContainer(
      child: Column(
        children: [
          LabeledInput(
            label: 'Business Name',
            icon: Icons.badge_outlined,
            controller: _businessNameController,
            hintText: 'e.g. Grand Plaza Hotel',
          ),

          LabeledInput(
            label: 'Description',
            icon: Icons.notes_outlined,
            controller: _descriptionController,
            hintText: 'What makes your venue special?',
            maxLines: 3,
          ),

          LabeledDropdown(
            label: 'Venue Type',
            icon: Icons.category_outlined,
            notifier: _venueType,
            hintText: 'Select venue type',
            items: const [
              'Wedding Hall',
              'Convention Center',
              'Conference Hall',
              'Event Space',
            ],
          ),

          LabeledInput(
            label: 'Business Address',
            icon: Icons.location_on_outlined,
            controller: _businessAddressController,
            hintText: 'Enter your full business address',
            maxLines: 3,
          ),

          LabeledInput(
            label: 'Capacity',
            icon: Icons.people_outline,
            controller: _capacityController,
            hintText: 'Enter maximum number of guests',
          ),

          LabeledInput(
            label: 'Price per Day',
            icon: Icons.currency_rupee,
            controller: _priceController,
            hintText: 'Enter amount per day',
          ),

          LabeledInput(
            label: 'Business Manager',
            icon: Icons.person_outline,
            controller: _managerController,
            hintText: 'Enter full registered name',
          ),

          LabeledInput(
            label: 'Venue Location',
            icon: Icons.location_on_outlined,
            controller: _locationController,
            hintText: 'Example: Tirur, Malappuram',
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentUploadCard(
    VenueVerificationState state,
  ) {
    return CardContainer(
      padding: const EdgeInsets.all(16),
      child: state.selectedDocument == null
          ? DocumentUploadRow(
              icon: Icons.description_outlined,
              title: 'Business License',
              subtitle: 'PDF, JPG, JPEG or PNG — maximum 10 MB',
              badgeText: 'Required',
              badgeColor: AppColors.gold,
              trailing: UploadButton(
                onPressed: state.isSubmitting
                    ? () {}
                    : () {
                        context
                            .read<VenueVerificationBloc>()
                            .add(
                              const PickVenueDocumentEvent(),
                            );
                      },
              ),
            )
          : DocumentUploadRow(
              icon: Icons.description_outlined,
              title: state.selectedDocument!.name,
              subtitle:
                  '${(state.selectedDocument!.size / 1024).toStringAsFixed(1)} KB selected',
              progress: 1,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ProgressBadge(progress: 1),
                  IconButton(
                    tooltip: 'Remove document',
                    onPressed: state.isSubmitting
                        ? null
                        : () {
                            context
                                .read<VenueVerificationBloc>()
                                .add(
                                  const RemoveVenueDocumentEvent(),
                                );
                          },
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildVenuePhotosSection(
    VenueVerificationState state,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Add high-resolution exterior and interior photos',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: state.isSubmitting
                    ? null
                    : () {
                        context
                            .read<VenueVerificationBloc>()
                            .add(
                              const PickVenueImagesEvent(),
                            );
                      },
                icon: const Icon(
                  Icons.add,
                  size: 16,
                  color: AppColors.navy,
                ),
                label: const Text(
                  'Add Photos',
                  style: TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              ...List.generate(
                state.selectedImages.length,
                (index) {
                  final image =
                      state.selectedImages[index];

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(10),
                        child: Image.file(
                          File(image.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 16,
                            color: Colors.white,
                            onPressed: state.isSubmitting
                                ? null
                                : () {
                                    context
                                        .read<
                                            VenueVerificationBloc>()
                                        .add(
                                          RemoveVenueImageEvent(
                                            index: index,
                                          ),
                                        );
                                  },
                            icon: const Icon(Icons.close),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              AddPhotoTile(
                onTap: state.isSubmitting
                    ? () {}
                    : () {
                        context
                            .read<VenueVerificationBloc>()
                            .add(
                              const PickVenueImagesEvent(),
                            );
                      },
              ),
            ],
          ),

          if (state.selectedImages.isEmpty) ...[
            const SizedBox(height: 10),
            const Text(
              'Please select at least one venue photo.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMapCard(
    VenueVerificationState state,
  ) {
    final bool hasLocation =
        state.latitude != null && state.longitude != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Container(
              height: 180,
              width: double.infinity,
              color: const Color(0xFFDDE3E8),
              child: CustomPaint(
                painter: MapGridPainter(),
              ),
            ),

            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Text(
                    hasLocation
                        ? 'Latitude: '
                            '${state.latitude!.toStringAsFixed(6)}\n'
                            'Longitude: '
                            '${state.longitude!.toStringAsFixed(6)}'
                        : 'Venue location is not selected',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 12,
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: state.isSubmitting
                      ? null
                      : () {
                          _openLocationPicker(state);
                        },
                  icon: Icon(
                    hasLocation
                        ? Icons.edit_location_alt_outlined
                        : Icons.my_location,
                    size: 16,
                  ),
                  label: Text(
                    hasLocation
                        ? 'Change Location'
                        : 'Detect Location',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.primaryColor,
                    foregroundColor: AppColors.white,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitSection(
    VenueVerificationState state,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          if (state.isSubmitting)
            const SizedBox(
              height: 52,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            PrimaryButton(
              text: 'Submit Verification Request',
              onTap: _submitVerification,
              backgroundColor:
                  AppColors.primaryColor,
              textColor: AppColors.white,
              borderSideColor:
                  AppColors.primaryColor,
            ),

          if (state.isSubmitting) ...[
            const SizedBox(height: 10),
            const Text(
              'Uploading venue photos and document. '
              'Please do not close the application.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],

          const SizedBox(height: 12),

          const Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              children: [
                TextSpan(
                  text: 'By submitting you agree to our ',
                ),
                TextSpan(
                  text: 'Terms of Service',
                  style: TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}