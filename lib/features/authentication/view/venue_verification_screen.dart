import 'package:flutter/material.dart';

// -----------------------------------------------------------------------
// VENUE VERIFICATION SCREEN
// A pixel-close recreation of the "Venue Verification" mobile screen:
// hero image with a gold verified badge, business info form, document
// upload rows with progress, a venue-photo grid, a map/location card,
// and a submit CTA.
//
// Drop this file into your Flutter project (e.g. lib/venue_verification_screen.dart)
// and push it like any other screen:
//   Navigator.push(context, MaterialPageRoute(builder: (_) => const VenueVerificationScreen()));
// -----------------------------------------------------------------------

class AppColors {
  static const navy = Color(0xFF11162A);
  static const navyDark = Color(0xFF0B0F1F);
  static const gold = Color(0xFFCBA135);
  static const goldLight = Color(0xFFE9C766);
  static const background = Color(0xFFF7F7F9);
  static const cardBorder = Color(0xFFE7E7EC);
  static const textPrimary = Color(0xFF1A1C23);
  static const textSecondary = Color(0xFF8A8D9A);
  static const green = Color(0xFF2E9E5B);
  static const inputFill = Color(0xFFFAFAFB);
}

void main() {
  runApp(const VenueVerificationApp());
}

class VenueVerificationApp extends StatelessWidget {
  const VenueVerificationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Venue Verification',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.navy),
      ),
      home: const VenueVerificationScreen(),
    );
  }
}

class VenueVerificationScreen extends StatefulWidget {
  const VenueVerificationScreen({super.key});

  @override
  State<VenueVerificationScreen> createState() =>
      _VenueVerificationScreenState();
}

class _VenueVerificationScreenState extends State<VenueVerificationScreen> {
  final _businessNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _managerController = TextEditingController();
  final _locationController = TextEditingController();

  // Fake progress state for the document upload rows.
  final double _businessLicenseProgress = 0.75;

  @override
  void dispose() {
    _businessNameController.dispose();
    _descriptionController.dispose();
    _managerController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            _buildDocumentUploadCard(),
            const SizedBox(height: 24),
            _buildVenuePhotosSection(),
            const SizedBox(height: 24),
            _buildSectionHeader(
              icon: Icons.location_on_outlined,
              title: 'LOCATION VERIFICATION',
            ),
            const SizedBox(height: 12),
            _buildMapCard(),
            const SizedBox(height: 28),
            _buildSubmitSection(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // APP BAR
  // ---------------------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary),
        onPressed: () => Navigator.maybePop(context),
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

  // ---------------------------------------------------------------------
  // TITLE + SUBTITLE
  // ---------------------------------------------------------------------
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

  // ---------------------------------------------------------------------
  // HERO IMAGE WITH GOLD VERIFIED BADGE
  // ---------------------------------------------------------------------
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
                  colors: [Color(0xFF20232E), Color(0xFF0B0D14)],
                ),
              ),
              child: Opacity(
                opacity: 0.5,
                child: Icon(Icons.storefront, size: 90, color: Colors.white24),
              ),
            ),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.goldLight, AppColors.gold],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withOpacity(0.5),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 32),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // SECTION HEADER (small caps label with icon)
  // ---------------------------------------------------------------------
  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.gold),
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

  // ---------------------------------------------------------------------
  // BUSINESS INFORMATION CARD
  // ---------------------------------------------------------------------
  Widget _buildBusinessInfoCard() {
    return _CardContainer(
      child: Column(
        children: [
          _LabeledInput(
            label: 'Business Name',
            icon: Icons.badge_outlined,
            controller: _businessNameController,
            hintText: 'e.g. Grand Plaza Hotel',
          ),
          const _Divider(),
          _LabeledInput(
            label: 'Description',
            icon: Icons.notes_outlined,
            controller: _descriptionController,
            hintText: 'What makes your venue special?',
            maxLines: 3,
          ),
          const _Divider(),
          _LabeledInput(
            label: 'Business Manager',
            icon: Icons.person_outline,
            controller: _managerController,
            hintText: 'Enter full registered name',
          ),
          const _Divider(),
          _LabeledInput(
            label: 'Venue Location',
            icon: Icons.location_on_outlined,
            controller: _locationController,
            hintText: 'Search venue address',
            trailingIcon: Icons.search,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // DOCUMENT UPLOAD CARD
  // ---------------------------------------------------------------------
  Widget _buildDocumentUploadCard() {
    return _CardContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _DocumentUploadRow(
            icon: Icons.badge_outlined,
            title: 'Owner ID',
            subtitle: 'Passport or National ID',
            badgeText: 'Required',
            badgeColor: AppColors.gold,
            trailing: _UploadButton(onPressed: () {}),
          ),
          const SizedBox(height: 16),
          _DocumentUploadRow(
            icon: Icons.description_outlined,
            title: 'Business License',
            subtitle: 'Active business/permit license',
            progress: _businessLicenseProgress,
            trailing: _ProgressBadge(progress: _businessLicenseProgress),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // VENUE PHOTOS SECTION
  // ---------------------------------------------------------------------
  Widget _buildVenuePhotosSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                onPressed: () {},
                icon: const Icon(Icons.add, size: 16, color: AppColors.navy),
                label: const Text(
                  'Add Photos',
                  style: TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.inputFill,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: AppColors.cardBorder),
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
              _PhotoThumb(colors: [Color(0xFF3A3F55), Color(0xFF1B1E2C)]),
              _PhotoThumb(colors: [Color(0xFF4A5568), Color(0xFF2D3748)]),
              _PhotoThumb(colors: [Color(0xFFB08D57), Color(0xFF6B4E2E)]),
              _AddPhotoTile(onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // MAP / LOCATION CARD
  // ---------------------------------------------------------------------
  Widget _buildMapCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Container(
              height: 160,
              width: double.infinity,
              color: const Color(0xFFDDE3E8),
              child: CustomPaint(painter: _MapGridPainter()),
            ),
            const Positioned(
              top: 12,
              left: 12,
              child: _CoordinateChip(),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 12,
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.my_location, size: 16),
                  label: const Text('Detect Location'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
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

  // ---------------------------------------------------------------------
  // SUBMIT SECTION
  // ---------------------------------------------------------------------
  Widget _buildSubmitSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Verification request submitted')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Submit Verification Request',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              children: [
                const TextSpan(text: 'By submitting you agree to our '),
                TextSpan(
                  text: 'Terms of Service',
                  style: const TextStyle(
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

// ===========================================================================
// REUSABLE PIECES
// ===========================================================================

class _CardContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const _CardContainer({
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: AppColors.cardBorder);
  }
}

class _LabeledInput extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final IconData? trailingIcon;

  const _LabeledInput({
    required this.label,
    required this.icon,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.gold),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              filled: true,
              fillColor: AppColors.inputFill,
              suffixIcon: trailingIcon != null
                  ? Icon(trailingIcon, size: 18, color: AppColors.textSecondary)
                  : null,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.cardBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.cardBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.gold, width: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentUploadRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? badgeText;
  final Color? badgeColor;
  final double? progress;
  final Widget trailing;

  const _DocumentUploadRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.badgeText,
    this.badgeColor,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Icon(icon, size: 18, color: AppColors.navy),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (badgeText != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: (badgeColor ?? AppColors.gold).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        badgeText!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: badgeColor ?? AppColors.gold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              if (progress != null) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: AppColors.cardBorder,
                    valueColor: const AlwaysStoppedAnimation(AppColors.green),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 8),
        trailing,
      ],
    );
  }
}

class _UploadButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _UploadButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.upload_outlined, size: 16),
      label: const Text('Upload'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.navy,
        side: const BorderSide(color: AppColors.cardBorder),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class _ProgressBadge extends StatelessWidget {
  final double progress;

  const _ProgressBadge({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${(progress * 100).toInt()}% Complete',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.green,
        ),
      ),
    );
  }
}

class _PhotoThumb extends StatelessWidget {
  final List<Color> colors;

  const _PhotoThumb({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}

class _AddPhotoTile extends StatelessWidget {
  final VoidCallback onTap;

  const _AddPhotoTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: DottedBorderBox(
        child: const Center(
          child: Icon(Icons.add, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

/// Simple dashed-border container (hand rolled, no external package needed).
class DottedBorderBox extends StatelessWidget {
  final Widget child;

  const DottedBorderBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.cardBorder
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(12),
    );
    final path = Path()..addRRect(rrect);
    final dashPath = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      const dashLength = 5.0;
      const gapLength = 4.0;
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + dashLength),
          Offset.zero,
        );
        distance += dashLength + gapLength;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CoordinateChip extends StatelessWidget {
  const _CoordinateChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4),
        ],
      ),
      child: const Text(
        '40.7128° N, 74.0060° W',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

/// Lightweight painter that mimics a stylized map grid background
/// so the location card doesn't require a real maps SDK/API key.
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 1;

    const step = 24.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // Center pin
    final pinPaint = Paint()..color = AppColors.navy;
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, 8, pinPaint);
    canvas.drawCircle(center, 8, Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}