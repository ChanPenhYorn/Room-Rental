import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:room_rental_flutter/core/theme/app_theme.dart';
import 'package:room_rental_flutter/features/listings/domain/entities/room_entity.dart';
import 'package:room_rental_flutter/features/listings/presentation/providers/room_provider.dart';
import 'package:room_rental_flutter/features/listings/presentation/screens/room_detail_screen.dart';
import 'package:room_rental_flutter/features/social/presentation/providers/favourite_provider.dart';

/// Favourites Screen
/// Displays a list of user's saved/favourite rooms
class FavouritesScreen extends ConsumerWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouriteIdsAsync = ref.watch(favouriteRoomsProvider);
    final allRoomsAsync = ref.watch(roomListProvider);

    return Scaffold(
      backgroundColor: AppTheme.surfaceWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Favourites',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryBlack,
          ),
        ),
      ),
      body: favouriteIdsAsync.when(
        data: (favoriteIds) {
          if (favoriteIds.isEmpty) {
            return _buildEmptyState();
          }

          return allRoomsAsync.when(
            data: (allRooms) {
              // Filter rooms to only show favorited ones
              final favouriteRooms = allRooms
                  .where((room) => favoriteIds.contains(room.id))
                  .toList();

              if (favouriteRooms.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: favouriteRooms.length,
                itemBuilder: (context, index) {
                  final room = favouriteRooms[index];
                  return _buildFavouriteCard(context, ref, room);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('Error loading rooms: $error'),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading favourites: $error'),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.secondaryGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 64,
                color: AppTheme.primaryGreen,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No favourites yet',
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlack,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start exploring and save your favorite rooms to find them easily later.',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 16,
                color: AppTheme.secondaryGray,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavouriteCard(
    BuildContext context,
    WidgetRef ref,
    RoomEntity room,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RoomDetailScreen(room: room),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Room Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: room.imageUrl != null
                  ? Image.network(
                      room.imageUrl!,
                      width: 120,
                      height: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 120,
                          height: 140,
                          color: Colors.grey[200],
                          child: const Icon(Icons.home, size: 40),
                        );
                      },
                    )
                  : Container(
                      width: 120,
                      height: 140,
                      color: Colors.grey[200],
                      child: const Icon(Icons.home, size: 40),
                    ),
            ),

            // Room Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Favorite Button
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
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            try {
                              await ref
                                  .read(favouriteRoomsProvider.notifier)
                                  .toggleFavourite(room.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Removed from favourites'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      e.toString().contains('logged in')
                                          ? 'Please log in to save favorites'
                                          : 'Failed to remove favorite',
                                    ),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Icon(
                            Icons.favorite,
                            color: AppTheme.primaryGreen,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Location
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: AppTheme.secondaryGray,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            room.location,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: AppTheme.secondaryGray,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Rating
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          room.rating.toStringAsFixed(1),
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlack,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Price
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '\$${room.price.toInt()}',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                          TextSpan(
                            text: ' / month',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: AppTheme.secondaryGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
