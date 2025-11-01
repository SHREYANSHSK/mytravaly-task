import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBarCubit extends Cubit<bool> {
  SearchBarCubit() : super(false);

  void show() => emit(true);
  void hide() => emit(false);
}
