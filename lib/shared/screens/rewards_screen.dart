import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grupo_casadecor/mobile/models/reward.dart';
import 'package:grupo_casadecor/shared/services/rewards_controller.dart';
import 'package:grupo_casadecor/shared/services/specifier_controller.dart';

class RewardsScreen extends StatefulWidget {
  final SpecifierController controller;
  const RewardsScreen({super.key, required this.controller});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  final TextEditingController _searchController = TextEditingController();

  final RewardsController _controller = Get.put(RewardsController());

  List<RewardModel> _filteredRewards = [];

  @override
  void initState() {
    super.initState();
    print('[RewardsScreen] initState executado');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.initValues(); // Deve disparar o print acima
    });

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _controller.fetchAwards().then((_) {
      _filteredRewards = _controller.awardsList.cast<RewardModel>().toList();
      _animationController.forward();
      setState(() {});
    });

    _searchController.addListener(() {
      _filterRewards(_searchController.text);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    Get.delete<RewardsController>();
    super.dispose();
  }

  void _filterRewards(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredRewards = _controller.awardsList.cast<RewardModel>().toList();
      });
    } else {
      setState(() {
        _filteredRewards = _controller.awardsList
            .cast<RewardModel>()
            .where((reward) =>
                (reward.titulo ?? '').toLowerCase().contains(query.toLowerCase()) ||
                (reward.descricao ?? '').toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const userPoints = 1000; // exemplo fixo, substitua pela pontuação real

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Prêmios Disponíveis',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_controller.errorMessage.isNotEmpty) {
          return Center(child: Text(_controller.errorMessage.value));
        }
        if (_filteredRewards.isEmpty) {
          return const Center(child: Text('Nenhum prêmio encontrado.'));
        }

        return Column(
          children: [
            StreamBuilder<double>(
              stream: widget.controller.pointsController.stream,
              builder: (context, snapshot) {
                print("Snapshot data: ${snapshot.data} - HasData: ${snapshot.hasData}");
                final totalPoints = snapshot.data ?? 0.0;

                return Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.secondary,
                        theme.colorScheme.secondary.withAlpha(204),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        color: theme.colorScheme.onSecondary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Seus pontos: ${totalPoints.toStringAsFixed(0)} pts',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar prêmios...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _filteredRewards.length,
                itemBuilder: (context, index) {
                  final reward = _filteredRewards[index];
                  return AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      final animationValue = Tween<double>(
                        begin: 0.0,
                        end: 1.0,
                      ).animate(CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(
                          index * 0.1,
                          1.0,
                          curve: Curves.easeOut,
                        ),
                      ));

                      return Transform.scale(
                        scale: animationValue.value,
                        child: RewardCard(
                          reward: reward,
                          canRedeem: userPoints >= (reward.pontos ?? 0),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}

class RewardCard extends StatelessWidget {
  final RewardModel reward;
  final bool canRedeem;

  const RewardCard({
    super.key,
    required this.reward,
    required this.canRedeem,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: canRedeem ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: canRedeem
            ? () {
                showDialog(
                  context: context,
                  builder: (context) => RewardDialog(reward: reward),
                );
              }
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                      ),
                      child: Image.network(
                        reward.imagem1 ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: Icon(
                              Icons.card_giftcard,
                              size: 32,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  if (!canRedeem)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.lock,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: canRedeem ? theme.colorScheme.secondary : theme.colorScheme.outline,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${reward.pontos ?? 0} pts',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: canRedeem
                              ? theme.colorScheme.onSecondary
                              : theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reward.titulo ?? '',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: canRedeem
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        reward.descricao ?? '',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: canRedeem
                              ? theme.colorScheme.onSurface.withValues(alpha: 0.7)
                              : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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

class RewardDialog extends StatelessWidget {
  final RewardModel reward;

  const RewardDialog({super.key, required this.reward});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        'Resgatar Prêmio',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reward.titulo ?? '',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            reward.descricao ?? '',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: theme.colorScheme.onSecondaryContainer,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Este prêmio custará ${reward.pontos ?? 0} pontos.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // fecha o dialogo atual

            // Exibe mensagem de contato com o administrador
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Atenção'),
                content: const Text(
                  'Entre em contato com um administrador do Grupo Casa Decor para concluir o resgate.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
          child: const Text('Resgatar'),
        ),
      ],
    );
  }
}
