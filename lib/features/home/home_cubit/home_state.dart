part of 'home_cubit.dart';

class HomeState {}

class HomeInitial extends HomeState {}

// Stories States
class StoriesLoading extends HomeState {}

class StoriesLoaded extends HomeState {
  final List<StoryModel> stories;
  StoriesLoaded(this.stories);
}

class StoriesError extends HomeState {
  final String message;
  StoriesError(this.message);
}

// Posts States
class PostsLoading extends HomeState {}

class PostsLoaded extends HomeState {
  final List<PostsModel> posts;
  PostsLoaded(this.posts);
}

class PostsError extends HomeState {
  final String message;
  PostsError(this.message);
}

// User States
class FetchingUserData extends HomeState {}

class UserFetched extends HomeState {
  final UserDataModel user;
  UserFetched(this.user);
}

class UserFetchedError extends HomeState {
  final String message;
  UserFetchedError(this.message);
}

// Media Picking States
class ImagePicked extends HomeState {
  final String imagePath;
  ImagePicked(this.imagePath);
}

class VideoPicked extends HomeState {
  final String videoPath;
  VideoPicked(this.videoPath);
}

class ImagePickingError extends HomeState {
  final String message;
  ImagePickingError(this.message);
}

class VideoPickingError extends HomeState {
  final String message;
  VideoPickingError(this.message);
}

// Create Post States
class PostCreating extends HomeState {}

class PostCreated extends HomeState {}

class PostCreatedError extends HomeState {
  final String message;
  PostCreatedError(this.message);
}
