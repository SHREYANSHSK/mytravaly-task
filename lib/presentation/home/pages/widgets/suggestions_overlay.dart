import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../autocomplete/bloc/autocomplete_state.dart';
import '../../../autocomplete/bloc/autocomplete_boc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../data/models/search_suggestion_model.dart';
import '../../../../routes/app_routes_name.dart';

class SuggestionsOverlay extends StatelessWidget {
  const SuggestionsOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 80,
      left: 16,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: BlocBuilder<AutocompleteBloc, AutocompleteState>(
            builder: (context, state) {
              if (state is AutocompleteLoading) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (state is AutocompleteLoaded) {
                if (state.suggestions.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No suggestions found',
                        style: TextStyle(color: AppColors.textSecondary)),
                  );
                }

                return ListView.builder(
                  itemCount: state.suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = state.suggestions[index];
                    return ListTile(
                      leading: Icon(
                        _getIconForType(suggestion.displayIcon),
                        color: AppColors.primary,
                      ),
                      title: Text(suggestion.valueToDisplay,
                          overflow: TextOverflow.ellipsis),
                      subtitle: Text(suggestion.subtitle,
                          style: TextStyle(fontSize: AppSizes.f12)),
                      onTap: () {
                        _performSearch(context, suggestion);
                      },
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'city':
        return Icons.location_city;
      case 'country':
        return Icons.public;
      case 'state':
        return Icons.map;
      case 'hotel':
        return Icons.hotel;
      default:
        return Icons.search;
    }
  }

  void _performSearch(BuildContext context, SearchSuggestion suggestion) {
    final searchType = suggestion.searchArray.type;
    final query = suggestion.searchArray.query.first;

    Log.debug('Performing search with type: $searchType, query: $query');

    Navigator.pushNamed(
      context,
      AppRoutesName.searchResults,
      arguments: {
        'query': query,
        'searchType': searchType,
        'displayText': suggestion.valueToDisplay,
      },
    );
  }
}
