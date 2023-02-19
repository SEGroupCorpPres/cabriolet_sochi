part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetData extends AccountEvent{
  GetData();
}

class UserSignOutEvent extends AccountEvent{

}