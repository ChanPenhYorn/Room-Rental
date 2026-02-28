import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/room_card.dart';
import '../providers/room_provider.dart';
import 'room_detail_screen.dart';

/// Search Screen with search history and results
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  List<String> _searchHistory = [
    'Modern Studio',
    'DHA Phase 5',
    'Apartment',
    'Gulberg',
  ];
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchFocus.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;

    setState(() {
      _searchQuery = query;
      _isSearching = true;

      // Add to history if not already there
      if (!_searchHistory.contains(query)) {
        _searchHistory.insert(0, query);
        if (_searchHistory.length > 10) {
          _searchHistory = _searchHistory.sublist(0, 10);
        }
      }
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final roomsAsync = ref.watch(roomListProvider);

    return Scaffold(
      backgroundColor: AppTheme.surfaceWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.dividerGray,
            borderRadius: BorderRadius.circular(24),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocus,
            onSubmitted: _performSearch,
            decoration: InputDecoration(
              hintText: 'Search apartment, house...',
              hintStyle: GoogleFonts.outfit(
                color: AppTheme.secondaryGray,
                fontSize: 14,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: AppTheme.secondaryGray,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: AppTheme.secondaryGray,
                      ),
                      onPressed: _clearSearch,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
      ),
      body: _isSearching
          ? _buildSearchResults(roomsAsync)
          : _buildSearchHistory(),
    );
  }

  Widget _buildSearchHistory() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Searches',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlack,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _searchHistory.clear();
                });
              },
              child: Text(
                'Clear All',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_searchHistory.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text(
                'No recent searches',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: AppTheme.secondaryGray,
                ),
              ),
            ),
          )
        else
          ..._searchHistory.map((query) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.history,
                color: AppTheme.secondaryGray,
              ),
              title: Text(
                query,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: AppTheme.primaryBlack,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: AppTheme.secondaryGray,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _searchHistory.remove(query);
                  });
                },
              ),
              onTap: () {
                _searchController.text = query;
                _performSearch(query);
              },
            );
          }).toList(),
        const SizedBox(height: 32),
        Text(
          'Popular Searches',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryBlack,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              [
                'Studio',
                'Apartment',
                'DHA',
                'Gulberg',
                'Affordable',
                'Luxury',
              ].map((tag) {
                return InkWell(
                  onTap: () {
                    _searchController.text = tag;
                    _performSearch(tag);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.dividerGray,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      tag,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: AppTheme.primaryBlack,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildSearchResults(AsyncValue roomsAsync) {
    return roomsAsync.when(
      data: (rooms) {
        // Filter rooms based on search query
        final filteredRooms = rooms.where((room) {
          final query = _searchQuery.toLowerCase();
          return (room.title.toLowerCase().contains(query)) ||
              (room.location?.toLowerCase().contains(query) ?? false) ||
              (room.description.toLowerCase().contains(query));
        }).toList();

        if (filteredRooms.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 80,
                  color: AppTheme.secondaryGray.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No results found',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBlack,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try searching with different keywords',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: AppTheme.secondaryGray,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              '${filteredRooms.length} results found',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlack,
              ),
            ),
            const SizedBox(height: 16),
            ...filteredRooms.map((room) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: RoomCard(
                  room: room,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RoomDetailScreen(room: room),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Text('Error: $err'),
      ),
    );
  }
}
