import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Keys para las secciones
  final GlobalKey _inicioKey = GlobalKey();
  final GlobalKey _sobreMiKey = GlobalKey();
  final GlobalKey _proyectosKey = GlobalKey();
  final GlobalKey _contactoKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  int _activeSection = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateActiveSection);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateActiveSection);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateActiveSection() {
    final keys = [_inicioKey, _sobreMiKey, _proyectosKey, _contactoKey];
    final viewportTop = MediaQuery.of(context).size.width < 768 ? 120.0 : 160.0;
    int idx = 0;
    for (int i = 0; i < keys.length; i++) {
      final ctx = keys[i].currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject();
      if (box is! RenderBox) continue;
      final y = box.localToGlobal(Offset.zero).dy;
      if (y <= viewportTop) idx = i;
    }
    if (idx != _activeSection) {
      setState(() => _activeSection = idx);
    }
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0a0e1a),
              Color(0xFF0d1117),
              Color(0xFF0f1419),
              Color(0xFF0a0e1a),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Fondo con efectos visuales mejorados
            ..._buildBackgroundEffects(),

            // Contenido principal con scroll
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width < 768 ? 70 : 80,
              ), // Espacio para el navbar fijo
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    Container(key: _inicioKey), // Marcador para Inicio
                    SizedBox(
                        height:
                            MediaQuery.of(context).size.width < 768 ? 30 : 60),
                    _FadeInUp(
                      delay: const Duration(milliseconds: 100),
                      child: _buildHeroSection(context, key: _sobreMiKey),
                    ),
                    SizedBox(
                        height:
                            MediaQuery.of(context).size.width < 768 ? 40 : 60),
                    _FadeInUp(
                      delay: const Duration(milliseconds: 350),
                      child: _buildStatsSection(context),
                    ),
                    SizedBox(
                        height:
                            MediaQuery.of(context).size.width < 768 ? 50 : 80),
                    _FadeInUp(
                      delay: const Duration(milliseconds: 500),
                      child: _buildSkillsSection(context),
                    ),
                    SizedBox(
                        height:
                            MediaQuery.of(context).size.width < 768 ? 50 : 80),
                    _FadeInUp(
                      delay: const Duration(milliseconds: 650),
                      child: _buildProjectsHighlight(context,
                          key: _proyectosKey),
                    ),
                    SizedBox(
                        height:
                            MediaQuery.of(context).size.width < 768 ? 50 : 80),
                    _FadeInUp(
                      delay: const Duration(milliseconds: 800),
                      child: _buildContactSection(context, key: _contactoKey),
                    ),
                    SizedBox(
                        height:
                            MediaQuery.of(context).size.width < 768 ? 40 : 60),
                    _buildFooter(),
                  ],
                ),
              ),
            ),

            // Navbar fijo en la parte superior
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF0a0e1a),
                      const Color(0xFF0a0e1a).withValues(alpha: 0.9),
                      const Color(0xFF0a0e1a).withValues(alpha: 0.0),
                    ],
                    stops: const [0.0, 0.7, 1.0],
                  ),
                ),
                child: _buildNavBar(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBackgroundEffects() {
    return const [
      // Grid sutil global
      Positioned.fill(
        child: IgnorePointer(
          child: CustomPaint(painter: _SubtleGridPainter()),
        ),
      ),

      // Orbe principal azul (arriba-izquierda)
      Positioned(
        top: -180,
        left: -120,
        child: _AnimatedOrb(
          size: 520,
          color: Color(0xFF42A5F5),
          opacity: 0.22,
          driftX: 40,
          driftY: 30,
          duration: Duration(seconds: 18),
        ),
      ),

      // Orbe teal (centro-derecha)
      Positioned(
        top: 420,
        right: -160,
        child: _AnimatedOrb(
          size: 460,
          color: Color(0xFF00D2B8),
          opacity: 0.18,
          driftX: -50,
          driftY: 40,
          duration: Duration(seconds: 22),
        ),
      ),

      // Orbe púrpura (inferior)
      Positioned(
        bottom: -220,
        left: 200,
        child: _AnimatedOrb(
          size: 560,
          color: Color(0xFF7C5CFF),
          opacity: 0.16,
          driftX: 60,
          driftY: -30,
          duration: Duration(seconds: 26),
        ),
      ),
    ];
  }

  Widget _buildNavBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isVerySmall = screenWidth < 400;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 40,
        vertical: isMobile ? 10 : 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo - más compacto en móvil
          Row(
            children: [
              Container(
                width: isMobile ? 34 : 45,
                height: isMobile ? 34 : 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF42A5F5), Color(0xFF00D2B8)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF42A5F5).withValues(alpha: 0.3),
                      blurRadius: isMobile ? 10 : 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'LG',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 12 : 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              if (!isVerySmall) ...[
                const SizedBox(width: 10),
                Text(
                  'leodan.dev',
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ],
          ),

          // Menú de navegación - solo iconos en móvil
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 6 : 0,
              vertical: isMobile ? 4 : 0,
            ),
            decoration: isMobile
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withValues(alpha: 0.05),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  )
                : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNavItem('Inicio', Icons.home_rounded,
                    () => _scrollToSection(_inicioKey),
                    isMobile: isMobile, isActive: _activeSection == 0),
                SizedBox(width: isMobile ? 2 : 8),
                _buildNavItem('Sobre mí', Icons.person_rounded,
                    () => _scrollToSection(_sobreMiKey),
                    isMobile: isMobile, isActive: _activeSection == 1),
                SizedBox(width: isMobile ? 2 : 8),
                _buildNavItem('Proyectos', Icons.work_rounded,
                    () => _scrollToSection(_proyectosKey),
                    isMobile: isMobile, isActive: _activeSection == 2),
                SizedBox(width: isMobile ? 2 : 8),
                _buildNavItem('Contacto', Icons.mail_rounded,
                    () => _scrollToSection(_contactoKey),
                    isMobile: isMobile, isActive: _activeSection == 3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String label, IconData icon, VoidCallback onTap,
      {bool isMobile = false, bool isActive = false}) {
    return _HoverNavItem(
      label: label,
      icon: icon,
      onTap: onTap,
      isMobile: isMobile,
      isActive: isActive,
    );
  }

  Widget _buildHeroSection(BuildContext context, {Key? key}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Container(
      key: key,
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
      child: isMobile
          ? _buildHeroMobile(context)
          : _buildHeroDesktop(context, isTablet: isTablet),
    );
  }

  Widget _buildHeroMobile(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmall = screenWidth < 380;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar con anillo rotatorio
        _RotatingAvatarRing(
          size: isVerySmall ? 130 : 150,
          thickness: 3,
          colors: const [
            Color(0xFF42A5F5),
            Color(0xFF00D2B8),
            Color(0xFF7C5CFF),
            Color(0xFFFF6D5A),
            Color(0xFF42A5F5),
          ],
          child: Image.asset(
            'assets/img/profile2.jpg',
            fit: BoxFit.cover,
            alignment: const Alignment(0, 0.15),
          ),
        ),
        const SizedBox(height: 18),
        const _AvailableBadge(isMobile: true),
        const SizedBox(height: 14),

        // Información
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Saludo pequeño
            Text(
              '¡Hola! Soy',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF42A5F5).withValues(alpha: 0.9),
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 6),
            _GradientText(
              text: 'Leodan García',
              textAlign: TextAlign.center,
              colors: const [
                Colors.white,
                Color(0xFFBFD7F5),
                Color(0xFFE8E4FF),
              ],
              style: GoogleFonts.spaceGrotesk(
                fontSize: isVerySmall ? 30 : 36,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.05,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 14),

            // Texto animado - contenedor más elegante
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white.withValues(alpha: 0.05),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: SizedBox(
                height: 24,
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: isVerySmall ? 13 : 14,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                  child: AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Desarrollador Frontend Mobile',
                        speed: const Duration(milliseconds: 70),
                        textStyle: TextStyle(
                          fontSize: isVerySmall ? 13 : 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF42A5F5),
                        ),
                      ),
                      TypewriterAnimatedText(
                        'Especializado en Dart & Flutter',
                        speed: const Duration(milliseconds: 70),
                        textStyle: TextStyle(
                          fontSize: isVerySmall ? 13 : 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF00D2B8),
                        ),
                      ),
                      TypewriterAnimatedText(
                        'Automatización con Python & n8n',
                        speed: const Duration(milliseconds: 70),
                        textStyle: TextStyle(
                          fontSize: isVerySmall ? 13 : 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFF6D5A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Descripción más corta para móvil
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Desarrollador junior de apps móviles con Flutter. '
                'Apasionado por la automatización y el aprendizaje continuo.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isVerySmall ? 13 : 14,
                  color: Colors.white.withValues(alpha: 0.65),
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Badges en línea
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBadge('UTEG · 7mo', isMobile: true),
                const SizedBox(width: 8),
                _buildBadge('Ecuador 🇪🇨', isMobile: true),
              ],
            ),

            const SizedBox(height: 20),

            // CTAs principales
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                _PrimaryCTA(
                  label: 'Contáctame',
                  icon: Icons.arrow_forward_rounded,
                  isMobile: true,
                  onTap: () => _scrollToSection(_contactoKey),
                ),
                _SecondaryCTA(
                  label: 'Proyectos',
                  icon: Icons.folder_rounded,
                  isMobile: true,
                  onTap: () => _scrollToSection(_proyectosKey),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // Iconos sociales - grid compacto
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIconMobile(
                  iconPath: 'assets/icons/github.svg',
                  color: const Color(0xFF24292e),
                  url: 'https://github.com/leodan87',
                ),
                const SizedBox(width: 10),
                _buildSocialIconMobile(
                  iconPath: 'assets/icons/instagram.svg',
                  color: const Color(0xFFE4405F),
                  url: 'https://instagram.com/leo_dangg',
                ),
                const SizedBox(width: 10),
                _buildSocialIconMobile(
                  iconPath: 'assets/icons/twitter.svg',
                  color: const Color(0xFF14171A),
                  url: 'https://x.com/LeodanGarcia4',
                ),
                const SizedBox(width: 10),
                _buildSocialIconMobile(
                  iconPath: 'assets/icons/discord.svg',
                  color: const Color(0xFF5865F2),
                  url: 'https://discord.com/users/leo_garcia',
                ),
                const SizedBox(width: 10),
                _buildSocialIconMobile(
                  iconPath: 'assets/icons/email.svg',
                  color: const Color(0xFF42A5F5),
                  url: 'mailto:leogarcia@leodan.dev',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIconMobile({
    required String iconPath,
    required Color color,
    required String url,
  }) {
    return InkWell(
      onTap: () => _launchURL(url),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            iconPath,
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroDesktop(BuildContext context, {bool isTablet = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar con anillo rotatorio
        _RotatingAvatarRing(
          size: isTablet ? 170 : 200,
          thickness: 3,
          colors: const [
            Color(0xFF42A5F5),
            Color(0xFF00D2B8),
            Color(0xFF7C5CFF),
            Color(0xFFFF6D5A),
            Color(0xFF42A5F5),
          ],
          child: Image.asset(
            'assets/img/profile2.jpg',
            fit: BoxFit.cover,
            alignment: const Alignment(0, 0.15),
          ),
        ),
        SizedBox(width: isTablet ? 40 : 60),

        // Información
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _AvailableBadge(),
              const SizedBox(height: 18),
              _GradientText(
                text: 'Leodan García',
                colors: const [
                  Colors.white,
                  Color(0xFFBFD7F5),
                  Color(0xFFE8E4FF),
                ],
                style: GoogleFonts.spaceGrotesk(
                  fontSize: isTablet ? 48 : 60,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.0,
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(height: 16),

              // Texto animado
              SizedBox(
                height: 60,
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: isTablet ? 20 : 24,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                  child: AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Desarrollador Frontend Mobile',
                        speed: const Duration(milliseconds: 80),
                        textStyle: TextStyle(
                          fontSize: isTablet ? 20 : 24,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF42A5F5),
                        ),
                      ),
                      TypewriterAnimatedText(
                        'Especializado en Dart & Flutter',
                        speed: const Duration(milliseconds: 80),
                        textStyle: TextStyle(
                          fontSize: isTablet ? 20 : 24,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF00D2B8),
                        ),
                      ),
                      TypewriterAnimatedText(
                        'Automatización con Python & n8n',
                        speed: const Duration(milliseconds: 80),
                        textStyle: TextStyle(
                          fontSize: isTablet ? 20 : 24,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFF6D5A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Text(
                'Soy un desarrollador junior de aplicaciones móviles especializado en frontend. '
                'Trabajo con Dart y Flutter, conozco Python para automatización, n8n, Git y Linux. '
                'Me encanta aprender nuevas tecnologías y mejorar mis habilidades constantemente.',
                style: TextStyle(
                  fontSize: isTablet ? 15 : 17,
                  color: Colors.white.withValues(alpha: 0.7),
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 32),

              // Badges
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildBadge('UTEG · 7mo semestre · Ingeniería de Software'),
                  _buildBadge('Ecuador 🇪🇨'),
                ],
              ),

              const SizedBox(height: 28),

              // CTAs principales
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _PrimaryCTA(
                    label: 'Contáctame',
                    icon: Icons.arrow_forward_rounded,
                    onTap: () => _scrollToSection(_contactoKey),
                  ),
                  _SecondaryCTA(
                    label: 'Ver proyectos',
                    icon: Icons.folder_rounded,
                    onTap: () => _scrollToSection(_proyectosKey),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Iconos sociales
              Row(
                children: [
                  _buildSocialIcon(
                    iconPath: 'assets/icons/github.svg',
                    color: const Color(0xFF24292e),
                    url: 'https://github.com/leodan87',
                    tooltip: 'GitHub - leodan87',
                  ),
                  const SizedBox(width: 12),
                  _buildSocialIcon(
                    iconPath: 'assets/icons/instagram.svg',
                    color: const Color(0xFFE4405F),
                    url: 'https://instagram.com/leo_dangg',
                    tooltip: 'Instagram - @leo_dangg',
                  ),
                  const SizedBox(width: 12),
                  _buildSocialIcon(
                    iconPath: 'assets/icons/twitter.svg',
                    color: const Color(0xFF14171A),
                    url: 'https://x.com/LeodanGarcia4',
                    tooltip: 'X - @LeodanGarcia4',
                  ),
                  const SizedBox(width: 12),
                  _buildSocialIcon(
                    iconPath: 'assets/icons/discord.svg',
                    color: const Color(0xFF5865F2),
                    url: 'https://discord.com/users/leo_garcia',
                    tooltip: 'Discord - leo_garcia',
                  ),
                  const SizedBox(width: 12),
                  _buildSocialIcon(
                    iconPath: 'assets/icons/email.svg',
                    color: const Color(0xFF42A5F5),
                    url: 'mailto:leogarcia@leodan.dev',
                    tooltip: 'Email - leogarcia@leodan.dev',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    final stats = [
      _StatCard(
        value: 4,
        suffix: '+',
        label: 'PROYECTOS',
        icon: Icons.rocket_launch_rounded,
        logoAsset: 'assets/icons/flutter.svg',
        color: const Color(0xFF42A5F5),
        isMobile: isMobile,
        onTap: () => _scrollToSection(_proyectosKey),
      ),
      _StatCard(
        value: 6,
        suffix: '+',
        label: 'TECNOLOGÍAS',
        icon: Icons.layers_rounded,
        logoAsset: 'assets/icons/dart.svg',
        color: const Color(0xFF00D2B8),
        isMobile: isMobile,
        onTap: () => _scrollToSection(_skillsKey),
      ),
      _StatCard(
        value: 1,
        suffix: '🏆',
        label: 'HACKATHON',
        icon: Icons.emoji_events_rounded,
        logoEmoji: '🥈',
        color: const Color(0xFFFFD43B),
        isMobile: isMobile,
        onTap: () => _scrollToSection(_proyectosKey),
      ),
      _StatCard(
        value: 7,
        suffix: 'º sem',
        label: 'INGENIERÍA SOFTWARE',
        icon: Icons.school_rounded,
        logoAsset: 'assets/img/uteg-logo.png',
        logoBgColor: Colors.white,
        color: const Color(0xFF7C5CFF),
        isMobile: isMobile,
      ),
    ];

    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cols = isMobile ? 2 : 4;
          final spacing = isMobile ? 10.0 : 18.0;
          final width =
              (constraints.maxWidth - spacing * (cols - 1)) / cols;
          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: stats.map((s) => SizedBox(width: width, child: s)).toList(),
          );
        },
      ),
    );
  }

  Widget _buildBadge(String text, {bool isMobile = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: isMobile ? 8 : 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isMobile ? 12 : 14,
          fontWeight: FontWeight.w600,
          color: Colors.white.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _buildSocialIcon({
    required String iconPath,
    required Color color,
    required String url,
    required String tooltip,
  }) {
    return _HoverSocialIcon(
      iconPath: iconPath,
      color: color,
      url: url,
      tooltip: tooltip,
      onTap: _launchURL,
    );
  }

  Widget _buildSkillsSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      key: _skillsKey,
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40),
      child: Column(
        crossAxisAlignment:
            isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            number: '01',
            eyebrow: 'Stack',
            title: 'Tecnologías',
            subtitle: 'Herramientas con las que construyo día a día',
            accent: const Color(0xFF42A5F5),
            isMobile: isMobile,
          ),
          SizedBox(height: isMobile ? 24 : 40),
          isMobile
              ? _buildSkillsGridMobile()
              : Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildSkillCard('Flutter', 'assets/icons/flutter.svg',
                        const Color(0xFF42A5F5)),
                    _buildSkillCard('Dart', 'assets/icons/dart.svg',
                        const Color(0xFF00D2B8)),
                    _buildSkillCard('Python', 'assets/icons/python.svg',
                        const Color(0xFFFFD43B)),
                    _buildSkillCard(
                        'n8n', 'assets/icons/n8n.svg', const Color(0xFFFF6D5A)),
                    _buildSkillCard(
                        'Git', 'assets/icons/git.svg', const Color(0xFFF05032)),
                    _buildSkillCard('Linux', 'assets/icons/terminal.svg',
                        const Color(0xFFFCC624)),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildSkillsGridMobile() {
    final skills = [
      {
        'name': 'Flutter',
        'icon': 'assets/icons/flutter.svg',
        'color': const Color(0xFF42A5F5)
      },
      {
        'name': 'Dart',
        'icon': 'assets/icons/dart.svg',
        'color': const Color(0xFF00D2B8)
      },
      {
        'name': 'Python',
        'icon': 'assets/icons/python.svg',
        'color': const Color(0xFFFFD43B)
      },
      {
        'name': 'n8n',
        'icon': 'assets/icons/n8n.svg',
        'color': const Color(0xFFFF6D5A)
      },
      {
        'name': 'Git',
        'icon': 'assets/icons/git.svg',
        'color': const Color(0xFFF05032)
      },
      {
        'name': 'Linux',
        'icon': 'assets/icons/terminal.svg',
        'color': const Color(0xFFFCC624)
      },
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: skills
          .map((skill) => _buildSkillChipMobile(
                skill['name'] as String,
                skill['icon'] as String,
                skill['color'] as Color,
              ))
          .toList(),
    );
  }

  Widget _buildSkillChipMobile(String name, String iconPath, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.4),
          width: 1.5,
        ),
        color: color.withValues(alpha: 0.1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          const SizedBox(width: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCard(String name, String iconPath, Color color) {
    return _HoverSkillCard(name: name, iconPath: iconPath, color: color);
  }

  Widget _buildProjectsHighlight(BuildContext context, {Key? key}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      key: key,
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40),
      child: Column(
        crossAxisAlignment:
            isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            number: '02',
            eyebrow: 'Portfolio',
            title: 'Proyectos destacados',
            subtitle:
                'Una muestra de apps que he construido, desde hackathones hasta productos reales',
            accent: const Color(0xFF00D2B8),
            isMobile: isMobile,
          ),
          SizedBox(height: isMobile ? 24 : 40),

          // Featured: AlertaEstudiantil (full-width, premiado)
          _HoverProjectCard(
            title: 'AlertaEstudiantil',
            description: isMobile
                ? 'Detecta estudiantes en riesgo académico y envía alertas automáticas con recomendaciones generadas por IA.'
                : 'Sistema que detecta estudiantes en riesgo académico y envía alertas automáticas con recomendaciones personalizadas generadas por IA. Desarrollado en 36h durante el Hackathon UTEG.',
            tech: isMobile
                ? const ['Flutter', 'n8n', 'AI', 'Cloud Run']
                : const ['Flutter', 'n8n', 'Cloud Run', 'AI', 'Dart'],
            color: const Color(0xFF42A5F5),
            featured: true,
            isMobile: isMobile,
            icon: Icons.school_rounded,
            logoAsset: 'assets/img/uteg-logo.png',
            logoBgColor: Colors.white,
            statusLabel: '2do lugar · Hackathon UTEG',
            statusIcon: '🏆',
            statusColor: const Color(0xFFFFD43B),
          ),
          SizedBox(height: isMobile ? 16 : 24),

          // Grid secundario: 3 proyectos (2 cols desktop, 1 col mobile)
          LayoutBuilder(
            builder: (context, constraints) {
              final cols = isMobile ? 1 : 2;
              final spacing = isMobile ? 14.0 : 20.0;
              final w =
                  (constraints.maxWidth - spacing * (cols - 1)) / cols;
              final cards = <Widget>[
                _HoverProjectCard(
                  title: 'Penthum',
                  description: isMobile
                      ? 'Mensajería anónima con mensajes efímeros y cifrado E2E.'
                      : 'App de mensajería anónima con mensajes efímeros, cifrado E2E (AES-256), protección contra capturas y salas temporales con QR.',
                  tech: isMobile
                      ? const ['Flutter', 'Firebase', 'Riverpod']
                      : const [
                          'Flutter',
                          'Firebase',
                          'Riverpod',
                          'SQLCipher',
                          'FCM'
                        ],
                  color: const Color(0xFF7C5CFF),
                  isMobile: isMobile,
                  icon: Icons.shield_moon_rounded,
                  logoAsset: 'assets/img/logo_penthum.png',
                  statusLabel: 'En desarrollo',
                  statusIcon: '🚧',
                  statusColor: const Color(0xFFF59E0B),
                ),
                _HoverProjectCard(
                  title: 'LockPass',
                  description: isMobile
                      ? 'Gestor de contraseñas seguro y ordenado.'
                      : 'App para guardar cuentas y contraseñas de forma segura, enfocada en simplicidad y orden.',
                  tech: const ['Flutter', 'Dart'],
                  color: const Color(0xFFF97316),
                  isMobile: isMobile,
                  icon: Icons.lock_rounded,
                  logoAsset: 'assets/img/logo_lockpas.png',
                  statusLabel: 'Activo',
                  statusIcon: '🟢',
                  statusColor: const Color(0xFF10B981),
                ),
                _HoverProjectCard(
                  title: 'JaraSecurity',
                  description: isMobile
                      ? 'Seguridad privada: reportes, control y supervisión.'
                      : 'App para empresa de seguridad privada con sistema de reportes, control y módulos de supervisión.',
                  tech: const ['Flutter', 'Dart'],
                  color: const Color(0xFFC9A961),
                  isMobile: isMobile,
                  icon: Icons.security_rounded,
                  logoAsset: 'assets/img/logo_jara.png',
                  statusLabel: 'Producción',
                  statusIcon: '🟢',
                  statusColor: const Color(0xFF10B981),
                ),
              ];
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children:
                    cards.map((c) => SizedBox(width: w, child: c)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context, {Key? key}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      key: key,
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40),
      child: Column(
        crossAxisAlignment:
            isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            number: '03',
            eyebrow: 'Contacto',
            title: 'Hablemos',
            subtitle: isMobile
                ? 'Disponible para proyectos'
                : 'Disponible para proyectos, colaboraciones y oportunidades',
            accent: const Color(0xFFFF6D5A),
            isMobile: isMobile,
          ),
          SizedBox(height: isMobile ? 24 : 40),
          isMobile
              ? Column(
                  children: [
                    _buildContactCardMobile(
                      icon: Icons.email,
                      title: 'Email Principal',
                      subtitle: 'leogarcia@leodan.dev',
                      color: const Color(0xFF42A5F5),
                      url: 'mailto:leogarcia@leodan.dev',
                    ),
                    const SizedBox(height: 12),
                    _buildContactCardMobile(
                      icon: Icons.support_agent,
                      title: 'Soporte',
                      subtitle: 'support@leodan.dev',
                      color: const Color(0xFF7C5CFF),
                      url: 'mailto:support@leodan.dev',
                    ),
                    const SizedBox(height: 12),
                    _buildContactCardMobile(
                      icon: Icons.person,
                      title: 'Personal',
                      subtitle: 'leogarcia.lsgg@gmail.com',
                      color: const Color(0xFF00D2B8),
                      url: 'mailto:leogarcia.lsgg@gmail.com',
                    ),
                  ],
                )
              : Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    _buildContactCard(
                      icon: Icons.email,
                      title: 'Email Principal',
                      subtitle: 'leogarcia@leodan.dev',
                      color: const Color(0xFF42A5F5),
                      url: 'mailto:leogarcia@leodan.dev',
                    ),
                    _buildContactCard(
                      icon: Icons.support_agent,
                      title: 'Soporte',
                      subtitle: 'support@leodan.dev',
                      color: const Color(0xFF7C5CFF),
                      url: 'mailto:support@leodan.dev',
                    ),
                    _buildContactCard(
                      icon: Icons.person,
                      title: 'Personal',
                      subtitle: 'leogarcia.lsgg@gmail.com',
                      color: const Color(0xFF00D2B8),
                      url: 'mailto:leogarcia.lsgg@gmail.com',
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildContactCardMobile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required String url,
  }) {
    return InkWell(
      onTap: () => _launchURL(url),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withValues(alpha: 0.25),
          ),
          color: color.withValues(alpha: 0.05),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                ),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: color.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required String url,
  }) {
    return _HoverContactCard(
      icon: icon,
      title: title,
      subtitle: subtitle,
      color: color,
      url: url,
      onTap: _launchURL,
    );
  }

  Widget _buildFooter() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 24 : 30,
        horizontal: isMobile ? 20 : 40,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              '© ${DateTime.now().year} Leodan García. Todos los derechos reservados.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMobile ? 12 : 14,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Desarrollado con Flutter & Dart',
              style: TextStyle(
                fontSize: isMobile ? 11 : 12,
                color: Colors.white.withValues(alpha: 0.35),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

// Widget con efecto hover para iconos sociales
class _HoverSocialIcon extends StatefulWidget {
  final String iconPath;
  final Color color;
  final String url;
  final String tooltip;
  final Function(String) onTap;

  const _HoverSocialIcon({
    required this.iconPath,
    required this.color,
    required this.url,
    required this.tooltip,
    required this.onTap,
  });

  @override
  State<_HoverSocialIcon> createState() => _HoverSocialIconState();
}

class _HoverSocialIconState extends State<_HoverSocialIcon> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: InkWell(
        onTap: () => widget.onTap(widget.url),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 56,
          height: 56,
          transform: _isHovering
              ? (Matrix4.identity()..scale(1.1))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: widget.color,
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.3),
                blurRadius: _isHovering ? 16 : 8,
                offset: Offset(0, _isHovering ? 8 : 4),
              ),
            ],
          ),
          child: Center(
            child: SvgPicture.asset(
              widget.iconPath,
              width: 26,
              height: 26,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Widget con efecto hover para skill cards
class _HoverSkillCard extends StatefulWidget {
  final String name;
  final String iconPath;
  final Color color;

  const _HoverSkillCard({
    required this.name,
    required this.iconPath,
    required this.color,
  });

  @override
  State<_HoverSkillCard> createState() => _HoverSkillCardState();
}

class _HoverSkillCardState extends State<_HoverSkillCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        transform: _isHovering
            ? (Matrix4.identity()..translate(0.0, -4.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovering
                ? widget.color.withValues(alpha: 0.6)
                : widget.color.withValues(alpha: 0.3),
            width: _isHovering ? 2 : 1.5,
          ),
          color: _isHovering
              ? widget.color.withValues(alpha: 0.15)
              : widget.color.withValues(alpha: 0.05),
          boxShadow: _isHovering
              ? [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              widget.iconPath,
              width: 28,
              height: 28,
              colorFilter: ColorFilter.mode(
                widget.color,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              widget.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: widget.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget con efecto hover para contact cards
class _HoverContactCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String url;
  final Function(String) onTap;

  const _HoverContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.url,
    required this.onTap,
  });

  @override
  State<_HoverContactCard> createState() => _HoverContactCardState();
}

class _HoverContactCardState extends State<_HoverContactCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: InkWell(
        onTap: () => widget.onTap(widget.url),
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          constraints: BoxConstraints(
            maxWidth: isMobile ? screenWidth - 40 : 350,
            minWidth: isMobile ? screenWidth - 40 : 280,
          ),
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          transform: _isHovering
              ? (Matrix4.identity()..translate(0.0, -6.0))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _isHovering
                  ? widget.color.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.08),
              width: _isHovering ? 2 : 1,
            ),
            color: _isHovering
                ? widget.color.withValues(alpha: 0.05)
                : Colors.transparent,
            boxShadow: _isHovering
                ? [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    colors: [widget.color, widget.color.withValues(alpha: 0.6)],
                  ),
                ),
                child: Icon(widget.icon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Grid sutil de fondo
class _SubtleGridPainter extends CustomPainter {
  const _SubtleGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.018)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const spacing = 80.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Orbe con blur radial y drift muy lento
class _AnimatedOrb extends StatefulWidget {
  final double size;
  final Color color;
  final double opacity;
  final double driftX;
  final double driftY;
  final Duration duration;

  const _AnimatedOrb({
    required this.size,
    required this.color,
    required this.opacity,
    required this.driftX,
    required this.driftY,
    required this.duration,
  });

  @override
  State<_AnimatedOrb> createState() => _AnimatedOrbState();
}

class _AnimatedOrbState extends State<_AnimatedOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = Curves.easeInOutSine.transform(_controller.value);
        final dx = (t - 0.5) * 2 * widget.driftX;
        final dy = (t - 0.5) * 2 * widget.driftY;
        return Transform.translate(
          offset: Offset(dx, dy),
          child: IgnorePointer(
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    widget.color.withValues(alpha: widget.opacity),
                    widget.color.withValues(alpha: widget.opacity * 0.4),
                    widget.color.withValues(alpha: 0),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Widget de navegación con hover
class _HoverNavItem extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isMobile;
  final bool isActive;

  const _HoverNavItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isMobile = false,
    this.isActive = false,
  });

  @override
  State<_HoverNavItem> createState() => _HoverNavItemState();
}

class _HoverNavItemState extends State<_HoverNavItem> {
  bool _isHovering = false;

  static const _accent = Color(0xFF42A5F5);

  @override
  Widget build(BuildContext context) {
    final highlight = _isHovering || widget.isActive;
    final color =
        highlight ? _accent : Colors.white.withValues(alpha: 0.7);

    return Tooltip(
      message: widget.isMobile ? widget.label : '',
      preferBelow: true,
      decoration: BoxDecoration(
        color: const Color(0xFF1a2332),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      child: InkWell(
        onTap: widget.onTap,
        onHover: (hovering) => setState(() => _isHovering = hovering),
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isMobile ? 10 : 12,
            vertical: widget.isMobile ? 8 : 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.isActive
                ? _accent.withValues(alpha: 0.12)
                : (_isHovering
                    ? _accent.withValues(alpha: 0.08)
                    : Colors.transparent),
            border: Border.all(
              color: widget.isActive
                  ? _accent.withValues(alpha: 0.4)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.icon,
                    color: color,
                    size: 18,
                  ),
                  if (!widget.isMobile) ...[
                    const SizedBox(width: 6),
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ],
                ],
              ),
              // Subrayado de sección activa
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(top: 4),
                height: 2,
                width: widget.isActive ? (widget.isMobile ? 14 : 22) : 0,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF42A5F5), Color(0xFF00D2B8)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Project card con tilt 3D, status pill, icono/logo
class _HoverProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final List<String> tech;
  final Color color;
  final bool featured;
  final bool isMobile;
  final IconData? icon;
  final String? logoAsset;
  final Color? logoBgColor;
  final String? statusLabel;
  final String? statusIcon;
  final Color? statusColor;

  const _HoverProjectCard({
    required this.title,
    required this.description,
    required this.tech,
    required this.color,
    this.featured = false,
    this.isMobile = false,
    this.icon,
    this.logoAsset,
    this.logoBgColor,
    this.statusLabel,
    this.statusIcon,
    this.statusColor,
  });

  @override
  State<_HoverProjectCard> createState() => _HoverProjectCardState();
}

class _HoverProjectCardState extends State<_HoverProjectCard> {
  bool _hovering = false;
  Offset _localPos = Offset.zero;
  Size _size = Size.zero;

  void _onHoverMove(PointerEvent e) {
    if (widget.isMobile) return;
    setState(() => _localPos = e.localPosition);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = widget.isMobile;
    final featured = widget.featured;

    // Cálculo de tilt 3D basado en posición del ratón
    double rotX = 0;
    double rotY = 0;
    if (!isMobile && _hovering && _size != Size.zero) {
      final cx = _size.width / 2;
      final cy = _size.height / 2;
      final nx = ((_localPos.dx - cx) / cx).clamp(-1.0, 1.0);
      final ny = ((_localPos.dy - cy) / cy).clamp(-1.0, 1.0);
      rotX = -ny * 0.05;
      rotY = nx * 0.05;
    }

    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateX(rotX)
      ..rotateY(rotY)
      ..translate(0.0, _hovering ? -6.0 : 0.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() {
        _hovering = false;
        _localPos = Offset.zero;
      }),
      onHover: _onHoverMove,
      child: LayoutBuilder(
        builder: (context, c) {
          _size = Size(c.maxWidth, c.maxHeight);
          return AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            transform: transform,
            transformAlignment: Alignment.center,
            padding: EdgeInsets.all(
              isMobile ? 18 : (featured ? 32 : 24),
            ),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(isMobile ? 16 : (featured ? 22 : 18)),
              border: Border.all(
                color: _hovering
                    ? widget.color.withValues(alpha: 0.55)
                    : widget.color.withValues(alpha: 0.18),
                width: _hovering ? 1.5 : 1,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  widget.color.withValues(alpha: _hovering ? 0.18 : 0.08),
                  widget.color.withValues(alpha: _hovering ? 0.05 : 0.02),
                ],
              ),
              boxShadow: _hovering
                  ? [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.3),
                        blurRadius: 28,
                        offset: const Offset(0, 14),
                      ),
                    ]
                  : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Fila superior: logo/icono + status
                Row(
                  children: [
                    if (widget.logoAsset != null)
                      _ProjectLogoBox(
                        asset: widget.logoAsset!,
                        size: isMobile ? 44 : (featured ? 64 : 52),
                        color: widget.color,
                        fallbackIcon: widget.icon,
                        backgroundColor: widget.logoBgColor,
                      )
                    else if (widget.icon != null)
                      Container(
                        width: isMobile ? 40 : (featured ? 58 : 48),
                        height: isMobile ? 40 : (featured ? 58 : 48),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(isMobile ? 12 : 14),
                          gradient: LinearGradient(
                            colors: [
                              widget.color,
                              widget.color.withValues(alpha: 0.7),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: widget.color.withValues(alpha: 0.35),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.icon,
                          color: Colors.white,
                          size: isMobile ? 22 : (featured ? 30 : 26),
                        ),
                      ),
                    const Spacer(),
                    if (widget.statusLabel != null)
                      _StatusPill(
                        label: widget.statusLabel!,
                        icon: widget.statusIcon,
                        color: widget.statusColor ?? widget.color,
                        isMobile: isMobile,
                      ),
                  ],
                ),
                SizedBox(height: isMobile ? 14 : 18),

                // Título
                Text(
                  widget.title,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: isMobile
                        ? (featured ? 22 : 20)
                        : (featured ? 32 : 24),
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: isMobile ? 8 : 10),

                // Descripción
                Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: isMobile ? 13 : (featured ? 16 : 14),
                    color: Colors.white.withValues(alpha: 0.68),
                    height: 1.55,
                  ),
                ),
                SizedBox(height: isMobile ? 14 : 18),

                // Tech tags
                Wrap(
                  spacing: isMobile ? 6 : 8,
                  runSpacing: isMobile ? 6 : 8,
                  children: widget.tech
                      .map((t) => _TechTag(
                            label: t,
                            color: widget.color,
                            isMobile: isMobile,
                          ))
                      .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Pill de estado (🏆 Premiado, 🟢 Activo, etc.)
class _StatusPill extends StatelessWidget {
  final String label;
  final String? icon;
  final Color color;
  final bool isMobile;

  const _StatusPill({
    required this.label,
    required this.color,
    this.icon,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 9 : 11,
        vertical: isMobile ? 5 : 6,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: color.withValues(alpha: 0.12),
        border: Border.all(
          color: color.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Text(icon!, style: TextStyle(fontSize: isMobile ? 11 : 12)),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: isMobile ? 10 : 11,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// Tag de tecnología
class _TechTag extends StatelessWidget {
  final String label;
  final Color color;
  final bool isMobile;

  const _TechTag({
    required this.label,
    required this.color,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 10 : 11,
        vertical: isMobile ? 4 : 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: isMobile ? 11 : 12,
          fontWeight: FontWeight.w600,
          color: Colors.white.withValues(alpha: 0.85),
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// Encabezado de sección: número + eyebrow + título + línea decorativa
class _SectionHeader extends StatelessWidget {
  final String number;
  final String eyebrow;
  final String title;
  final String? subtitle;
  final Color accent;
  final bool isMobile;

  const _SectionHeader({
    required this.number,
    required this.eyebrow,
    required this.title,
    required this.accent,
    this.subtitle,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Fila: número + eyebrow + línea
        Row(
          mainAxisSize: isMobile ? MainAxisSize.min : MainAxisSize.max,
          children: [
            Text(
              number,
              style: GoogleFonts.spaceGrotesk(
                fontSize: isMobile ? 13 : 15,
                fontWeight: FontWeight.w700,
                color: accent,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: isMobile ? 18 : 28,
              height: 1.2,
              color: accent.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 10),
            Text(
              eyebrow.toUpperCase(),
              style: TextStyle(
                fontSize: isMobile ? 11 : 12,
                fontWeight: FontWeight.w700,
                color: Colors.white.withValues(alpha: 0.55),
                letterSpacing: 3,
              ),
            ),
            if (!isMobile) ...[
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.08),
                        Colors.white.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        // Título grande
        Text(
          title,
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.spaceGrotesk(
            fontSize: isMobile ? 30 : 44,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1.05,
            letterSpacing: -0.8,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
            style: TextStyle(
              fontSize: isMobile ? 13 : 16,
              color: Colors.white.withValues(alpha: 0.55),
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }
}

// Punto verde pulsante
class _PulsingDot extends StatefulWidget {
  final Color color;
  final double size;

  const _PulsingDot({required this.color, this.size = 8});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 2.4,
      height: widget.size * 2.4,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _c,
            builder: (context, _) {
              final t = _c.value;
              return Opacity(
                opacity: (1 - t).clamp(0.0, 1.0),
                child: Container(
                  width: widget.size * (1 + t * 1.6),
                  height: widget.size * (1 + t * 1.6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withValues(alpha: 0.35),
                  ),
                ),
              );
            },
          ),
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color,
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.6),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Badge "Disponible para proyectos" con punto verde pulsante
class _AvailableBadge extends StatelessWidget {
  final bool isMobile;
  const _AvailableBadge({this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 14,
        vertical: isMobile ? 7 : 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: const Color(0xFF10B981).withValues(alpha: 0.1),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _PulsingDot(color: Color(0xFF10B981), size: 7),
          const SizedBox(width: 6),
          Text(
            'Disponible para proyectos',
            style: TextStyle(
              fontSize: isMobile ? 11 : 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF10B981),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// Título con ShaderMask gradiente
class _GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final List<Color> colors;
  final TextAlign? textAlign;

  const _GradientText({
    required this.text,
    required this.style,
    required this.colors,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(text, style: style, textAlign: textAlign),
    );
  }
}

// Anillo conic rotatorio alrededor del avatar
class _RotatingAvatarRing extends StatefulWidget {
  final double size;
  final double thickness;
  final Widget child;
  final List<Color> colors;

  const _RotatingAvatarRing({
    required this.size,
    required this.child,
    required this.colors,
    this.thickness = 3,
  });

  @override
  State<_RotatingAvatarRing> createState() => _RotatingAvatarRingState();
}

class _RotatingAvatarRingState extends State<_RotatingAvatarRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.colors.first.withValues(alpha: 0.28),
                blurRadius: 40,
                spreadRadius: 2,
              ),
            ],
          ),
          child: CustomPaint(
            painter: _ConicRingPainter(
              progress: _c.value,
              colors: widget.colors,
              thickness: widget.thickness,
            ),
            child: Padding(
              padding: EdgeInsets.all(widget.thickness + 3),
              child: ClipOval(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF0a0e1a),
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ConicRingPainter extends CustomPainter {
  final double progress;
  final List<Color> colors;
  final double thickness;

  _ConicRingPainter({
    required this.progress,
    required this.colors,
    required this.thickness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: 2 * math.pi,
        transform: GradientRotation(progress * 2 * math.pi),
        colors: [...colors, colors.first],
      ).createShader(rect);
    canvas.drawCircle(
      size.center(Offset.zero),
      size.width / 2 - thickness / 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ConicRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// Botón CTA primario con gradiente
class _PrimaryCTA extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isMobile;

  const _PrimaryCTA({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isMobile = false,
  });

  @override
  State<_PrimaryCTA> createState() => _PrimaryCTAState();
}

class _PrimaryCTAState extends State<_PrimaryCTA> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isMobile ? 20 : 26,
            vertical: widget.isMobile ? 12 : 15,
          ),
          transform: _hover
              ? (Matrix4.identity()..translate(0.0, -2.0))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: const LinearGradient(
              colors: [Color(0xFF42A5F5), Color(0xFF00D2B8)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF42A5F5)
                    .withValues(alpha: _hover ? 0.5 : 0.3),
                blurRadius: _hover ? 24 : 16,
                offset: Offset(0, _hover ? 10 : 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: widget.isMobile ? 13 : 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 8),
              Icon(widget.icon,
                  size: widget.isMobile ? 16 : 18, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

// Botón CTA secundario (ghost)
class _SecondaryCTA extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isMobile;

  const _SecondaryCTA({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isMobile = false,
  });

  @override
  State<_SecondaryCTA> createState() => _SecondaryCTAState();
}

class _SecondaryCTAState extends State<_SecondaryCTA> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isMobile ? 20 : 26,
            vertical: widget.isMobile ? 12 : 15,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: _hover
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.transparent,
            border: Border.all(
              color: Colors.white.withValues(alpha: _hover ? 0.35 : 0.18),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon,
                  size: widget.isMobile ? 16 : 18, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: widget.isMobile ? 13 : 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Contador animado de 0 hasta target
class _AnimatedCounter extends StatefulWidget {
  final int target;
  final Duration duration;
  final TextStyle style;
  final String suffix;

  const _AnimatedCounter({
    required this.target,
    required this.style,
    this.suffix = '',
    this.duration = const Duration(milliseconds: 1600),
  });

  @override
  State<_AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<_AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = Curves.easeOutCubic.transform(_c.value);
        final value = (t * widget.target).round();
        return Text('$value${widget.suffix}', style: widget.style);
      },
    );
  }
}

// Card de una estadística individual
class _StatCard extends StatefulWidget {
  final int value;
  final String suffix;
  final String label;
  final IconData icon;
  final Color color;
  final bool isMobile;
  final VoidCallback? onTap;
  final String? logoAsset;
  final Color? logoBgColor;
  final String? logoEmoji;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    this.suffix = '',
    this.isMobile = false,
    this.onTap,
    this.logoAsset,
    this.logoBgColor,
    this.logoEmoji,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = widget.isMobile;
    final color = widget.color;
    final clickable = widget.onTap != null;
    final showTrend = widget.suffix == '+';

    return MouseRegion(
      cursor: clickable ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.all(isMobile ? 14 : 22),
          transform: _hover
              ? (Matrix4.identity()..translate(0.0, -6.0))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isMobile ? 14 : 18),
            border: Border.all(
              color: _hover
                  ? color.withValues(alpha: 0.55)
                  : color.withValues(alpha: 0.22),
              width: _hover ? 1.5 : 1,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: _hover ? 0.20 : 0.10),
                color.withValues(alpha: _hover ? 0.06 : 0.02),
              ],
            ),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 26,
                      offset: const Offset(0, 12),
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  // Emoji / logo del asset / icono Material de fallback
                  if (widget.logoEmoji != null)
                    Container(
                      width: isMobile ? 38 : 46,
                      height: isMobile ? 38 : 46,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            color,
                            color.withValues(alpha: 0.7),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: _hover ? 0.5 : 0.32),
                            blurRadius: _hover ? 16 : 10,
                            offset: Offset(0, _hover ? 7 : 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          widget.logoEmoji!,
                          style: TextStyle(
                            fontSize: isMobile ? 22 : 26,
                            height: 1,
                          ),
                        ),
                      ),
                    )
                  else if (widget.logoAsset != null)
                    _ProjectLogoBox(
                      asset: widget.logoAsset!,
                      size: isMobile ? 42 : 50,
                      color: color,
                      fallbackIcon: widget.icon,
                      backgroundColor: widget.logoBgColor,
                    )
                  else
                    Container(
                      width: isMobile ? 38 : 46,
                      height: isMobile ? 38 : 46,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            color,
                            color.withValues(alpha: 0.7),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: _hover ? 0.5 : 0.32),
                            blurRadius: _hover ? 16 : 10,
                            offset: Offset(0, _hover ? 7 : 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.icon,
                        color: Colors.white,
                        size: isMobile ? 20 : 24,
                      ),
                    ),
                  const Spacer(),
                  // Indicador de tendencia para stats de crecimiento
                  if (showTrend)
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _hover ? 1.0 : 0.55,
                      child: Icon(
                        Icons.trending_up_rounded,
                        color: color,
                        size: isMobile ? 18 : 20,
                      ),
                    ),
                ],
              ),
              SizedBox(height: isMobile ? 14 : 18),
              _AnimatedCounter(
                target: widget.value,
                suffix: widget.suffix,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: isMobile ? 26 : 38,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -1,
                  height: 1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: isMobile ? 11 : 12,
                  color: Colors.white.withValues(alpha: 0.55),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: isMobile ? 10 : 14),
              // Línea de acento que se expande al hover
              LayoutBuilder(
                builder: (context, c) {
                  return Stack(
                    children: [
                      Container(
                        width: c.maxWidth,
                        height: 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutCubic,
                        height: 2,
                        width: _hover ? c.maxWidth : c.maxWidth * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: LinearGradient(
                            colors: [
                              color,
                              color.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Fade + slide-up al montarse, con delay configurable para stagger
class _FadeInUp extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double offset;

  const _FadeInUp({
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 650),
    this.offset = 30,
  });

  @override
  State<_FadeInUp> createState() => _FadeInUpState();
}

class _FadeInUpState extends State<_FadeInUp>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);
    Future.delayed(widget.delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = Curves.easeOutCubic.transform(_c.value);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * widget.offset),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

// Caja cuadrada para logo de proyecto: fondo sutil, borde del color acento,
// glow suave y fallback al icono Material si el asset no carga
class _ProjectLogoBox extends StatelessWidget {
  final String asset;
  final double size;
  final Color color;
  final IconData? fallbackIcon;
  final Color? backgroundColor;

  const _ProjectLogoBox({
    required this.asset,
    required this.size,
    required this.color,
    this.fallbackIcon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final radius = size * 0.26;
    final bg = backgroundColor ?? Colors.white.withValues(alpha: 0.04);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: bg,
        border: Border.all(
          color: color.withValues(alpha: 0.35),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius - 1),
        child: Padding(
          padding: EdgeInsets.all(size * 0.08),
          child: asset.endsWith('.svg')
              ? SvgPicture.asset(
                  asset,
                  fit: BoxFit.contain,
                  placeholderBuilder: (_) => Icon(
                    fallbackIcon ?? Icons.folder_rounded,
                    color: Colors.white,
                    size: size * 0.55,
                  ),
                )
              : Image.asset(
                  asset,
                  fit: BoxFit.contain,
                  errorBuilder: (ctx, err, stack) => Icon(
                    fallbackIcon ?? Icons.folder_rounded,
                    color: Colors.white,
                    size: size * 0.55,
                  ),
                ),
        ),
      ),
    );
  }
}
