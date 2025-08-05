import 'package:flutter/material.dart';
import 'package:grupo_casadecor/web/widgets/animated_section.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

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
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
            theme.colorScheme.surface,
          ],
        ),
      ),
      child: AnimatedSection(
        child: Column(
          children: [
            // Section Title
            Text(
              'COMO FUNCIONA',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Processo Simples em 4 Passos',
              style: theme.textTheme.displaySmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),

            // Steps
            if (isDesktop) _buildDesktopSteps(theme) else _buildMobileSteps(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopSteps(ThemeData theme) {
    return Row(
      children: [
        _StepCard(
          step: 1,
          title: 'Cadastre-se',
          description:
              'Crie sua conta gratuita e comprove sua qualificação como arquiteto profissional.',
          icon: Icons.person_add,
          theme: theme,
        ),
        _buildConnector(theme),
        _StepCard(
          step: 2,
          title: 'Compre nas Lojas',
          description:
              'Realize compras em nossas lojas parceiras e apresente seu código de identificação.',
          icon: Icons.shopping_bag,
          theme: theme,
        ),
        _buildConnector(theme),
        _StepCard(
          step: 3,
          title: 'Acumule Pontos',
          description: 'Receba pontos automaticamente baseados no valor das suas compras.',
          icon: Icons.stars,
          theme: theme,
        ),
        _buildConnector(theme),
        _StepCard(
          step: 4,
          title: 'Resgate Prêmios',
          description:
              'Troque seus pontos por produtos exclusivos, descontos ou experiências únicas.',
          icon: Icons.redeem,
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildMobileSteps(ThemeData theme) {
    return Column(
      children: [
        _StepCard(
          step: 1,
          title: 'Cadastre-se',
          description:
              'Crie sua conta gratuita e comprove sua qualificação como arquiteto profissional.',
          icon: Icons.person_add,
          theme: theme,
          isMobile: true,
        ),
        const SizedBox(height: 30),
        _StepCard(
          step: 2,
          title: 'Compre nas Lojas',
          description:
              'Realize compras em nossas lojas parceiras e apresente seu código de identificação.',
          icon: Icons.shopping_bag,
          theme: theme,
          isMobile: true,
        ),
        const SizedBox(height: 30),
        _StepCard(
          step: 3,
          title: 'Acumule Pontos',
          description: 'Receba pontos automaticamente baseados no valor das suas compras.',
          icon: Icons.stars,
          theme: theme,
          isMobile: true,
        ),
        const SizedBox(height: 30),
        _StepCard(
          step: 4,
          title: 'Resgate Prêmios',
          description:
              'Troque seus pontos por produtos exclusivos, descontos ou experiências únicas.',
          icon: Icons.redeem,
          theme: theme,
          isMobile: true,
        ),
      ],
    );
  }

  Widget _buildConnector(ThemeData theme) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.3),
              theme.colorScheme.secondary.withValues(alpha: 0.3),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepCard extends StatefulWidget {
  final int step;
  final String title;
  final String description;
  final IconData icon;
  final ThemeData theme;
  final bool isMobile;

  const _StepCard({
    required this.step,
    required this.title,
    required this.description,
    required this.icon,
    required this.theme,
    this.isMobile = false,
  });

  @override
  State<_StepCard> createState() => _StepCardState();
}

class _StepCardState extends State<_StepCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.05).animate(
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
          child: Transform.rotate(
            angle: _rotateAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: widget.theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? widget.theme.colorScheme.primary.withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.1),
                    blurRadius: _isHovered ? 20 : 10,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(
                  color: _isHovered
                      ? widget.theme.colorScheme.primary.withValues(alpha: 0.3)
                      : widget.theme.colorScheme.primary.withValues(alpha: 0.1),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  // Step Number
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.theme.colorScheme.primary,
                          widget.theme.colorScheme.secondary,
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: widget.theme.colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${widget.step}',
                        style: widget.theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: widget.theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.icon,
                      size: 40,
                      color: widget.theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    widget.title,
                    style: widget.theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: widget.theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Text(
                    widget.description,
                    style: widget.theme.textTheme.bodyMedium?.copyWith(
                      color: widget.theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
