import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:safenest/features/language/domain/usecases/get_language.dart';
import 'package:safenest/features/language/domain/usecases/set_language.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final SetLanguage setLanguage;
  final GetLanguage getLanguage;

  LanguageBloc({required this.setLanguage, required this.getLanguage}) : super(LanguageInitial()) {
    on<SetLanguageEvent>(_onSetLanguage);
    on<GetLanguageEvent>(_onGetLanguage);
  }

  Future<void> _onSetLanguage(SetLanguageEvent event, Emitter<LanguageState> emit) async {
    await setLanguage(SetLanguageParams(event.languageCode));
    emit(LanguageChanged(event.languageCode));
  }

  Future<void> _onGetLanguage(GetLanguageEvent event, Emitter<LanguageState> emit) async {
    final result = await getLanguage();
    result.fold(
          (failure) => emit(const LanguageError('Failed to load language')),
          (languageCode) => emit(LanguageLoaded(languageCode)),
    );
  }
}