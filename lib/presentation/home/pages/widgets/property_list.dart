import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/hotel_card.dart';

class PropertyList extends StatelessWidget {
  final List<dynamic> properties;
  final ScrollController? scrollController;

  const PropertyList({
    super.key,
    required this.properties,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (properties.isEmpty) {
      return const Center(
        child: Text('No properties available'),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: properties.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              AppStrings.featuredHotels,
              style: TextStyle(
                fontSize: AppSizes.f24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          );
        }

        final property = properties[index - 1];
        return HotelCard(property: property);
      },
    );
  }
}
