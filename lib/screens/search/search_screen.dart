import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../models/outfit_model.dart';
import '../../providers/outfit_provider.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/outfit_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.onOutfitTap,
  });

  final ValueChanged<OutfitModel> onOutfitTap;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchController;

  final List<String> _recentSearches = [
    'Lehenga · Lahore',
    'Faiza Saqlain',
    'Bridal ivory',
    'Mehndi green',
  ];

  @override
  void initState() {
    super.initState();
    final provider = context.read<OutfitProvider>();
    _searchController = TextEditingController(text: provider.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterModal(BuildContext context) {
    final outfitProvider = context.read<OutfitProvider>();
    double min = outfitProvider.minPrice;
    double max = outfitProvider.maxPrice;
    String? city = outfitProvider.selectedCity;
    final Set<String> sizes = Set.from(outfitProvider.selectedSizes);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                20,
                24,
                MediaQuery.of(context).viewInsets.bottom + 28,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Narrow the edit',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.ink,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            min = 1000;
                            max = 50000;
                            city = null;
                            sizes.clear();
                          });
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Budget Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'BUDGET · PKR / DAY',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                          color: AppColors.muted,
                        ),
                      ),
                      Text(
                        '${Formatters.pkr(min)} – ${Formatters.pkr(max)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: RangeValues(min, max),
                    min: 1000,
                    max: 50000,
                    divisions: 49,
                    activeColor: AppColors.red,
                    inactiveColor: AppColors.pink,
                    onChanged: (vals) {
                      setModalState(() {
                        min = vals.start;
                        max = vals.end;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Sizes
                  const Text(
                    'SIZE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: AppConstants.sizes.map((s) {
                      final has = sizes.contains(s);
                      return CustomChip(
                        label: s,
                        isSelected: has,
                        onTap: () {
                          setModalState(() {
                            if (has) {
                              sizes.remove(s);
                            } else {
                              sizes.add(s);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),

                  // City Dropdown/Selector
                  const Text(
                    'PICKUP CITY',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All Cities', ...AppConstants.cities].map((c) {
                        final isSel = (city == null && c == 'All Cities') || (city == c);
                        return CustomChip(
                          label: c,
                          isSelected: isSel,
                          onTap: () {
                            setModalState(() {
                              city = c == 'All Cities' ? null : c;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 28),

                  PrimaryButton(
                    text: 'Show Outfits',
                    onPressed: () {
                      outfitProvider.applyFilters(
                        min: min,
                        max: max,
                        city: city,
                        sizes: sizes,
                      );
                      Navigator.pop(ctx);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final outfitProvider = context.watch<OutfitProvider>();
    final outfits = outfitProvider.filteredOutfits;

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 95),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Find your look.',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 14),

              SearchInputField(
                controller: _searchController,
                hintText: 'Search lehenga, bridal, city, designer...',
                onChanged: (val) => outfitProvider.setSearchQuery(val),
                onFilterTap: () => _showFilterModal(context),
              ),
              const SizedBox(height: 16),

              // Recent Searches
              if (_searchController.text.isEmpty) ...[
                const Text(
                  'POPULAR & RECENT SEARCHES',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _recentSearches.map((term) {
                    return CustomChip(
                      label: term,
                      isSelected: false,
                      onTap: () {
                        _searchController.text = term.split(' · ').first;
                        outfitProvider.setSearchQuery(_searchController.text);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],

              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _searchController.text.isNotEmpty
                        ? 'Search results (${outfits.length})'
                        : 'Trending near you',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ink,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _showFilterModal(context),
                    icon: const Icon(Icons.tune, size: 16, color: AppColors.ink),
                    label: const Text(
                      'Filters',
                      style: TextStyle(fontSize: 12, color: AppColors.ink),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: Size.zero,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Outfits Results Grid
              Expanded(
                child: outfits.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search_off,
                              size: 48,
                              color: AppColors.mutedLight,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No matching looks found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Try adjusting your search or budget filters.',
                              style: TextStyle(color: AppColors.muted, fontSize: 12),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                _searchController.clear();
                                outfitProvider.resetFilters();
                              },
                              child: const Text('Reset all filters'),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        itemCount: outfits.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                        itemBuilder: (context, index) {
                          final outfit = outfits[index];
                          return OutfitCard(
                            outfit: outfit,
                            onTap: () => widget.onOutfitTap(outfit),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
