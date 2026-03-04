import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:travel_tour_app/providers/tour_provider.dart';
import 'package:travel_tour_app/widgets/tour_card.dart';
import 'package:travel_tour_app/widgets/search_bar.dart';
import 'package:travel_tour_app/constants/app_colors.dart';

class TourListScreen extends StatefulWidget {
  const TourListScreen({super.key});

  @override
  State<TourListScreen> createState() => _TourListScreenState();
}

class _TourListScreenState extends State<TourListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedSort = 'recommended';

  final List<String> _categories = [
    'All',
    'Adventure',
    'Beach',
    'Cultural',
    'Honeymoon',
    'Family',
    'Luxury',
    'Wildlife',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TourProvider>(context, listen: false).fetchTours();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tourProvider = Provider.of<TourProvider>(context);
    // Add this debug print
    print(
      '🏠 Building TourListScreen, tours count: ${tourProvider.tours.length}, isLoading: ${tourProvider.isLoading}',
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Tours'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBarWidget(
              controller: _searchController,
              hintText: 'Search tours by destination...',
              onChanged: (value) {
                tourProvider.searchTours(value);
              },
              onSearch: (value) {
                tourProvider.searchTours(value);
              },
            ),
          ),
          // Categories Filter
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                        if (category == 'All') {
                          tourProvider.clearFilters();
                        } else {
                          tourProvider.filterByDestination(category);
                        }
                      });
                    },
                    backgroundColor: AppColors.borderColor,
                    selectedColor: AppColors.primaryColor,
                    labelStyle: TextStyle(
                      color: _selectedCategory == category
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Sort Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${tourProvider.tours.length} Tours Found',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                DropdownButton<String>(
                  value: _selectedSort,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.sort),
                  items: const [
                    DropdownMenuItem(
                      value: 'recommended',
                      child: Text('Recommended'),
                    ),
                    DropdownMenuItem(
                      value: 'price_low',
                      child: Text('Price: Low to High'),
                    ),
                    DropdownMenuItem(
                      value: 'price_high',
                      child: Text('Price: High to Low'),
                    ),
                    DropdownMenuItem(
                      value: 'duration',
                      child: Text('Duration'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedSort = value!;
                      tourProvider.sortTours(value);
                    });
                  },
                ),
              ],
            ),
          ),
          // Tours List
          Expanded(
            child: tourProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : tourProvider.error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(tourProvider.error!, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => tourProvider.fetchTours(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : tourProvider.tours.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No tours found', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.7,
                        ),
                    itemCount: tourProvider.tours.length,
                    itemBuilder: (context, index) {
                      final tour = tourProvider.tours[index];
                      print('🎨 Rendering tour: ${tour.title}');
                      return TourCard(
                        tour: tour,
                        onTap: () => context.push('/tour/${tour.id}'),
                        onCategoryTap: () {
                          if (tour.categories.isNotEmpty) {
                            print(
                              '🔍 Filtering by category: ${tour.categories.first}',
                            );
                            Provider.of<TourProvider>(
                              context,
                              listen: false,
                            ).filterByCategory(tour.categories.first);
                          }
                        },
                      );
                    },
                  ),
          ),
          // Expanded(
          //   child: tourProvider.isLoading
          //       ? const Center(child: CircularProgressIndicator())
          //       : tourProvider.error != null
          //       ? Center(
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               const Icon(
          //                 Icons.error_outline,
          //                 size: 48,
          //                 color: Colors.red,
          //               ),
          //               const SizedBox(height: 16),
          //               Text(
          //                 tourProvider.error!,
          //                 textAlign: TextAlign.center,
          //                 style: const TextStyle(color: Colors.red),
          //               ),
          //               const SizedBox(height: 16),
          //               ElevatedButton(
          //                 onPressed: () {
          //                   tourProvider.fetchTours();
          //                 },
          //                 child: const Text('Retry'),
          //               ),
          //             ],
          //           ),
          //         )
          //       : tourProvider.tours.isEmpty
          //       ? const Center(
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Icon(Icons.search_off, size: 64, color: Colors.grey),
          //               SizedBox(height: 16),
          //               Text(
          //                 'No tours found',
          //                 style: TextStyle(fontSize: 18, color: Colors.grey),
          //               ),
          //               SizedBox(height: 8),
          //               Text(
          //                 'Try a different search or filter',
          //                 style: TextStyle(color: Colors.grey),
          //               ),
          //             ],
          //           ),
          //         )
          //       : RefreshIndicator(
          //           onRefresh: () => tourProvider.fetchTours(),
          //           child: GridView.builder(
          //             padding: const EdgeInsets.all(16),
          //             gridDelegate:
          //                 const SliverGridDelegateWithFixedCrossAxisCount(
          //                   crossAxisCount: 2,
          //                   crossAxisSpacing: 12,
          //                   mainAxisSpacing: 12,
          //                   childAspectRatio: 0.7,
          //                 ),
          //             itemCount: tourProvider.tours.length,
          //             itemBuilder: (context, index) {
          //               final tour = tourProvider.tours[index];
          //               return TourCard(
          //                 tour: tour,
          //                 onTap: () {
          //                   // Navigator.pushNamed(
          //                   //   context,
          //                   //   '/tour-detail',
          //                   //   arguments: tour.id,
          //                   // );
          //                   context.push('/tour/${tour.id}');
          //                 },
          //               );
          //             },
          //           ),
          //         ),
          // ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Tours'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Price Range
                const Text('Price Range'),
                RangeSlider(
                  values: const RangeValues(0, 5000),
                  min: 0,
                  max: 10000,
                  divisions: 10,
                  onChanged: (values) {
                    // Implement price filter
                  },
                ),
                // Duration
                const Text('Duration (days)'),
                RangeSlider(
                  values: const RangeValues(1, 10),
                  min: 1,
                  max: 30,
                  divisions: 10,
                  onChanged: (values) {
                    // Implement duration filter
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Apply Filters'),
            ),
          ],
        );
      },
    );
  }
}
