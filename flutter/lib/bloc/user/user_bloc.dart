import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nodejs_test/model/user_model.dart';
import 'package:nodejs_test/repository/database_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final DatabaseRepository _databaseRepository;

  UserBloc({required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(UserState.initial()) {
    on<UserRegister>(_onUserRegister);
    on<UserLogin>(_onUserLogin);
    on<UserLogout>(_onUserLogout);
  }

  void _onUserLogout(UserLogout event, Emitter<UserState> emit) {
    emit(
        state.copyWith(user: User.empty(), status: UserStatus.unauthenticated));
  }

  Future<void> _onUserLogin(UserLogin event, Emitter<UserState> emit) async {
    final user = await _databaseRepository.login(event.email, event.password);
    emit(state.copyWith(
        user: user,
        status: user == User.empty()
            ? UserStatus.unauthenticated
            : UserStatus.authenticated));
  }

  void _onUserRegister(UserRegister event, Emitter<UserState> emit) {
    _databaseRepository.register(event.email, event.password);
  }
}
