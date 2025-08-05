import 'package:flutter/material.dart';
import 'package:grupo_casadecor/web/widgets/animated_section.dart';

class PrizesSection extends StatelessWidget {
  const PrizesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 20,
        vertical: 100,
      ),
      color: theme.colorScheme.surface,
      child: AnimatedSection(
        child: Column(
          children: [
            // Section Title
            Text(
              'PRÊMIOS EXCLUSIVOS',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Recompensas que Inspiram',
              style: theme.textTheme.displaySmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Descubra uma seleção cuidadosa de prêmios pensados especialmente para arquitetos ambiciosos.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),

            // Featured Prize
            _FeaturedPrize(),

            const SizedBox(height: 60),

            // Prizes Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 900
                    ? 3
                    : constraints.maxWidth > 600
                        ? 2
                        : 1;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: _prizes.length,
                  itemBuilder: (context, index) {
                    final prize = _prizes[index];
                    return _PrizeCard(
                      title: prize['title'],
                      description: prize['description'],
                      points: prize['points'],
                      imageUrl: prize['imageUrl'],
                      category: prize['category'],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> _prizes = [
  {
    'title': 'Kit Ferramentas Premium',
    'description': 'Conjunto completo de ferramentas profissionais para arquitetos',
    'points': '2,500 pontos',
    'imageUrl':
        'https://pixabay.com/get/g2a4e7957a710c650635533040acf1ba2f85456c58c600cb94579e8fac9fbb1fddc3e9af3e107f969aefa92f235167d4f50bb67f39d81161a471448deb3696dbf_1280.jpg',
    'category': 'Ferramentas',
  },
  {
    'title': 'Curso de Design Avançado',
    'description': 'Acesso a curso online exclusivo com certificação',
    'points': '3,000 pontos',
    'imageUrl':
        'https://pixabay.com/get/g14139b1c92fe2e1f7981a93f1cd11e704ba337dc0698ff732e0006807da2564da01b8642d14663b1d3e9ac3d36e4603da195fb2855e513fd197116ba8ebc0b5b_1280.jpg',
    'category': 'Educação',
  },
  {
    'title': 'Viagem Arquitetônica',
    'description': 'Tour guiado por obras arquitetônicas icônicas',
    'points': '5,000 pontos',
    'imageUrl':
        'https://pixabay.com/get/gc05ed4d8aa349e4aaee29cfb768226c64a4992bdd844900edd6ecdc3ebe78163f89bb7e47bb28f5577ef3b82cff9c1c7f9b7f2af55188a74743955430168419d_1280.jpg',
    'category': 'Experiência',
  },
  {
    'title': 'Software Profissional',
    'description': 'Licença anual de software de design 3D',
    'points': '4,000 pontos',
    'imageUrl':
        'https://pixabay.com/get/g61158e5900f280ef3788352c4b2018263a6ced483d04a7fbf516653510a4e48353778a78cc93730132dbc06967d754f852af712e1e940b9f2394a65c4c18e7ba_1280.jpg',
    'category': 'Software',
  },
  {
    'title': 'Mesa Digitalizadora',
    'description': 'Equipamento premium para desenho digital',
    'points': '3,500 pontos',
    'imageUrl':
        'https://pixabay.com/get/gc913c792a55891bcc01410cb3d54689690362eeea3f50dbe184c7a954c591ce04cb769ad1ef9d9cf2e9a966f474661be9fd68e081e036de9976adf139e1a9e2a_1280.jpg',
    'category': 'Equipamento',
  },
  {
    'title': 'Consultoria Personalizada',
    'description': 'Sessões com especialistas em design',
    'points': '2,000 pontos',
    'imageUrl':
        'https://pixabay.com/get/g3143dfddad35568a59c6b2d788b42bdcb4d32a4feea4af927db6487bd1763f65c7b1fdc58a443e527951947d8a3eec809e08ce18829403999e15c461bf6aa2a2_1280.jpg',
    'category': 'Serviço',
  },
];

class _FeaturedPrize extends StatefulWidget {
  @override
  State<_FeaturedPrize> createState() => _FeaturedPrizeState();
}

class _FeaturedPrizeState extends State<_FeaturedPrize> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 768;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                // Left Content
                Expanded(
                  flex: isDesktop ? 6 : 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'PRÊMIO DESTAQUE',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'MacBook Pro 16" M3 Max',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'O poder da criação sem limites. Ideal para renderização, modelagem 3D e design arquitetônico profissional.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.stars,
                                  size: 20,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '10,000 pontos',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: theme.colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('Resgatar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Right Image (Desktop only)
                if (isDesktop) ...[
                  const SizedBox(width: 40),
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          'https://pixabay.com/get/g61158e5900f280ef3788352c4b2018263a6ced483d04a7fbf516653510a4e48353778a78cc93730132dbc06967d754f852af712e1e940b9f2394a65c4c18e7ba_1280.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.white.withValues(alpha: 0.1),
                            child: const Icon(
                              Icons.laptop_mac,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PrizeCard extends StatefulWidget {
  final String title;
  final String description;
  final String points;
  final String imageUrl;
  final String category;

  const _PrizeCard({
    required this.title,
    required this.description,
    required this.points,
    required this.imageUrl,
    required this.category,
  });

  @override
  State<_PrizeCard> createState() => _PrizeCardState();
}

class _PrizeCardState extends State<_PrizeCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
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
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? theme.colorScheme.primary.withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: 0.08),
                blurRadius: _isHovered ? 15 : 8,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                        child: Icon(
                          Icons.card_giftcard,
                          size: 60,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.category,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Title
                      Text(
                        widget.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Description
                      Expanded(
                        child: Text(
                          widget.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            height: 1.3,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Points and Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.points,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Resgatar',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
