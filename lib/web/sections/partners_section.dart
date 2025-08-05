import 'package:flutter/material.dart';
import 'package:grupo_casadecor/web/widgets/animated_section.dart';

class PartnersSection extends StatelessWidget {
  const PartnersSection({super.key});

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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            theme.colorScheme.primaryContainer.withValues(alpha: 0.05),
            theme.colorScheme.surface,
          ],
        ),
      ),
      child: AnimatedSection(
        child: Column(
          children: [
            // Section Title
            Text(
              'LOJAS PARCEIRAS',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Rede de Parceiros Premium',
              style: theme.textTheme.displaySmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Descubra nossa seleção exclusiva de lojas parceiras, escolhidas pela qualidade e excelência dos produtos oferecidos.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),

            // Partners Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 1000
                    ? 4
                    : constraints.maxWidth > 700
                        ? 3
                        : constraints.maxWidth > 500
                            ? 2
                            : 1;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: _partnerStores.length,
                  itemBuilder: (context, index) {
                    final partner = _partnerStores[index];
                    return _PartnerCard(
                      name: partner['name'],
                      category: partner['category'],
                      points: partner['points'],
                      icon: partner['icon'],
                      color: partner['color'],
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 60),

            // CTA Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.store),
                  const SizedBox(width: 8),
                  Text(
                    'Ver Todas as Lojas',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
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

final List<Map<String, dynamic>> _partnerStores = [
  {
    'name': 'Casa & Design',
    'category': 'Móveis Premium',
    'points': '2x pontos',
    'icon': Icons.chair,
    'color': const Color(0xFF2C5F41),
  },
  {
    'name': 'Materiais Nobres',
    'category': 'Revestimentos',
    'points': '3x pontos',
    'icon': Icons.texture,
    'color': const Color(0xFFB8860B),
  },
  {
    'name': 'Iluminação Elite',
    'category': 'Iluminação',
    'points': '2x pontos',
    'icon': Icons.lightbulb,
    'color': const Color(0xFF6B4423),
  },
  {
    'name': 'Ferramentas Pro',
    'category': 'Equipamentos',
    'points': '1.5x pontos',
    'icon': Icons.construction,
    'color': const Color(0xFF2C5F41),
  },
  {
    'name': 'Tintas & Cores',
    'category': 'Acabamentos',
    'points': '2x pontos',
    'icon': Icons.palette,
    'color': const Color(0xFFB8860B),
  },
  {
    'name': 'Jardim & Paisagem',
    'category': 'Paisagismo',
    'points': '2.5x pontos',
    'icon': Icons.park,
    'color': const Color(0xFF6B4423),
  },
  {
    'name': 'Tech House',
    'category': 'Automação',
    'points': '3x pontos',
    'icon': Icons.home,
    'color': const Color(0xFF2C5F41),
  },
  {
    'name': 'Metais & Acessórios',
    'category': 'Acessórios',
    'points': '1.5x pontos',
    'icon': Icons.hardware,
    'color': const Color(0xFFB8860B),
  },
];

class _PartnerCard extends StatefulWidget {
  final String name;
  final String category;
  final String points;
  final IconData icon;
  final Color color;

  const _PartnerCard({
    required this.name,
    required this.category,
    required this.points,
    required this.icon,
    required this.color,
  });

  @override
  State<_PartnerCard> createState() => _PartnerCardState();
}

class _PartnerCardState extends State<_PartnerCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
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
    _elevationAnimation = Tween<double>(begin: 5.0, end: 15.0).animate(
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
        child: AnimatedBuilder(
          animation: _elevationAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.1),
                    blurRadius: _elevationAnimation.value,
                    offset: Offset(0, _elevationAnimation.value / 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: widget.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: widget.color.withValues(alpha: 0.2),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            widget.icon,
                            size: 30,
                            color: widget.color,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Store Name
                        Text(
                          widget.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),

                        // Category
                        Text(
                          widget.category,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),

                        // Points Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.color,
                                widget.color.withValues(alpha: 0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.points,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
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
