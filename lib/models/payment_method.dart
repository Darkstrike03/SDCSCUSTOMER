class PaymentMethod {
  final String id;
  final String type;
  final String displayValue;
  final bool isDefault;

  const PaymentMethod({
    required this.id,
    required this.type,
    required this.displayValue,
    this.isDefault = false,
  });
}
