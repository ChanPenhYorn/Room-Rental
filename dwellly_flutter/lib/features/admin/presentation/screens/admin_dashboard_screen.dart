import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dwellly_client/room_rental_client.dart';
import 'package:dwellly_flutter/core/theme/app_theme.dart';
import 'package:dwellly_flutter/features/listings/presentation/providers/room_provider.dart';
import 'package:dwellly_flutter/features/listings/domain/entities/room_entity.dart';
import 'package:dwellly_flutter/features/owner_request/presentation/providers/owner_request_providers.dart';
import 'package:dwellly_flutter/features/admin/presentation/providers/user_providers.dart';
import 'package:dwellly_flutter/features/auth/presentation/providers/auth_providers.dart';
import 'package:dwellly_flutter/features/listings/presentation/screens/room_detail_screen.dart';
import 'package:intl/intl.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  RoomType? _selectedType;
  UserRole? _selectedRole;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
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
    final showFilter =
        _tabController.index == 0 ||
        _tabController.index == 2 ||
        _tabController.index == 3; // Approvals, All Listings, Users

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Admin Control Panel',
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
                fontSize: 13,
              ),
              unselectedLabelStyle: GoogleFonts.outfit(fontSize: 13),
              indicatorColor: AppTheme.primaryGreen,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Room Approvals'),
                Tab(text: 'Owner Requests'),
                Tab(text: 'All Listings'),
                Tab(text: 'Users'),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (showFilter)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: _tabController.index == 3
                          ? 'Search by name or email...'
                          : 'Search by title or location...',
                      hintStyle: GoogleFonts.outfit(
                        color: Colors.grey.shade400,
                      ),
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
                        _tabController.index == 3
                            ? 'User Role: '
                            : 'Room Type: ',
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
                            child: _tabController.index == 3
                                ? DropdownButton<UserRole?>(
                                    isExpanded: true,
                                    value: _selectedRole,
                                    hint: Text(
                                      'All Roles',
                                      style: GoogleFonts.outfit(),
                                    ),
                                    items: [
                                      DropdownMenuItem<UserRole?>(
                                        value: null,
                                        child: Text(
                                          'All Roles',
                                          style: GoogleFonts.outfit(),
                                        ),
                                      ),
                                      ...UserRole.values.map(
                                        (role) => DropdownMenuItem(
                                          value: role,
                                          child: Text(
                                            role.name.toUpperCase(),
                                            style: GoogleFonts.outfit(),
                                          ),
                                        ),
                                      ),
                                    ],
                                    onChanged: (val) {
                                      setState(() {
                                        _selectedRole = val;
                                      });
                                    },
                                  )
                                : DropdownButton<RoomType?>(
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
                _PendingAdminTab(filterFn: _filterRooms),
                const _OwnerRequestsTab(),
                _AllRoomsTab(filterFn: _filterRooms),
                _UsersTab(
                  searchQuery: _searchQuery,
                  selectedRole: _selectedRole,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingAdminTab extends ConsumerWidget {
  final List<RoomEntity> Function(List<RoomEntity>) filterFn;
  const _PendingAdminTab({required this.filterFn});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingRoomsProvider);

    return pendingAsync.when(
      data: (rooms) {
        final filteredRooms = filterFn(rooms);
        return filteredRooms.isEmpty
            ? const _EmptyState(
                icon: Icons.done_all_rounded,
                message: 'No pending approvals',
                subtitle: 'All listings submitted have been reviewed.',
              )
            : _RoomList(rooms: filteredRooms, tabType: _ListTabType.pending);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorState(message: e.toString()),
    );
  }
}

class _AllRoomsTab extends ConsumerWidget {
  final List<RoomEntity> Function(List<RoomEntity>) filterFn;
  const _AllRoomsTab({required this.filterFn});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allRoomsAsync = ref.watch(adminRoomsProvider);

    return allRoomsAsync.when(
      data: (rooms) {
        final filteredRooms = filterFn(rooms);
        return filteredRooms.isEmpty
            ? const _EmptyState(
                icon: Icons.list_alt_rounded,
                message: 'No rooms found',
                subtitle: 'Adjust your search filters.',
              )
            : _RoomList(rooms: filteredRooms, tabType: _ListTabType.all);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorState(message: e.toString()),
    );
  }
}

enum _ListTabType { pending, all }

class _RoomList extends ConsumerWidget {
  final List<RoomEntity> rooms;
  final _ListTabType tabType;

  const _RoomList({required this.rooms, required this.tabType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      color: AppTheme.primaryGreen,
      onRefresh: () async {
        ref.invalidate(pendingRoomsProvider);
        ref.invalidate(adminRoomsProvider);
      },
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          return _RoomManagementCard(
            room: rooms[index],
            tabType: tabType,
          );
        },
      ),
    );
  }
}

class _RoomManagementCard extends ConsumerWidget {
  final RoomEntity room;
  final _ListTabType tabType;

  const _RoomManagementCard({required this.room, required this.tabType});

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
                  hasPendingEdit: room.hasPendingEdit,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person_outline,
                            size: 14,
                            color: AppTheme.secondaryGray,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              room.ownerName ?? 'Unknown Owner',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                color: AppTheme.secondaryGray,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${room.images.length + (room.imageUrl != null ? 1 : 0)} Photos, ${room.facilities.length} Amenities',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 10),
                _ActionRow(room: room, tabType: tabType),
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
  final _ListTabType tabType;

  const _ActionRow({required this.room, required this.tabType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _ActionButton(
          icon: Icons.info_outline,
          label: 'View Details',
          color: AppTheme.secondaryGray,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RoomDetailScreen(room: room),
              ),
            );
          },
        ),
        if (tabType == _ListTabType.pending) ...[
          _ActionButton(
            icon: Icons.check_circle_outline,
            label: 'Approve',
            color: AppTheme.primaryGreen,
            onTap: () => _updateStatus(context, ref, RoomStatus.approved),
          ),
          _ActionButton(
            icon: Icons.cancel_outlined,
            label: 'Reject',
            color: Colors.red,
            onTap: () => _showRejectDialog(context, ref),
          ),
        ],
        if (tabType == _ListTabType.all) ...[
          _ActionButton(
            icon: room.isAvailable
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            label: room.isAvailable ? 'Suspend (Hide)' : 'Restore (Show)',
            color: room.isAvailable ? Colors.orange : Colors.blue,
            onTap: () => _toggleVisibility(context, ref),
          ),
          _ActionButton(
            icon: Icons.delete_outline,
            label: 'Force Delete',
            color: Colors.red.shade800,
            onTap: () => _confirmDelete(context, ref),
          ),
        ],
        if (room.hasPendingEdit)
          _ActionButton(
            icon: Icons.edit_note_outlined,
            label: 'Review Edits',
            color: Colors.blue.shade800,
            onTap: () => _showReviewEditsDialog(context, ref),
          ),
      ],
    );
  }

  Future<void> _updateStatus(
    BuildContext context,
    WidgetRef ref,
    RoomStatus status, {
    String? rejectionReason,
  }) async {
    final success = await ref
        .read(roomControllerProvider.notifier)
        .updateRoomStatus(room.id, status, rejectionReason: rejectionReason);
    if (context.mounted) {
      _showSnack(
        context,
        success ? 'Status updated to ${status.name}' : 'Failed to update',
        success ? AppTheme.primaryGreen : Colors.red,
      );
    }
  }

  Future<void> _toggleVisibility(BuildContext context, WidgetRef ref) async {
    final success = await ref
        .read(roomControllerProvider.notifier)
        .toggleAvailability(room.id);
    if (context.mounted) {
      _showSnack(
        context,
        success ? 'Visibility toggled' : 'Failed to toggle',
        success ? Colors.blue : Colors.red,
      );
    }
  }

  void _showRejectDialog(BuildContext context, WidgetRef ref) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Reject Listing',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Please provide a reason so the owner can fix the issues and resubmit.',
              style: GoogleFonts.outfit(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'E.g., Photos are blurry or price is invalid...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              final val = reasonController.text.trim();
              if (val.isEmpty) return;
              Navigator.pop(ctx);
              _updateStatus(
                context,
                ref,
                RoomStatus.rejected,
                rejectionReason: val,
              );
            },
            child: Text(
              'Reject',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Force Delete?',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'This permanently deletes the listing from the database.',
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade800,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ref
                  .read(roomControllerProvider.notifier)
                  .deleteRoom(room.id);
              if (context.mounted) {
                _showSnack(
                  context,
                  success ? 'Listing deleted' : 'Failed to delete',
                  success ? Colors.grey : Colors.red,
                );
              }
            },
            child: Text(
              'Delete',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.bold,
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
      ),
    );
  }

  void _showReviewEditsDialog(BuildContext context, WidgetRef ref) {
    if (room.pendingData == null) return;

    try {
      final pendingMap = jsonDecode(room.pendingData!) as Map<String, dynamic>;

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Review Proposed Edits',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The owner has proposed changes to this approved listing. Compare them below:',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: AppTheme.secondaryGray,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDiffItem('Title', room.title, pendingMap['title']),
                  _buildDiffItem(
                    'Description',
                    room.description,
                    pendingMap['description'],
                  ),
                  _buildDiffItem(
                    'Price',
                    '\$${room.price.toStringAsFixed(2)}',
                    pendingMap.containsKey('price')
                        ? '\$${(pendingMap['price'] as num).toDouble().toStringAsFixed(2)}'
                        : null,
                  ),
                  _buildDiffItem(
                    'Location',
                    room.location,
                    pendingMap['location'],
                  ),
                  _buildDiffItem('Type', room.type.uiLabel, pendingMap['type']),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Later',
                style: GoogleFonts.outfit(color: AppTheme.secondaryGray),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                _updateStatus(context, ref, RoomStatus.approved);
              },
              child: Text(
                'Approve & Apply',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      _showSnack(context, 'Error decoding edits: $e', Colors.red);
    }
  }

  Widget _buildDiffItem(String label, String current, dynamic proposed) {
    final proposedStr = proposed?.toString();
    final isDifferent = proposedStr != null && proposedStr != current;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            current,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: isDifferent ? Colors.red : Colors.black87,
            ),
          ),
          if (isDifferent) ...[
            const Icon(
              Icons.arrow_downward,
              size: 14,
              color: AppTheme.primaryGreen,
            ),
            Text(
              proposedStr,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryGreen,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// OWNER REQUESTS TAB
// ---------------------------------------------------------

class _OwnerRequestsTab extends ConsumerWidget {
  const _OwnerRequestsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(allOwnerRequestsProvider);

    return requestsAsync.when(
      data: (requests) {
        final pending = requests
            .where((r) => r.status == OwnerRequestStatus.pending)
            .toList();

        return pending.isEmpty
            ? const _EmptyState(
                icon: Icons.verified_user_outlined,
                message: 'No pending requests',
                subtitle: 'There are no new owner applications to review.',
              )
            : RefreshIndicator(
                color: AppTheme.primaryGreen,
                onRefresh: () async => ref.invalidate(allOwnerRequestsProvider),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: pending.length,
                  itemBuilder: (ctx, i) {
                    final req = pending[i];
                    return _OwnerRequestCard(request: req);
                  },
                ),
              );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorState(message: e.toString()),
    );
  }
}

class _OwnerRequestCard extends ConsumerWidget {
  final BecomeOwnerRequest request;

  const _OwnerRequestCard({required this.request});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
                backgroundImage: request.user?.profileImage != null
                    ? NetworkImage(request.user!.profileImage!)
                    : (request.user?.userInfo?.imageUrl != null
                          ? NetworkImage(request.user!.userInfo!.imageUrl!)
                          : null),
                child:
                    (request.user?.profileImage == null &&
                        request.user?.userInfo?.imageUrl == null)
                    ? const Icon(Icons.person, color: AppTheme.primaryGreen)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.user?.fullName ?? 'Unknown User',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      request.user?.userInfo?.email ??
                          (request.user?.userInfo?.userIdentifier != null &&
                                  request
                                          .user!
                                          .userInfo!
                                          .userIdentifier
                                          .length >
                                      10
                              ? 'ID: #${request.user!.userInfo!.userIdentifier.substring(0, 8)}...'
                              : (request.user?.userInfo?.userIdentifier ??
                                    'No identifier')),
                      style: GoogleFonts.outfit(
                        color: AppTheme.secondaryGray,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'ID: ${request.userId}',
                    style: GoogleFonts.outfit(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showUserInfoDialog(context, request.user),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'View Info',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (request.message != null && request.message!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '"${request.message}"',
                style: GoogleFonts.outfit(
                  fontStyle: FontStyle.italic,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      _handleUpdate(context, ref, OwnerRequestStatus.rejected),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Reject', style: GoogleFonts.outfit()),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () =>
                      _handleUpdate(context, ref, OwnerRequestStatus.approved),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Approve', style: GoogleFonts.outfit()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleUpdate(
    BuildContext context,
    WidgetRef ref,
    OwnerRequestStatus status,
  ) async {
    final success = await ref
        .read(ownerRequestControllerProvider.notifier)
        .updateRequestStatus(request.id ?? 0, status);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Request ${status.name}' : 'Action failed',
            style: GoogleFonts.outfit(),
          ),
          backgroundColor: success
              ? (status == OwnerRequestStatus.approved
                    ? AppTheme.primaryGreen
                    : Colors.orange)
              : Colors.red,
        ),
      );
    }
  }

  void _showUserInfoDialog(BuildContext context, User? user) {
    if (user == null) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: user.profileImage != null
                  ? NetworkImage(user.profileImage!)
                  : (user.userInfo?.imageUrl != null
                        ? NetworkImage(user.userInfo!.imageUrl!)
                        : null),
              child:
                  (user.profileImage == null && user.userInfo?.imageUrl == null)
                  ? const Icon(Icons.person)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'User Details',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Full Name', user.fullName),
            _buildDetailRow('Email', user.userInfo?.email ?? 'N/A'),
            _buildDetailRow('Phone', user.phone ?? 'Not provided'),
            _buildDetailRow('Role', user.role.name.toUpperCase()),
            _buildDetailRow(
              'Member Since',
              DateFormat('MMM dd, yyyy').format(user.createdAt),
            ),
            if (user.bio != null && user.bio!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Bio',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.bio!,
                style: GoogleFonts.outfit(fontSize: 14),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Close',
              style: GoogleFonts.outfit(
                color: AppTheme.primaryGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: AppTheme.primaryBlack,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// USERS TAB
// ---------------------------------------------------------

class _UsersTab extends ConsumerWidget {
  const _UsersTab({required this.searchQuery, this.selectedRole});
  final String searchQuery;
  final UserRole? selectedRole;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pass the search query and role to the provider
    final usersAsync = ref.watch(
      allUsersProvider((
        searchTerm: searchQuery.isEmpty ? null : searchQuery,
        role: selectedRole,
      )),
    );

    return usersAsync.when(
      data: (users) {
        final isFilterActive = searchQuery.isNotEmpty || selectedRole != null;
        return users.isEmpty
            ? _EmptyState(
                icon: isFilterActive
                    ? Icons.search_off_rounded
                    : Icons.group_off_outlined,
                message: isFilterActive ? 'No matches found' : 'No users found',
                subtitle: isFilterActive
                    ? 'Try a different search term or role.'
                    : 'There are no users to display.',
              )
            : RefreshIndicator(
                color: AppTheme.primaryGreen,
                onRefresh: () async {
                  ref.invalidate(userStatsProvider);
                  return ref.refresh(
                    allUsersProvider((
                      searchTerm: searchQuery.isEmpty ? null : searchQuery,
                      role: selectedRole,
                    )).future,
                  );
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const _UserStatsCards(),
                    const SizedBox(height: 16),
                    ...users.map((user) => _UserManagementCard(user: user)),
                  ],
                ),
              );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorState(message: e.toString()),
    );
  }
}

class _UserManagementCard extends ConsumerWidget {
  final User user;

  const _UserManagementCard({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayUrl =
        user.profileImage ??
        user.userInfo?.imageUrl ??
        'https://i.pravatar.cc/150?u=${user.id}';

    final roleColor = user.role == UserRole.admin
        ? Colors.purple
        : user.role == UserRole.owner
        ? AppTheme.primaryGreen
        : Colors.grey.shade600;

    // Check if the current user is the target user to prevent self-demotion
    final authState = ref.watch(authStateProvider);
    final isMe = authState.maybeWhen(
      authenticated: (currentUser) => currentUser.id == user.userInfoId,
      orElse: () => false,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(displayUrl),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      user.userInfo?.email ?? 'No email',
                      style: GoogleFonts.outfit(
                        color: AppTheme.secondaryGray,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: roleColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: roleColor.withOpacity(0.3)),
                ),
                child: Text(
                  user.role.name.toUpperCase(),
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: roleColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Joined: ${DateFormat('MMM dd, yyyy').format(user.createdAt)}',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton<UserRole>(
                  icon: const Icon(Icons.edit_note, size: 20),
                  hint: Text(
                    'Change Role',
                    style: GoogleFonts.outfit(fontSize: 13),
                  ),
                  items: UserRole.values.map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(
                        role.name.toUpperCase(),
                        style: GoogleFonts.outfit(),
                      ),
                    );
                  }).toList(),
                  onChanged: isMe
                      ? null
                      : (newRole) async {
                          if (newRole != null && newRole != user.role) {
                            _showRoleChangeDialog(context, ref, newRole);
                          }
                        },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showRoleChangeDialog(
    BuildContext context,
    WidgetRef ref,
    UserRole newRole,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Change Role?',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to change ${user.fullName}\'s role to ${newRole.name.toUpperCase()}?',
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
            style: ElevatedButton.styleFrom(
              backgroundColor: newRole == UserRole.admin
                  ? Colors.red
                  : AppTheme.primaryGreen,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ref
                  .read(userControllerProvider.notifier)
                  .updateUserRole(user.id!, newRole);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Role updated to ${newRole.name}'
                          : 'Failed to update role',
                      style: GoogleFonts.outfit(),
                    ),
                    backgroundColor: success
                        ? AppTheme.primaryGreen
                        : Colors.red,
                  ),
                );
              }
            },
            child: Text(
              'Confirm',
              style: GoogleFonts.outfit(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// REUSABLE WIDGETS
// ---------------------------------------------------------

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

class _UserStatsCards extends ConsumerWidget {
  const _UserStatsCards();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(userStatsProvider);

    return statsAsync.when(
      data: (stats) {
        if (stats.isEmpty) return const SizedBox.shrink();

        return Row(
          children: [
            _StatCard(
              label: 'Total Users',
              value: stats['total']?.toString() ?? '0',
              color: Colors.blue,
              icon: Icons.group,
            ),
            const SizedBox(width: 8),
            _StatCard(
              label: 'Admins',
              value: stats['admins']?.toString() ?? '0',
              color: Colors.purple,
              icon: Icons.admin_panel_settings,
            ),
            const SizedBox(width: 8),
            _StatCard(
              label: 'Owners',
              value: stats['owners']?.toString() ?? '0',
              color: AppTheme.primaryGreen,
              icon: Icons.real_estate_agent,
            ),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlack,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 11,
                color: AppTheme.secondaryGray,
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
  final bool hasPendingEdit;

  const _StatusBadge({
    required this.status,
    required this.isAvailable,
    this.hasPendingEdit = false,
  });

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
      label = 'Hidden/Suspended';
      icon = Icons.visibility_off_rounded;
    } else {
      color = AppTheme.primaryGreen;
      label = 'Active';
      icon = Icons.check_circle_rounded;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
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
        ),
        if (hasPendingEdit) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.blue.shade600,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.edit_note, size: 12, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  'Edit Pending',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
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
