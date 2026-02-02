import 'package:davoodi/utils/app_strings.dart';
import 'package:davoodi/utils/app_spacings.dart';
import 'package:davoodi/widgets/footer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  final List<GlobalKey> _sectionKeys = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animationController.forward();
    
    // Initialize section keys
    for (int i = 0; i < 6; i++) {
      _sectionKeys.add(GlobalKey());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _scrollToSection(int index) {
    final context = _sectionKeys[index].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Hero Section
            _HeroSection(
              key: _sectionKeys[0],
              onGetStarted: () => _scrollToSection(4),
              onLearnMore: () => _scrollToSection(1),
            ),
            
            // About Section
            _AboutSection(key: _sectionKeys[1]),
            
            // Services Section
            _ServicesSection(
              key: _sectionKeys[2],
              scrollController: _scrollController,
            ),
            
            // Why Choose Us Section
            _CustomerSatisfactionSection(key: _sectionKeys[3]),
            
            // Consultation Section
            _ConsultationSection(key: _sectionKeys[4]),
            
            // Footer
            FooterWidget(key: _sectionKeys[5]),
          ],
        ),
      ),
    );
  }
}

// Hero Section
class _HeroSection extends StatefulWidget {
  final VoidCallback onGetStarted;
  final VoidCallback onLearnMore;

  const _HeroSection({
    super.key,
    required this.onGetStarted,
    required this.onLearnMore,
  });

  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return ClipPath(
      clipper: _HeroCurveClipper(),
      child: Container(
        key: const ValueKey('hero'),
        height: screenHeight,
        width: double.infinity,
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/imgs/header.jpeg',
                fit: BoxFit.cover,
              ),
            ),

            // Dark overlay
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),

            // Content
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 24.0 : 48.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.heroTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 36 : 56,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                            letterSpacing: 1.2,
                          ),
                        ),
                        AppSpacings.height24,

                        Text(
                          AppStrings.heroSubtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.95),
                            fontSize: isMobile ? 20 : 28,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                        AppSpacings.height16,

                        Text(
                          AppStrings.heroDescription,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: isMobile ? 16 : 20,
                            height: 1.6,
                          ),
                        ),
                        AppSpacings.height48,

                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          alignment: WrapAlignment.center,
                          children: [
                            _AnimatedButton(
                              text: AppStrings.getStarted,
                              onPressed: widget.onGetStarted,
                              isPrimary: true,
                            ),
                            _AnimatedButton(
                              text: AppStrings.learnMore,
                              onPressed: widget.onLearnMore,
                              isPrimary: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Scroll indicator
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Text(
                      'اسکرول کنید',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                    AppSpacings.height8,
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white.withOpacity(0.7),
                      size: 32,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start at top-left corner
    path.moveTo(0, 0);

    // Go to bottom-left, but leave space for the curve to start
    path.lineTo(0, size.height * 0.82); // ← adjust this % to control how high/low the curve starts

    // Smooth quadratic Bézier curve — main dip in the middle
    path.quadraticBezierTo(
      size.width * 0.3,          // control point x = center
      size.height * 1,        // control point y = how deep the dip goes ( > 1 = below bottom)
      size.width,                // end x
      size.height * 0.80,        // end y — should match left side for symmetry
    );

    // Go up to top-right corner
    path.lineTo(size.width, 0);

    // Close the path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}




// Animated Button Widget
class _AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _AnimatedButton({
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
  });

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
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
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (_controller.value * 0.05),
            child: ElevatedButton(
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isPrimary
                    ? Colors.white
                    : Colors.transparent,
                foregroundColor: widget.isPrimary
                    ? const Color(0xFF1E3A5F)
                    : Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                elevation: _isHovered ? 8 : 4,
              ),
              child: Text(
                widget.text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// About Section
class _AboutSection extends StatefulWidget {
  const _AboutSection({super.key});

  @override
  State<_AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<_AboutSection> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Trigger animation when section is visible
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    
    return Container(
      key: const ValueKey('about'),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: 80,
      ),
      color: Colors.white,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Section Title
            Text(
              AppStrings.aboutTitle,
              style: TextStyle(
                fontSize: isMobile ? 32 : 42,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E3A5F),
              ),
            ),
            AppSpacings.height16,
            Container(
              width: 80,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF2C5282),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            AppSpacings.height24,
            
            // Subtitle
            Text(
              AppStrings.aboutSubtitle,
              style: TextStyle(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2C5282),
              ),
            ),
            AppSpacings.height32,
            
            // Description
            Container(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Text(
                AppStrings.aboutDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  height: 1.8,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Services Section
class _ServicesSection extends StatefulWidget {
  final ScrollController scrollController;

  const _ServicesSection({super.key, required this.scrollController});

  @override
  State<_ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<_ServicesSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final GlobalKey _sectionKey = GlobalKey();
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    widget.scrollController.addListener(_checkVisibility);
  }

  void _checkVisibility() {
    if (_hasAnimated || !mounted) return;

    final BuildContext? context = _sectionKey.currentContext;
    if (context == null) return;

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;

    // Trigger when section is reasonably visible
    if (position.dy < screenHeight * 0.7 &&
        position.dy > -renderBox.size.height * 0.3) {
      if (mounted) {
        _hasAnimated = true;
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_checkVisibility);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    final services = [
      {
        'icon': Icons.precision_manufacturing,
        'title': AppStrings.service1Title,
        'description': AppStrings.service1Description,
      },
      {
        'icon': Icons.engineering,
        'title': AppStrings.service2Title,
        'description': AppStrings.service2Description,
      },
      {
        'icon': Icons.build,
        'title': AppStrings.service3Title,
        'description': AppStrings.service3Description,
      },
      {
        'icon': Icons.verified,
        'title': AppStrings.service4Title,
        'description': AppStrings.service4Description,
      },
    ];

    return Container(
      key: _sectionKey,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: 80,
      ),
      color: const Color(0xFFF8F9FA),
      child: Column(
        children: [
          // Section Title
          Text(
            AppStrings.servicesTitle,
            style: TextStyle(
              fontSize: isMobile ? 32 : 42,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E3A5F),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 80,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF2C5282),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppStrings.servicesSubtitle,
            style: TextStyle(
              fontSize: isMobile ? 18 : 20,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // Services Grid
          StaggeredAnimationGrid(
            controller: _controller,
            crossAxisCount: isMobile ? 2 : 4, // 2 on mobile, 4 on desktop → compact squares
            children: services.map((service) {
              return _ServiceCard(
                icon: service['icon'] as IconData,
                title: service['title'] as String,
                description: service['description'] as String,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF1E3A5F);
    final accentColor = const Color(0xFF2C5282);

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final double scale = 1.0 + (_controller.value * 0.03);

          return Transform.scale(
            scale: scale,
            child: AspectRatio(
              aspectRatio: 1.0, // ← square cards (change to 1.1 or 0.92 if you prefer)
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(_isHovered ? 0.15 : 0.08),
                      blurRadius: _isHovered ? 20 : 10,
                      offset: Offset(0, _isHovered ? 10 : 4),
                    ),
                  ],
                  border: _isHovered
                      ? Border.all(
                          color: primaryColor.withOpacity(0.2), width: 1.5)
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.09),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.icon,
                        size: 36,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        widget.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: Colors.grey[700],
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
// Staggered Animation Grid
class StaggeredAnimationGrid extends StatelessWidget {
  final AnimationController controller;
  final List<Widget> children;
  final int crossAxisCount;

  const StaggeredAnimationGrid({
    super.key,
    required this.controller,
    required this.children,
    required this.crossAxisCount,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.15, // Increased from 0.85 to make cards shorter
      ),
      itemCount: children.length,
      itemBuilder: (context, index) {
        final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              index * 0.1,
              0.6 + (index * 0.1),
              curve: Curves.easeOut,
            ),
          ),
        );
        
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: controller,
              curve: Interval(
                index * 0.1,
                0.6 + (index * 0.1),
                curve: Curves.easeOutCubic,
              ),
            )),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(
                  parent: controller,
                  curve: Interval(
                    index * 0.1,
                    0.6 + (index * 0.1),
                    curve: Curves.easeOutCubic,
                  ),
                ),
              ),
              child: children[index],
            ),
          ),
        );
      },
    );
  }
}

// Why Choose Us Section
class _CustomerSatisfactionSection extends StatefulWidget {
  const _CustomerSatisfactionSection({super.key});

  @override
  State<_CustomerSatisfactionSection> createState() =>
      _CustomerSatisfactionSectionState();
}

class _CustomerSatisfactionSectionState
    extends State<_CustomerSatisfactionSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    final satisfactionFactors = [
      {
        'icon': Icons.sentiment_satisfied_alt,
        'title': 'تمرکز بر نیاز مشتری',
        'description':
            'تمام خدمات ما بر اساس شناخت دقیق نیازها و انتظارات مشتریان طراحی و ارائه می‌شود.',
      },
      {
        'icon': Icons.verified,
        'title': 'کیفیت تضمین‌شده',
        'description':
            'رعایت استانداردهای حرفه‌ای و کنترل کیفیت مستمر، اساس تعهد ما به مشتریان است.',
      },
      {
        'icon': Icons.handshake,
        'title': 'شفافیت و اعتماد',
        'description':
            'ارتباط شفاف، گزارش‌دهی دقیق و پایبندی به تعهدات، پایه‌ی اعتماد متقابل ماست.',
      },
      {
        'icon': Icons.support_agent,
        'title': 'پشتیبانی پاسخ‌گو',
        'description':
            'تیم پشتیبانی ما همواره در کنار شماست تا در سریع‌ترین زمان، بهترین پاسخ را ارائه دهد.',
      },
      {
        'icon': Icons.trending_up,
        'title': 'بهبود مستمر خدمات',
        'description':
            'با دریافت بازخورد مشتریان، خدمات خود را به‌صورت مداوم ارتقا می‌دهیم.',
      },
      {
        'icon': Icons.star_rate,
        'title': 'رضایت بلندمدت',
        'description':
            'هدف ما ایجاد همکاری‌های پایدار و رضایت بلندمدت، فراتر از یک قرارداد کوتاه‌مدت است.',
      },
    ];

    return Container(
      key: const ValueKey('customer-satisfaction'),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: 80,
      ),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            'رضایت مشتری',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 32 : 42,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E3A5F),
            ),
          ),
          AppSpacings.height16,
          Container(
            width: 80,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF2C5282),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          AppSpacings.height24,
          Text(
            'ما باور داریم رضایت مشتری نتیجه‌ی کیفیت، تعهد و ارتباط مؤثر است؛ '
            'اصولی که در تمام مراحل همکاری با شما رعایت می‌کنیم.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 18 : 20,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
          AppSpacings.height48,
          StaggeredAnimationGrid(
            controller: _controller,
            crossAxisCount: isMobile ? 1 : 3,
            children: satisfactionFactors.map((item) {
              return _ServiceCard(
                icon: item['icon'] as IconData,
                title: item['title'] as String,
                description: item['description'] as String,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _ConsultationSection extends StatefulWidget {
  const _ConsultationSection({super.key});
  @override
  State<_ConsultationSection> createState() => _ConsultationSectionState();
}

class _ConsultationSectionState extends State<_ConsultationSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // TODO: real submission logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('درخواست شما با موفقیت ارسال شد'),
          backgroundColor: const Color(0xFF2563EB),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      _formKey.currentState!.reset();
      _nameController.clear();
      _phoneController.clear();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: 100,
      ),
      // No color here → inherits page background (white)
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Text(
              AppStrings.consultationTitle,
              style: TextStyle(
                fontSize: isMobile ? 32 : 40,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111827),
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 64,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Text(
                AppStrings.consultationSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 17 : 19,
                  color: const Color(0xFF4B5563),
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 48),

            // ─── Form ───────────────────────────────────────────────
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextField(
                        controller: _nameController,
                        label: AppStrings.name,
                        icon: Icons.person_outline_rounded,
                        validator: (v) => v?.trim().isEmpty ?? true
                            ? 'لطفاً نام خود را وارد کنید'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _phoneController,
                        label: AppStrings.phone,
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (v) => v?.trim().isEmpty ?? true
                            ? 'لطفاً شماره تماس را وارد کنید'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _messageController,
                        label: AppStrings.message,
                        minLines: 4,
                        maxLines: 5,
                        validator: (v) => v?.trim().isEmpty ?? true
                            ? 'لطفاً پیام خود را وارد کنید'
                            : null,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          AppStrings.send,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    TextInputType? keyboardType,
    int minLines = 1,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF6B7280)),
        floatingLabelStyle: const TextStyle(color: Color(0xFF2563EB)),
        prefixIcon: icon != null
            ? Icon(icon, color: const Color(0xFF9CA3AF), size: 22)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB), width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
        ),
        // ─── Most important changes here ───
        filled: false,          // no background fill
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      validator: validator,
    );
  }
}

