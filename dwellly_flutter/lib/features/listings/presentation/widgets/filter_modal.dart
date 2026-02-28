import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';

/// Filter options model
class FilterOptions {
  final double minPrice;
  final double maxPrice;
  final List<String> propertyTypes;
  final List<String> amenities;
  final double? minRating;

  FilterOptions({
    this.minPrice = 0,
    this.maxPrice = 1000,
    this.propertyTypes = const [],
    this.amenities = const [],
    this.minRating,
  });

  FilterOptions copyWith({
    double? minPrice,
    double? maxPrice,
    List<String>? propertyTypes,
    List<String>? amenities,
    double? minRating,
  }) {
    return FilterOptions(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      propertyTypes: propertyTypes ?? this.propertyTypes,
      amenities: amenities ?? this.amenities,
      minRating: minRating ?? this.minRating,
    );
  }
}

/// Filter Modal Bottom Sheet
class FilterModal extends StatefulWidget {
  final FilterOptions? initialFilters;
  final Function(FilterOptions) onApply;

  const FilterModal({
    super.key,
    this.initialFilters,
    required this.onApply,
  });

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  late double _minPrice;
  late double _maxPrice;
  late List<String> _selectedTypes;
  late List<String> _selectedAmenities;
  double? _minRating;

  final List<String> _propertyTypes = [
    'Studio',
    '1BR Apt',
    '2BR Apt',
    'Dormitory',
    'Villa',
    'House',
    'Condo',
  ];

  final List<String> _amenitiesList = [
    'WiFi',
    'AC',
    'Kitchen',
    'Parking',
    'Security',
    'Gym',
    'Pool',
    'Garden',
  ];

  @override
  void initState() {
    super.initState();
    final filters = widget.initialFilters ?? FilterOptions();
    _minPrice = filters.minPrice;
    _maxPrice = filters.maxPrice;
    _selectedTypes = List.from(filters.propertyTypes);
    _selectedAmenities = List.from(filters.amenities);
    _minRating = filters.minRating;
  }

  void _resetFilters() {
    setState(() {
      _minPrice = 0;
      _maxPrice = 1000;
      _selectedTypes = [];
      _selectedAmenities = [];
      _minRating = null;
    });
  }

  void _applyFilters() {
    widget.onApply(
      FilterOptions(
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        propertyTypes: _selectedTypes,
        amenities: _selectedAmenities,
        minRating: _minRating,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.dividerGray,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlack,
                  ),
                ),
                TextButton(
                  onPressed: _resetFilters,
                  child: Text(
                    'Reset',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Price Range
                _buildSectionTitle('Price Range'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Min Price',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: AppTheme.secondaryGray,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${_minPrice.toInt()}',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Max Price',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: AppTheme.secondaryGray,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${_maxPrice.toInt()}',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                RangeSlider(
                  values: RangeValues(_minPrice, _maxPrice),
                  min: 0,
                  max: 1000,
                  divisions: 20,
                  activeColor: AppTheme.primaryGreen,
                  inactiveColor: AppTheme.dividerGray,
                  onChanged: (RangeValues values) {
                    setState(() {
                      _minPrice = values.start;
                      _maxPrice = values.end;
                    });
                  },
                ),
                const SizedBox(height: 32),

                // Property Type
                _buildSectionTitle('Property Type'),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _propertyTypes.map((type) {
                    final isSelected = _selectedTypes.contains(type);
                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedTypes.remove(type);
                          } else {
                            _selectedTypes.add(type);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryGreen
                              : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryGreen
                                : AppTheme.dividerGray,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          type,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: isSelected
                                ? Colors.white
                                : AppTheme.primaryBlack,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),

                // Amenities
                _buildSectionTitle('Amenities'),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _amenitiesList.map((amenity) {
                    final isSelected = _selectedAmenities.contains(amenity);
                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedAmenities.remove(amenity);
                          } else {
                            _selectedAmenities.add(amenity);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryGreen
                              : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryGreen
                                : AppTheme.dividerGray,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          amenity,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: isSelected
                                ? Colors.white
                                : AppTheme.primaryBlack,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),

                // Rating
                _buildSectionTitle('Minimum Rating'),
                const SizedBox(height: 16),
                Row(
                  children: List.generate(5, (index) {
                    final rating = (index + 1).toDouble();
                    final isSelected = _minRating == rating;
                    return Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _minRating = isSelected ? null : rating;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryGreen
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primaryGreen
                                  : AppTheme.dividerGray,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                size: 16,
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.primaryGreen,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${index + 1}',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.primaryBlack,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Apply Button
          Container(
            padding: const EdgeInsets.all(20),
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
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Apply Filters',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppTheme.primaryBlack,
      ),
    );
  }
}
