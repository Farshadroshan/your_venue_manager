import 'package:flutter/material.dart';
import 'package:your_venue_manager/core/colors/app_colors.dart';


class AccountPendingVerificationScreen extends StatelessWidget {
  const AccountPendingVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // _buildTopBar(),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: _buildStatusCard(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // STATUS CARD
  // ---------------------------------------------------------------------
  Widget _buildStatusCard(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Gold accent bar at the top of the card
          Container(
            height: 5,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              gradient: LinearGradient(
                colors: [AppColors.goldLight, AppColors.gold],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
            child: Column(
              children: [
                _buildPendingIcon(),
                const SizedBox(height: 24),
                const Text(
                  'Account Pending Verification',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navyDark,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your registration has been submitted successfully. '
                  'Our team will review your business details and verify '
                  'your account. You will be notified once approval is '
                  'completed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 22),
                _buildReviewPill(),
                const SizedBox(height: 28),
                _buildStepTracker(),
                const SizedBox(height: 26),
                const Divider(height: 1, color: AppColors.cardBorder),
                const SizedBox(height: 18),
                _buildBackToLogin(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // GLOWING PENDING ICON
  // ---------------------------------------------------------------------
  Widget _buildPendingIcon() {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3FE),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.35),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.assignment_outlined, size: 32, color: AppColors.blueAccent),
          Positioned(
            right: 14,
            bottom: 14,
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: AppColors.gold,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.access_time, size: 12, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // "REVIEW IN PROGRESS" PILL
  // ---------------------------------------------------------------------
  Widget _buildReviewPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.pillBackground,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.circle, size: 8, color: AppColors.blueAccent),
          SizedBox(width: 8),
          Text(
            'REVIEW IN PROGRESS',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: AppColors.navyDark,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // STEP TRACKER: Submitted -> Reviewing -> Access
  // ---------------------------------------------------------------------
  Widget _buildStepTracker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepNode(
          icon: Icons.check,
          label: 'Submitted',
          state: _StepState.done,
        ),
        _buildConnector(active: true),
        const _StepNode(
          icon: Icons.access_time,
          label: 'Reviewing',
          state: _StepState.active,
        ),
        _buildConnector(active: false),
        const _StepNode(
          icon: Icons.vpn_key_outlined,
          label: 'Access',
          state: _StepState.upcoming,
        ),
      ],
    );
  }

  Widget _buildConnector({required bool active}) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Container(
        width: 34,
        height: 2,
        color: active ? AppColors.gold.withValues(alpha: 0.6) : AppColors.cardBorder,
      ),
    );
  }

  // ---------------------------------------------------------------------
  // BACK TO LOGIN LINK
  // ---------------------------------------------------------------------
  Widget _buildBackToLogin(BuildContext context) {
    return TextButton.icon(
      onPressed: () => Navigator.maybePop(context),
      icon: const Icon(Icons.arrow_back, size: 16, color: AppColors.navy),
      label: const Text(
        'BACK TO LOGIN',
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: AppColors.navy,
        ),
      ),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.navy,
      ),
    );
  }
}

enum _StepState { done, active, upcoming }

class _StepNode extends StatelessWidget {
  final IconData icon;
  final String label;
  final _StepState state;

  const _StepNode({
    required this.icon,
    required this.label,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    late final Color bgColor;
    late final Color iconColor;
    late final Color labelColor;

    switch (state) {
      case _StepState.done:
        bgColor = AppColors.navy;
        iconColor = Colors.white;
        labelColor = AppColors.navyDark;
        break;
      case _StepState.active:
        bgColor = AppColors.goldLight.withValues(alpha: 0.5);
        iconColor = AppColors.gold;
        labelColor = AppColors.gold;
        break;
      case _StepState.upcoming:
        bgColor = AppColors.stepGrayBg;
        iconColor = AppColors.stepGrayIcon;
        labelColor = AppColors.textSecondary;
        break;
    }

    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: state == _StepState.active
                ? Border.all(color: AppColors.gold, width: 1.6)
                : null,
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: labelColor,
          ),
        ),
      ],
    );
  }
}