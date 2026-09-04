import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/customer_data.dart';
import 'auth_provider.dart';

/// Fetches the current user's row from the customer_data table.
/// Returns null when logged out or Supabase is not initialized.
final customerDataProvider =
    FutureProvider.autoDispose<CustomerData?>((ref) async {
  final auth = ref.watch(authProvider);
  if (!auth.isLoggedIn) return null;

  try {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await Supabase.instance.client
        .from('customer_data')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;
    return CustomerData.fromJson(response);
  } catch (_) {
    return null;
  }
});

/// Updates the current user's customer_data row and refreshes the provider.
Future<void> updateCustomerProfile(
  WidgetRef ref, {
  required String fullName,
  String? phone,
  String? avatarUrl,
  String? backgroundUrl,
}) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) throw Exception('Not logged in');

  await Supabase.instance.client.from('customer_data').update({
    'full_name': fullName,
    'phone': phone,
    'avatar_url': avatarUrl,
    'background_url': backgroundUrl,
    'updated_at': DateTime.now().toUtc().toIso8601String(),
  }).eq('id', userId);

  ref.invalidate(customerDataProvider);
}

/// Fetches the current user's saved addresses (JSONB array as CustomerAddress).
Future<List<CustomerAddress>> _fetchAddresses(WidgetRef ref) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return [];
  final response = await Supabase.instance.client
      .from('customer_data')
      .select('addresses')
      .eq('id', userId)
      .maybeSingle();
  final raw = (response?['addresses'] as List<dynamic>?) ?? [];
  return raw
      .map((a) => CustomerAddress.fromJson(a as Map<String, dynamic>))
      .toList();
}

/// Saves the given address list back to the customer_data JSONB column.
Future<void> _saveAddresses(WidgetRef ref, List<CustomerAddress> addresses) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) throw Exception('Not logged in');

  await Supabase.instance.client.from('customer_data').update({
    'addresses': addresses.map((a) => a.toJson()).toList(),
    'updated_at': DateTime.now().toUtc().toIso8601String(),
  }).eq('id', userId);

  ref.invalidate(customerDataProvider);
}

/// Adds a new address to the user's saved addresses.
Future<void> addCustomerAddress(WidgetRef ref, CustomerAddress address) async {
  final current = await _fetchAddresses(ref);
  // First added address becomes the default.
  final setDefault = current.isEmpty;
  final newAddr = setDefault ? address.copyWith(isDefault: true) : address;
  await _saveAddresses(ref, [...current, newAddr]);
}

/// Updates an existing address by id.
Future<void> updateCustomerAddress(
    WidgetRef ref, CustomerAddress address) async {
  final current = await _fetchAddresses(ref);
  final updated = current
      .map((a) => a.id == address.id ? address : a)
      .toList();
  await _saveAddresses(ref, updated);
}

/// Removes an address by id.
Future<void> deleteCustomerAddress(WidgetRef ref, String id) async {
  final current = await _fetchAddresses(ref);
  final remaining = current.where((a) => a.id != id).toList();
  // If we deleted the default, promote the first remaining to default.
  final lostDefault = current.any((a) => a.id == id && a.isDefault);
  if (lostDefault && remaining.isNotEmpty) {
    remaining[0] = remaining[0].copyWith(isDefault: true);
  }
  await _saveAddresses(ref, remaining);
}

/// Marks one address as the default (clearing the others).
Future<void> setDefaultAddress(WidgetRef ref, String id) async {
  final current = await _fetchAddresses(ref);
  final updated = current
      .map((a) => a.copyWith(isDefault: a.id == id))
      .toList();
  await _saveAddresses(ref, updated);
}
