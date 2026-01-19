import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/home/models/story_model.dart';
import 'package:social_media_app/features/home/services/home_services.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  final HomeServicesImpl _db = HomeServicesImpl();

  Future<void> fetchStories() async {
    emit(StoriesLoading());
    try {
      final stories = await _db.fetchStories();
      final List<StoryModel> finalStories = [];

      for (final story in stories) {
        final user = await _db.getUsersData(story.authorId);
        finalStories.add(story.copyWith(name: user.name));
      }

      emit(StoriesLoaded(finalStories));
    } catch (e) {
      print(e);
      emit(StoriesError(e.toString()));
    }
  }
}
