enum TransactionType { earned, spent }

class PointTransaction {
  final String id;
  final String description;
  final int points;
  final int valor; // valor também como int
  final DateTime date;
  final TransactionType type;
  final String companyName;

  const PointTransaction({
    required this.id,
    required this.description,
    required this.points,
    required this.valor,
    required this.date,
    required this.type,
    required this.companyName,
  });

  factory PointTransaction.fromJson(Map<String, dynamic> json) {
    int valorInt = double.tryParse(json['valor']?.toString() ?? '0')?.round() ?? 0;

    return PointTransaction(
      id: json['id']?.toString() ?? '',
      description: json['descricao']?.toString() ?? '',
      valor: valorInt,
      points: valorInt,
      date: DateTime.parse(json['data_compra']?.toString() ?? DateTime.now().toIso8601String())
          .toLocal(),
      type: _parseType(json['tipo']?.toString()),
      companyName: json['empresa']?['nome']?.toString() ?? '',
    );
  }

  static TransactionType _parseType(String? tipo) {
    switch (tipo?.toLowerCase()) {
      case 'saida':
        return TransactionType.spent;
      case 'entrada':
        return TransactionType.earned;
      default:
        return TransactionType.earned; // fallback
    }
  }
}
