import '../models/models.dart';

class MockData {
  MockData._();

  static final List<ServiceCategory> categories = [
    const ServiceCategory(id: 'electrician', name: 'Electrician', iconName: 'bolt'),
    const ServiceCategory(id: 'plumber', name: 'Plumber', iconName: 'water_drop'),
    const ServiceCategory(id: 'cleaning', name: 'Cleaning', iconName: 'cleaning_services'),
    const ServiceCategory(id: 'carpenter', name: 'Carpenter', iconName: 'hammer'),
    const ServiceCategory(id: 'painter', name: 'Painter', iconName: 'format_paint'),
    const ServiceCategory(id: 'caregiver', name: 'Caregiver', iconName: 'elderly_woman'),
    const ServiceCategory(id: 'driver', name: 'Driver', iconName: 'directions_car'),
    const ServiceCategory(id: 'gardener', name: 'Gardener', iconName: 'yard'),
  ];

  static final List<Worker> workers = [
    // Electricians
    const Worker(
      id: 'w1', name: 'Rajesh Kumar', photoUrl: '', rating: 4.8,
      reviewCount: 124, distanceKm: 1.2, isVerified: true, yearsActive: 8,
      completedJobs: 340,       skills: ['Wiring', 'Inverter Repair', 'Fan Installation'],
      categoryId: 'electrician', priceEstimate: 350, hourlyRate: 300,
      contractVisitFee: 200, availableToday: true,
      about: 'Certified electrician with over 8 years of experience in residential '
          'wiring, inverter repair and smart-home installations. Known for neat work, '
          'clear estimates and always leaving the workspace spotless.',
    ),
    const Worker(
      id: 'w2', name: 'Amit Sharma', photoUrl: '', rating: 4.5,
      reviewCount: 89, distanceKm: 2.5, isVerified: true, yearsActive: 5,
      completedJobs: 190, skills: ['Switch Board', 'MCB Repair', 'Lighting'],
      categoryId: 'electrician', priceEstimate: 300, availableToday: true,
      about: 'Focused on wiring, switchboards and lighting upgrades. Fast, tidy and '
          'always happy to explain the work before starting.',
    ),
    // Plumbers
    const Worker(
      id: 'w3', name: 'Suresh Patel', photoUrl: '', rating: 4.7,
      reviewCount: 98, distanceKm: 1.8, isVerified: true, yearsActive: 6,
      completedJobs: 275,       skills: ['Pipe Fitting', 'Leak Repair', 'Bathroom Fitting'],
      categoryId: 'plumber', priceEstimate: 400, hourlyRate: 350,
      contractVisitFee: 250, availableToday: false,
      about: 'Experienced plumber specialising in leak repair, pipe fitting and '
          'bathroom fittings. Sudden emergencies handled with priority.',
    ),
    const Worker(
      id: 'w4', name: 'Mohammad Ali', photoUrl: '', rating: 4.3,
      reviewCount: 56, distanceKm: 3.1, isVerified: true, yearsActive: 3,
      completedJobs: 110,       skills: ['Drain Cleaning', 'Tap Repair', 'Water Tank'],
      categoryId: 'plumber', priceEstimate: 350, hourlyRate: 300,
      availableToday: true,
      about: 'Reliable plumber for drain cleaning, tap repair and water tank '
          'services. Answers quickly and turns up on time.',
    ),
    // Cleaning
    const Worker(
      id: 'w5', name: 'Priya Devi', photoUrl: '', rating: 4.9,
      reviewCount: 201, distanceKm: 0.8, isVerified: true, yearsActive: 10,
      completedJobs: 520, skills: ['Deep Cleaning', 'Kitchen Cleaning', 'Bathroom Cleaning'],
      categoryId: 'cleaning', priceEstimate: 500, availableToday: true,
      about: 'Deep-cleaning specialist with a decade of experience. Uses safe, '
          'eco-friendly products and pays attention to every corner.',
    ),
    const Worker(
      id: 'w6', name: 'Anita Singh', photoUrl: '', rating: 4.6,
      reviewCount: 78, distanceKm: 2.0, isVerified: true, yearsActive: 4,
      completedJobs: 165, skills: ['Home Cleaning', 'Office Cleaning', 'Carpet Cleaning'],
      categoryId: 'cleaning', priceEstimate: 450, availableToday: true,
      about: 'Thorough home and office cleaning expert. Trusted by regular clients '
          'for consistent, high-quality results.',
    ),
    // Carpenter
    const Worker(
      id: 'w7', name: 'Dinesh Yadav', photoUrl: '', rating: 4.7,
      reviewCount: 112, distanceKm: 1.5, isVerified: true, yearsActive: 12,
      completedJobs: 380, skills: ['Furniture Repair', 'Door Installation', 'Woodwork'],
      categoryId: 'carpenter', priceEstimate: 450, availableToday: false,
      about: 'Master carpenter with 12 years in furniture repair, door installation '
          'and custom woodwork. Delivers sturdy, finely finished work.',
    ),
    // Painter
    const Worker(
      id: 'w8', name: 'Vikram Rao', photoUrl: '', rating: 4.4,
      reviewCount: 67, distanceKm: 3.5, isVerified: true, yearsActive: 7,
      completedJobs: 145, skills: ['Interior Painting', 'Exterior Painting', 'Wall Texture'],
      categoryId: 'painter', priceEstimate: 550, availableToday: true,
      about: 'Painter specialising in interior, exterior and textured wall finishes. '
          'Careful surface prep and smooth, even coats every time.',
    ),
  ];

  static final List<WorkerReview> reviews = [
    const WorkerReview(workerId: 'w1', name: 'Michael T.', initials: 'MT', rating: 5, timeAgo: '2 weeks ago', comment: 'Rajesh arrived on time, diagnosed the wiring issue quickly and explained exactly what needed to be done. Highly professional.'),
    const WorkerReview(workerId: 'w1', name: 'Elena L.', initials: 'EL', rating: 5, timeAgo: '1 month ago', comment: 'Installed our inverter flawlessly. Neat work and respectful of the property. Best electrician in the area.'),
    const WorkerReview(workerId: 'w5', name: 'Sandeep K.', initials: 'SK', rating: 5, timeAgo: '1 week ago', comment: 'Priya did a fantastic deep clean. The kitchen looks brand new. Highly recommended!'),
    const WorkerReview(workerId: 'w5', name: 'Ritu M.', initials: 'RM', rating: 5, timeAgo: '3 weeks ago', comment: 'Very thorough and gentle with our furniture. Booked her again for next month.'),
    const WorkerReview(workerId: 'w7', name: 'Arjun N.', initials: 'AN', rating: 4, timeAgo: '2 weeks ago', comment: 'Great carpenter, fixed our wardrobe door perfectly. Very skilled.'),
    const WorkerReview(workerId: 'w3', name: 'Neha P.', initials: 'NP', rating: 5, timeAgo: '1 month ago', comment: 'Fixed a stubborn leak in no time. Polite and professional throughout.'),
  ];

  static final List<Booking> bookings = [
    Booking(
      id: 'b1', serviceName: 'Electrical Wiring', workerId: 'w1',
      workerName: 'Rajesh Kumar', workerPhotoUrl: '', addressLabel: 'Home',
      addressDetail: '12, Green Park Colony, Sector 5', type: BookingType.immediate,
      tier: ServiceTier.contract, contractVisitFee: 200,
      status: BookingStatus.workerEnRoute, createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      priceEstimate: 200,
    ),
    Booking(
      id: 'b2', serviceName: 'Bathroom Plumbing', workerId: 'w3',
      workerName: 'Suresh Patel', workerPhotoUrl: '', addressLabel: 'Work',
      addressDetail: '45, MG Road, Near SBI', type: BookingType.scheduled,
      tier: ServiceTier.fixed, status: BookingStatus.confirmed,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      scheduledDateTime: DateTime.now().add(const Duration(days: 2)),
      priceEstimate: 400,
    ),
    Booking(
      id: 'b3', serviceName: 'Deep Cleaning', workerId: 'w5',
      workerName: 'Priya Devi', workerPhotoUrl: '', addressLabel: 'Home',
      addressDetail: '12, Green Park Colony, Sector 5', type: BookingType.immediate,
      tier: ServiceTier.hourly, hourlyRate: 450,
      status: BookingStatus.completed, isPaid: true,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      priceEstimate: 500,
    ),
  ];

  static final List<Quote> quotes = [
    Quote(
      status: 'pending', bookingId: 'b1', proposedAmount: 4500,
      proposedTimeline: '3 days (2 visits)', consultancyFee: 200,
      distanceFee: 40, proposedAt: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
  ];

  static final List<Receipt> receipts = [
    Receipt(
      id: 'r1', bookingId: 'b3', serviceName: 'Deep Cleaning',
      workerName: 'Priya Devi', paymentMethod: 'UPI · priya@upi',
      baseAmount: 500, tax: 0, tip: 50, total: 550,
      paidAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  static final List<WorkSession> workSessions = [
    WorkSession(
      id: 'ws1', bookingId: 'b3', isPause: false,
      startTime: DateTime.now().subtract(const Duration(days: 5, hours: 2)),
      endTime: DateTime.now().subtract(const Duration(days: 5, hours: 1)),
    ),
    WorkSession(
      id: 'ws2', bookingId: 'b3', isPause: false,
      startTime: DateTime.now().subtract(const Duration(days: 5, hours: 1)),
      endTime: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  static final List<Address> addresses = [
    const Address(id: 'a1', label: 'Home', detail: '12, Green Park Colony, Sector 5', latitude: 22.5726, longitude: 88.3639),
    const Address(id: 'a2', label: 'Work', detail: '45, MG Road, Near SBI', latitude: 22.5800, longitude: 88.3700),
    const Address(id: 'a3', label: 'Parents', detail: '78, Lake Gardens, Block B', latitude: 22.5200, longitude: 88.3500),
  ];

  static final List<PaymentMethod> paymentMethods = [
    const PaymentMethod(id: 'pm1', type: 'UPI', displayValue: 'rajesh@upi', isDefault: true),
    const PaymentMethod(id: 'pm2', type: 'UPI', displayValue: '98765****@paytm'),
  ];

  static final List<NotificationItem> notifications = [
    NotificationItem(
      id: 'n1', type: NotificationType.booking, title: 'Worker En Route',
      message: 'Rajesh Kumar is on the way for Electrical Wiring service.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)), isRead: false,
    ),
    NotificationItem(
      id: 'n2', type: NotificationType.booking, title: 'Booking Confirmed',
      message: 'Your plumbing service with Suresh Patel is confirmed for 2 Sep.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)), isRead: false,
    ),
    NotificationItem(
      id: 'n3', type: NotificationType.system, title: 'Verification Complete',
      message: 'Your account has been successfully verified.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)), isRead: true,
    ),
    NotificationItem(
      id: 'n4', type: NotificationType.promotion, title: 'Festival Offer',
      message: 'Get 10% off on deep cleaning services this month.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)), isRead: true,
    ),
    NotificationItem(
      id: 'n5', type: NotificationType.booking, title: 'Service Completed',
      message: 'Deep cleaning by Priya Devi has been completed. Rate your experience!',
      timestamp: DateTime.now().subtract(const Duration(days: 5)), isRead: true,
    ),
  ];

  static final List<Map<String, String>> faqItems = [
    {'question': 'How do I book a service?', 'answer': 'Select a category from the home screen, choose a worker, and confirm your booking.'},
    {'question': 'Are workers verified?', 'answer': 'Yes, all workers on SDCS are verified cooperative members with valid credentials.'},
    {'question': 'How do I cancel a booking?', 'answer': 'Go to your bookings and select the active booking to cancel. Cancellation is free if the worker has not started.'},
    {'question': 'What payment methods are accepted?', 'answer': 'We currently support UPI payments. More methods will be added soon.'},
    {'question': 'How do I raise a complaint?', 'answer': 'Go to Help & Support and tap "Raise a Complaint" to submit your issue.'},
  ];
}
