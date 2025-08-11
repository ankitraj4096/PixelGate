import 'package:basic/repositories/image_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'images_event.dart';
import 'images_state.dart';

class ImagesBloc extends Bloc<ImagesEvent, ImagesState> {
  final ImageRepository imageRepository;

  ImagesBloc(this.imageRepository) : super(ImagesInitial()) {
    on<FetchImages>(_onFetchImages);
  }

  Future<void> _onFetchImages(
    FetchImages event,
    Emitter<ImagesState> emit,
  ) async {
    emit(ImagesLoading());

    try {
      final images = await imageRepository.fetchImages();
      emit(ImagesLoaded(images: images));
    } catch (e) {
      emit(ImagesError(error: e.toString()));
    }
  }
}
