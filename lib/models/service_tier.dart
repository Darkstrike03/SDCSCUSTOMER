/// Pricing/service tiers a customer can book a worker under.
///
/// Mirrors the product spec (§5): Fixed, Hourly and Contract pricing.
enum ServiceTier { fixed, hourly, contract }

extension ServiceTierX on ServiceTier {
  String get label => switch (this) {
        ServiceTier.fixed => 'Fixed',
        ServiceTier.hourly => 'Hourly',
        ServiceTier.contract => 'Contract',
      };

  String get description => switch (this) {
        ServiceTier.fixed =>
          'Standard catalog job with a published price. Limited free distance included.',
        ServiceTier.hourly =>
          'Open-ended work billed by time. Distance fee included in the hourly rate.',
        ServiceTier.contract =>
          'Large or ambiguous-scope job. Price confirmed by the worker after an on-site visit.',
      };
}
