import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/services/location_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/customer_data_provider.dart';
import '../../../models/customer_data.dart';

const _uuid = Uuid();

/// Add or edit a saved address.
///
/// When opened without [existing] it runs the full two-step flow
/// (choose a label, then fill details). When [existing] is provided it skips
/// straight to the details step pre-filled for editing.
class AddAddressScreen extends ConsumerStatefulWidget {
  final CustomerAddress? existing;

  const AddAddressScreen({super.key, this.existing});

  @override
  ConsumerState<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends ConsumerState<AddAddressScreen> {
  final _locationService = LocationService();

  String? _label;
  late final TextEditingController _detailCtrl;
  late final TextEditingController _pincodeCtrl;
  late final TextEditingController _latCtrl;
  late final TextEditingController _lngCtrl;

  bool _isEditing = false;
  bool _onDetailsStep = false;
  bool _locating = false;
  bool _saving = false;
  String? _locationStatus;

  List<String> get _labels => const ['Home', 'Office', 'Parents', 'Other'];

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _isEditing = existing != null;
    _onDetailsStep = existing != null;
    _label = existing?.label;
    _detailCtrl = TextEditingController(text: existing?.detail ?? '');
    _pincodeCtrl = TextEditingController(text: existing?.pincode ?? '');
    _latCtrl = TextEditingController(
      text: existing?.latitude != null ? existing!.latitude.toString() : '',
    );
    _lngCtrl = TextEditingController(
      text: existing?.longitude != null ? existing!.longitude.toString() : '',
    );
  }

  @override
  void dispose() {
    _detailCtrl.dispose();
    _pincodeCtrl.dispose();
    _latCtrl.dispose();
    _lngCtrl.dispose();
    super.dispose();
  }

  Future<void> _useCurrentLocation() async {
    setState(() {
      _locating = true;
      _locationStatus = null;
    });

    final result = await _locationService.getCurrentPosition();

    if (!mounted) return;
    setState(() {
      _locating = false;
      if (result.isSuccess) {
        _latCtrl.text = result.latitude!.toStringAsFixed(6);
        _lngCtrl.text = result.longitude!.toStringAsFixed(6);
        _locationStatus = 'Location set from current position.';
      } else {
        _locationStatus = result.error;
      }
    });
  }

  Future<void> _save() async {
    final detail = _detailCtrl.text.trim();
    if (detail.isEmpty) {
      _showSnack('Address cannot be empty');
      return;
    }
    final pincode = _pincodeCtrl.text.trim();
    if (pincode.isEmpty) {
      _showSnack('Pincode cannot be empty');
      return;
    }

    final double? lat = double.tryParse(_latCtrl.text.trim());
    final double? lng = double.tryParse(_lngCtrl.text.trim());
    if (_latCtrl.text.trim().isNotEmpty && lat == null ||
        _lngCtrl.text.trim().isNotEmpty && lng == null) {
      _showSnack('Latitude/Longitude must be valid numbers');
      return;
    }

    final address = CustomerAddress(
      id: widget.existing?.id ?? _uuid.v4(),
      label: _label ?? 'Home',
      detail: detail,
      pincode: pincode,
      latitude: lat,
      longitude: lng,
      isDefault: widget.existing?.isDefault ?? false,
    );

    setState(() => _saving = true);
    try {
      if (_isEditing) {
        await updateCustomerAddress(ref, address);
      } else {
        await addCustomerAddress(ref, address);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'Address updated' : 'Address added'),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) _showSnack('Failed to save: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Address' : 'Add Address'),
      ),
      body: SafeArea(
        child: _onDetailsStep ? _buildDetails(context) : _buildStep(context),
      ),
    );
  }

  Widget _buildStep(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose a label',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'What kind of place is this?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.4,
            children: _labels.map((label) {
              final selected = _label == label;
              return InkWell(
                key: ValueKey('label-$label'),
                borderRadius: BorderRadius.circular(14),
                onTap: () => setState(() => _label = label),
                child: Container(
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primarySurface
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected ? AppColors.primary : AppColors.divider,
                      width: selected ? 1.5 : 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_iconFor(label),
                          color: AppColors.primary, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _label == null
                  ? null
                  : () => setState(() => _onDetailsStep = true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(_iconFor(_label ?? 'Home'), color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                _label ?? 'Home',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              if (!_isEditing) ...[
                const Spacer(),
                TextButton.icon(
                  onPressed: () => setState(() => _onDetailsStep = false),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Change'),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _detailCtrl,
            maxLines: 3,
            decoration: _decoration('Full Address', Icons.location_on_outlined),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _pincodeCtrl,
            keyboardType: TextInputType.number,
            decoration: _decoration('Pincode', Icons.numbers_outlined),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                onPressed: _locating ? null : _useCurrentLocation,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primarySurface,
                  foregroundColor: AppColors.primary,
                ),
                icon: _locating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _locating ? 'Getting location...' : 'Use my current location',
                  style: TextStyle(
                    color: _locating
                        ? AppColors.textSecondary
                        : AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (_locationStatus != null) ...[
            const SizedBox(height: 8),
            Text(
              _locationStatus!,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
          const SizedBox(height: 16),
          // -- Map placeholder --
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider, width: 0.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.map_outlined,
                    size: 40, color: AppColors.textHint),
                const SizedBox(height: 8),
                Text(
                  _latCtrl.text.isNotEmpty && _lngCtrl.text.isNotEmpty &&
                          double.tryParse(_latCtrl.text) != null &&
                          double.tryParse(_lngCtrl.text) != null
                      ? 'Pin at ${_latCtrl.text}, ${_lngCtrl.text}'
                      : 'Map preview coming soon',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _latCtrl,
                  keyboardType: TextInputType.number,
                  decoration: _decoration('Latitude', Icons.place_outlined),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _lngCtrl,
                  keyboardType: TextInputType.number,
                  decoration: _decoration('Longitude', Icons.place_outlined),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Save Address',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: AppColors.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  IconData _iconFor(String label) {
    switch (label) {
      case 'Home':
        return Icons.home_outlined;
      case 'Office':
        return Icons.work_outline;
      case 'Parents':
        return Icons.family_restroom_outlined;
      default:
        return Icons.location_on_outlined;
    }
  }
}
