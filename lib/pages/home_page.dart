import 'package:flutter/material.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
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
                    _buildHeroSection(context, key: _sobreMiKey),
                    SizedBox(
                        height:
                            MediaQuery.of(context).size.width < 768 ? 50 : 80),
                    _buildSkillsSection(context),
                    SizedBox(
                        height:
                            MediaQuery.of(context).size.width < 768 ? 50 : 80),
                    _buildProjectsHighlight(context, key: _proyectosKey),
                    SizedBox(
                        height:
                            MediaQuery.of(context).size.width < 768 ? 50 : 80),
                    _buildContactSection(context, key: _contactoKey),
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
    return [
      // Gradiente de fondo más visible
      Positioned.fill(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topLeft,
              radius: 1.5,
              colors: [
                const Color(0xFF1a2332).withValues(alpha: 0.3),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),

      // Cuadro grande superior izquierda
      Positioned(
        top: -40,
        left: 50,
        child: _FloatingSquare(
          size: 120,
          color: const Color(0xFF42A5F5),
          opacity: 0.06,
          rotation: 15,
        ),
      ),

      // Cuadro mediano superior derecha
      Positioned(
        top: 80,
        right: 100,
        child: _FloatingSquare(
          size: 90,
          color: const Color(0xFF7C5CFF),
          opacity: 0.05,
          rotation: -20,
        ),
      ),

      // Cuadro pequeño centro izquierda
      Positioned(
        top: 300,
        left: 150,
        child: _FloatingSquare(
          size: 70,
          color: const Color(0xFFFF6D5A),
          opacity: 0.04,
          rotation: 25,
        ),
      ),

      // Cuadro mediano centro derecha
      Positioned(
        top: 400,
        right: 200,
        child: _FloatingSquare(
          size: 100,
          color: const Color(0xFF00D2B8),
          opacity: 0.05,
          rotation: -15,
        ),
      ),

      // Cuadro grande inferior derecha
      Positioned(
        bottom: -30,
        right: 80,
        child: _FloatingSquare(
          size: 140,
          color: const Color(0xFF00D2B8),
          opacity: 0.07,
          rotation: 18,
        ),
      ),

      // Cuadro mediano inferior izquierda
      Positioned(
        bottom: 180,
        left: 60,
        child: _FloatingSquare(
          size: 110,
          color: const Color(0xFF42A5F5),
          opacity: 0.05,
          rotation: -12,
        ),
      ),

      // Cuadro pequeño inferior centro
      Positioned(
        bottom: 320,
        left: 300,
        child: _FloatingSquare(
          size: 80,
          color: const Color(0xFF7C5CFF),
          opacity: 0.04,
          rotation: 30,
        ),
      ),

      // Líneas decorativas sutiles
      Positioned(
        top: 150,
        left: 0,
        right: 0,
        child: CustomPaint(
          size: const Size(double.infinity, 400),
          painter: _GridPainter(),
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
                    isMobile: isMobile),
                SizedBox(width: isMobile ? 2 : 8),
                _buildNavItem('Sobre mí', Icons.person_rounded,
                    () => _scrollToSection(_sobreMiKey),
                    isMobile: isMobile),
                SizedBox(width: isMobile ? 2 : 8),
                _buildNavItem('Proyectos', Icons.work_rounded,
                    () => _scrollToSection(_proyectosKey),
                    isMobile: isMobile),
                SizedBox(width: isMobile ? 2 : 8),
                _buildNavItem('Contacto', Icons.mail_rounded,
                    () => _scrollToSection(_contactoKey),
                    isMobile: isMobile),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String label, IconData icon, VoidCallback onTap,
      {bool isMobile = false}) {
    return _HoverNavItem(
        label: label, icon: icon, onTap: onTap, isMobile: isMobile);
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
        // Avatar con borde elegante
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF42A5F5), Color(0xFF00D2B8), Color(0xFF7C5CFF)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF42A5F5).withValues(alpha: 0.3),
                blurRadius: 25,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Container(
            width: isVerySmall ? 110 : 130,
            height: isVerySmall ? 110 : 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF0a0e1a), width: 3),
              image: const DecorationImage(
                image: AssetImage('assets/img/profile2.jpg'),
                fit: BoxFit.cover,
                alignment: Alignment(0, 0.15),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

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
            Text(
              'Leodan García',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isVerySmall ? 26 : 30,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.1,
                letterSpacing: -0.5,
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
                _buildBadge('UTEG · 6to', isMobile: true),
                const SizedBox(width: 8),
                _buildBadge('Ecuador 🇪🇨', isMobile: true),
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
        // Avatar
        Container(
          width: isTablet ? 150 : 180,
          height: isTablet ? 150 : 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF42A5F5).withValues(alpha: 0.2),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
            image: const DecorationImage(
              image: AssetImage('assets/img/profile2.jpg'),
              fit: BoxFit.cover,
              alignment: Alignment(0, 0.15),
            ),
          ),
        ),
        SizedBox(width: isTablet ? 40 : 60),

        // Información
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Leodan García',
                style: TextStyle(
                  fontSize: isTablet ? 42 : 52,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.1,
                  letterSpacing: -1,
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
                  _buildBadge('UTEG · 6to semestre · Ingeniería de Software'),
                  _buildBadge('Ecuador 🇪🇨'),
                ],
              ),

              const SizedBox(height: 32),

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
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40),
      child: Column(
        crossAxisAlignment:
            isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Text(
            'Tecnologías',
            style: TextStyle(
              fontSize: isMobile ? 24 : 36,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          if (isMobile)
            Text(
              'Stack de desarrollo',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          SizedBox(height: isMobile ? 20 : 32),
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
          Text(
            'Proyectos',
            style: TextStyle(
              fontSize: isMobile ? 24 : 36,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          if (isMobile) ...[
            const SizedBox(height: 6),
            Text(
              'Trabajos destacados',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ],
          SizedBox(height: isMobile ? 20 : 32),

          // LockPass
          _buildProjectCard(
            title: 'LockPass',
            description: isMobile
                ? 'App para guardar contraseñas de forma segura y ordenada.'
                : 'App para guardar cuentas y contraseñas de forma segura, enfocada en simplicidad y orden.',
            tech: ['Flutter', 'Dart'],
            color: const Color(0xFF7C5CFF),
            isMobile: isMobile,
          ),
          SizedBox(height: isMobile ? 14 : 20),

          // JaraSecurity
          _buildProjectCard(
            title: 'JaraSecurity',
            description: isMobile
                ? 'App de seguridad privada con reportes y supervisión.'
                : 'App para empresa de seguridad privada con sistema de reportes, control y módulos de supervisión.',
            tech: ['Flutter', 'Dart'],
            color: const Color(0xFFC9A961),
            isMobile: isMobile,
          ),
          SizedBox(height: isMobile ? 14 : 20),

          // AlertaEstudiantil
          _buildProjectCard(
            title: 'AlertaEstudiantil 🥈',
            description: isMobile
                ? 'Hackathon UTEG - 2do lugar. Detecta estudiantes en riesgo con IA.'
                : 'Hackathon UTEG - 2do lugar. Detecta estudiantes en riesgo académico y envía alertas automáticas con recomendaciones generadas por IA.',
            tech: isMobile
                ? ['Flutter', 'n8n', 'AI']
                : ['Flutter', 'n8n', 'Cloud Run', 'AI'],
            color: const Color(0xFF42A5F5),
            featured: true,
            isMobile: isMobile,
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard({
    required String title,
    required String description,
    required List<String> tech,
    required Color color,
    bool featured = false,
    bool isMobile = false,
  }) {
    return _HoverProjectCard(
      title: title,
      description: description,
      tech: tech,
      color: color,
      featured: featured,
      isMobile: isMobile,
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
          Text(
            'Contacto',
            style: TextStyle(
              fontSize: isMobile ? 24 : 36,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isMobile
                ? 'Disponible para proyectos'
                : 'Disponible para proyectos, colaboraciones y oportunidades',
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
            style: TextStyle(
              fontSize: isMobile ? 13 : 17,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          SizedBox(height: isMobile ? 20 : 32),
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

// Custom painter para efectos de fondo
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.02)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Líneas diagonales decorativas
    for (int i = 0; i < 8; i++) {
      final startX = i * (size.width / 8);
      final path = Path();
      path.moveTo(startX, 0);
      path.lineTo(startX + 100, size.height);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Widget de cuadro flotante
class _FloatingSquare extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;
  final double rotation;

  const _FloatingSquare({
    required this.size,
    required this.color,
    required this.opacity,
    required this.rotation,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation * 3.14159 / 180, // Convertir a radianes
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * 0.15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: opacity * 1.3),
              color.withValues(alpha: opacity * 0.7),
              color.withValues(alpha: opacity * 0.3),
            ],
          ),
          border: Border.all(
            color: color.withValues(alpha: opacity * 0.5),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

// Widget de navegación con hover
class _HoverNavItem extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isMobile;

  const _HoverNavItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isMobile = false,
  });

  @override
  State<_HoverNavItem> createState() => _HoverNavItemState();
}

class _HoverNavItemState extends State<_HoverNavItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
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
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isMobile ? 10 : 12,
            vertical: widget.isMobile ? 8 : 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _isHovering
                ? const Color(0xFF42A5F5).withValues(alpha: 0.15)
                : Colors.transparent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: _isHovering
                    ? const Color(0xFF42A5F5)
                    : Colors.white.withValues(alpha: 0.7),
                size: widget.isMobile ? 18 : 18,
              ),
              if (!widget.isMobile) ...[
                const SizedBox(width: 6),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _isHovering
                        ? const Color(0xFF42A5F5)
                        : Colors.white.withValues(alpha: 0.7),
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

// Widget con efecto hover para project cards
class _HoverProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final List<String> tech;
  final Color color;
  final bool featured;
  final bool isMobile;

  const _HoverProjectCard({
    required this.title,
    required this.description,
    required this.tech,
    required this.color,
    required this.featured,
    this.isMobile = false,
  });

  @override
  State<_HoverProjectCard> createState() => _HoverProjectCardState();
}

class _HoverProjectCardState extends State<_HoverProjectCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = widget.isMobile;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(isMobile ? 18 : 28),
        transform: _isHovering
            ? (Matrix4.identity()..translate(0.0, -4.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
          border: Border.all(
            color: isMobile
                ? widget.color.withValues(alpha: 0.3)
                : (_isHovering
                    ? widget.color.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.08)),
            width: isMobile ? 1.5 : (_isHovering ? 2 : 1),
          ),
          gradient: (isMobile || _isHovering)
              ? LinearGradient(
                  colors: [
                    widget.color.withValues(alpha: isMobile ? 0.08 : 0.15),
                    widget.color.withValues(alpha: isMobile ? 0.02 : 0.05),
                  ],
                )
              : null,
          boxShadow: _isHovering
              ? [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (isMobile)
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color,
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withValues(alpha: 0.5),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: isMobile ? 18 : 26,
                      fontWeight: FontWeight.w900,
                      color: widget.color,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 8 : 12),
            Text(
              widget.description,
              style: TextStyle(
                fontSize: isMobile ? 13 : 16,
                color: Colors.white.withValues(alpha: 0.65),
                height: 1.5,
              ),
            ),
            SizedBox(height: isMobile ? 12 : 16),
            Wrap(
              spacing: isMobile ? 6 : 8,
              runSpacing: isMobile ? 6 : 8,
              children: widget.tech
                  .map((t) => _buildTechTag(t, isMobile: isMobile))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechTag(String text, {bool isMobile = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 10 : 12,
        vertical: isMobile ? 4 : 6,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: 0.08),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isMobile ? 11 : 13,
          fontWeight: FontWeight.w600,
          color: Colors.white.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
