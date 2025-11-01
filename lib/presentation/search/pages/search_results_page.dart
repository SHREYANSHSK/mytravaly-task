import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/search_property_card.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../../../core/constants/app_colors.dart';
import 'widgets/build_empty_state.dart';
import 'widgets/build_error_state.dart';
import 'widgets/build_header.dart';

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
              return buildEmptyState(context);
            }

            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: properties.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return buildHeader(properties.length, hasMore);
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
            return buildErrorState(state.message,context,widget.query,widget.searchType);
          }
          return const SizedBox();
        },
      ),
    );
  }






}
