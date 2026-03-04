import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:travel_tour_app/providers/tour_provider.dart';
import 'package:travel_tour_app/widgets/tour_card.dart';
import 'package:travel_tour_app/widgets/search_bar.dart';
import 'package:travel_tour_app/constants/app_colors.dart';

class TourSearchScreen extends StatefulWidget {
  const TourSearchScreen({super.key});

  @override
  State<TourSearchScreen> createState() => _TourSearchScreenState();
}

class _TourSearchScreenState extends State<TourSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tourProvider = Provider.of<TourProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Tours'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBarWidget(
              controller: _searchController,
              hintText: 'Search by destination or tour name...',
              autofocus: true,
              onChanged: (value) {
                tourProvider.searchTours(value);
              },
              onSearch: (value) {
                tourProvider.searchTours(value);
              },
            ),
          ),
          Expanded(
            child: tourProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : tourProvider.tours.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          _searchController.text.isEmpty
                              ? 'Start typing to search tours'
                              : 'No tours found for "${_searchController.text}"',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
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
                      return TourCard(
                        tour: tour,
                        onTap: () => context.push('/tour/${tour.id}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
