import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mytravaly_task/core/constants/app_sizes.dart';
import 'package:mytravaly_task/presentation/autocomplete/bloc/autocomplete_boc.dart';
import 'package:mytravaly_task/routes/app_routes_name.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../../autocomplete/bloc/autocomplete_event.dart';
import '../../autocomplete/bloc/autocomplete_state.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/hotel_card.dart';
import '../../../core/utils/debouncer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  final FocusNode _searchFocusNode = FocusNode();
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const LoadPopularStays());
    _searchController.addListener(_onSearchTextChanged);
    _searchFocusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debouncer.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    final query = _searchController.text;
    if (query.isEmpty) {
      context.read<AutocompleteBloc>().add(ClearSuggestions());
      setState(() => _showSuggestions = false);
    } else {
      _debouncer.run(() {
        context.read<AutocompleteBloc>().add(SearchQueryChanged(query));
        setState(() => _showSuggestions = true);
      });
    }
  }

  void _onFocusChanged() {
    if (!_searchFocusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() => _showSuggestions = false);
        }
      });
    }
  }

  void _performSearch(String query) {
    _searchFocusNode.unfocus();
    setState(() => _showSuggestions = false);
    Navigator.pushNamed(context, AppRoutesName.searchResults, arguments: query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeBloc>().add(RefreshPopularStays());
        },
        child: Stack(
          children: [
            Column(
              children: [
                _buildSearchBar(),
                Expanded(
                  child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state is HomeLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is HomeLoaded) {
                        return _buildPropertyList(state.properties);
                      } else if (state is HomeError) {
                        return _buildErrorState(state.message);
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
            if (_showSuggestions) _buildSuggestionsOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.surface,
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        decoration: InputDecoration(
          hintText: AppStrings.searchPlaceholder,
          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              context.read<AutocompleteBloc>().add(ClearSuggestions());
            },
          )
              : null,

        ),
        onSubmitted: _performSearch,
      ),
    );
  }

  Widget _buildSuggestionsOverlay() {
    return Positioned(
      top: 80,
      left: 16,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(AppSizes.r12),
        child: Container(
          constraints: BoxConstraints(maxHeight: AppSizes.h300),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.r12),
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
                    child: Text('No suggestions found'),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = state.suggestions[index];
                    return ListTile(
                      leading: Icon(
                        _getIconForType(suggestion.type),
                        color: AppColors.primary,
                      ),
                      title: Text(suggestion.text),
                      subtitle: suggestion.subtitle != null
                          ? Text(suggestion.subtitle!)
                          : null,
                      onTap: () => _performSearch(suggestion.text),
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

  Widget _buildPropertyList(List<dynamic> properties) {
    if (properties.isEmpty) {
      return const Center(
        child: Text('No properties available'),
      );
    }

    return ListView.builder(
      controller: _scrollController,
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

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: AppColors.error),
            SizedBox(height: AppSizes.h16),
            Text(
              message,
              style: TextStyle(fontSize: AppSizes.f16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<HomeBloc>().add(const LoadPopularStays());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
