import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/load_provider.dart';
import '../../widgets/notification_badge.dart';
import 'create_load_screen.dart';
import 'order_history_screen.dart';
import '../tracking/order_tracking_screen.dart';
import '../settings/help_support_screen.dart';

class CustomerHomeContent extends StatefulWidget {
  const CustomerHomeContent({super.key});

  @override
  State<CustomerHomeContent> createState() => _CustomerHomeContentState();
}

class _CustomerHomeContentState extends State<CustomerHomeContent> {
  final PageController _bannerController = PageController();
  final PageController _promoController = PageController();
  int _currentBannerIndex = 0;
  int _currentPromoIndex = 0;

  final List<BannerData> _banners = [
    BannerData(
      title: 'Fast Delivery',
      subtitle: 'Get your items delivered quickly',
      color: Colors.purple,
      icon: Icons.flash_on,
    ),
    BannerData(
      title: 'Track Anytime',
      subtitle: 'Real-time tracking of your orders',
      color: Colors.blue,
      icon: Icons.location_searching,
    ),
    BannerData(
      title: 'Safe & Secure',
      subtitle: 'Your packages are in safe hands',
      color: Colors.green,
      icon: Icons.verified_user,
    ),
    BannerData(
      title: '24/7 Support',
      subtitle: 'We\'re here to help anytime',
      color: Colors.orange,
      icon: Icons.support_agent,
    ),
  ];

  final List<PromoData> _promos = [
    PromoData(
      title: '20% OFF',
      subtitle: 'First Order',
      description: 'Use code: FIRST20',
      color: Colors.red,
    ),
    PromoData(
      title: 'FREE',
      subtitle: 'Delivery',
      description: 'On orders above \$50',
      color: Colors.green,
    ),
    PromoData(
      title: '\$10 OFF',
      subtitle: 'Next Order',
      description: 'Refer a friend',
      color: Colors.blue,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    _loadData();
  }

  void _loadData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final loadProvider = Provider.of<LoadProvider>(context, listen: false);
    
    if (authProvider.user != null) {
      loadProvider.fetchLoadsByCustomer(authProvider.user!.id);
      loadProvider.fetchCustomerStats(authProvider.user!.id);
    }
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _bannerController.hasClients) {
        int nextPage = (_currentBannerIndex + 1) % _banners.length;
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && _promoController.hasClients) {
        int nextPage = (_currentPromoIndex + 1) % _promos.length;
        _promoController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _loadData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 20),
                _buildBannerSection(),
                const SizedBox(height: 20),
                _buildPromotionsSection(),
                const SizedBox(height: 20),
                _buildActiveDeliveries(context),
                const SizedBox(height: 20),
                _buildQuickStats(context),
                const SizedBox(height: 20),
                _buildServices(),
                const SizedBox(height: 20),
                _buildTopDriversSection(context),
                const SizedBox(height: 20),
                _buildTopVehiclesSection(context),
                const SizedBox(height: 20),
                _buildQuickActions(context),
                const SizedBox(height: 20),
                _buildWhyChooseUs(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final now = DateTime.now();
    final hour = now.hour;
    String greeting = 'Good Morning';
    IconData greetingIcon = Icons.wb_sunny;
    
    if (hour >= 12 && hour < 17) {
      greeting = 'Good Afternoon';
      greetingIcon = Icons.wb_cloudy;
    } else if (hour >= 17) {
      greeting = 'Good Evening';
      greetingIcon = Icons.nightlight_round;
    }
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[700]!, Colors.purple[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(greetingIcon, color: Colors.white70, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          '$greeting,',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      authProvider.user?.name ?? 'Customer',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const NotificationBadge(),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.purple[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Search Bar
          InkWell(
            onTap: () {
              // Open search
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.white.withOpacity(0.8)),
                  const SizedBox(width: 12),
                  Text(
                    'Search for services...',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerSection() {
    return SizedBox(
      height: 180,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _bannerController,
              onPageChanged: (index) {
                setState(() {
                  _currentBannerIndex = index;
                });
              },
              itemCount: _banners.length,
              itemBuilder: (context, index) {
                return _buildBannerCard(_banners[index]);
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _banners.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentBannerIndex == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _currentBannerIndex == index
                      ? Colors.purple
                      : Colors.grey[300],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCard(BannerData banner) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [banner.color, banner.color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: banner.color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    banner.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    banner.subtitle,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            Icon(
              banner.icon,
              size: 70,
              color: Colors.white.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(Icons.local_offer, color: Colors.purple, size: 24),
              SizedBox(width: 8),
              Text(
                'Special Offers',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 120,
          child: PageView.builder(
            controller: _promoController,
            onPageChanged: (index) {
              setState(() {
                _currentPromoIndex = index;
              });
            },
            itemCount: _promos.length,
            itemBuilder: (context, index) {
              return _buildPromoCard(_promos[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPromoCard(PromoData promo) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: promo.color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: promo.color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  promo.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  promo.subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    promo.description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.card_giftcard,
            size: 60,
            color: Colors.white.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveDeliveries(BuildContext context) {
    final loadProvider = Provider.of<LoadProvider>(context);
    final activeLoads = loadProvider.loads
        .where((load) => ['assigned', 'in-transit'].contains(load.status))
        .toList();

    if (activeLoads.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(Icons.inbox_outlined, size: 60, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                'No Active Deliveries',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Place your first order now!',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final load = activeLoads.first;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Active Deliveries',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (activeLoads.length > 1)
                TextButton(
                  onPressed: () {
                    // Navigate to loads screen
                  },
                  child: Text('View All (${activeLoads.length})'),
                ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[600]!, Colors.blue[400]!],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      load.loadNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            load.status == 'in-transit' ? Icons.local_shipping : Icons.assignment,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            load.status == 'in-transit' ? 'In Transit' : 'Assigned',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  'Expected Delivery',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      load.formattedDeliveryDate,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderTrackingScreen(load: load),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue[700],
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on),
                      SizedBox(width: 8),
                      Text(
                        'Track Delivery',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    final loadProvider = Provider.of<LoadProvider>(context);
    final stats = loadProvider.stats;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Statistics',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Orders',
                  '${stats?['totalOrders'] ?? 0}',
                  Icons.shopping_bag,
                  Colors.purple,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildStatCard(
                  'Active',
                  '${stats?['active'] ?? 0}',
                  Icons.local_shipping,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Delivered',
                  '${stats?['delivered'] ?? 0}',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildStatCard(
                  'Pending',
                  '${stats?['pending'] ?? 0}',
                  Icons.pending,
                  Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 15),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildServices() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Our Services',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildServiceCard(
                  'Same Day',
                  Icons.today,
                  Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildServiceCard(
                  'Express',
                  Icons.rocket_launch,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildServiceCard(
                  'Standard',
                  Icons.local_shipping,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildServiceCard(
                  'Economy',
                  Icons.savings,
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTopDriversSection(BuildContext context) {
    final topDrivers = [
      {'name': 'John Doe', 'rating': 4.9, 'trips': 150, 'image': null},
      {'name': 'Jane Smith', 'rating': 4.8, 'trips': 120, 'image': null},
      {'name': 'Mike Johnson', 'rating': 4.7, 'trips': 100, 'image': null},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.stars, color: Colors.amber, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Top Rated Drivers',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.85),
              itemCount: topDrivers.length,
              itemBuilder: (context, index) {
                final driver = topDrivers[index];
                return Container(
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green[700]!, Colors.green[500]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.green[700],
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.amber,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.verified,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                driver['name'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${driver['rating']}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Icon(
                                    Icons.local_shipping,
                                    color: Colors.white70,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${driver['trips']} trips',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Available',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopVehiclesSection(BuildContext context) {
    final topVehicles = [
      {'name': 'Mercedes Sprinter', 'number': 'TRK-001', 'capacity': 1500, 'type': 'Truck', 'image': null},
      {'name': 'Ford Transit', 'number': 'VAN-005', 'capacity': 1200, 'type': 'Van', 'image': null},
      {'name': 'Toyota Hiace', 'number': 'VAN-003', 'capacity': 1000, 'type': 'Van', 'image': null},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.directions_car, color: Colors.blue, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Top Vehicles',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.85),
              itemCount: topVehicles.length,
              itemBuilder: (context, index) {
                final vehicle = topVehicles[index];
                return Container(
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[700]!, Colors.blue[500]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            Icons.local_shipping,
                            size: 50,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                vehicle['name'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                vehicle['number'] as String,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.scale,
                                    color: Colors.white70,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${vehicle['capacity']} kg',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      vehicle['type'] as String,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  'New Order',
                  Icons.add_box,
                  Colors.green,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreateLoadScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildActionCard(
                  'Track Order',
                  Icons.location_searching,
                  Colors.orange,
                  () {
                    final loadProvider = Provider.of<LoadProvider>(context, listen: false);
                    final activeLoad = loadProvider.loads
                        .where((l) => ['assigned', 'in-transit'].contains(l.status))
                        .firstOrNull;
                    
                    if (activeLoad != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderTrackingScreen(load: activeLoad),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No active orders to track')),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  'Order History',
                  Icons.history,
                  Colors.blue,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OrderHistoryScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildActionCard(
                  'Support',
                  Icons.support_agent,
                  Colors.purple,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HelpSupportScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWhyChooseUs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Why Choose Us?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _buildFeatureItem(
            Icons.verified_user,
            'Safe & Secure',
            'Your packages are insured and tracked',
            Colors.green,
          ),
          _buildFeatureItem(
            Icons.schedule,
            'On-Time Delivery',
            '98% of orders delivered on time',
            Colors.blue,
          ),
          _buildFeatureItem(
            Icons.support_agent,
            '24/7 Support',
            'Always here to help you',
            Colors.orange,
          ),
          _buildFeatureItem(
            Icons.price_check,
            'Best Prices',
            'Competitive rates for all services',
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BannerData {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  BannerData({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });
}

class PromoData {
  final String title;
  final String subtitle;
  final String description;
  final Color color;

  PromoData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
  });
}

extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? get firstOrNull {
    var iterator = this.iterator;
    if (iterator.moveNext()) {
      return iterator.current;
    }
    return null;
  }
}