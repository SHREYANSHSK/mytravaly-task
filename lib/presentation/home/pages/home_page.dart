import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/debouncer.dart';
import '../cubit/search_bar_cubit.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import 'widgets/error_state.dart';
import 'widgets/property_list.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/suggestions_overlay.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  final debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadPopularStays());
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchBarCubit(),
      child: Scaffold(
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
                  SearchBarWidget(
                    searchController: searchController,
                    searchFocusNode: searchFocusNode,
                    debouncer: debouncer,
                  ),
                  Expanded(
                    child: BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                        if (state is HomeLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is HomeLoaded) {
                          return PropertyList(properties: state.properties);
                        } else if (state is HomeError) {
                          return ErrorState(message: state.message);
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
              BlocBuilder<SearchBarCubit, bool>(
                builder: (context, showSuggestions) {
                  return showSuggestions
                      ? const SuggestionsOverlay()
                      : const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
