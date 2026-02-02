import 'package:davoodi/utils/app_strings.dart';
import 'package:davoodi/utils/app_spacings.dart';
import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A5F),
        image: DecorationImage(
          image: const AssetImage('assets/patterns/stardust.png'),
          repeat: ImageRepeat.repeat,
          alignment: Alignment.center,
          scale: 0.1,  // ← adjust this: 1.5 = larger pattern, 3.0 = smaller/denser
          colorFilter: ColorFilter.mode(
            Color(0xFF2C5282).withOpacity(0.60),   // ← key: 0.18–0.35 range usually works best
            BlendMode.softLight,              // ← usually gives nicest subtle result
            // Try these alternatives if softLight doesn't look good:
            // BlendMode.overlay     → stronger contrast
            // BlendMode.plus        → glowing/highlight effect
            // BlendMode.srcATop     → keeps more of original pattern color
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: 48,
      ),
      child: Column(
        children: [
          // Main Footer Content
          isMobile ? _buildMobileLayout() : _buildDesktopLayout(),

          AppSpacings.height32,

          // Divider
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.2),
          ),

          AppSpacings.height24,

          // Copyright
          Text(
            AppStrings.footerRights,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: _FooterSection(
            title: AppStrings.footerAbout,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.footerAboutText,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
                AppSpacings.height16,
                Row(
                  children: [
                    Icon(Icons.facebook, color: Colors.white.withOpacity(0.7), size: 24),
                    AppSpacings.width16,
                    Icon(Icons.camera_alt, color: Colors.white.withOpacity(0.7), size: 24),
                    AppSpacings.width16,
                    Icon(Icons.business, color: Colors.white.withOpacity(0.7), size: 24),
                  ],
                ),
              ],
            ),
          ),
        ),
        AppSpacings.width32,
        Expanded(
          child: _FooterSection(
            title: AppStrings.footerQuickLinks,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FooterLink(text: AppStrings.home),
                AppSpacings.height12,
                _FooterLink(text: AppStrings.aboutUs),
                AppSpacings.height12,
                _FooterLink(text: AppStrings.services),
                AppSpacings.height12,
                _FooterLink(text: AppStrings.consultationTitle),
              ],
            ),
          ),
        ),
        AppSpacings.width32,
        Expanded(
          child: _FooterSection(
            title: AppStrings.footerContact,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ContactItem(icon: Icons.location_on, text: AppStrings.footerAddress),
                AppSpacings.height16,
                _ContactItem(icon: Icons.phone, text: AppStrings.footerPhone),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FooterSection(
          title: AppStrings.footerAbout,
          child: Text(
            AppStrings.footerAboutText,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ),
        AppSpacings.height32,
        _FooterSection(
          title: AppStrings.footerQuickLinks,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FooterLink(text: AppStrings.home),
              AppSpacings.height12,
              _FooterLink(text: AppStrings.aboutUs),
              AppSpacings.height12,
              _FooterLink(text: AppStrings.services),
            ],
          ),
        ),
        AppSpacings.height32,
        _FooterSection(
          title: AppStrings.footerContact,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ContactItem(icon: Icons.location_on, text: AppStrings.footerAddress),
              AppSpacings.height16,
              _ContactItem(icon: Icons.phone, text: AppStrings.footerPhone),
            ],
          ),
        ),
      ],
    );
  }
}

class _FooterSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _FooterSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSpacings.height16,
        child,
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String text;
  const _FooterLink({required this.text});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: TextStyle(
          color: _isHovered ? Colors.white : Colors.white.withOpacity(0.7),
          fontSize: 14,
          decoration: _isHovered ? TextDecoration.underline : null,
        ),
        child: GestureDetector(
          onTap: () {
            // Handle navigation
          },
          child: Text(widget.text),
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.7), size: 20),
        AppSpacings.width12,
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
          ),
        ),
      ],
    );
  }
}