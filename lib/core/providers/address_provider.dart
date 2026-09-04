import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/address.dart';
import '../../models/customer_data.dart';
import 'customer_data_provider.dart';

/// Converts a [CustomerAddress] to the legacy [Address] model.
Address _fromCustomerAddress(CustomerAddress ca) => Address(
      id: ca.id.isNotEmpty ? ca.id : '${ca.label}-${ca.detail}',
      label: ca.label,
      detail: ca.detail,
      latitude: ca.latitude ?? 0,
      longitude: ca.longitude ?? 0,
    );

/// All addresses from the current user's customer_data row.
final addressListProvider = Provider<List<Address>>((ref) {
  final customerAsync = ref.watch(customerDataProvider);
  final customer = customerAsync.valueOrNull;
  if (customer == null) return [];
  return customer.addresses.map(_fromCustomerAddress).toList();
});

/// The currently selected address. Auto-selects the default address, falling
/// back to the first one when no default is marked.
final selectedAddressProvider = StateProvider<Address?>((ref) {
  final customer = ref.watch(customerDataProvider).valueOrNull;
  if (customer == null || customer.addresses.isEmpty) return null;

  CustomerAddress? defaultAddr;
  for (final a in customer.addresses) {
    if (a.isDefault) {
      defaultAddr = a;
      break;
    }
  }
  final chosen = defaultAddr ?? customer.addresses.first;
  return _fromCustomerAddress(chosen);
});
