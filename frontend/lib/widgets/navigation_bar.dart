import 'package:davoodi/theme/app_colors.dart';
import 'package:davoodi/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final double height;
  final bool isPersian;

  const NavigationBarWidget({
    super.key,
    this.height = 90,
    this.isPersian = true,
  });

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  bool _isScrolled = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    final homeText = widget.isPersian ? AppStrings.home : "Home";
    final aboutText = widget.isPersian ? AppStrings.aboutUs : "About Us";
    final servicesText = widget.isPersian ? AppStrings.services : "Services";
    final contactText = widget.isPersian ? AppStrings.contactUs : "Contact";
    final titleText = widget.isPersian ? "داوودی" : "Davoodi";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: _isScrolled
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: widget.height,
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 48),
          child: Row(
            children: [
              // Logo/Brand Section
              _LogoSection(title: titleText),
              
              if (!isMobile) ...[
                const Spacer(),
                
                // Navigation Links
                _NavButton(title: homeText, path: "/"),
                const SizedBox(width: 32),
                _NavButton(title: aboutText, path: "/about"),
                const SizedBox(width: 32),
                _NavButton(title: servicesText, path: "/services"),
                const SizedBox(width: 40),
                
                // Contact Button
                _ContactButton(text: contactText),
              ] else ...[
                const Spacer(),
                
                // Mobile Menu Button
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    color: LightThemeColors.primaryDark,
                    iconSize: 28,
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Logo Section
class _LogoSection extends StatelessWidget {
  final String title;

  const _LogoSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => GoRouter.of(context).go("/"),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo Icon/Shape
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    LightThemeColors.primaryDark,
                    LightThemeColors.primaryColor,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: LightThemeColors.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.precision_manufacturing,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            
            // Company Name
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: LightThemeColors.primaryDark,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'تزریق پلاستیک',
                  style: TextStyle(
                    color: LightThemeColors.textLight,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Navigation Button
class _NavButton extends StatefulWidget {
  final String title;
  final String path;

  const _NavButton({required this.title, required this.path});

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;
    final isActive = currentPath == widget.path;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _isHovering = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovering = false);
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: () => GoRouter.of(context).go(widget.path),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  border: isActive
                      ? Border(
                          bottom: BorderSide(
                            color: LightThemeColors.primaryColor,
                            width: 2.5,
                          ),
                        )
                      : null,
                ),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: _isHovering || isActive
                        ? LightThemeColors.primaryColor
                        : LightThemeColors.primaryTextColor,
                    fontSize: 16,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                  child: Text(widget.title),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Contact Button
class _ContactButton extends StatefulWidget {
  final String text;

  const _ContactButton({required this.text});

  @override
  State<_ContactButton> createState() => _ContactButtonState();
}

class _ContactButtonState extends State<_ContactButton> with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _isHovering = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovering = false);
        _controller.reverse();
      },
        child: GestureDetector(
        onTap: () {
          // Scroll to consultation section or navigate
          // You can implement scroll to section here
        },
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _isHovering
                        ? [
                            LightThemeColors.primaryColor,
                            LightThemeColors.primaryDark,
                          ]
                        : [
                            LightThemeColors.primaryDark,
                            LightThemeColors.primaryColor,
                          ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: _isHovering
                      ? [
                          BoxShadow(
                            color: LightThemeColors.primaryColor.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: LightThemeColors.primaryColor.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Text(
                  widget.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Mobile Navigation Drawer
class NavigationDrawerWidget extends StatelessWidget {
  final bool isPersian;
  const NavigationDrawerWidget({super.key, this.isPersian = true});

  @override
  Widget build(BuildContext context) {
    final homeText = isPersian ? AppStrings.home : "Home";
    final aboutText = isPersian ? AppStrings.aboutUs : "About Us";
    final servicesText = isPersian ? AppStrings.services : "Services";
    final contactText = isPersian ? AppStrings.contactUs : "Contact";
    final titleText = isPersian ? "داوودی" : "Davoodi";

    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Drawer Header
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    LightThemeColors.primaryDark,
                    LightThemeColors.primaryColor,
                  ],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.precision_manufacturing,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titleText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'تزریق پلاستیک',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  _DrawerItem(
                    title: homeText,
                    path: "/",
                    icon: Icons.home,
                  ),
                  _DrawerItem(
                    title: aboutText,
                    path: "/about",
                    icon: Icons.info,
                  ),
                  _DrawerItem(
                    title: servicesText,
                    path: "/services",
                    icon: Icons.work,
                  ),
                  const Divider(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            LightThemeColors.primaryDark,
                            LightThemeColors.primaryColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          contactText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Drawer Item
class _DrawerItem extends StatelessWidget {
  final String title;
  final String path;
  final IconData icon;

  const _DrawerItem({
    required this.title,
    required this.path,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;
    final isActive = currentPath == path;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? LightThemeColors.primaryColor.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive
              ? LightThemeColors.primaryColor
              : LightThemeColors.textLight,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive
                ? LightThemeColors.primaryColor
                : LightThemeColors.primaryTextColor,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            fontSize: 16,
          ),
        ),
        onTap: () {
          GoRouter.of(context).go(path);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
