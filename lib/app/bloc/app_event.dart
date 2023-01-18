part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {}

class IsAuthenticated extends AppEvent {
  @override
  List<Object?> get props => [];
}
