import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_tour_app/models/flight_model.dart';
import 'package:travel_tour_app/constants/app_colors.dart';

class FlightCard extends StatelessWidget {
  final FlightModel flight;
  final VoidCallback? onTap;

  const FlightCard({super.key, required this.flight, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('✈️ Flight card tapped: ${flight.flightNumber}');
        if (onTap != null) onTap!();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Airline and Flight Number
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  flight.airline,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.flightTag,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    flight.flightNumber,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Flight Route and Timing
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Departure
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flight.departure.formattedTime,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      flight.departure.airport,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      flight.departure.formattedDate,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                // Flight Duration
                Column(
                  children: [
                    const Icon(
                      Icons.airplanemode_active,
                      color: AppColors.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      flight.duration,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (flight.stops > 0)
                      Text(
                        '${flight.stops} stop${flight.stops > 1 ? 's' : ''}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.warningColor,
                        ),
                      ),
                  ],
                ),
                // Arrival
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      flight.arrival.formattedTime,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      flight.arrival.airport,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      flight.arrival.formattedDate,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: AppColors.borderColor, height: 1),
            const SizedBox(height: 16),
            // Price and Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    Text(
                      flight.price.economyFormatted,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    Text(
                      'Economy',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8), // Add spacing before map button
                // ADD THIS MAP BUTTON
                IconButton(
                  icon: const Icon(Icons.map, color: AppColors.primaryColor),
                  onPressed: () {
                    // Navigate to map view
                    context.push('/flight-route-map', extra: flight.toJson());
                  },
                  tooltip: 'View flight route',
                ),
                SizedBox(width: 8), // Add spacing after map button
                // Book Button
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                  ),
                  child: const Text('Book Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
