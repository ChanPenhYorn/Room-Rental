import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dwellly_flutter/features/bookings/presentation/screens/my_activities_screen.dart';
import 'package:dwellly_flutter/features/social/presentation/screens/chat_list_screen.dart';
import 'package:dwellly_flutter/features/social/presentation/screens/favourites_screen.dart';
import 'package:dwellly_flutter/features/social/presentation/screens/profile_screen.dart';
import 'package:dwellly_client/room_rental_client.dart';
import '../../../notifications/presentation/providers/notification_providers.dart';
import '../../../notifications/presentation/screens/notification_screen.dart';
import '../../../../features/auth/presentation/providers/user_providers.dart';
import '../../../../features/owner_request/presentation/providers/owner_request_providers.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/room_card.dart';
import '../providers/room_provider.dart';
import '../widgets/filter_modal.dart';
import 'room_detail_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;
  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _screens = [
    const HomeView(),
    const FavouritesScreen(),
    const MyActivitiesScreen(),
    const ChatListScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.primaryGreen,
          unselectedItemColor: AppTheme.secondaryGray,
          selectedLabelStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 10,
          ),
          unselectedLabelStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.normal,
            fontSize: 10,
          ),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today),
              label: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for new notifications to show an alert and refresh stale state
    ref.listen<AppNotification?>(newNotificationEventProvider, (
      previous,
      next,
    ) {
      if (next != null) {
        // 1. Refresh relevant providers if it's a role or request change
        final type = next.data?['type'];
        if (type == 'role_change' ||
            type == 'owner_request' ||
            type == 'owner_request_status' ||
            type == 'room_status' ||
            type == 'room_submission') {
          print(
            '🔔 [HomeView] Role/Request/Room change detected (type: $type), refreshing state...',
          );
          ref.invalidate(userProfileProvider);
          ref.invalidate(myOwnerRequestProvider);
          ref.invalidate(allOwnerRequestsProvider);

          ref.invalidate(myRoomsProvider);
          ref.invalidate(adminRoomsProvider);
          ref.invalidate(pendingRoomsProvider);

          // Also refresh the notification list itself
          ref.read(notificationsProvider.notifier).refresh();
        }

        // 2. Show SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.notifications_active,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          next.title,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          next.body,
                          style: GoogleFonts.outfit(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: AppTheme.primaryGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 4),
          ),
        );
        // Clear the event after showing
        Future.microtask(
          () => ref.read(newNotificationEventProvider.notifier).state = null,
        );
      }
    });

    final roomsAsync = ref.watch(roomListProvider);

    return Scaffold(
      backgroundColor: AppTheme.surfaceWhite,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header with Location & Notification
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: AppTheme.secondaryGray,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: AppTheme.primaryGreen,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Phnom Penh, Cambodia',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryBlack,
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Consumer(
                      builder: (context, ref, _) {
                        // Watch notificationsProvider to trigger initialization and refresh
                        ref.watch(notificationsProvider);
                        final unreadCount = ref.watch(
                          unreadNotificationCountProvider,
                        );
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.notifications_none_outlined,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const NotificationScreen(),
                                    ),
                                  );
                                },
                                color: AppTheme.primaryBlack,
                              ),
                            ),
                            if (unreadCount > 0)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 8,
                                    minHeight: 8,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Search & Filter
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SearchScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.dividerGray,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.transparent),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search,
                                color: AppTheme.secondaryGray,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Search room, apartment...',
                                  style: GoogleFonts.outfit(
                                    color: AppTheme.secondaryGray,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => Consumer(
                            builder: (context, ref, _) {
                              return FilterModal(
                                initialFilters: ref.read(roomFilterProvider),
                                onApply: (filters) {
                                  ref
                                      .read(roomFilterProvider.notifier)
                                      .setFilter(filters);
                                },
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.tune,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Premium Modern Segmented Tab
            SliverToBoxAdapter(
              child: Consumer(
                builder: (context, ref, child) {
                  final selectedCategory = ref.watch(selectedCategoryProvider);
                  final categories = [
                    'All',
                    'Studio',
                    '1BR Apt',
                    '2BR Apt',
                    'Dormitory',
                    'Villa',
                    'House',
                    'Condo',
                  ];

                  return _ModernSegmentedTab(
                    categories: categories,
                    selectedCategory: selectedCategory,
                    onCategorySelected: (category) {
                      ref
                          .read(selectedCategoryProvider.notifier)
                          .setCategory(category);
                    },
                  );
                },
              ),
            ),

            const SliverPadding(padding: EdgeInsets.only(top: 20)),

            // Near You Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Near You',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlack,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'See All',
                        style: GoogleFonts.outfit(
                          color: AppTheme.secondaryGray,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Room List
            roomsAsync.when(
              data: (rooms) {
                if (rooms.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No rooms found',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.secondaryGray,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try selecting a different category\nor check back later.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              ref
                                  .read(selectedCategoryProvider.notifier)
                                  .setCategory('All');
                            },
                            child: Text(
                              'Clear Filter',
                              style: GoogleFonts.outfit(
                                color: AppTheme.primaryGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final room = rooms[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RoomDetailScreen(room: room),
                              ),
                            );
                          },
                          child: RoomCard(room: room),
                        );
                      },
                      childCount: rooms.length,
                    ),
                  ),
                );
              },
              error: (err, stack) => SliverToBoxAdapter(
                child: Center(child: Text('Error: $err')),
              ),
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
            ),

            const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
          ],
        ),
      ),
    );
  }
}

class _ModernSegmentedTab extends StatefulWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const _ModernSegmentedTab({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<_ModernSegmentedTab> createState() => _ModernSegmentedTabState();
}

class _ModernSegmentedTabState extends State<_ModernSegmentedTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.categories.length,
      vsync: this,
      initialIndex: widget.categories.indexOf(widget.selectedCategory),
    );
  }

  @override
  void didUpdateWidget(_ModernSegmentedTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategory != widget.selectedCategory) {
      final newIndex = widget.categories.indexOf(widget.selectedCategory);
      if (newIndex != -1 && newIndex != _tabController.index) {
        _tabController.animateTo(newIndex);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 54,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppTheme.dividerGray.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          onTap: (index) {
            widget.onCategorySelected(widget.categories[index]);
          },
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          indicator: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: AppTheme.primaryGreen,
          unselectedLabelColor: AppTheme.secondaryGray,
          labelStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          unselectedLabelStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          tabAlignment: TabAlignment.start,
          tabs: widget.categories.map((c) {
            return Tab(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(c),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
