part of 'home_cubit.dart';

class HomeState {}

final class HomeInitial extends HomeState {}

final class StoriesLoading extends HomeState {}

final class StoriesLoaded extends HomeState {
  final List<StoryModel> stories;
  StoriesLoaded(this.stories);
}

final class StoriesError extends HomeState {
  final String message;
  StoriesError(this.message);
}
