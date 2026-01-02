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
              padding: const EdgeInsets.only(top: 80), // Espacio para el navbar fijo
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    Container(key: _inicioKey), // Marcador para Inicio
                    const SizedBox(height: 60),
                    _buildHeroSection(context, key: _sobreMiKey),
                    const SizedBox(height: 80),
                    _buildSkillsSection(context),
                    const SizedBox(height: 80),
                    _buildProjectsHighlight(context, key: _proyectosKey),
                    const SizedBox(height: 80),
                    _buildContactSection(context, key: _contactoKey),
                    const SizedBox(height: 60),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF42A5F5), Color(0xFF00D2B8)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF42A5F5).withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'LG',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'leodan.dev',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          
          // Menú de navegación
          Row(
            children: [
              _buildNavItem('Inicio', Icons.home_rounded, () => _scrollToSection(_inicioKey)),
              const SizedBox(width: 8),
              _buildNavItem('Sobre mí', Icons.person_rounded, () => _scrollToSection(_sobreMiKey)),
              const SizedBox(width: 8),
              _buildNavItem('Proyectos', Icons.work_rounded, () => _scrollToSection(_proyectosKey)),
              const SizedBox(width: 8),
              _buildNavItem('Contacto', Icons.mail_rounded, () => _scrollToSection(_contactoKey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String label, IconData icon, VoidCallback onTap) {
    return _HoverNavItem(label: label, icon: icon, onTap: onTap);
  }

  Widget _buildHeroSection(BuildContext context, {Key? key}) {
    return Container(
      key: key,
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          Container(
            width: 180,
            height: 180,
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
          const SizedBox(width: 60),
          
          // Información
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Leodan García',
                  style: TextStyle(
                    fontSize: 52,
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
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Desarrollador Frontend Mobile',
                          speed: const Duration(milliseconds: 80),
                          textStyle: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF42A5F5),
                          ),
                        ),
                        TypewriterAnimatedText(
                          'Especializado en Dart & Flutter',
                          speed: const Duration(milliseconds: 80),
                          textStyle: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF00D2B8),
                          ),
                        ),
                        TypewriterAnimatedText(
                          'Automatización con Python & n8n',
                          speed: const Duration(milliseconds: 80),
                          textStyle: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFF6D5A),
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
                    fontSize: 17,
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
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
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
    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tecnologías',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildSkillCard('Flutter', 'assets/icons/flutter.svg', const Color(0xFF42A5F5)),
              _buildSkillCard('Dart', 'assets/icons/dart.svg', const Color(0xFF00D2B8)),
              _buildSkillCard('Python', 'assets/icons/python.svg', const Color(0xFFFFD43B)),
              _buildSkillCard('n8n', 'assets/icons/n8n.svg', const Color(0xFFFF6D5A)),
              _buildSkillCard('Git', 'assets/icons/git.svg', const Color(0xFFF05032)),
              _buildSkillCard('Linux', 'assets/icons/terminal.svg', const Color(0xFFFCC624)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCard(String name, String iconPath, Color color) {
    return _HoverSkillCard(name: name, iconPath: iconPath, color: color);
  }

  Widget _buildProjectsHighlight(BuildContext context, {Key? key}) {
    return Container(
      key: key,
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Proyectos Destacados',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          
          // LockPass
          _buildProjectCard(
            title: 'LockPass',
            description: 'App para guardar cuentas y contraseñas de forma segura, enfocada en simplicidad y orden.',
            tech: ['Flutter', 'Dart'],
            color: const Color(0xFF7C5CFF),
          ),
          const SizedBox(height: 20),
          
          // JaraSecurity
          _buildProjectCard(
            title: 'JaraSecurity',
            description: 'App para empresa de seguridad privada con sistema de reportes, control y módulos de supervisión.',
            tech: ['Flutter', 'Dart'],
            color: const Color(0xFFC9A961),
          ),
          const SizedBox(height: 20),
          
          // AlertaEstudiantil
          _buildProjectCard(
            title: 'AlertaEstudiantil 🥈',
            description: 'Hackathon UTEG - 2do lugar. Detecta estudiantes en riesgo académico y envía alertas automáticas con recomendaciones generadas por IA.',
            tech: ['Flutter', 'n8n', 'Cloud Run', 'AI'],
            color: const Color(0xFF42A5F5),
            featured: true,
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
  }) {
    return _HoverProjectCard(
      title: title,
      description: description,
      tech: tech,
      color: color,
      featured: featured,
    );
  }

  Widget _buildTechTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: 0.05),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.white.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  Widget _buildContactSection(BuildContext context, {Key? key}) {
    return Container(
      key: key,
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contacto',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Disponible para proyectos, colaboraciones y oportunidades',
            style: TextStyle(
              fontSize: 17,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 32),
          
          Wrap(
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Center(
        child: Column(
          children: [
            Text(
              'Creado con Flutter & Dart',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.4),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '© ${DateTime.now().year} Leodan García. Todos los derechos reservados.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.5),
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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: InkWell(
        onTap: () => widget.onTap(widget.url),
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 350,
          padding: const EdgeInsets.all(24),
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

  const _HoverNavItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_HoverNavItem> createState() => _HoverNavItemState();
}

class _HoverNavItemState extends State<_HoverNavItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHover: (hovering) => setState(() => _isHovering = hovering),
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              color: _isHovering
                  ? const Color(0xFF42A5F5)
                  : Colors.white.withValues(alpha: 0.7),
              size: 18,
            ),
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

  const _HoverProjectCard({
    required this.title,
    required this.description,
    required this.tech,
    required this.color,
    required this.featured,
  });

  @override
  State<_HoverProjectCard> createState() => _HoverProjectCardState();
}

class _HoverProjectCardState extends State<_HoverProjectCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(28),
        transform: _isHovering
            ? (Matrix4.identity()..translate(0.0, -4.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovering
                ? widget.color.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.08),
            width: _isHovering ? 2 : 1,
          ),
          gradient: _isHovering
              ? LinearGradient(
                  colors: [
                    widget.color.withValues(alpha: 0.15),
                    widget.color.withValues(alpha: 0.05),
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
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: widget.color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.7),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.tech.map((t) => _buildTechTag(t)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: 0.05),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.white.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
