part of 'app_cubit.dart';

class AppState extends Equatable {
  final bool logged;

  AppState.initial() : logged = null;
  AppState.logged(this.logged);

  @override
  List<Object> get props => [logged];
}
