abstract class HomeState {}

class HomeInitial extends HomeState {}
class HomeLoadingState extends HomeState {}

class HomeSuccessState extends HomeState {}

class HomeErrorState extends HomeState {
  String? error;

  HomeErrorState({this.error});
}
class CustomerRequestSuccessState extends HomeState {
  final String link;

  CustomerRequestSuccessState(this.link);
}
