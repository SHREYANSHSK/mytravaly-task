import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../autocomplete/bloc/autocomplete_boc.dart';
import '../../../autocomplete/bloc/autocomplete_event.dart';
import '../../cubit/search_bar_cubit.dart';
import '../../../../routes/app_routes_name.dart';
import '../../../../core/utils/debouncer.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final Debouncer debouncer;

  const SearchBarWidget({
    super.key,
    required this.searchController,
    required this.searchFocusNode,
    required this.debouncer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.surface,
      child: TextField(
        controller: searchController,
        focusNode: searchFocusNode,
        decoration: InputDecoration(
          hintText: AppStrings.searchPlaceholder,
          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              searchController.clear();
              context.read<AutocompleteBloc>().add(ClearSuggestions());
              context.read<SearchBarCubit>().hide();
            },
          )
              : null,
          filled: true,
          fillColor: AppColors.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          if (value.isEmpty) {
            context.read<AutocompleteBloc>().add(ClearSuggestions());
            context.read<SearchBarCubit>().hide();
          } else {
            debouncer.run(() {
              context.read<AutocompleteBloc>().add(SearchQueryChanged(value));
              context.read<SearchBarCubit>().show();
            });
          }
        },
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            Navigator.pushNamed(
              context,
              AppRoutesName.searchResults,
              arguments: {
                'query': value.trim(),
                'searchType': 'hotelIdSearch',
                'displayText': value.trim(),
              },
            );
            searchFocusNode.unfocus();
            context.read<SearchBarCubit>().hide();
          }
        },
      ),
    );
  }
}
