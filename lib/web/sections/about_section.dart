import 'package:flutter/material.dart';
import 'package:grupo_casadecor/web/widgets/animated_section.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

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
              'SOBRE O PROGRAMA',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Sistema de Pontuação Exclusivo',
              style: theme.textTheme.displaySmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),

            // Content
            Row(
              children: [
                // Left Content
                Expanded(
                  flex: isDesktop ? 6 : 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transformando Compras em Experiências',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'O Grupo Casa Decor revoluciona a experiência de compra para arquitetos, oferecendo um sistema de pontuação exclusivo que transforma cada aquisição em uma oportunidade de crescimento profissional.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Através de parcerias estratégicas com as melhores lojas do setor, conectamos profissionais da arquitetura a produtos premium, materiais de qualidade superior e soluções inovadoras.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Statistics
                      const Row(
                        children: [
                          _StatCard(
                            number: '500+',
                            label: 'Arquitetos\nCadastrados',
                            icon: Icons.people,
                          ),
                          SizedBox(width: 20),
                          _StatCard(
                            number: '50+',
                            label: 'Lojas\nParceiras',
                            icon: Icons.store,
                          ),
                          SizedBox(width: 20),
                          _StatCard(
                            number: '1000+',
                            label: 'Prêmios\nResgatados',
                            icon: Icons.card_giftcard,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Right Image (Desktop only)
                if (isDesktop) ...[
                  const SizedBox(width: 60),
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(alpha: 0.1),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          'https://pixabay.com/get/g3143dfddad35568a59c6b2d788b42bdcb4d32a4feea4af927db6487bd1763f65c7b1fdc58a443e527951947d8a3eec809e08ce18829403999e15c461bf6aa2a2_1280.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.architecture,
                              size: 100,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatefulWidget {
  final String number;
  final String label;
  final IconData icon;

  const _StatCard({
    required this.number,
    required this.label,
    required this.icon,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> with SingleTickerProviderStateMixin {
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
    final theme = Theme.of(context);

    return Expanded(
      child: MouseRegion(
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
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _isHovered
                  ? theme.colorScheme.primaryContainer.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  widget.icon,
                  size: 32,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  widget.number,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
