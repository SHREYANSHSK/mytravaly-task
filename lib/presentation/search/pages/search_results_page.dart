import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/search_property_card.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;
  final String searchType;
  final String displayText;

  const SearchResultsPage({
    super.key,
    required this.query,
    this.searchType = 'hotelIdSearch',
    this.displayText = '',
  });

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<SearchBloc>().add(SearchHotels(
      query: widget.query,
      searchType: widget.searchType,
    ));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<SearchBloc>().add(LoadMoreSearchResults());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle = widget.displayText.isNotEmpty
        ? widget.displayText
        : widget.query;

    return Scaffold(
      appBar: AppBar(
        title: Text('Results for "$displayTitle"'),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SearchLoaded || state is SearchLoadingMore) {
            final properties = state is SearchLoaded
                ? state.properties
                : (state as SearchLoadingMore).properties;

            final hasMore = state is SearchLoaded ? state.hasMore : false;

            if (properties.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: properties.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildHeader(properties.length, hasMore);
                }

                if (index <= properties.length) {
                  final property = properties[index - 1];
                  return SearchPropertyCard(property: property);
                } else {
                  if (state is SearchLoadingMore || hasMore) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'No more results',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }
              },
            );
          } else if (state is SearchError) {
            return _buildErrorState(state.message);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildHeader(int count, bool hasMore) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$count ${count == 1 ? 'property' : 'properties'} found',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          if (hasMore) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 14,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Scroll down to load more results',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            AppStrings.noResults,
            style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Go Back'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
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
            const SizedBox(height: 16),
            const Text(
              AppStrings.errorOccurred,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<SearchBloc>().add(SearchHotels(
                  query: widget.query,
                  searchType: widget.searchType,
                ));
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
