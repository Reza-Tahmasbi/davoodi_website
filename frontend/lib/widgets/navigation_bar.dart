import 'package:davoodi/theme/app_colors.dart';
import 'package:davoodi/utils/app_spacings.dart';
import 'package:davoodi/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final double height;
  final bool isPersian; // true = Persian, false = English

  const NavigationBarWidget({
    super.key,
    this.height = 80,
    this.isPersian = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    // simple if/else for texts
    final homeText = isPersian ? AppStrings.home : "Home";
    final aboutText = isPersian ? AppStrings.aboutUs : "About Us";
    final servicesText = isPersian ? AppStrings.services : "Services";
    final titleText = isPersian ? "داوودی" : "Davoodi";
    final backgorundColor = LightThemeColors.onSurfaceColor;

    return AppBar(
      backgroundColor: backgorundColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Column(
        children: [
          AppSpacings.height20,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 16), // optional spacing from edge

              // RIGHT: logo / title -> Davoodi
              Text(
                titleText,
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),

              // LEFT: mobile menu button
              if (isMobile)
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu, color: Colors.blue.shade900),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                )
              else
                const SizedBox(width: 16),

              // CENTER: nav buttons
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _NavButton(title: homeText, path: "/"),
                    AppSpacings.width32,
                    AppSpacings.width32,
                    _NavButton(title: aboutText, path: "/about"),
                    AppSpacings.width32,
                    AppSpacings.width32,
                    _NavButton(title: servicesText, path: "/services"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: Colors.grey.shade300, // line color
          height: 1,
        ),
      ),
    );
  }
}

class _NavButton extends StatefulWidget {
  final String title;
  final String path;

  const _NavButton({required this.title, required this.path});

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final normalColor = LightThemeColors.primaryTextColor;
    final hoverColor = LightThemeColors.secondaryTextColor;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: () => GoRouter.of(context).go(widget.path),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            color: _isHovering ? hoverColor : normalColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          child: Text(widget.title),
        ),
      ),
    );
  }
}

class NavigationDrawerWidget extends StatelessWidget {
  final bool isPersian; // control language in drawer
  const NavigationDrawerWidget({super.key, this.isPersian = true});

  @override
  Widget build(BuildContext context) {
    final homeText = isPersian ? AppStrings.home : "Home";
    final aboutText = isPersian ? AppStrings.aboutUs : "About Us";
    final servicesText = isPersian ? AppStrings.services : "Services";
    final titleText = isPersian ? "داوودی" : "Davoodi";

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue.shade900),
            child: Text(
              titleText,
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          _DrawerItem(title: homeText, path: "/"),
          _DrawerItem(title: aboutText, path: "/about"),
          _DrawerItem(title: servicesText, path: "/services"),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String title;
  final String path;

  const _DrawerItem({required this.title, required this.path});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {
        GoRouter.of(context).go(path);
        Navigator.of(context).pop(); // close drawer
      },
    );
  }
}
