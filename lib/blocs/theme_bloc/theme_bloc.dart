import 'package:bloc/bloc.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.light()) {
    on<ToggleTheme>((event, emit) {
      if (state.isDark) {
        emit(ThemeState.light());
      } else {
        emit(ThemeState.dark());
      }
    });
  }
}
