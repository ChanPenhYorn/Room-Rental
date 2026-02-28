import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:room_rental_client/room_rental_client.dart';
import 'package:room_rental_flutter/core/theme/app_theme.dart';
import 'package:room_rental_flutter/features/listings/presentation/providers/room_provider.dart';
import 'package:room_rental_flutter/features/listings/domain/entities/room_entity.dart';

class OwnerDashboardScreen extends ConsumerStatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  ConsumerState<OwnerDashboardScreen> createState() =>
      _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends ConsumerState<OwnerDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  RoomType? _selectedType;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<RoomEntity> _filterRooms(List<RoomEntity> rooms) {
    return rooms.where((room) {
      bool matchesSearch = true;
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        matchesSearch =
            room.title.toLowerCase().contains(q) ||
            room.location.toLowerCase().contains(q);
      }
      bool matchesType = true;
      if (_selectedType != null) {
        matchesType = room.type == _selectedType;
      }
      return matchesSearch && matchesType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'My Properties',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.primaryBlack,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.primaryGreen,
              unselectedLabelColor: AppTheme.secondaryGray,
              labelStyle: GoogleFonts.outfit(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: GoogleFonts.outfit(fontSize: 14),
              indicatorColor: AppTheme.primaryGreen,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Pending'),
                Tab(text: 'My Listings'),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter & Search Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by title or location...',
                    hintStyle: GoogleFonts.outfit(color: Colors.grey.shade400),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Room Type: ',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBlack,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<RoomType?>(
                            isExpanded: true,
                            value: _selectedType,
                            hint: Text(
                              'All Types',
                              style: GoogleFonts.outfit(),
                            ),
                            items: [
                              DropdownMenuItem<RoomType?>(
                                value: null,
                                child: Text(
                                  'All Types',
                                  style: GoogleFonts.outfit(),
                                ),
                              ),
                              ...RoomType.values.map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(
                                    type.uiLabel,
                                    style: GoogleFonts.outfit(),
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (val) {
                              setState(() {
                                _selectedType = val;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _PendingTab(filterFn: _filterRooms),
                _MyListingsTab(filterFn: _filterRooms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingTab extends ConsumerWidget {
  final List<RoomEntity> Function(List<RoomEntity>) filterFn;
  const _PendingTab({required this.filterFn});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingRoomsProvider);

    return pendingAsync.when(
      data: (rooms) {
        final filteredRooms = filterFn(rooms);
        return filteredRooms.isEmpty
            ? const _EmptyState(
                icon: Icons.hourglass_empty_rounded,
                message: 'No pending listings',
                subtitle:
                    'All listings have been reviewed or nothing matches the filter.',
              )
            : _RoomList(
                rooms: filteredRooms,
                showPendingActions: true,
                isAdmin: false,
              );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorState(message: e.toString()),
    );
  }
}

class _MyListingsTab extends ConsumerWidget {
  final List<RoomEntity> Function(List<RoomEntity>) filterFn;
  const _MyListingsTab({required this.filterFn});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myRoomsAsync = ref.watch(myRoomsProvider);

    return myRoomsAsync.when(
      data: (rooms) {
        final filteredRooms = filterFn(rooms);
        return filteredRooms.isEmpty
            ? const _EmptyState(
                icon: Icons.home_work_outlined,
                message: 'No listings found',
                subtitle: 'Check your search filters or add a property.',
              )
            : _RoomList(
                rooms: filteredRooms,
                showPendingActions: false,
                isAdmin: false,
              );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorState(message: e.toString()),
    );
  }
}

class _RoomList extends ConsumerWidget {
  final List<RoomEntity> rooms;
  final bool showPendingActions;
  final bool isAdmin;

  const _RoomList({
    required this.rooms,
    required this.showPendingActions,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      color: AppTheme.primaryGreen,
      onRefresh: () async {
        ref.invalidate(pendingRoomsProvider);
        ref.invalidate(myRoomsProvider);
      },
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          return _RoomManagementCard(
            room: rooms[index],
            showPendingActions: showPendingActions,
            isAdmin: isAdmin,
          );
        },
      ),
    );
  }
}

class _RoomManagementCard extends ConsumerWidget {
  final RoomEntity room;
  final bool showPendingActions;
  final bool isAdmin;

  const _RoomManagementCard({
    required this.room,
    required this.showPendingActions,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: room.imageUrl != null
                      ? _buildRoomImage(room.imageUrl!)
                      : const _PlaceholderImage(),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: _StatusBadge(
                  status: room.status,
                  isAvailable: room.isAvailable,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        room.title,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlack,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '\$${room.price.toStringAsFixed(0)}/mo',
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: AppTheme.secondaryGray,
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        room.location,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: AppTheme.secondaryGray,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 10),
                _ActionRow(
                  room: room,
                  showPendingActions: showPendingActions,
                  isAdmin: isAdmin,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomImage(String path) {
    if (path.startsWith('http') || path.startsWith('https')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const _PlaceholderImage(),
      );
    } else {
      final cleanPath = path.replaceFirst('file://', '');
      return Image.file(
        File(cleanPath),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const _PlaceholderImage(),
      );
    }
  }
}

class _ActionRow extends ConsumerWidget {
  final RoomEntity room;
  final bool showPendingActions;
  final bool isAdmin;

  const _ActionRow({
    required this.room,
    required this.showPendingActions,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isApproved = room.status == RoomStatus.approved;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (isApproved && !isAdmin)
          _ActionButton(
            icon: room.isAvailable
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            label: room.isAvailable ? 'Hide' : 'Show',
            color: room.isAvailable ? Colors.orange : Colors.blue,
            onTap: () => _handleToggle(context, ref, room.id),
          ),
        if (!isAdmin)
          _ActionButton(
            icon: Icons.delete_outline,
            label: 'Delete',
            color: Colors.red.shade400,
            onTap: () => _confirmDelete(context, ref, room.id),
          ),
      ],
    );
  }

  Future<void> _handleToggle(
    BuildContext context,
    WidgetRef ref,
    int roomId,
  ) async {
    final success = await ref
        .read(roomControllerProvider.notifier)
        .toggleAvailability(roomId);
    if (context.mounted) {
      _showSnack(
        context,
        success ? 'Visibility updated' : 'Failed to update visibility',
        success ? AppTheme.primaryGreen : Colors.red,
      );
    }
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, int roomId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Listing?',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'This action cannot be undone. Are you sure?',
          style: GoogleFonts.outfit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: GoogleFonts.outfit(color: AppTheme.secondaryGray),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ref
                  .read(roomControllerProvider.notifier)
                  .deleteRoom(roomId);
              if (context.mounted) {
                _showSnack(
                  context,
                  success ? 'Listing deleted' : 'Failed to delete listing',
                  success ? Colors.grey : Colors.red,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Delete',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.outfit()),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final RoomStatus status;
  final bool isAvailable;

  const _StatusBadge({required this.status, required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    late Color color;
    late String label;
    late IconData icon;

    if (status == RoomStatus.pending) {
      color = Colors.amber.shade700;
      label = 'Pending';
      icon = Icons.hourglass_top_rounded;
    } else if (status == RoomStatus.rejected) {
      color = Colors.red;
      label = 'Rejected';
      icon = Icons.cancel_rounded;
    } else if (!isAvailable) {
      color = Colors.grey.shade600;
      label = 'Hidden';
      icon = Icons.visibility_off_rounded;
    } else {
      color = AppTheme.primaryGreen;
      label = 'Active';
      icon = Icons.check_circle_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: Icon(
        Icons.home_work_outlined,
        size: 48,
        color: Colors.grey.shade300,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.message,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 56, color: AppTheme.primaryGreen),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlack,
              ),
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: AppTheme.secondaryGray,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Error: $message',
        style: GoogleFonts.outfit(color: Colors.red),
      ),
    );
  }
}
