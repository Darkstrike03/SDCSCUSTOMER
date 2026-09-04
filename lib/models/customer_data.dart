class CustomerAddress {
  final String id;
  final String label;
  final String detail;
  final String? pincode;
  final double? latitude;
  final double? longitude;
  final bool isDefault;

  const CustomerAddress({
    required this.id,
    required this.label,
    required this.detail,
    this.pincode,
    this.latitude,
    this.longitude,
    this.isDefault = false,
  });

  factory CustomerAddress.fromJson(Map<String, dynamic> json) {
    return CustomerAddress(
      id: json['id'] as String? ?? '',
      label: json['label'] as String? ?? '',
      detail: json['detail'] as String? ?? '',
      pincode: json['pincode'] as String?,
      latitude: (json['lat'] as num?)?.toDouble(),
      longitude: (json['lng'] as num?)?.toDouble(),
      isDefault: json['is_default'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id.isNotEmpty) 'id': id,
        'label': label,
        'detail': detail,
        if (pincode != null) 'pincode': pincode,
        if (latitude != null) 'lat': latitude,
        if (longitude != null) 'lng': longitude,
        'is_default': isDefault,
      };

  CustomerAddress copyWith({
    String? id,
    String? label,
    String? detail,
    String? pincode,
    double? latitude,
    double? longitude,
    bool? isDefault,
  }) {
    return CustomerAddress(
      id: id ?? this.id,
      label: label ?? this.label,
      detail: detail ?? this.detail,
      pincode: pincode ?? this.pincode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class CustomerData {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String? backgroundUrl;
  final List<CustomerAddress> addresses;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CustomerData({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.backgroundUrl,
    this.addresses = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    final rawAddresses = json['addresses'] as List<dynamic>? ?? [];
    return CustomerData(
      id: json['id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      backgroundUrl: json['background_url'] as String?,
      addresses: rawAddresses
          .map((a) => CustomerAddress.fromJson(a as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  CustomerData copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? avatarUrl,
    String? backgroundUrl,
    List<CustomerAddress>? addresses,
  }) {
    return CustomerData(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      backgroundUrl: backgroundUrl ?? this.backgroundUrl,
      addresses: addresses ?? this.addresses,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
