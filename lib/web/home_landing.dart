import 'package:flutter/material.dart';
import 'package:grupo_casadecor/web/sections/about_section.dart';
import 'package:grupo_casadecor/web/sections/benefits_section.dart';
import 'package:grupo_casadecor/web/sections/contact_section.dart';
import 'package:grupo_casadecor/web/sections/hero_section.dart';
import 'package:grupo_casadecor/web/sections/how_section.dart';
import 'package:grupo_casadecor/web/sections/partners_section.dart';
import 'package:grupo_casadecor/web/sections/prizes_section.dart';
import 'package:grupo_casadecor/web/widgets/navigation_menu.dart';

class HomeLandingPage extends StatefulWidget {
  const HomeLandingPage({super.key});

  @override
  State<HomeLandingPage> createState() => _HomeLandingPageState();
}

class _HomeLandingPageState extends State<HomeLandingPage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(7, (index) => GlobalKey());

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _scrollToSection(int index) {
    if (index < _sectionKeys.length) {
      final context = _sectionKeys[index].currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: HeroSection(key: _sectionKeys[0]),
                ),
                SliverToBoxAdapter(
                  child: AboutSection(key: _sectionKeys[1]),
                ),
                SliverToBoxAdapter(
                  child: HowItWorksSection(key: _sectionKeys[2]),
                ),
                SliverToBoxAdapter(
                  child: BenefitsSection(key: _sectionKeys[3]),
                ),
                SliverToBoxAdapter(
                  child: PartnersSection(key: _sectionKeys[4]),
                ),
                SliverToBoxAdapter(
                  child: PrizesSection(key: _sectionKeys[5]),
                ),
                SliverToBoxAdapter(
                  child: ContactSection(key: _sectionKeys[6]),
                ),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: NavigationMenu(
                onNavigate: _scrollToSection,
                scrollController: _scrollController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
