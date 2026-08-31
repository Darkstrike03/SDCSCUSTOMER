import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/address.dart';
import '../../data/mock_data.dart';

final selectedAddressProvider = StateProvider<Address?>((ref) {
  return MockData.addresses.isEmpty ? null : MockData.addresses.first;
});
